// Wardrobe: saved outfits (folders, tags, share, publish, send), job uniforms and code import.

import { h, icon, toast, confirmBox, formBox, dropdown, copyText, modal, sfx } from '../ui.js';
import { server, post } from '../bridge.js';
import { S, isDirty, commitDone, emit } from '../state.js';

export const toSigned = (n) => { n = Number(n); return n > 2147483647 ? n - 4294967296 : n; };
export const sameModel = (m) => !m || toSigned(m) === toSigned(S.data.model);

const REASONS = {
    limit: 'You reached the outfit limit', not_found: 'Outfit not found', wrong_model: "That outfit doesn't fit your body type",
    no_skin: 'Save your look first', money: 'Not enough money', cooldown: 'Slow down a little', distance: 'They are too far away',
    target: 'Invalid player', denied: 'Not allowed', full: 'The bag is full', expired: 'That offer expired', disabled: 'Gallery is disabled',
};
export const reason = (r) => REASONS[r] || 'Something went wrong';

let previewing = false;
export async function preview(skin) {
    previewing = true;
    await post('preview', { skin });
    toast('Previewing — not saved', 'info', 1800);
    emit('preview');
}
export async function clearPreview() {
    if (!previewing) return;
    previewing = false;
    await post('preview', { clear: true });
    emit('preview');
}
export const isPreviewing = () => previewing;

export async function wear(spec) {
    const res = await server('wearOutfit', spec);
    if (res && res.ok) {
        previewing = false;
        if (res.limits) S.limits = res.limits;
        commitDone(res.skin);
        toast('Outfit equipped', 'success');
    } else toast(reason(res && res.reason), 'error');
    return res;
}

export async function sendToNearby(outfit) {
    const players = await server('nearbyPlayers');
    if (!players || !players.length) return toast('Nobody is close enough', 'error');
    const target = await modal((box, close) => {
        box.append(h('h3', {}, 'Send outfit'), h('p', {}, `Choose who receives "${outfit.name}".`),
            h('div', { class: 'list' }, players.map((p) => h('button', { class: 'item', onclick: () => close(p) },
                h('div', { class: 'ico' }, icon('user')), h('div', { class: 'meta' }, h('b', {}, p.name), h('small', {}, `ID ${p.id}`)), icon('send')))),
            h('div', { class: 'row' }, h('button', { class: 'btn ghost', onclick: () => close(null) }, 'Cancel')));
    });
    if (!target) return;
    const res = await server('sendOutfit', target.id, outfit.id);
    res && res.ok ? toast(`Sent to ${target.name}`, 'success') : toast(reason(res && res.reason), 'error');
}

