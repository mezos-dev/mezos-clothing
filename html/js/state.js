// Editor state: current skin, baseline (for pricing), limits and undo/redo history.

import { post } from './bridge.js';
import { clone, entryEqual, CLOTHING_KEYS, BARBER_KEYS, HERITAGE_KEYS, FEATURES, SURGEON_REST, META, tattooId } from './schema.js';

const listeners = new Set();

export const S = {
    data: null,         // payload from Lua
    mode: null,
    skin: null,
    baseline: null,
    limits: {},
    history: [],
    future: [],
};

export function onChange(fn) { listeners.add(fn); return () => listeners.delete(fn); }
export function emit(reason) { listeners.forEach((fn) => fn(reason)); }

export function init(data) {
    S.data = data;
    S.mode = data.mode;
    S.skin = clone(data.skin);
    S.baseline = clone(data.skin);
    S.limits = data.limits || {};
    S.history = [];
    S.future = [];
}

// ───────────── editing ─────────────

let snapTimer = null;
function snapshot() {
    // group rapid edits (slider drags) into one undo step
    if (snapTimer) return;
    S.history.push(clone(S.skin));
    if (S.history.length > 80) S.history.shift();
    S.future = [];
    snapTimer = setTimeout(() => { snapTimer = null; }, 600);
}

// Patches are coalesced per key (~30ms) so slider drags don't flood the game.
const pending = {};
function sendPatch(key) {
    if (pending[key]) return pending[key].promise;
    const p = {};
    p.promise = new Promise((resolve) => { p.resolve = resolve; });
    pending[key] = p;
    setTimeout(async () => {
        delete pending[key];
        const res = await post('patch', { key, value: S.skin[key] });
        if (res && res.limits) {
            S.limits[key] = res.limits;
            emit('limits');
        }
        p.resolve(res && res.limits);
    }, 30);
    return p.promise;
}

// Change a key. Returns a promise resolving to new limits for that key.
export function setKey(key, value, { silent = false } = {}) {
    snapshot();
    S.skin[key] = value;
    if (!silent) emit('skin');
    return sendPatch(key);
}

export function patchField(key, field, v, opts) {
    const value = { ...(S.skin[key] || {}), [field]: v };
    return setKey(key, value, opts);
}

export async function applySkin(skin, { record = true } = {}) {
    if (record) { S.history.push(clone(S.skin)); S.future = []; }
    S.skin = clone(skin);
    emit('reload');
    const res = await post('applySkin', { skin: S.skin });
    if (res && res.limits) { S.limits = res.limits; emit('limits'); }
}

export function undo() {
    if (!S.history.length) return;
    S.future.push(clone(S.skin));
    applySkin(S.history.pop(), { record: false });
}

export function redo() {
    if (!S.future.length) return;
    S.history.push(clone(S.skin));
    applySkin(S.future.pop(), { record: false });
}

export function resetKeys(keys) {
    const skin = clone(S.skin);
    for (const k of keys) skin[k] = clone(S.baseline[k]);
    return applySkin(skin);
}

// ───────────── pricing (mirror of server/payments.lua) ─────────────

export function changedKeys(keys) {
    return keys.filter((k) => !entryEqual(S.baseline[k], S.skin[k]));
}

export function cart() {
    const P = S.data && S.data.prices;
    const lines = [];
    if (!P) return { lines, total: 0 };
    const mode = S.mode;
    const add = (label, price, removal) => lines.push({ label, price: +price || 0, removal });

    if (mode === 'clothing') {
        for (const k of changedKeys(CLOTHING_KEYS)) add(META[k].label, P.clothing[k]);
    } else if (mode === 'barber') {
        for (const k of changedKeys(BARBER_KEYS)) add(META[k].label, P.barber[k]);
    } else if (mode === 'surgeon') {
        if (changedKeys(HERITAGE_KEYS).length) add('Heritage', P.surgeon.heritage);
        const f = changedKeys(FEATURES).length;
        if (f) add(`Face features ×${f}`, P.surgeon.feature * f);
        for (const k of changedKeys(SURGEON_REST)) add(META[k].label, P.surgeon[k]);
    } else if (mode === 'tattoo') {
        const cat = new Map((S.data.tattoos || []).map((t) => [t.id, t]));
        const had = new Set((S.baseline.tattoos || []).map(tattooId));
        const has = new Set((S.skin.tattoos || []).map(tattooId));
        for (const id of has) if (!had.has(id)) { const t = cat.get(id); add(t ? t.label : 'Tattoo', t ? t.price : P.tattoo.default); }
        for (const id of had) if (!has.has(id)) { const t = cat.get(id); add(`Remove ${t ? t.label : 'tattoo'}`, P.tattoo.removal, true); }
    }
    return { lines, total: lines.reduce((a, l) => a + l.price, 0) };
}

export function isDirty() {
    return JSON.stringify(S.skin) !== JSON.stringify(S.baseline);
}

export function commitDone(skin) {
    S.skin = clone(skin);
    S.baseline = clone(skin);
    S.history = [];
    S.future = [];
    emit('reload');
}
