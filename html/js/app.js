// Mezos Appearance — UI orchestrator.

import { h, $, icon, money, toast, confirmBox, sfx, setSounds } from './ui.js';
import { post, IS_GAME } from './bridge.js';
import { S, init, onChange, cart, isDirty, commitDone, undo, redo, changedKeys, resetKeys } from './state.js';
import { resetLive, syncAll, focusCam, setLastCam } from './components.js';
import { TAB, MODES } from './views/editor.js';
import { STEPS, renderStep, randomizeStep, randomizeAll } from './views/creator.js';
import { openBag, hideBag, showOffer } from './views/bag.js';
import { preview, clearPreview, reason } from './views/wardrobe.js';
import { CLOTHING_KEYS, BARBER_KEYS, HERITAGE_KEYS, FEATURES, SURGEON_REST } from './schema.js';

const app = $('#app');
let modeDef = null;
let currentTab = null;
let step = 0;
let refs = {};

const TAB_KEYS = {
    tops: ['torso2', 't-shirt', 'arms', 'vest', 'decals'], bottoms: ['pants', 'shoes'], accessories: ['mask', 'accessory', 'bag'],
    props: ['hat', 'glass', 'ear', 'watch', 'bracelet'], hair: ['hair', 'hair_fade'], facial: ['beard', 'eyebrows', 'chest_hair'],
    makeup: ['makeup', 'blush', 'lipstick'], heritage: HERITAGE_KEYS, features: FEATURES, skin: SURGEON_REST, tattoos: ['tattoos'],
};

// ───────────── theme ─────────────
function hexToRgb(hex) {
    const m = /^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i.exec(hex || '');
    return m ? `${parseInt(m[1], 16)}, ${parseInt(m[2], 16)}, ${parseInt(m[3], 16)}` : null;
}
function applyTheme(theme = {}) {
    const root = document.documentElement.style;
    for (const k of ['accent', 'accent2', 'danger', 'success']) {
        if (!theme[k]) continue;
        root.setProperty(`--${k}`, theme[k]);
        const rgb = hexToRgb(theme[k]);
        if (rgb) root.setProperty(`--${k}-rgb`, rgb);
    }
    setSounds(theme.sounds !== false);
}

// ───────────── intro ─────────────
function playIntro(theme) {
    return new Promise((resolve) => {
        const el = $('#intro');
        const log = h('div', { class: 'log' });
        const bar = h('i');
        let done = false;
        const finish = () => {
            if (done) return;
            done = true;
            el.classList.add('fade');
            setTimeout(() => { el.classList.add('hidden'); el.classList.remove('fade'); el.innerHTML = ''; }, 800);
            window.removeEventListener('keydown', finish);
            resolve();
        };
        el.innerHTML = '';
        el.append(h('div', { class: 'grid-floor' }),
            h('div', { class: 'core' },
                h('div', { class: 'ring' }, h('div')),
                h('h1', {}, theme.serverName || 'MEZOS'),
                h('h2', {}, (theme.tagline || 'Design your future self').toUpperCase()),
                log, h('div', { class: 'bar' }, bar)),
            h('button', { class: 'skip', onclick: finish }, 'Press any key to skip'));
        el.classList.remove('hidden');
        sfx('open');
        const lines = [
            'Initializing GENESIS protocol', 'Mapping neural identity matrix', 'Calibrating genome sequencer',
            'Loading morphology lattice', 'Syncing citizen registry', 'Biometric studio online',
        ];
        lines.forEach((l, i) => setTimeout(() => {
            if (done) return;
            log.append(h('div', {}, `> ${l}... `, h('b', {}, 'OK')));
            log.scrollTop = 9999;
            bar.style.width = `${((i + 1) / lines.length) * 100}%`;
            sfx('tick');
        }, 350 + i * 420));
        setTimeout(finish, 350 + lines.length * 420 + 700);
        setTimeout(() => window.addEventListener('keydown', finish), 400);
    });
}

// ───────────── shell ─────────────
function walletPills() {
    const m = S.data.money;
    if (!m || !S.data.prices) return null;
    return h('div', { class: 'wallet' },
        h('div', { class: 'pill' }, icon('cash'), money(m.cash)),
        h('div', { class: 'pill' }, icon('bank'), money(m.bank)));
}

