// DOM helpers, icons, sounds, toasts and modals.

export function h(tag, attrs = {}, ...children) {
    const el = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs || {})) {
        if (v === undefined || v === null || v === false) continue;
        if (k === 'class') el.className = v;
        else if (k === 'style' && typeof v === 'object') Object.assign(el.style, v);
        else if (k.startsWith('on') && typeof v === 'function') el.addEventListener(k.slice(2).toLowerCase(), v);
        else if (k === 'html') el.innerHTML = v;
        else el.setAttribute(k, v === true ? '' : v);
    }
    for (const c of children.flat(Infinity)) {
        if (c === null || c === undefined || c === false) continue;
        el.append(c instanceof Node ? c : document.createTextNode(String(c)));
    }
    return el;
}

export const $ = (sel, root = document) => root.querySelector(sel);
export const money = (n) => '$' + Math.round(n || 0).toLocaleString('en-US');
export const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
export const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

// ───────────── icons (24px stroke set) ─────────────
const P = {
    logo: '<path d="M12 2l8.5 5v10L12 22l-8.5-5V7z"/><path d="M12 7l4.3 2.5v5L12 17l-4.3-2.5v-5z"/>',
    shirt: '<path d="M8 3l-5 3 2 5 3-1.5V21h8V9.5L19 11l2-5-5-3a4 4 0 0 1-8 0z"/>',
    jacket: '<path d="M9 3L4 6v15h5V9"/><path d="M15 3l5 3v15h-5V9"/><path d="M9 3l3 5 3-5"/><path d="M12 8v13"/>',
    pants: '<path d="M6 3h12l1 18h-5l-2-11-2 11H5z"/><path d="M6 7h12"/>',
    shoe: '<path d="M3 16v-6l5 1 4 3 8 1a2 2 0 0 1 2 2v1H3z"/><path d="M3 20h19"/>',
    hat: '<path d="M4 15c0-5 3.5-9 8-9s8 4 8 9"/><path d="M2 15h20v2H2z"/>',
    glasses: '<circle cx="6.5" cy="14" r="3.5"/><circle cx="17.5" cy="14" r="3.5"/><path d="M10 14h4M3 13l1-5M21 13l-1-5"/>',
    mask: '<path d="M4 6c5-2 11-2 16 0v5a8 8 0 0 1-16 0z"/><path d="M8 11h2M14 11h2"/>',
    watch: '<circle cx="12" cy="12" r="5"/><path d="M12 10v2l1.5 1.5M9 7l1-4h4l1 4M9 17l1 4h4l1-4"/>',
    ear: '<path d="M7 9a5 5 0 0 1 10 0c0 3-3 4-3 7a3 3 0 0 1-6 0"/><circle cx="12" cy="19.5" r="1"/>',
    bracelet: '<ellipse cx="12" cy="12" rx="8" ry="4"/><path d="M4 12v2c0 2.2 3.6 4 8 4s8-1.8 8-4v-2"/>',
    bag: '<path d="M5 8h14l-1 13H6z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>',
    vest: '<path d="M8 3h8l1 4 3 2v12H4V9l3-2z"/><path d="M8 3c0 3 1.5 5 4 5s4-2 4-5"/>',
    chain: '<path d="M6 4c0 6 3 10 6 10s6-4 6-10"/><circle cx="12" cy="17" r="3"/>',
    glove: '<path d="M7 21v-8L5 9a1.5 1.5 0 0 1 2.5-1.5L9 10V4a1.5 1.5 0 0 1 3 0v5-6a1.5 1.5 0 0 1 3 0v6-4a1.5 1.5 0 0 1 3 0v9c0 3-2 7-5 7z"/>',
    badge: '<path d="M12 2l3 3h4v4l3 3-3 3v4h-4l-3 3-3-3H5v-4l-3-3 3-3V5h4z"/>',
    scissors: '<circle cx="6" cy="6" r="3"/><circle cx="6" cy="18" r="3"/><path d="M8.1 8.1L20 20M8.1 15.9L20 4"/>',
    beard: '<path d="M5 8c0 8 3 13 7 13s7-5 7-13"/><path d="M8 13c1.5 1 6.5 1 8 0"/><path d="M5 8c2-1 4-1 7 0 3-1 5-1 7 0"/>',
    brow: '<path d="M3 12c3-4 6-4 8-2M13 10c2-2 5-2 8 2"/><circle cx="7" cy="16" r="1.5"/><circle cx="17" cy="16" r="1.5"/>',
    palette: '<path d="M12 3a9 9 0 1 0 0 18c1.7 0 2-1 2-2s-1-1.5-1-2.5 1-1.5 2-1.5h2a4 4 0 0 0 4-4c0-4.4-4-8-9-8z"/><circle cx="7.5" cy="11" r="1"/><circle cx="10" cy="7" r="1"/><circle cx="15" cy="7.5" r="1"/>',
    lips: '<path d="M2 12c3-4 6-5 10-3 4-2 7-1 10 3-3 4-6 6-10 6s-7-2-10-6z"/><path d="M2 12h20"/>',
    dna: '<path d="M7 3c0 6 10 6 10 12s-10 3-10 6M17 3c0 6-10 6-10 12s10 3 10 6M8 7h8M8 17h8"/>',
    face: '<circle cx="12" cy="12" r="9"/><path d="M9 10h.01M15 10h.01M9 15c1.5 1.5 4.5 1.5 6 0"/>',
    sparkle: '<path d="M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8z"/><path d="M19 17l.7 2 2 .7-2 .7-.7 2-.7-2-2-.7 2-.7z"/>',
    eye: '<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
    pen: '<path d="M14 4l6 6L9 21H3v-6z"/><path d="M12 6l6 6"/>',
    hanger: '<path d="M12 7a2 2 0 1 1 2-2c0 1-2 1.5-2 3v1L3 16a1.5 1.5 0 0 0 1 3h16a1.5 1.5 0 0 0 1-3z"/>',
    grid: '<rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>',
    globe: '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18"/>',
    shield: '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/>',
    user: '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-7 8-7s8 3 8 7"/>',
    users: '<circle cx="9" cy="8" r="3.5"/><path d="M2 20c0-3.5 3-6 7-6s7 2.5 7 6"/><path d="M16 4.5a3.5 3.5 0 0 1 0 7M18 14c2.5.7 4 3 4 6"/>',
    male: '<circle cx="10" cy="14" r="6"/><path d="M14.5 9.5L21 3M15 3h6v6"/>',
    female: '<circle cx="12" cy="9" r="6"/><path d="M12 15v7M9 19h6"/>',
    check: '<path d="M4 12l5 5L20 6"/>',
    x: '<path d="M6 6l12 12M18 6L6 18"/>',
    plus: '<path d="M12 5v14M5 12h14"/>',
    minus: '<path d="M5 12h14"/>',
    left: '<path d="M15 5l-7 7 7 7"/>',
    right: '<path d="M9 5l7 7-7 7"/>',
    rotl: '<path d="M3 12a9 9 0 1 0 3-6.7L3 8"/><path d="M3 3v5h5"/>',
    rotr: '<path d="M21 12a9 9 0 1 1-3-6.7L21 8"/><path d="M21 3v5h-5"/>',
    undo: '<path d="M9 14L4 9l5-5"/><path d="M4 9h11a5 5 0 0 1 0 10h-3"/>',
    redo: '<path d="M15 14l5-5-5-5"/><path d="M20 9H9a5 5 0 0 0 0 10h3"/>',
    dice: '<rect x="3" y="3" width="18" height="18" rx="3"/><circle cx="8" cy="8" r="1.2"/><circle cx="16" cy="16" r="1.2"/><circle cx="12" cy="12" r="1.2"/><circle cx="16" cy="8" r="1.2"/><circle cx="8" cy="16" r="1.2"/>',
    reset: '<path d="M4 4v6h6"/><path d="M20 12A8 8 0 0 0 5.3 7.3L4 10M4 12a8 8 0 0 0 14.7 4.7"/>',
    search: '<circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/>',
    star: '<path d="M12 3l2.8 5.8 6.2.9-4.5 4.4 1 6.2L12 17.4 6.5 20.3l1-6.2L3 9.7l6.2-.9z"/>',
    heart: '<path d="M12 20s-8-4.6-8-11a4.5 4.5 0 0 1 8-2.8A4.5 4.5 0 0 1 20 9c0 6.4-8 11-8 11z"/>',
    share: '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><path d="M8.6 10.5l6.8-4M8.6 13.5l6.8 4"/>',
    send: '<path d="M22 2L11 13"/><path d="M22 2l-7 20-4-9-9-4z"/>',
    copy: '<rect x="9" y="9" width="12" height="12" rx="2"/><path d="M5 15V5a2 2 0 0 1 2-2h10"/>',
    trash: '<path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/>',
    edit: '<path d="M4 20h4L20 8l-4-4L4 16z"/>',
    more: '<circle cx="5" cy="12" r="1.3"/><circle cx="12" cy="12" r="1.3"/><circle cx="19" cy="12" r="1.3"/>',
    save: '<path d="M5 3h11l3 3v15H5z"/><path d="M8 3v5h7V3M8 21v-7h8v7"/>',
    download: '<path d="M12 3v12M7 10l5 5 5-5M4 21h16"/>',
    upload: '<path d="M12 21V9M7 14l5-5 5 5M4 3h16"/>',
    folder: '<path d="M3 6h6l2 2h10v11H3z"/>',
    cash: '<rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="12" cy="12" r="3"/>',
    bank: '<path d="M3 10l9-6 9 6M5 10v8M9 10v8M15 10v8M19 10v8M3 21h18"/>',
    cart: '<circle cx="9" cy="20" r="1.5"/><circle cx="18" cy="20" r="1.5"/><path d="M2 3h3l3 12h11l2-8H6.5"/>',
    camera: '<path d="M3 8h4l2-3h6l2 3h4v12H3z"/><circle cx="12" cy="13" r="4"/>',
    body: '<circle cx="12" cy="4.5" r="2.5"/><path d="M8 22l1-9-3-5h12l-3 5 1 9"/>',
    head: '<circle cx="12" cy="9" r="6"/><path d="M8 21v-3M16 21v-3"/>',
    legs: '<path d="M8 3h8l-1 18h-2l-1-12-1 12H9z"/>',
    feet: '<path d="M4 18v-4l5 1 4 2 7 1v2H4z"/>',
    torso: '<path d="M7 3l-3 4 2 3v11h12V10l2-3-3-4z"/>',
    sun: '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2M5 5l1.5 1.5M17.5 17.5L19 19M5 19l1.5-1.5M17.5 6.5L19 5"/>',
    bulb: '<path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-4 10.5c.8.8 1 1.5 1 2.5h6c0-1 .2-1.7 1-2.5A6 6 0 0 0 12 3z"/>',
    hide: '<path d="M3 3l18 18M10.6 6.1A10 10 0 0 1 12 6c6 0 10 6 10 6a17 17 0 0 1-3.1 3.6M6.6 6.6C3.8 8.4 2 12 2 12s4 6 10 6c1.8 0 3.4-.5 4.8-1.3"/>',
    gift: '<rect x="3" y="8" width="18" height="13"/><path d="M3 12h18M12 8v13M12 8S10 3 7.5 4 9 8 12 8zM12 8s2-5 4.5-4S15 8 12 8z"/>',
    ink: '<path d="M12 2s6 7 6 12a6 6 0 0 1-12 0c0-5 6-12 6-12z"/><path d="M9 15a3 3 0 0 0 3 3"/>',
    run: '<circle cx="15" cy="4" r="2"/><path d="M7 21l3-6 3 2v5M5 11l3-3 4 1 3 3 3 1M10 15l2-6"/>',
    tie: '<path d="M10 3h4l-1 3 2 11-3 4-3-4 2-11z"/>',
    hoodie: '<path d="M7 5c0-1 2-2 5-2s5 1 5 2l3 3-2 4-1-1v10H7V11l-1 1-2-4z"/><path d="M9 5c0 3 1.5 5 3 5s3-2 3-5"/>',
    lock: '<rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>',
    info: '<circle cx="12" cy="12" r="9"/><path d="M12 11v6M12 7.5v.01"/>',
    alert: '<path d="M12 3l10 18H2z"/><path d="M12 10v5M12 18v.01"/>',
    flame: '<path d="M12 22c4 0 7-3 7-7 0-5-5-7-5-12-3 2-5 5-5 8-1-1-2-2-2-4-1.5 2-2 4-2 6 0 5 3 9 7 9z"/>',
    clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    trophy: '<path d="M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0z"/><path d="M17 5h3v2a3 3 0 0 1-3 3M7 5H4v2a3 3 0 0 0 3 3"/>',
    code: '<path d="M8 6l-6 6 6 6M16 6l6 6-6 6"/>',
};

