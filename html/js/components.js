// Editor controls. Each control registers a sync() so undo/redo/limits refresh it in place.

import { h, icon, sfx, clamp, money } from './ui.js';
import { S, setKey, patchField, changedKeys, resetKeys } from './state.js';
import { post } from './bridge.js';
import { META, isProp, OVERLAYS, entryEqual, parentImage, FATHERS, MOTHERS, EYE_COLORS } from './schema.js';

export const live = [];
export function resetLive() { live.length = 0; }
export function syncAll() { live.forEach((fn) => { try { fn(); } catch (e) { /* element gone */ } }); }

let lastCam = null;
export function focusCam(preset) {
    if (!preset || preset === lastCam) return;
    lastCam = preset;
    post('camera', { preset });
}
export function setLastCam(p) { lastCam = p; }

const favKey = (key) => `mz_fav_${S.data?.gender || 'x'}_${key}`;
function getFavs(key) { try { return JSON.parse(localStorage.getItem(favKey(key)) || '[]'); } catch (e) { return []; } }
function toggleFav(key, n) {
    const f = new Set(getFavs(key));
    f.has(n) ? f.delete(n) : f.add(n);
    try { localStorage.setItem(favKey(key), JSON.stringify([...f])); } catch (e) { /* storage unavailable */ }
}

// ───────────── primitives ─────────────

export function stepper({ get, min, max, set, format, small, skipZero }) {
    const input = h('input', { type: 'number' });
    const of = h('span', { class: 'of' });
    const step = (d) => {
        let v = get() + d;
        const lo = min(), hi = max();
        if (skipZero && v === 0) v += d;
        if (v > hi) v = lo;
        if (v < lo) v = hi;
        if (skipZero && v === 0) v = d > 0 ? 1 : lo;
        set(v); sfx('tick'); sync();
    };
    const sync = () => {
        const v = get();
        if (document.activeElement !== input) input.value = format ? format(v) : v;
        of.textContent = `/ ${Math.max(0, max())}`;
    };
    input.addEventListener('change', () => {
        let v = parseInt(input.value, 10);
        if (isNaN(v)) v = get();
        set(clamp(v, min(), max())); sync();
    });
    input.addEventListener('keydown', (e) => { if (e.key === 'Enter') input.blur(); e.stopPropagation(); });
    const el = h('div', { class: `stepper ${small ? 'sm' : ''}` },
        h('button', { onclick: () => step(-1) }, icon('left')),
        h('div', { class: 'val' }, input, of),
        h('button', { onclick: () => step(1) }, icon('right')));
    live.push(sync); sync();
    return el;
}

export function slider({ label, min = 0, max = 1, step = 0.01, get, set, center, format }) {
    const out = h('b');
    const input = h('input', { type: 'range', min, max, step });
    const wrap = h('div', { class: `range ${center ? 'center' : ''}` }, input);
    const paint = () => {
        const v = +input.value;
        wrap.style.setProperty('--p', `${((v - min) / (max - min)) * 100}%`);
        out.textContent = format ? format(v) : v;
    };
    input.addEventListener('input', () => { set(+input.value); paint(); });
    input.addEventListener('dblclick', () => { const d = center ? (min + max) / 2 : min; input.value = d; set(d); paint(); });
    const sync = () => { if (document.activeElement !== input) input.value = get(); paint(); };
    live.push(sync); sync();
    return h('div', { class: 'field' }, h('div', { class: 'field-label' }, h('span', {}, label), out), wrap);
}

export function swatches({ colors, get, set }) {
    const el = h('div', { class: 'swatches' });
    const btns = colors.map((c, i) => {
        const b = h('button', { class: 'swatch', style: { background: c }, title: `#${i}`, onclick: () => { set(i); sfx('tick'); sync(); } });
        el.append(b);
        return b;
    });
    const sync = () => { const v = get(); btns.forEach((b, i) => b.classList.toggle('active', i === v)); };
    live.push(sync); sync();
    return el;
}