function cameraCard() {
    const presets = [['full', 'body'], ['head', 'head'], ['torso', 'torso'], ['legs', 'legs'], ['feet', 'feet']];
    const lights = [['studio', '#fff5ea'], ['neon', '#28dcff'], ['violet', '#aa5aff'], ['sunset', '#ff8c46'], ['off', '#222']];
    const cam = h('div', { class: 'camctl' }, presets.map(([p, ic]) => h('button', { title: p, 'data-p': p, onclick: (e) => {
        setLastCam(null); focusCam(p);
        cam.querySelectorAll('button').forEach((b) => b.classList.toggle('active', b === e.currentTarget));
    } }, icon(ic))));
    const light = h('div', { class: 'lightctl' }, lights.map(([l, c]) => h('button', { title: `Lighting: ${l}`, class: l === 'studio' ? 'active' : '', onclick: (e) => {
        post('camera', { lighting: l });
        light.querySelectorAll('button').forEach((b) => b.classList.toggle('active', b === e.currentTarget));
    } }, h('i', { style: { background: c, boxShadow: `0 0 8px ${c}` } }))));
    return h('div', { class: 'card glass' }, h('div', { class: 'edge' }),
        h('h3', {}, icon('camera'), 'Camera'), cam, light,
        h('div', { class: 'rotate-row' },
            h('button', { onclick: () => post('camera', { rotate: -45 }) }, icon('rotl')),
            h('button', { onclick: () => post('camera', { angle: 0 }) }, 'Front'),
            h('button', { onclick: () => post('camera', { angle: 180 }) }, 'Back'),
            h('button', { onclick: () => post('camera', { rotate: 45 }) }, icon('rotr')),
            h('button', { title: 'Hide UI (H)', onclick: toggleHide }, icon('hide'))));
}

function cartCard() {
    const list = h('div', { class: 'cart-list' });
    const total = h('b');
    refs.cartList = list;
    refs.cartTotal = total;
    return h('div', { class: 'card glass cart' }, h('div', { class: 'edge' }),
        h('h3', {}, icon('cart'), 'Checkout'), list,
        h('div', { class: 'cart-total' }, h('span', { style: { color: 'var(--muted)', letterSpacing: '2px', fontSize: '12px', textTransform: 'uppercase', fontWeight: 700 } }, 'Total'), total));
}

function updateCart() {
    if (refs.payBtn && !refs.cartList) refs.payBtn.disabled = !isDirty();
    if (!refs.cartList) return;
    const c = cart();
    refs.cartList.innerHTML = '';
    if (!c.lines.length) refs.cartList.append(h('div', { class: 'cart-empty' }, 'No changes yet. Everything you modify appears here.'));
    c.lines.forEach((l) => refs.cartList.append(h('div', { class: `cart-row ${l.removal ? 'removal' : ''}` }, h('span', {}, l.label), h('span', {}, l.price > 0 ? money(l.price) : 'FREE'))));
    refs.cartTotal.textContent = money(c.total);
    if (refs.payBtn) {
        refs.payBtn.disabled = !isDirty();
        refs.payBtn.lastChild.textContent = c.total > 0 ? `Pay ${money(c.total)}` : 'Confirm';
    }
}

function updateDots() {
    if (!refs.rail) return;
    refs.rail.querySelectorAll('.rail-btn').forEach((b) => {
        const keys = TAB_KEYS[b.dataset.tab];
        const dot = b.querySelector('.dot');
        if (dot) dot.classList.toggle('hidden', !(keys && changedKeys(keys).length));
    });
}

