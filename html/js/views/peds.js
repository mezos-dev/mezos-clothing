// Admin: switch ped model.

import { h, icon, toast } from '../ui.js';
import { post } from '../bridge.js';
import { S, commitDone } from '../state.js';

export async function switchModel(payload) {
    const res = await post('setModel', payload);
    if (!res || !res.skin) return toast('Model could not be loaded', 'error');
    S.data.freemode = res.freemode;
    S.data.gender = res.gender;
    S.data.model = res.model;
    if (res.tattoos) S.data.tattoos = res.tattoos;
    S.limits = res.limits || {};
    // a new model starts a fresh editing session (undo history can't cross models)
    commitDone(res.skin);
    document.dispatchEvent(new CustomEvent('mz:rerender'));
    return res;
}

export function pedsView() {
    let list = 'male', query = '';
    const models = S.data.models || { male: [], female: [] };
    const out = h('div', { class: 'list' });
    const seg = h('div', { class: 'seg' },
        h('button', { class: 'active', onclick: (e) => { list = 'male'; mark(e.currentTarget); render(); } }, icon('male'), `Male (${models.male.length})`),
        h('button', { onclick: (e) => { list = 'female'; mark(e.currentTarget); render(); } }, icon('female'), `Female (${models.female.length})`));
    const mark = (b) => { seg.querySelectorAll('button').forEach((x) => x.classList.remove('active')); b.classList.add('active'); };

    function render() {
        out.innerHTML = '';
        models[list].filter((m) => !query || m.toLowerCase().includes(query)).slice(0, 150).forEach((m) => {
            out.append(h('button', { class: 'item', onclick: () => switchModel({ model: m }) },
                h('div', { class: 'ico' }, icon(m.includes('freemode') ? 'sparkle' : 'user')),
                h('div', { class: 'meta' }, h('b', {}, m), h('small', {}, m.includes('freemode') ? 'Fully customizable' : 'Components only'))));
        });
    }
    render();
    return h('div', {},
        h('div', { style: { display: 'flex', gap: '8px', marginBottom: '12px' } },
            h('button', { class: 'btn sm', style: { flex: 1 }, onclick: () => switchModel({ gender: 'male' }) }, icon('male'), 'Freemode M'),
            h('button', { class: 'btn sm', style: { flex: 1 }, onclick: () => switchModel({ gender: 'female' }) }, icon('female'), 'Freemode F')),
        seg,
        h('div', { class: 'search' }, icon('search'), h('input', { class: 'input', placeholder: 'Search models…', oninput: (e) => { query = e.target.value.toLowerCase(); render(); }, onkeydown: (e) => e.stopPropagation() })),
        out);
}