export function wardrobeView() {
    let outfits = [];
    let tab = 'mine', folder = '', query = '';
    const root = h('div', {});
    const body = h('div', {});
    const store = S.mode === 'clothing';
    const jobs = S.data.jobOutfits;

    const seg = h('div', { class: 'seg' });
    const tabs = [['mine', 'hanger', 'Outfits'], jobs && jobs.length ? ['uniforms', 'shield', 'Uniforms'] : null, ['import', 'download', 'Import']].filter(Boolean);
    const segBtns = tabs.map(([id, ic, label]) => {
        const b = h('button', { onclick: () => { tab = id; clearPreview(); paint(); } }, icon(ic), label);
        seg.append(b);
        return [b, id];
    });
    root.append(seg, body);

    async function load() {
        body.innerHTML = '';
        body.append(h('div', { class: 'spinner' }));
        outfits = (await server('getOutfits')) || [];
        render();
    }

    function setOutfits(res, okMsg) {
        if (res && res.ok) {
            if (res.outfits) outfits = res.outfits;
            if (okMsg) toast(okMsg, 'success');
            render();
        } else toast(reason(res && res.reason), 'error');
    }

    async function saveCurrent() {
        if (store && isDirty()) return toast('Confirm your purchase before saving it as an outfit', 'error');
        const data = await formBox('Save outfit', 'Saves the look you are wearing.', [
            { name: 'name', label: 'Name', placeholder: 'Night out', max: 32 },
            { name: 'folder', label: 'Folder (optional)', placeholder: 'Work, Casual…', max: 32, required: false },
            { name: 'tags', label: 'Tags (optional)', placeholder: 'summer, formal', max: 128, required: false },
        ]);
        if (!data) return;
        setOutfits(await server('saveOutfit', data), 'Outfit saved');
    }

    function outfitMenu(anchor, o) {
        dropdown(anchor, [
            { icon: 'eye', label: 'Try on', action: () => preview(o.skin) },
            { icon: 'edit', label: 'Rename & organize', action: async () => {
                const d = await formBox('Edit outfit', null, [
                    { name: 'name', label: 'Name', value: o.name, max: 32 },
                    { name: 'folder', label: 'Folder', value: o.folder, max: 32, required: false },
                    { name: 'tags', label: 'Tags', value: o.tags, max: 128, required: false },
                ]);
                if (d) setOutfits(await server('editOutfitInfo', o.id, d), 'Outfit updated');
            } },
            { icon: 'save', label: 'Overwrite with current look', action: async () => {
                if (store && isDirty()) return toast('Confirm your purchase first', 'error');
                if (await confirmBox('Overwrite outfit', `Replace "${o.name}" with what you are wearing now?`, { ok: 'Overwrite' })) setOutfits(await server('updateOutfit', o.id), 'Outfit overwritten');
            } },
            { icon: 'copy', label: 'Duplicate', action: async () => setOutfits(await server('duplicateOutfit', o.id), 'Outfit duplicated') },
            '-',
            { icon: 'code', label: 'Share code', action: async () => {
                const res = await server('getShareCode', o.id);
                if (!res || !res.ok) return toast('Could not create a code', 'error');
                if (res.outfits) outfits = res.outfits;
                render();
                modal((box, close) => box.append(h('h3', {}, 'Share code'), h('p', {}, 'Anyone can import this outfit with the code below.'),
                    h('div', { class: 'code-box' }, h('b', {}, res.code), h('button', { class: 'btn sm', onclick: () => { copyText(res.code); toast('Copied to clipboard', 'success'); } }, icon('copy'), 'Copy')),
                    h('div', { class: 'row' }, h('button', { class: 'btn primary', onclick: () => close() }, 'Done'))));
            } },
            S.data.gallery ? { icon: 'upload', label: 'Publish to gallery', action: async () => {
                const d = await formBox('Publish to gallery', 'Your character name is shown as the author.', [{ name: 'tags', label: 'Tags', value: o.tags, max: 128, required: false }], { ok: 'Publish' });
                if (!d) return;
                const res = await server('galleryPublish', o.id, d.tags);
                res && res.ok ? toast('Published to the gallery', 'success') : toast(reason(res && res.reason), 'error');
            } } : null,
            { icon: 'send', label: 'Send to nearby player', action: () => sendToNearby(o) },
            '-',
            { icon: 'trash', label: 'Delete', danger: true, action: async () => {
                if (await confirmBox('Delete outfit', `Delete "${o.name}" permanently?`, { ok: 'Delete', danger: true })) setOutfits(await server('deleteOutfit', o.id), 'Outfit deleted');
            } },
        ]);
    }

    function renderMine() {
        const folders = [...new Set(outfits.map((o) => o.folder).filter(Boolean))].sort();
        const head = h('div', { style: { display: 'flex', gap: '8px', marginBottom: '12px' } },
            h('button', { class: 'btn primary sm', style: { flex: 1 }, onclick: saveCurrent }, icon('plus'), 'Save current look'),
            isPreviewing() ? h('button', { class: 'btn sm', onclick: async () => { await clearPreview(); render(); } }, icon('x'), 'Stop preview') : null);
        const search = h('div', { class: 'search' }, icon('search'), h('input', { class: 'input', placeholder: 'Search outfits or tags…', value: query, oninput: (e) => { query = e.target.value.toLowerCase(); renderList(); }, onkeydown: (e) => e.stopPropagation() }));
        const chips = h('div', { class: 'chips', style: { marginBottom: '12px' } },
            [['', 'All'], ...folders.map((f) => [f, f])].map(([f, label]) => h('button', { class: `chip ${folder === f ? 'active' : ''}`, onclick: () => { folder = f; render(); } }, f ? icon('folder') : null, label)));
        const list = h('div', { class: 'list' });
        const counter = h('div', { class: 'cart-empty', style: { textAlign: 'right' } }, `${outfits.length} / ${S.data.maxOutfits} outfits`);

        function renderList() {
            list.innerHTML = '';
            const items = outfits.filter((o) => (!folder || o.folder === folder) &&
                (!query || o.name.toLowerCase().includes(query) || (o.tags || '').toLowerCase().includes(query)));
            items.forEach((o, i) => {
                const fits = sameModel(o.model);
                const more = h('button', { class: 'btn icon ghost', onclick: (e) => { e.stopPropagation(); outfitMenu(more.parentElement, o); } }, icon('more'));
                list.append(h('div', { class: 'item', style: { animationDelay: `${Math.min(i, 12) * 25}ms` } },
                    h('div', { class: 'ico' }, icon('hanger')),
                    h('div', { class: 'meta' }, h('b', {}, o.name),
                        h('small', {}, o.folder ? h('span', { class: 'tag' }, o.folder) : null, o.shareCode ? h('span', { class: 'tag violet' }, o.shareCode) : null,
                            !fits ? h('span', { class: 'tag bad' }, 'Other body') : null, o.tags ? h('span', {}, o.tags) : null)),
                    h('div', { class: 'tools' },
                        h('button', { class: 'btn sm primary', disabled: !fits, onclick: () => wear({ type: 'outfit', id: o.id }).then(render) }, 'Wear'),
                        more)));
            });
            if (!items.length) list.append(h('div', { class: 'empty' }, icon('hanger'), h('b', {}, outfits.length ? 'No matches' : 'No outfits yet'), outfits.length ? 'Try another folder or search.' : 'Save the look you are wearing to build your wardrobe.'));
        }
        renderList();
        return h('div', {}, head, search, folders.length ? chips : null, list, counter);
    }

    function renderUniforms() {
        return h('div', { class: 'list' }, jobs.map((o, i) => h('div', { class: 'item', style: { animationDelay: `${i * 30}ms` } },
            h('div', { class: 'ico' }, icon('shield')),
            h('div', { class: 'meta' }, h('b', {}, o.name), h('small', {}, 'Department issue')),
            h('div', { class: 'tools' },
                h('button', { class: 'btn icon ghost', title: 'Try on', onclick: () => preview(o.skin) }, icon('eye')),
                h('button', { class: 'btn sm primary', onclick: () => wear({ type: 'job', index: o.index }) }, 'Wear')))));
    }

    function renderImport() {
        const input = h('input', { class: 'input', placeholder: `${S.data.sharePrefix}-XXXXX`, maxlength: 16, style: { fontFamily: 'var(--font-display)', letterSpacing: '3px', textTransform: 'uppercase' }, onkeydown: (e) => { e.stopPropagation(); if (e.key === 'Enter') look(); } });
        const result = h('div', { style: { marginTop: '14px' } });
        async function look() {
            const code = input.value.trim();
            if (!code) return;
            result.innerHTML = '';
            result.append(h('div', { class: 'spinner' }));
            const res = await server('previewCode', code);
            result.innerHTML = '';
            if (!res || !res.ok) { result.append(h('div', { class: 'empty' }, icon('alert'), h('b', {}, 'Code not found'), 'Double-check the code and try again.')); return; }
            const o = res.outfit;
            const fits = sameModel(o.model);
            result.append(h('div', { class: 'gcard' },
                h('div', { class: 'gname' }, o.name),
                h('div', { class: 'gby' }, fits ? 'Ready to import' : 'Made for another body type'),
                h('div', { class: 'gactions' },
                    h('button', { class: 'btn sm', disabled: !fits, onclick: () => preview(o.skin) }, icon('eye'), 'Try on'),
                    h('button', { class: 'btn sm primary', disabled: !fits, onclick: async () => {
                        const r = await server('importCode', code, o.name);
                        if (r && r.ok) { outfits = r.outfits || outfits; await clearPreview(); toast('Outfit imported', 'success'); tab = 'mine'; paint(); } else toast(reason(r && r.reason), 'error');
                    } }, icon('download'), 'Save'))));
        }
        return h('div', {},
            h('p', { style: { color: 'var(--muted)', marginBottom: '12px', fontSize: '14px' } }, 'Paste a share code to preview and save an outfit someone shared with you.'),
            h('div', { style: { display: 'flex', gap: '8px' } }, input, h('button', { class: 'btn primary', onclick: look }, icon('search'))),
            result);
    }

    function render() {
        body.innerHTML = '';
        if (tab === 'mine') body.append(renderMine());
        else if (tab === 'uniforms') body.append(renderUniforms());
        else body.append(renderImport());
    }
    function paint() {
        segBtns.forEach(([b, id]) => b.classList.toggle('active', id === tab));
        render();
    }

    segBtns.forEach(([b, id]) => b.classList.toggle('active', id === tab));
    load();
    root.reload = load;
    return root;
}