function actionsCard() {
    const mode = S.mode;
    const card = h('div', { class: 'card glass actions' }, h('div', { class: 'edge' }));
    const undoRow = h('div', { style: { display: 'flex', gap: '8px' } },
        h('button', { class: 'btn sm ghost', style: { flex: 1 }, onclick: undo, title: 'Ctrl+Z' }, icon('undo'), 'Undo'),
        h('button', { class: 'btn sm ghost', style: { flex: 1 }, onclick: redo, title: 'Ctrl+Y' }, icon('redo'), 'Redo'));

    if (mode === 'creator') {
        card.append(
            h('button', { class: 'btn block', onclick: () => randomizeStep(STEPS[step]) }, icon('dice'), 'Randomize step'),
            h('button', { class: 'btn ghost block', onclick: randomizeAll }, icon('sparkle'), 'Randomize everything'),
            undoRow);
        return card;
    }
    if (modeDef.readonly) {
        card.append(h('button', { class: 'btn block', onclick: exit }, icon('x'), 'Close'));
        return card;
    }
    const pay = h('button', { class: 'btn primary block', onclick: confirmPurchase }, icon('check'), h('span', {}, mode === 'admin' ? 'Save' : 'Confirm'));
    refs.payBtn = pay;
    card.append(pay, undoRow,
        h('div', { style: { display: 'flex', gap: '8px' } },
            h('button', { class: 'btn sm ghost', style: { flex: 1 }, onclick: () => resetKeys(Object.keys(S.baseline)) }, icon('reset'), 'Reset'),
            h('button', { class: 'btn sm danger', style: { flex: 1 }, onclick: exit }, icon('x'), 'Exit')));
    if (S.data.bagPrice) {
        card.append(h('div', { class: 'item', style: { marginTop: '4px' } },
            h('div', { class: 'ico' }, icon('bag')),
            h('div', { class: 'meta' }, h('b', {}, 'Outfit Bag'), h('small', {}, `Carry outfits anywhere · ${money(S.data.bagPrice)}`)),
            h('button', { class: 'btn sm', onclick: buyBag }, 'Buy')));
    }
    return card;
}

function build() {
    const mode = S.mode;
    modeDef = mode === 'creator' ? { title: 'Genesis' } : MODES[mode];
    refs = {};
    app.innerHTML = '';
    app.className = '';

    const drag = h('div', { class: 'drag-zone' });
    bindDrag(drag);

    const topbar = h('div', { class: 'topbar' },
        h('div', { class: 'brand' }, h('div', { class: 'logo' }, icon('logo')),
            h('div', {}, h('small', {}, (S.data.theme && S.data.theme.serverName) || 'Mezos'), h('h1', {}, mode === 'creator' ? 'Genesis' : (S.data.context || modeDef.title)))),
        walletPills());

    const panel = h('div', { class: 'panel glass' }, h('div', { class: 'edge' }));
    refs.head = h('div', { class: 'panel-head' });
    refs.body = h('div', { class: 'panel-body' });
    refs.foot = h('div', { class: 'panel-foot hidden' });
    panel.append(refs.head, refs.body, refs.foot);

    const side = h('div', { class: 'side' });
    if (S.data.prices) side.append(cartCard());
    side.append(actionsCard(), cameraCard());

    const hints = h('div', { class: 'hints' },
        h('span', {}, h('kbd', {}, 'DRAG'), 'Rotate'), h('span', {}, h('kbd', {}, 'WHEEL'), 'Zoom'),
        h('span', {}, h('kbd', {}, 'H'), 'Hide UI'), mode !== 'wardrobe' ? h('span', {}, h('kbd', {}, 'CTRL+Z'), 'Undo') : null,
        mode !== 'creator' ? h('span', {}, h('kbd', {}, 'ESC'), 'Exit') : null);

    app.append(h('div', { class: 'vignette' }), drag, topbar);

    if (mode === 'creator') {
        refs.steps = h('div', { class: 'steps glass' });
        app.append(refs.steps);
        topbar.querySelector('.brand').style.visibility = 'visible';
    } else {
        refs.rail = h('div', { class: 'rail glass' });
        modeDef.tabs.forEach((id) => {
            if (id === '|') { refs.rail.append(h('div', { class: 'rail-sep' })); return; }
            const t = TAB[id];
            if (id === 'gallery' && !S.data.gallery) return;
            refs.rail.append(h('button', { class: 'rail-btn', 'data-tab': id, 'data-tip': t.label, onclick: () => showTab(id) }, icon(t.icon), TAB_KEYS[id] ? h('i', { class: 'dot hidden' }) : null));
        });
        app.append(refs.rail);
    }
    app.append(panel, side, hints, h('button', { class: 'btn sm unhide hidden', onclick: toggleHide }, icon('eye'), 'Show UI'));
    app.classList.remove('hidden');

    if (mode === 'creator') showStep(0);
    else showTab(modeDef.tabs[0]);
    updateCart();
}