export function icon(name, cls = '') {
    const span = document.createElement('span');
    span.style.display = 'contents';
    span.innerHTML = `<svg class="i ${cls}" viewBox="0 0 24 24">${P[name] || P.info}</svg>`;
    return span.firstChild;
}

// ───────────── sounds (tiny WebAudio blips) ─────────────
let audio = null;
let soundsOn = true;
export function setSounds(on) { soundsOn = on; }
export function sfx(kind = 'tick') {
    if (!soundsOn) return;
    try {
        audio = audio || new (window.AudioContext || window.webkitAudioContext)();
        const o = audio.createOscillator(), g = audio.createGain();
        const f = { tick: 1400, hover: 1900, ok: 880, error: 220, open: 520 }[kind] || 1200;
        o.type = kind === 'error' ? 'sawtooth' : 'sine';
        o.frequency.setValueAtTime(f, audio.currentTime);
        if (kind === 'ok' || kind === 'open') o.frequency.exponentialRampToValueAtTime(f * 1.6, audio.currentTime + 0.12);
        g.gain.setValueAtTime(kind === 'tick' ? 0.025 : 0.05, audio.currentTime);
        g.gain.exponentialRampToValueAtTime(0.0001, audio.currentTime + (kind === 'tick' ? 0.05 : 0.18));
        o.connect(g).connect(audio.destination);
        o.start(); o.stop(audio.currentTime + 0.2);
    } catch (e) { /* audio unavailable */ }
}

