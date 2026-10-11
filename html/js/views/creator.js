// "Genesis" first-spawn creator: intro + step wizard.

import { h, icon, sfx } from '../ui.js';
import { S, applySkin } from '../state.js';
import { FEATURES, FATHERS, MOTHERS, clone, EYE_COLORS } from '../schema.js';
import { heritagePanel, featureSlider, section, eyeColorPicker, overlayPicker, hairPicker, fadePicker, itemPicker, live, focusCam } from '../components.js';
import { FEATURE_GROUPS } from '../schema.js';
import { switchModel } from './peds.js';

const rnd = (n) => Math.floor(Math.random() * n);
const pick = (arr) => arr[rnd(arr.length)];

// ───────────── randomizers ─────────────
function randomHeritage(skin) {
    const f = pick(FATHERS)[0], m = pick(MOTHERS)[0];
    skin.face = { item: f, texture: f };
    skin.face2 = { item: m, texture: m };
    skin.facemix = { shapeMix: +(0.2 + Math.random() * 0.6).toFixed(2), skinMix: +(0.2 + Math.random() * 0.6).toFixed(2) };
}
function randomFace(skin) {
    for (const k of FEATURES) skin[k] = { item: Math.round((Math.random() * 10 - 5) * 2) / 2, texture: 0 };
}
function randomSkin(skin) {
    skin.eye_color = { item: rnd(8) };
    skin.complexion = { item: Math.random() < 0.5 ? -1 : rnd(12), texture: 0, opacity: +(Math.random() * 0.6).toFixed(2) };
    skin.moles = { item: Math.random() < 0.6 ? -1 : rnd(18), texture: 0, opacity: +(Math.random() * 0.7).toFixed(2) };
    skin.blemishes = { item: -1, texture: 0, opacity: 1 };
    skin.ageing = { item: -1, texture: 0, opacity: 1 };
}
function randomHair(skin) {
    const max = (S.limits.hair && S.limits.hair.max) || 20;
    const color = rnd(Math.min(30, (S.data.palettes.hair || []).length || 30));
    skin.hair = { item: rnd(Math.min(max, 40)), texture: color, highlight: Math.random() < 0.7 ? color : rnd(30) };
    skin.eyebrows = { item: rnd(20), texture: color, opacity: +(0.6 + Math.random() * 0.4).toFixed(2) };
    if (S.data.gender === 'male') skin.beard = Math.random() < 0.5 ? { item: -1, texture: color, opacity: 1 } : { item: rnd(20), texture: color, opacity: +(0.5 + Math.random() * 0.5).toFixed(2) };
}
function randomMakeup(skin) {
    const female = S.data.gender === 'female';
    skin.makeup = female && Math.random() < 0.6 ? { item: rnd(16), texture: rnd(20), opacity: 0.8 } : { item: -1, texture: 0, opacity: 1 };
    skin.lipstick = female && Math.random() < 0.6 ? { item: rnd(9), texture: rnd(30), opacity: 0.7 } : { item: -1, texture: 0, opacity: 1 };
    skin.blush = female && Math.random() < 0.4 ? { item: rnd(6), texture: rnd(20), opacity: 0.5 } : { item: -1, texture: 0, opacity: 1 };
}
function applyPreset(skin, preset) {
    for (const [k, v] of Object.entries(preset.data)) skin[k] = { item: v.item, texture: v.texture };
}

export function randomizeAll() {
    const s = clone(S.skin);
    randomHeritage(s); randomFace(s); randomSkin(s); randomHair(s); randomMakeup(s);
    const presets = (S.data.creator.starterOutfits || {})[S.data.gender] || [];
    if (presets.length) applyPreset(s, pick(presets));
    applySkin(s);
}

// ───────────── steps ─────────────
export const STEPS = [
    { id: 'identity', label: 'Identity', icon: 'user', title: 'Identity', desc: 'Choose the body you will inhabit.', cam: 'full' },
    { id: 'heritage', label: 'Heritage', icon: 'dna', title: 'Heritage', desc: 'Your parents shape your face and skin.', cam: 'head', random: randomHeritage },
    { id: 'face', label: 'Face', icon: 'face', title: 'Face Sculpt', desc: 'Sculpt every detail. Double-click a slider to reset.', cam: 'head', random: randomFace },
    { id: 'skin', label: 'Skin', icon: 'sparkle', title: 'Skin & Eyes', desc: 'Complexion, age and eye color.', cam: 'head', random: randomSkin },
    { id: 'hair', label: 'Hair', icon: 'scissors', title: 'Hair & Facial Hair', desc: 'Cut, color and grooming.', cam: 'head', random: randomHair },
    { id: 'makeup', label: 'Makeup', icon: 'palette', title: 'Makeup', desc: 'Optional finishing touches.', cam: 'head', random: randomMakeup },
    { id: 'outfit', label: 'Outfit', icon: 'shirt', title: 'Starter Outfit', desc: 'Pick a starting style — you can shop for more later.', cam: 'full' },
    { id: 'review', label: 'Review', icon: 'check', title: 'Final Review', desc: 'Take a last look. You are ready to enter the city.', cam: 'full' },
];