function setHead(eyebrow, title, desc) {
    refs.head.innerHTML = '';
    refs.head.append(h('div', { class: 'eyebrow' }, eyebrow), h('h2', {}, title), desc ? h('p', {}, desc) : null);
}

function showTab(id) {
    clearPreview();
    currentTab = id;
    const t = TAB[id];
    resetLive();
    setHead(t.eyebrow, t.title, t.desc);
    refs.body.innerHTML = '';
    refs.body.scrollTop = 0;
    const content = t.render(modeDef.prices);
    (Array.isArray(content) ? content : [content]).forEach((c) => c && refs.body.append(c));
    refs.rail.querySelectorAll('.rail-btn').forEach((b) => b.classList.toggle('active', b.dataset.tab === id));
    setLastCam(null);
    focusCam(t.cam);
    updateDots();
    sfx('tick');
}

function showStep(i) {
    step = Math.max(0, Math.min(STEPS.length - 1, i));
    const st = STEPS[step];
    resetLive();
    setHead(`Step ${step + 1} of ${STEPS.length}`, st.title, st.desc);
    refs.body.innerHTML = '';
    refs.body.scrollTop = 0;
    refs.body.append(renderStep(st));

    refs.steps.innerHTML = '';
    STEPS.forEach((s, n) => {
        if (n) refs.steps.append(h('div', { class: 'step-line' }));
        refs.steps.append(h('button', { class: `step ${n === step ? 'active' : ''} ${n < step ? 'done' : ''}`, onclick: () => showStep(n) },
            h('i', {}, n < step ? '✓' : n + 1), h('span', {}, s.label)));
    });

    refs.foot.classList.remove('hidden');
    refs.foot.innerHTML = '';
    refs.foot.append(
        h('button', { class: 'btn ghost', disabled: step === 0, onclick: () => showStep(step - 1) }, icon('left'), 'Back'),
        step === STEPS.length - 1
            ? h('button', { class: 'btn primary', style: { flex: 1 }, onclick: confirmPurchase }, icon('check'), 'Enter the city')
            : h('button', { class: 'btn primary', style: { flex: 1 }, onclick: () => showStep(step + 1) }, 'Next', icon('right')));
    setLastCam(null);
    focusCam(st.cam);
    sfx('tick');
}

// ───────────── actions ─────────────
async function confirmPurchase() {
    const mode = S.mode;
    if (mode !== 'creator' && !isDirty()) return toast('Nothing to confirm', 'info');
    const c = cart();
    if (mode === 'creator') {
        if (!(await confirmBox('Finalize character', 'Your face can only be changed later by a plastic surgeon. Ready?', { ok: 'Enter the city' }))) return;
    } else if (c.total > 0) {
        if (!(await confirmBox('Confirm purchase', `You will be charged ${money(c.total)} for ${c.lines.length} item${c.lines.length > 1 ? 's' : ''}.`, { ok: `Pay ${money(c.total)}` }))) return;
    }
    const res = await post('commit');
    if (res && res.ok) {
        commitDone(res.skin);
        if (S.data.money && res.price) {
            // reflect the payment locally (server already charged)
            const m = S.data.money;
            if (m.cash >= res.price) m.cash -= res.price; else m.bank -= res.price;
            const w = app.querySelector('.wallet');
            if (w) w.replaceWith(walletPills());
        }
        if (mode === 'creator') {
            toast('Welcome to the city', 'success');
            setTimeout(() => post('close', { force: true, revert: false }), 600);
            return;
        }
        toast(res.price > 0 ? `Purchased for ${money(res.price)}` : 'Saved', 'success');
        updateCart(); updateDots();
    } else if (res && res.reason === 'money') {
        toast(`You can't afford this (${money(res.price)})`, 'error');
    } else {
        toast('Could not save your look', 'error');
    }
}

async function exit() {
    if (S.mode === 'creator') return;
    if (!modeDef.readonly && isDirty()) {
        const ok = await confirmBox('Discard changes?', S.data.prices ? 'You have unpaid changes. Leaving will revert them.' : 'Your unsaved changes will be lost.', { ok: 'Discard', danger: true });
        if (!ok) return;
    }
    post('close', { revert: true });
}