// ───────────── toasts ─────────────
export function toast(message, kind = 'info', ms = 3200) {
    const root = document.getElementById('toasts');
    const ic = { success: 'check', error: 'alert', info: 'info' }[kind] || 'info';
    const el = h('div', { class: `toast ${kind}` }, icon(ic), h('span', {}, message));
    root.append(el);
    sfx(kind === 'error' ? 'error' : kind === 'success' ? 'ok' : 'tick');
    setTimeout(() => { el.classList.add('out'); setTimeout(() => el.remove(), 300); }, ms);
}

// ───────────── modals ─────────────
export function modal(build, { dismissable = true } = {}) {
    const root = document.getElementById('modal-root');
    return new Promise((resolve) => {
        const close = (v) => { backdrop.remove(); resolve(v); };
        const box = h('div', { class: 'modal glass' }, h('div', { class: 'edge' }));
        const backdrop = h('div', { class: 'backdrop', onmousedown: (e) => { if (dismissable && e.target === backdrop) close(null); } }, box);
        build(box, close);
        root.append(backdrop);
        const first = box.querySelector('input');
        if (first) setTimeout(() => first.focus(), 30);
    });
}

export function confirmBox(title, text, { ok = 'Confirm', danger = false } = {}) {
    return modal((box, close) => {
        box.append(
            h('h3', {}, title), h('p', {}, text),
            h('div', { class: 'row' },
                h('button', { class: 'btn ghost', onclick: () => close(false) }, 'Cancel'),
                h('button', { class: `btn ${danger ? 'danger' : 'primary'}`, onclick: () => close(true) }, ok)));
    });
}

