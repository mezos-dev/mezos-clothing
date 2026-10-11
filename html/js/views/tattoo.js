// Tattoo parlor: browse by body zone & collection, preview, add/remove.

import { h, icon, money, sfx } from '../ui.js';
import { S, setKey } from '../state.js';
import { live, focusCam } from '../components.js';
import { ZONES, tattooId } from '../schema.js';
import { post } from '../bridge.js';

export function tattooView() {
    const all = (S.data.tattoos || []).filter((t) => t.zone !== 6);
    let zone = 0, pack = '', query = '', onlyMine = false;

    const has = () => new Set((S.skin.tattoos || []).map(tattooId));
    const had = () => new Set((S.baseline.tattoos || []).map(tattooId));

    const toggle = (t) => {
        const list = [...(S.skin.tattoos || [])];
        const i = list.findIndex((x) => tattooId(x) === t.id);
        if (i >= 0) list.splice(i, 1); else list.push({ collection: t.collection, name: t.name });
        setKey('tattoos', list);
        sfx('tick');
    };

    const seg = h('div', { class: 'seg', style: { display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)' } });
    const zoneBtns = ZONES.map((z) => {
        const b = h('button', { onclick: () => { zone = z.id; focusCam(z.cam); paint(); } }, icon(z.icon), z.label);
        seg.append(b);
        return [b, z];
    });

    const packs = [...new Set(all.map((t) => t.pack))].sort();
    const packSel = h('select', { class: 'input', onchange: (e) => { pack = e.target.value; render(); } },
        h('option', { value: '' }, 'All collections'), packs.map((p) => h('option', { value: p }, p)));
    const search = h('div', { class: 'search' }, icon('search'), h('input', { class: 'input', placeholder: 'Search designs…', oninput: (e) => { query = e.target.value.toLowerCase(); render(); }, onkeydown: (e) => e.stopPropagation() }));
    const mineChip = h('button', { class: 'chip', onclick: () => { onlyMine = !onlyMine; mineChip.classList.toggle('active', onlyMine); render(); } }, icon('check'), 'Applied');
    // clothes off/on (preview only; the outfit returns when the menu closes)
    let undressed = !!S.data.undressed;
    const clothesText = h('span', {});
    const clothesChip = h('button', { class: 'chip', title: 'Take clothes off to see your skin' }, icon('shirt'), clothesText);
    const paintClothes = () => {
        clothesChip.classList.toggle('active', undressed);
        clothesText.textContent = undressed ? 'Clothes off' : 'Clothes on';
    };
    paintClothes();
    clothesChip.onclick = async () => {
        undressed = !undressed;
        paintClothes();
        sfx('tick');
        const res = await post('undress', { on: undressed });
        if (res && typeof res.undressed === 'boolean') { undressed = res.undressed; paintClothes(); }
    };
    const clearBtn = h('button', { class: 'chip', onclick: () => { setKey('tattoos', []); render(); } }, icon('trash'), 'Remove all');
    const count = h('small', { style: { color: 'var(--muted)' } });
    const list = h('div', { class: 'list' });

    function render() {
        const mine = has(), owned = had();
        list.innerHTML = '';
        const items = all.filter((t) =>
            (onlyMine ? mine.has(t.id) : t.zone === zone) &&
            (!pack || t.pack === pack) &&
            (!query || t.label.toLowerCase().includes(query) || t.pack.toLowerCase().includes(query)));
        count.textContent = `${items.length} designs`;
        const frag = document.createDocumentFragment();
        for (const t of items.slice(0, 160)) {
            const on = mine.has(t.id), wasOn = owned.has(t.id);
            let status = null;
            if (on && !wasOn) status = h('span', { class: 'tag' }, 'New');
            else if (on && wasOn) status = h('span', { class: 'tag ok' }, 'Owned');
            else if (!on && wasOn) status = h('span', { class: 'tag bad' }, 'Removing');
            frag.append(h('div', { class: `item ${on ? 'active' : ''} ${!on && wasOn ? 'removed' : ''}`, style: { cursor: 'pointer', animationDelay: '0s' }, onclick: () => { toggle(t); render(); } },
                h('div', { class: 'ico' }, icon('ink')),
                h('div', { class: 'meta' }, h('b', {}, t.label), h('small', {}, t.pack, status)),
                h('span', { class: 'price', style: { color: 'var(--accent)', fontWeight: 700 } }, wasOn ? '' : money(t.price)),
                h('div', { class: 'btn icon ghost' }, icon(on ? 'minus' : 'plus'))));
        }
        list.append(frag);
        if (items.length > 160) list.append(h('div', { class: 'cart-empty' }, `Showing 160 of ${items.length}. Refine with search or collection.`));
        if (!items.length) list.append(h('div', { class: 'empty' }, icon('ink'), h('b', {}, 'No designs'), 'Try another zone or collection.'));
    }
    function paint() {
        zoneBtns.forEach(([b, z]) => b.classList.toggle('active', z.id === zone && !onlyMine));
        render();
    }
    live.push(() => render());
    paint();

    return h('div', {},
        seg, search,
        h('div', { class: 'field' }, packSel),
        h('div', { style: { display: 'flex', alignItems: 'center', gap: '6px', marginBottom: '12px', flexWrap: 'wrap' } }, clothesChip, mineChip, clearBtn, h('span', { style: { marginLeft: 'auto' } }, count)),
        list);
}
