// Outfit bag panel (standalone) and outfit gift popup.

import { h, icon, toast, formBox, confirmBox, sfx } from '../ui.js';
import { post, server } from '../bridge.js';
import { reason, toSigned } from './wardrobe.js';

let bag = null; // { bagId, data, model }

export function openBag(msg) {
    bag = { bagId: msg.bagId, data: msg.data, model: msg.model };
    document.getElementById('bag').classList.remove('hidden');
    sfx('open');
    render();
}

export function hideBag() {
    document.getElementById('bag').classList.add('hidden');
    bag = null;
}

function closeBag() {
    hideBag();
    post('bagClose');
}

async function act(name, ...args) {
    const res = await server(name, bag.bagId, ...args);
    if (res && res.ok) {
        bag.data = { ...bag.data, ...res };
        render();
        return res;
    }
    toast(reason(res && res.reason), 'error');
    return null;
}

function render() {
    const root = document.getElementById('bag');
    root.innerHTML = '';
    if (!bag) return;
    const d = bag.data;
    const outfits = d.outfits || [];
    const fits = (m) => !m || toSigned(m) === toSigned(bag.model);

    const list = h('div', { class: 'list' }, outfits.map((o, i) => {
        const index = i + 1; // Lua index
        return h('div', { class: 'item', style: { animationDelay: `${i * 30}ms` } },
            h('div', { class: 'ico' }, icon('hanger')),
            h('div', { class: 'meta' }, h('b', {}, o.name), h('small', {}, fits(o.model) ? 'Ready to wear' : h('span', { class: 'tag bad' }, 'Other body'))),
            h('div', { class: 'tools' },
                h('button', { class: 'btn icon ghost', title: 'Rename', onclick: async () => {
                    const f = await formBox('Rename outfit', null, [{ name: 'name', label: 'Name', value: o.name }]);
                    if (f) act('bagRenameOutfit', index, f.name);
                } }, icon('edit')),
                h('button', { class: 'btn icon ghost', title: 'Copy to wardrobe', onclick: async () => { if (await act('bagToWardrobe', index)) toast('Copied to your wardrobe', 'success'); } }, icon('download')),
                h('button', { class: 'btn icon ghost', title: 'Remove', onclick: async () => {
                    if (await confirmBox('Remove outfit', `Take "${o.name}" out of the bag?`, { ok: 'Remove', danger: true })) act('bagRemove', index);
                } }, icon('trash')),
                h('button', { class: 'btn sm primary', disabled: !fits(o.model), onclick: () => { post('bagWear', { index }); hideBag(); } }, 'Wear')));
    }));
    if (!outfits.length) list.append(h('div', { class: 'empty' }, icon('bag'), h('b', {}, 'The bag is empty'), 'Pack your current look or an outfit from your wardrobe.'));

    const wardrobe = (d.wardrobe || []).filter((o) => fits(o.model));
    const select = h('select', { class: 'input', style: { flex: 1 } },
        h('option', { value: '' }, wardrobe.length ? 'Pack from wardrobe…' : 'No wardrobe outfits'),
        wardrobe.map((o) => h('option', { value: o.id }, o.name)));

    const pct = Math.min(100, (outfits.length / (d.max || 10)) * 100);
    root.append(h('div', { class: 'bag-panel glass' }, h('div', { class: 'edge' }),
        h('div', { class: 'panel-head' },
            h('div', { class: 'eyebrow' }, 'Outfit Bag'),
            h('div', { style: { display: 'flex', alignItems: 'center', gap: '10px' } },
                h('h2', { style: { flex: 1 } }, d.label || 'Outfit Bag'),
                h('button', { class: 'btn icon ghost', title: 'Rename bag', onclick: async () => {
                    const f = await formBox('Rename bag', 'Shown on the item in your inventory.', [{ name: 'label', label: 'Label', value: d.label, max: 30 }]);
                    if (f) act('bagRename', f.label);
                } }, icon('edit')),
                h('button', { class: 'btn icon ghost', onclick: closeBag }, icon('x'))),
            h('p', {}, `${outfits.length} / ${d.max} outfits · goes with the bag when you hand it over`),
            h('div', { class: 'capacity' }, h('i', { style: { width: `${pct}%` } }))),
        h('div', { class: 'panel-body' }, list),
        h('div', { class: 'panel-foot', style: { flexDirection: 'column' } },
            h('button', { class: 'btn primary block', disabled: outfits.length >= d.max, onclick: async () => {
                const f = await formBox('Pack current look', null, [{ name: 'name', label: 'Name', placeholder: 'Gym fit' }], { ok: 'Pack' });
                if (f && (await act('bagAddCurrent', f.name))) toast('Packed into the bag', 'success');
            } }, icon('plus'), 'Pack current look'),
            h('div', { style: { display: 'flex', gap: '8px' } }, select,
                h('button', { class: 'btn', disabled: outfits.length >= d.max, onclick: async () => {
                    if (!select.value) return;
                    if (await act('bagAddFromWardrobe', select.value)) toast('Packed into the bag', 'success');
                } }, icon('plus'))))));
}

// ───────────── outfit gifts ─────────────

export function showOffer(msg, inMenu, onTry) {
    const o = msg.offer;
    const root = document.getElementById('modal-root');
    const close = () => { backdrop.remove(); if (msg.standalone) post('popupClosed'); };
    const respond = async (accept) => {
        const res = await server('respondOffer', o.offerId, accept);
        if (accept) res && res.ok ? toast('Outfit added to your wardrobe', 'success') : toast(reason(res && res.reason), 'error');
        close();
        document.dispatchEvent(new CustomEvent('mz:outfits'));
    };
    const box = h('div', { class: 'offer glass' }, h('div', { class: 'edge' }),
        h('div', { class: 'gift' }, icon('gift')),
        h('h3', { style: { fontFamily: 'var(--font-display)', letterSpacing: '2px', fontSize: '15px', textTransform: 'uppercase' } }, 'Incoming outfit'),
        h('p', { style: { color: 'var(--muted)', margin: '6px 0 16px' } }, `${o.from} wants to give you "${o.name}".`),
        h('div', { style: { display: 'flex', gap: '8px' } },
            h('button', { class: 'btn ghost', style: { flex: 1 }, onclick: () => respond(false) }, 'Decline'),
            inMenu ? h('button', { class: 'btn', onclick: () => onTry(o.skin) }, icon('eye')) : null,
            h('button', { class: 'btn primary', style: { flex: 1 }, onclick: () => respond(true) }, icon('check'), 'Accept')));
    const backdrop = h('div', { class: 'backdrop' }, box);
    root.append(backdrop);
    sfx('open');
    setTimeout(() => { if (backdrop.isConnected) close(); }, 60000);
}