// fields: [{ name, label, value, placeholder, max }]
export function formBox(title, text, fields, { ok = 'Save' } = {}) {
    return modal((box, close) => {
        const inputs = {};
        const submit = () => {
            const out = {};
            for (const f of fields) out[f.name] = inputs[f.name].value.trim();
            if (fields[0].required !== false && !out[fields[0].name]) { inputs[fields[0].name].focus(); return; }
            close(out);
        };
        box.append(h('h3', {}, title));
        if (text) box.append(h('p', {}, text));
        for (const f of fields) {
            const input = h('input', { class: 'input', value: f.value || '', placeholder: f.placeholder || '', maxlength: f.max || 32, onkeydown: (e) => { if (e.key === 'Enter') submit(); } });
            if (f.upper) input.addEventListener('input', () => { input.value = input.value.toUpperCase(); });
            inputs[f.name] = input;
            box.append(h('div', { class: 'field' }, h('div', { class: 'field-label' }, f.label), input));
        }
        box.append(h('div', { class: 'row' },
            h('button', { class: 'btn ghost', onclick: () => close(null) }, 'Cancel'),
            h('button', { class: 'btn primary', onclick: submit }, ok)));
    });
}

export function copyText(text) {
    const ta = h('textarea', { style: { position: 'fixed', opacity: 0 } });
    ta.value = text;
    document.body.append(ta);
    ta.select();
    try { document.execCommand('copy'); } catch (e) { /* ignore */ }
    ta.remove();
}

// Close any open dropdown when clicking elsewhere
document.addEventListener('mousedown', (e) => {
    document.querySelectorAll('.dropdown').forEach((d) => { if (!d.contains(e.target)) d.remove(); });
});

export function dropdown(anchor, items) {
    document.querySelectorAll('.dropdown').forEach((d) => d.remove());
    const menu = h('div', { class: 'dropdown' });
    for (const it of items) {
        if (it === '-') { menu.append(h('hr')); continue; }
        if (!it) continue;
        menu.append(h('button', { class: it.danger ? 'danger' : '', onclick: () => { menu.remove(); it.action(); } }, icon(it.icon), it.label));
    }
    anchor.style.position = 'relative';
    anchor.append(menu);
}