// Section wrapper with price / changed badge / reset
export function section(title, iconName, keys, body, { cam, priceKey, priceTable } = {}) {
    const badge = h('span', { class: 'changed hidden' }, 'modified');
    const resetBtn = h('button', { class: 'btn icon ghost hidden', title: 'Reset', onclick: (e) => { e.stopPropagation(); resetKeys(keys); } }, icon('reset'));
    let priceEl = null;
    const table = priceTable && S.data.prices && S.data.prices[priceTable];
    const p = table && table[priceKey || keys[0]];
    if (p !== undefined) priceEl = h('span', { class: 'price' }, p > 0 ? money(p) : 'FREE');
    const el = h('div', { class: 'section', onmousedown: () => focusCam(cam) },
        h('div', { class: 'section-title' },
            h('h4', {}, icon(iconName), title),
            h('div', { style: { display: 'flex', gap: '8px', alignItems: 'center' } }, badge, priceEl, resetBtn)),
        body);
    const sync = () => {
        const changed = changedKeys(keys).length > 0;
        badge.classList.toggle('hidden', !changed);
        resetBtn.classList.toggle('hidden', !changed);
    };
    live.push(sync); sync();
    return el;
}

// ───────────── composite pickers ─────────────

const PAGE = 36;

// Drawable + texture picker for components & props
export function itemPicker(key, { priceTable } = {}) {
    const prop = isProp(key);
    const meta = META[key];
    const lim = () => S.limits[key] || { max: 0, textures: 0 };
    const cur = () => S.skin[key] || { item: 0, texture: 0 };
    let page = Math.max(0, Math.floor((cur().item < 0 ? 0 : cur().item) / PAGE));

    const setItem = (v) => setKey(key, { ...cur(), item: v, texture: 0 });
    const minItem = () => (prop ? -1 : 0);
    const maxItem = () => Math.max(minItem(), lim().max - 1);

    const style = stepper({ get: () => cur().item, min: minItem, max: maxItem, set: setItem, skipZero: prop });
    const texture = stepper({
        small: true, get: () => Math.max(0, cur().texture),
        min: () => 0, max: () => Math.max(0, lim().textures - 1),
        set: (v) => patchField(key, 'texture', v),
    });

    const grid = h('div', { class: 'grid' });
    const pager = h('div', { class: 'pager' });
    let favOnly = false;
    const favBtn = h('button', { class: 'chip', onclick: () => { favOnly = !favOnly; favBtn.classList.toggle('active', favOnly); page = 0; renderGrid(); } }, icon('star'), 'Favorites');

    const renderGrid = () => {
        grid.innerHTML = '';
        const total = lim().max;
        const favs = new Set(getFavs(key));
        let ids = [];
        if (favOnly) ids = [...favs].filter((n) => n < total).sort((a, b) => a - b);
        else {
            const start = page * PAGE;
            for (let i = start; i < Math.min(total, start + PAGE); i++) ids.push(i);
        }
        if (prop && !favOnly && page === 0) ids = [-1, ...ids.filter((n) => n !== 0)];
        for (const n of ids) {
            const t = h('button', {
                class: `tile ${n === cur().item || (n === -1 && cur().item <= 0 && prop) ? 'active' : ''} ${favs.has(n) ? 'favorite' : ''} ${n < 0 ? 'none' : ''}`,
                onclick: () => { setItem(n); sfx('tick'); syncTiles(); },
                oncontextmenu: (e) => { e.preventDefault(); if (n >= 0) { toggleFav(key, n); renderGrid(); } },
                title: n >= 0 ? 'Right-click to favorite' : '',
            }, n < 0 ? 'NONE' : n, icon('star', 'fav'));
            t.dataset.n = n;
            grid.append(t);
        }
        if (!ids.length) grid.append(h('div', { class: 'cart-empty', style: { gridColumn: '1 / -1' } }, favOnly ? 'Right-click items to add favorites.' : 'Nothing here.'));
        const pages = Math.max(1, Math.ceil(total / PAGE));
        pager.innerHTML = '';
        if (!favOnly) {
            pager.append(
                h('button', { class: 'btn icon ghost', onclick: () => { page = (page - 1 + pages) % pages; renderGrid(); } }, icon('left')),
                h('span', {}, `Page ${page + 1} / ${pages}`),
                h('button', { class: 'btn icon ghost', onclick: () => { page = (page + 1) % pages; renderGrid(); } }, icon('right')));
        }
    };
    const syncTiles = () => {
        const v = cur().item;
        grid.querySelectorAll('.tile').forEach((t) => {
            const n = +t.dataset.n;
            t.classList.toggle('active', n === v || (prop && n === -1 && v <= 0));
        });
    };
    let lastMax = -1;
    live.push(() => { if (lim().max !== lastMax) { lastMax = lim().max; renderGrid(); } else syncTiles(); });
    renderGrid();

    return section(meta.label, meta.icon, [key], h('div', {},
        h('div', { class: 'field' }, h('div', { class: 'field-label' }, h('span', {}, 'Style'), h('div', { class: 'chips' }, favBtn)), style),
        grid, pager,
        h('div', { class: 'field', style: { marginTop: '12px' } }, h('div', { class: 'field-label' }, h('span', {}, 'Variant')), texture),
    ), { cam: meta.cam, priceTable });
}