async function buyBag() {
    if (!(await confirmBox('Buy outfit bag', `Buy an outfit bag for ${money(S.data.bagPrice)}? Pack outfits inside and change anywhere — or hand it to a friend.`, { ok: 'Buy' }))) return;
    const { server } = await import('./bridge.js');
    const res = await server('buyBag');
    res && res.ok ? toast('Outfit bag added to your inventory', 'success') : toast(res && res.reason === 'inventory' ? 'Your inventory is full' : reason(res && res.reason), 'error');
}

function toggleHide() {
    const hidden = app.classList.toggle('ui-hidden');
    app.querySelector('.unhide').classList.toggle('hidden', !hidden);
}

// ───────────── camera drag / wheel ─────────────
function bindDrag(zone) {
    let dragging = false, acc = 0, raf = null;
    const flush = () => { raf = null; if (acc) { post('camera', { rotate: acc }); acc = 0; } };
    zone.addEventListener('mousedown', (e) => { if (e.button === 0) dragging = true; });
    window.addEventListener('mouseup', () => { dragging = false; });
    window.addEventListener('mousemove', (e) => {
        if (!dragging) return;
        acc += e.movementX * 0.45;
        if (!raf) raf = requestAnimationFrame(flush);
    });
    zone.addEventListener('wheel', (e) => { post('camera', { zoom: e.deltaY > 0 ? 0.08 : -0.08 }); }, { passive: true });
}

window.addEventListener('keydown', (e) => {
    if (app.classList.contains('hidden') || !S.data) return;
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
    if (document.querySelector('#modal-root .backdrop')) { if (e.key === 'Escape') document.querySelector('#modal-root .backdrop').dispatchEvent(new MouseEvent('mousedown')); return; }
    const k = e.key.toLowerCase();
    if (k === 'h') toggleHide();
    else if (e.ctrlKey && k === 'z' && !e.shiftKey) undo();
    else if (e.ctrlKey && (k === 'y' || (k === 'z' && e.shiftKey))) redo();
    else if (k === 'escape') exit();
    else if (k === 'q' || k === 'arrowleft') post('camera', { rotate: -15 });
    else if (k === 'e' || k === 'arrowright') post('camera', { rotate: 15 });
});

// ───────────── live updates ─────────────
onChange((reasonName) => {
    if (reasonName === 'skin' || reasonName === 'reload' || reasonName === 'limits') syncAll();
    updateCart();
    updateDots();
});
document.addEventListener('mz:rerender', () => {
    if (S.mode === 'creator') showStep(step);
    else if (currentTab) showTab(currentTab);
});
document.addEventListener('mz:outfits', () => { if (currentTab === 'wardrobe') showTab('wardrobe'); });

// ───────────── messages from Lua ─────────────
async function open(data) {
    init(data);
    applyTheme(data.theme);
    if (data.mode === 'creator' && data.creator && data.creator.intro) await playIntro(data.theme || {});
    build();
    sfx('open');
}

function closeUI() {
    app.classList.add('hidden');
    app.innerHTML = '';
    $('#modal-root').innerHTML = '';
    S.data = null;
    currentTab = null;
}

function promptMsg(m) {
    const el = $('#prompt');
    if (!m.show) { el.classList.add('hidden'); return; }
    el.className = 'glass';
    el.innerHTML = '';
    el.append(h('div', { class: 'key' }, m.key || 'E'), h('div', {}, h('small', {}, m.title), h('b', {}, m.text)));
}

window.addEventListener('message', (e) => {
    const m = e.data || {};
    switch (m.action) {
        case 'open': $('#prompt').classList.add('hidden'); open(m.data); break;
        case 'close': closeUI(); break;
        case 'toast': toast(m.message, m.kind); break;
        case 'prompt': if (app.classList.contains('hidden')) promptMsg(m); break;
        case 'bag': applyTheme(m.theme); $('#prompt').classList.add('hidden'); openBag(m); break;
        case 'bagHide': hideBag(); break;
        case 'offer': if (m.offer && m.offer.skin === undefined) m.offer.skin = {}; showOffer(m, !app.classList.contains('hidden'), preview); break;
        case 'reloadOutfits': document.dispatchEvent(new CustomEvent('mz:outfits')); break;
    }
});

if (!IS_GAME) import('./dev.js');