export function randomizeStep(step) {
    if (!step.random) return;
    const s = clone(S.skin);
    step.random(s);
    applySkin(s);
    sfx('ok');
}

export function renderStep(step) {
    const d = S.data;
    switch (step.id) {
        case 'identity': {
            const wrap = h('div', {});
            if (d.creator.allowGenderSwap) {
                const set = async (g) => {
                    if (g === d.gender) return;
                    await switchModel({ gender: g });
                    const s = clone(S.skin);
                    randomHeritage(s);
                    const presets = (d.creator.starterOutfits || {})[g] || [];
                    if (presets.length) applyPreset(s, presets[0]);
                    s.eyebrows = { item: 0, texture: 0, opacity: 1 };
                    await applySkin(s, { record: false });
                };
                wrap.append(section('Body Type', 'body', [], h('div', { class: 'gender' },
                    h('button', { class: d.gender === 'male' ? 'active' : '', onclick: () => set('male') }, icon('male'), 'MASCULINE'),
                    h('button', { class: d.gender === 'female' ? 'active' : '', onclick: () => set('female') }, icon('female'), 'FEMININE'))));
            }
            wrap.append(section('Quick Start', 'dice', [], h('div', {},
                h('p', { style: { color: 'var(--muted)', fontSize: '14px', marginBottom: '10px' } }, 'Short on ideas? Generate a complete random look, then refine it step by step.'),
                h('button', { class: 'btn block', onclick: randomizeAll }, icon('dice'), 'Generate random look'))));
            return wrap;
        }
        case 'heritage': return heritagePanel();
        case 'face': return h('div', {}, FEATURE_GROUPS.map((g) => section(g.label, g.icon, g.keys.map((k) => k[0]), h('div', {}, g.keys.map(([k, l]) => featureSlider(k, l))), { cam: 'head' })));
        case 'skin': return h('div', {}, eyeColorPicker(), ['complexion', 'ageing', 'blemishes', 'sun_damage', 'moles'].map((k) => overlayPicker(k)));
        case 'hair': return h('div', {}, hairPicker(), fadePicker(), overlayPicker('eyebrows'), d.gender === 'male' ? overlayPicker('beard') : null, d.gender === 'male' ? overlayPicker('chest_hair') : null);
        case 'makeup': return h('div', {}, overlayPicker('makeup'), overlayPicker('blush'), overlayPicker('lipstick'));
        case 'outfit': {
            const presets = (d.creator.starterOutfits || {})[d.gender] || [];
            const grid = h('div', { class: 'presets' });
            const btns = presets.map((p) => {
                const b = h('button', { class: 'preset', onclick: () => { const s = clone(S.skin); applyPreset(s, p); applySkin(s); sfx('tick'); } }, icon(p.icon || 'shirt'), p.label);
                grid.append(b);
                return [b, p];
            });
            const sync = () => btns.forEach(([b, p]) => b.classList.toggle('active', Object.entries(p.data).every(([k, v]) => S.skin[k] && S.skin[k].item === v.item && S.skin[k].texture === v.texture)));
            live.push(sync); sync();
            return h('div', {}, section('Styles', 'hanger', [], grid), itemPicker('torso2'), itemPicker('pants'), itemPicker('shoes'));
        }
        case 'review': {
            const s = S.skin;
            const father = FATHERS.find((x) => x[0] === s.face.item), mother = MOTHERS.find((x) => x[0] === s.face2.item);
            const cell = (label, value) => h('div', {}, h('small', {}, label), h('b', {}, value));
            focusCam('full');
            return h('div', {},
                section('Profile', 'user', [], h('div', { class: 'summary-grid' },
                    cell('Body', d.gender === 'female' ? 'Feminine' : 'Masculine'),
                    cell('Eyes', EYE_COLORS[s.eye_color.item] || 'Default'),
                    cell('Father', father ? father[1] : '—'),
                    cell('Mother', mother ? mother[1] : '—'),
                    cell('Hair', `Style ${s.hair.item}`),
                    cell('Resemblance', `${Math.round(s.facemix.shapeMix * 100)}% mother`))),
                h('p', { style: { color: 'var(--muted)', fontSize: '14px', lineHeight: 1.45 } },
                    'Your face is permanent once confirmed — only a plastic surgeon can change it later. Clothes, hair and tattoos can be changed at stores around the city.'));
        }
    }
    return h('div');
}
