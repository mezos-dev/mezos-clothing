// Community gallery: trending / new / top / mine, likes, try on, save copy.

import { h, icon, toast, confirmBox } from '../ui.js';
import { server } from '../bridge.js';
import { S } from '../state.js';
import { preview, clearPreview, reason, isPreviewing } from './wardrobe.js';

export function galleryView() {
    if (!S.data.gallery) return h('div', { class: 'empty' }, icon('globe'), h('b', {}, 'Gallery disabled'));
    let sort = 'trending', page = 0, search = '', mine = false, items = [], hasMore = false;
    const root = h('div', {});
    const grid = h('div', { class: 'gallery-grid' });
    const more = h('div', { style: { marginTop: '10px' } });

    const sorts = [['trending', 'flame', 'Trending'], ['new', 'clock', 'New'], ['top', 'trophy', 'Top'], ['mine', 'user', 'Mine']];
    const seg = h('div', { class: 'seg' });
    const btns = sorts.map(([id, ic, label]) => {
        const b = h('button', { onclick: () => { mine = id === 'mine'; sort = mine ? 'new' : id; page = 0; items = []; paintSeg(id); load(); } }, icon(ic), label);
        seg.append(b);
        return [b, id];
    });
    const paintSeg = (id) => btns.forEach(([b, x]) => b.classList.toggle('active', x === id));
    paintSeg('trending');

    let t = null;
    const searchBox = h('div', { class: 'search' }, icon('search'), h('input', {
        class: 'input', placeholder: 'Search name, tag or author…', onkeydown: (e) => e.stopPropagation(),
        oninput: (e) => { clearTimeout(t); t = setTimeout(() => { search = e.target.value; page = 0; items = []; load(); }, 350); },
    }));
    const stop = h('button', { class: 'btn sm block hidden', style: { marginBottom: '10px' }, onclick: async () => { await clearPreview(); stop.classList.add('hidden'); } }, icon('x'), 'Stop preview');

    root.append(seg, searchBox, stop, grid, more);

    async function load() {
        if (page === 0) { grid.innerHTML = ''; grid.append(h('div', { class: 'spinner', style: { gridColumn: '1 / -1' } })); }
        const res = await server('galleryList', { sort, page, search, mine });
        if (!res || !res.ok) { grid.innerHTML = ''; grid.append(h('div', { class: 'empty', style: { gridColumn: '1 / -1' } }, icon('alert'), h('b', {}, reason(res && res.reason)))); return; }
        items = page === 0 ? res.items : items.concat(res.items);
        hasMore = res.hasMore;
        render();
    }

    function card(it, i) {
        const likeBtn = h('button', { class: it.liked ? 'liked' : '', onclick: async () => {
            const r = await server('galleryLike', it.id);
            if (r && r.ok) { it.liked = r.liked; it.likes = r.likes; likeBtn.className = it.liked ? 'liked' : ''; likeBtn.lastChild.textContent = it.likes; }
        } }, icon('heart'), h('span', {}, it.likes));
        return h('div', { class: 'gcard', style: { animationDelay: `${Math.min(i, 10) * 30}ms` } },
            h('div', { class: 'gname', title: it.name }, it.name),
            h('div', { class: 'gby' }, `by ${it.author}`),
            it.tags ? h('div', { class: 'gby', style: { color: 'var(--accent)' } }, it.tags) : null,
            h('div', { class: 'gstats' }, likeBtn, h('span', { style: { display: 'flex', alignItems: 'center', gap: '4px' } }, icon('download'), it.uses),
                (it.mine || S.data.isAdmin) ? h('button', { style: { marginLeft: 'auto' }, title: 'Delete', onclick: async () => {
                    if (!(await confirmBox('Remove post', `Remove "${it.name}" from the gallery?`, { ok: 'Remove', danger: true }))) return;
                    const r = await server('galleryDelete', it.id);
                    if (r && r.ok) { items = items.filter((x) => x.id !== it.id); render(); toast('Post removed', 'success'); }
                } }, icon('trash')) : null),
            h('div', { class: 'gactions' },
                h('button', { class: 'btn sm', onclick: () => { preview(it.skin); stop.classList.remove('hidden'); } }, icon('eye')),
                h('button', { class: 'btn sm primary', onclick: async () => {
                    const r = await server('gallerySave', it.id);
                    if (r && r.ok) { it.uses++; toast('Saved to your wardrobe', 'success'); render(); } else toast(reason(r && r.reason), 'error');
                } }, icon('save'), 'Save')));
    }

    function render() {
        grid.innerHTML = '';
        items.forEach((it, i) => grid.append(card(it, i)));
        if (!items.length) grid.append(h('div', { class: 'empty', style: { gridColumn: '1 / -1' } }, icon('globe'), h('b', {}, mine ? 'You have no posts' : 'Nothing here yet'), mine ? 'Publish an outfit from your wardrobe.' : 'Be the first to publish an outfit.'));
        more.innerHTML = '';
        if (hasMore) more.append(h('button', { class: 'btn sm block', onclick: () => { page++; load(); } }, 'Load more'));
        stop.classList.toggle('hidden', !isPreviewing());
    }

    load();
    return root;
}