// Head overlay (beard, brows, makeup, ageing...)
export function overlayPicker(key, { priceTable, title } = {}) {
    const def = OVERLAYS[key];
    const meta = META[key];
    const lim = () => S.limits[key] || { max: 0, textures: 0 };
    const cur = () => S.skin[key] || { item: -1, texture: 0, opacity: 1 };
    const body = h('div', {});
    body.append(h('div', { class: 'field' }, h('div', { class: 'field-label' }, h('span', {}, 'Style')),
        stepper({ get: () => cur().item, min: () => -1, max: () => lim().max - 1, set: (v) => patchField(key, 'item', v), format: (v) => v })));
    body.append(slider({ label: 'Opacity', min: 0, max: 1, step: 0.01, get: () => cur().opacity ?? 1, set: (v) => patchField(key, 'opacity', v), format: (v) => `${Math.round(v * 100)}%` }));
    if (def.color) {
        const colors = def.color === 1 ? S.data.palettes.hair : S.data.palettes.makeup;
        body.append(h('div', { class: 'field' }, h('div', { class: 'field-label' }, h('span', {}, 'Color')),
            swatches({ colors, get: () => cur().texture, set: (v) => patchField(key, 'texture', v) })));
    }
    return section(title || meta.label, meta.icon, [key], body, { cam: meta.cam, priceTable });
}

export function hairPicker({ priceTable } = {}) {
    const lim = () => S.limits.hair || { max: 0 };
    const cur = () => S.skin.hair;
    const body = h('div', {},
        h('div', { class: 'field' }, h('div', { class: 'field-label' }, h('span', {}, 'Style')),
            stepper({ get: () => cur().item, min: () => 0, max: () => lim().max - 1, set: (v) => patchField('hair', 'item', v) })),
        h('div', { class: 'field' }, h('div', { class: 'field-label' }, h('span', {}, 'Color')),
            swatches({ colors: S.data.palettes.hair, get: () => cur().texture, set: (v) => patchField('hair', 'texture', v) })),
        h('div', { class: 'field' }, h('div', { class: 'field-label' }, h('span', {}, 'Highlight')),
            swatches({ colors: S.data.palettes.hair, get: () => cur().highlight ?? cur().texture, set: (v) => patchField('hair', 'highlight', v) })));
    return section('Hair', 'scissors', ['hair'], body, { cam: 'head', priceTable });
}

export function fadePicker({ priceTable } = {}) {
    const fades = (S.data.tattoos || []).filter((t) => t.zone === 6);
    const grid = h('div', { class: 'grid' });
    const cur = () => S.skin.hair_fade || { collection: '', name: '' };
    const set = (t) => setKey('hair_fade', t ? { collection: t.collection, name: t.name } : { collection: '', name: '' });
    const none = h('button', { class: 'tile none', onclick: () => { set(null); sync(); } }, 'NONE');
    grid.append(none);
    const tiles = fades.map((t, i) => {
        const b = h('button', { class: 'tile', title: t.pack, onclick: () => { set(t); sfx('tick'); sync(); } }, i + 1);
        grid.append(b);
        return [b, t];
    });
    const sync = () => {
        const c = cur();
        none.classList.toggle('active', !c.name);
        tiles.forEach(([b, t]) => b.classList.toggle('active', t.name === c.name && t.collection === c.collection));
    };
    live.push(sync); sync();
    return section('Fades & Lines', 'scissors', ['hair_fade'], h('div', { style: { maxHeight: '220px', overflowY: 'auto' } }, grid), { cam: 'head', priceTable });
}

export function parentPicker(title, list, key, iconName) {
    const grid = h('div', { class: 'parents' });
    const cur = () => S.skin[key];
    const cards = list.map(([id, name]) => {
        const src = parentImage(id);
        const img = src ? h('img', { src, onerror: (e) => { e.target.remove(); } }) : null;
        const c = h('button', { class: 'parent', onclick: () => { setKey(key, { item: id, texture: id }); sfx('tick'); sync(); } },
            h('div', { class: 'ph' }, icon('user')), img, h('span', {}, name));
        grid.append(c);
        return [c, id];
    });
    const sync = () => cards.forEach(([c, id]) => c.classList.toggle('active', cur().item === id));
    live.push(sync); sync();
    return section(title, iconName, [key], grid, { cam: 'head' });
}

export function heritagePanel(priceTable) {
    const mix = () => S.skin.facemix;
    const setMix = (f, v) => setKey('facemix', { ...mix(), [f]: v });
    return h('div', {},
        parentPicker('Father', FATHERS, 'face', 'male'),
        parentPicker('Mother', MOTHERS, 'face2', 'female'),
        section('Blend', 'dna', ['facemix'], h('div', {},
            slider({ label: 'Resemblance', min: 0, max: 1, step: 0.01, get: () => mix().shapeMix, set: (v) => setMix('shapeMix', v), format: (v) => `${Math.round((1 - v) * 100)}% father · ${Math.round(v * 100)}% mother` }),
            slider({ label: 'Skin tone', min: 0, max: 1, step: 0.01, get: () => mix().skinMix, set: (v) => setMix('skinMix', v), format: (v) => `${Math.round((1 - v) * 100)} / ${Math.round(v * 100)}` }),
        ), { cam: 'head', priceTable, priceKey: 'heritage' }));
}

export function featureSlider(key, label) {
    return slider({
        label, min: -10, max: 10, step: 0.5, center: true,
        get: () => S.skin[key]?.item ?? 0,
        set: (v) => setKey(key, { item: v, texture: 0 }),
        format: (v) => (v > 0 ? '+' : '') + v,
    });
}

export function eyeColorPicker(priceTable) {
    const grid = h('div', { class: 'chips' });
    const btns = EYE_COLORS.map((name, i) => {
        const b = h('button', { class: 'chip', onclick: () => { setKey('eye_color', { item: i }); sfx('tick'); sync(); } }, name);
        grid.append(b);
        return b;
    });
    const sync = () => btns.forEach((b, i) => b.classList.toggle('active', S.skin.eye_color?.item === i));
    live.push(sync); sync();
    return section('Eye Color', 'eye', ['eye_color'], grid, { cam: 'head', priceTable });
}

export { entryEqual };
