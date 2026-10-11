// Browser-only dev harness: mocks Lua so every view can be tested outside the game.
// Open html/index.html?mode=clothing (clothing|barber|surgeon|tattoo|wardrobe|creator|admin|bag|offer)

import { setMock } from './bridge.js';
import { COMPONENTS, PROPS, OVERLAYS, FEATURES } from './schema.js';

document.body.classList.add('dev');
const params = new URLSearchParams(location.search);
const mode = params.get('mode') || 'clothing';

const hsl = (i, n, s = 55, l = 45) => `hsl(${Math.round((i / n) * 360)}, ${s}%, ${l}%)`;
const palettes = { hair: Array.from({ length: 64 }, (_, i) => hsl(i, 64, 45, 35)), makeup: Array.from({ length: 64 }, (_, i) => hsl(i, 64, 70, 55)) };

function defaultSkin() {
    const s = { face: { item: 3, texture: 3 }, face2: { item: 25, texture: 25 }, facemix: { shapeMix: 0.5, skinMix: 0.5 }, hair: { item: 4, texture: 2, highlight: 2 }, eye_color: { item: 3 }, hair_fade: { collection: '', name: '' }, tattoos: [] };
    for (const k of Object.keys(COMPONENTS)) if (!s[k]) s[k] = { item: 0, texture: 0 };
    s['t-shirt'] = { item: 15, texture: 0 };
    for (const k of Object.keys(PROPS)) s[k] = { item: -1, texture: 0 };
    for (const k of Object.keys(OVERLAYS)) s[k] = { item: -1, texture: 1, opacity: 1 };
    for (const k of FEATURES) s[k] = { item: 0, texture: 0 };
    return s;
}
function limits() {
    const l = {};
    for (const k of Object.keys(COMPONENTS)) l[k] = { max: k === 'hair' ? 76 : 120 + k.length * 9, textures: k === 'hair' ? 64 : 6 };
    for (const k of Object.keys(PROPS)) l[k] = { max: 60, textures: 4 };
    for (const k of Object.keys(OVERLAYS)) l[k] = { max: 20, textures: OVERLAYS[k].color ? 64 : 0 };
    return l;
}
const packs = ['Classic', 'Bikers', 'Hipster', 'Cayo Perico', 'Casino'];
const tattoos = [];
for (let z = 0; z <= 6; z++) for (let i = 0; i < (z === 6 ? 14 : 22); i++) {
    const pack = packs[(i + z) % packs.length];
    tattoos.push({ id: `col_${z}:t_${z}_${i}`, collection: `col_${z}`, name: `t_${z}_${i}`, label: z === 6 ? `Fade ${i + 1}` : `${['Skull', 'Rose', 'Dragon', 'Tribal', 'Koi', 'Script'][i % 6]} ${i + 1}`, zone: z, pack, price: 400 + z * 50 });
}

const prices = {
    clothing: { mask: 120, arms: 0, pants: 180, bag: 150, shoes: 160, accessory: 90, 't-shirt': 110, vest: 140, decals: 60, torso2: 220, hat: 80, glass: 70, ear: 60, watch: 150, bracelet: 90 },
    barber: { hair: 120, hair_fade: 80, beard: 70, eyebrows: 40, chest_hair: 50, makeup: 80, blush: 50, lipstick: 50 },
    surgeon: { heritage: 2500, feature: 400, eye_color: 300, ageing: 600, moles: 250, blemishes: 250, complexion: 250, sun_damage: 250, body_blemishes: 250 },
    tattoo: { default: 450, zones: {}, removal: 250 }, outfitBag: 1500, importOutfit: 0,
};

let outfits = [
    { id: 'mz-1', name: 'Night Runner', model: 1885233650, skin: {}, shareCode: 'MZ-7F3K2', folder: 'Street', tags: 'neon, night' },
    { id: 'mz-2', name: 'Boardroom', model: 1885233650, skin: {}, folder: 'Work', tags: 'formal' },
    { id: 'mz-3', name: 'Beach Day', model: 1885233650, skin: {}, folder: '', tags: '' },
    { id: 'mz-4', name: 'Her Gala Dress', model: -1667301416, skin: {}, folder: 'Gifts', tags: '' },
];
const gallery = Array.from({ length: 9 }, (_, i) => ({ id: i + 1, name: ['Cyber Ronin', 'Desert Nomad', 'Vinewood Elite', 'Track Day', 'Midnight Biker', 'Chrome Angel', 'Ghost Ops', 'Sunset Drift', 'Neo Tokyo'][i], author: ['Ava K.', 'Rio M.', 'Zed P.'][i % 3], likes: 120 - i * 11, uses: 40 - i * 3, liked: i === 1, mine: i === 2, tags: ['street', 'luxury', 'tactical'][i % 3], skin: {} }));

const bagData = { ok: true, label: 'Gym Bag', max: 10, outfits: [{ name: 'Workout', model: 1885233650, skin: {} }, { name: 'Undercover', model: 1885233650, skin: {} }], wardrobe: outfits };

const serverMock = {
    getOutfits: () => outfits,
    saveOutfit: (d) => { outfits = [{ id: 'mz-' + Date.now(), name: d.name, model: 1885233650, skin: {}, folder: d.folder, tags: d.tags }, ...outfits]; return { ok: true, outfits }; },
    deleteOutfit: (id) => { outfits = outfits.filter((o) => o.id !== id); return { ok: true, outfits }; },
    duplicateOutfit: (id) => { const o = outfits.find((x) => x.id === id); outfits = [{ ...o, id: 'mz-' + Date.now(), name: o.name + ' (copy)' }, ...outfits]; return { ok: true, outfits }; },
    editOutfitInfo: (id, d) => { Object.assign(outfits.find((x) => x.id === id), d); return { ok: true, outfits }; },
    updateOutfit: () => ({ ok: true, outfits }),
    getShareCode: (id) => { const o = outfits.find((x) => x.id === id); o.shareCode = o.shareCode || 'MZ-Q8W2P'; return { ok: true, code: o.shareCode, outfits }; },
    previewCode: (c) => (c.toUpperCase().includes('X') ? { ok: false } : { ok: true, outfit: { name: 'Shared Fit', model: 1885233650, skin: {} } }),
    importCode: () => ({ ok: true, outfits }),
    nearbyPlayers: () => [{ id: 12, name: 'Jordan R.' }, { id: 31, name: 'Mia L.' }],
    sendOutfit: () => ({ ok: true }),
    respondOffer: () => ({ ok: true, outfits }),
    galleryList: (q) => ({ ok: true, items: q.mine ? gallery.filter((g) => g.mine) : gallery, hasMore: false }),
    galleryLike: (id) => { const g = gallery.find((x) => x.id === id); g.liked = !g.liked; g.likes += g.liked ? 1 : -1; return { ok: true, liked: g.liked, likes: g.likes }; },
    gallerySave: () => ({ ok: true, outfits }),
    galleryDelete: () => ({ ok: true }),
    galleryPublish: () => ({ ok: true }),
    wearOutfit: () => ({ ok: true, skin: defaultSkin(), model: 1885233650 }),
    buyBag: () => ({ ok: true }),
    bagAddCurrent: (_, name) => { bagData.outfits.push({ name, model: 1885233650, skin: {} }); return { ...bagData }; },
    bagRemove: (_, i) => { bagData.outfits.splice(i - 1, 1); return { ...bagData }; },
    bagRenameOutfit: (_, i, n) => { bagData.outfits[i - 1].name = n; return { ...bagData }; },
    bagRename: (_, l) => { bagData.label = l; return { ...bagData }; },
    bagToWardrobe: () => ({ ...bagData }),
    bagAddFromWardrobe: () => ({ ...bagData }),
};

setMock(async (name, data) => {
    await new Promise((r) => setTimeout(r, 60));
    if (name === 'server') {
        const fn = serverMock[data.name];
        console.log('[server]', data.name, data.args);
        return fn ? fn(...(data.args || [])) : { ok: false };
    }
    if (name === 'patch') return { limits: limits()[data.key] };
    if (name === 'applySkin') return { limits: limits() };
    if (name === 'commit') return { ok: true, skin: JSON.parse(JSON.stringify(window.__lastSkin || defaultSkin())), price: 0 };
    if (name === 'setModel') return { skin: defaultSkin(), limits: limits(), freemode: true, gender: data.gender || 'male', model: data.gender === 'female' ? -1667301416 : 1885233650, tattoos };
    if (name === 'close') { console.log('[close]', data); setTimeout(() => location.reload(), 300); }
    console.log('[nui]', name, data);
    return {};
});

const payload = {
    mode, skin: defaultSkin(), limits: limits(), palettes, freemode: true, gender: 'male', model: 1885233650,
    prices: ['clothing', 'barber', 'surgeon', 'tattoo'].includes(mode) ? prices : null,
    money: { cash: 4820, bank: 125300 }, isAdmin: true, gallery: true, maxOutfits: 60, sharePrefix: 'MZ',
    bagPrice: mode === 'clothing' ? 1500 : null, tattoos,
    jobOutfits: mode === 'wardrobe' ? [{ index: 1, name: 'Patrol Short Sleeve', skin: {} }, { index: 2, name: 'Trooper Tan', skin: {} }] : null,
    theme: { accent: '#22e4ff', accent2: '#a855ff', serverName: 'MEZOS', tagline: 'Design your future self', sounds: true },
    context: { clothing: 'Clothing Store', barber: 'Barber Shop', surgeon: 'Plastic Surgeon', tattoo: 'Tattoo Parlor', wardrobe: 'Wardrobe', creator: 'Genesis', admin: 'Admin' }[mode],
    creator: mode === 'creator' ? { intro: true, allowGenderSwap: true, starterOutfits: { male: [{ label: 'Casual', icon: 'shirt', data: { torso2: { item: 0, texture: 0 } } }, { label: 'Street', icon: 'hoodie', data: { torso2: { item: 7, texture: 0 } } }, { label: 'Smart', icon: 'tie', data: { torso2: { item: 4, texture: 0 } } }, { label: 'Sport', icon: 'run', data: { torso2: { item: 5, texture: 0 } } }], female: [] } } : null,
    models: { male: ['mp_m_freemode_01', 'a_m_y_skater_01', 'a_m_m_business_01'], female: ['mp_f_freemode_01', 'a_f_y_beach_01'] },
};

setTimeout(() => {
    if (mode === 'bag') window.postMessage({ action: 'bag', bagId: 'bag-1', data: bagData, theme: payload.theme, model: 1885233650 }, '*');
    else if (mode === 'prompt') window.postMessage({ action: 'prompt', show: true, title: 'Clothing Store', text: 'Browse clothes', key: 'E' }, '*');
    else if (mode === 'offer') window.postMessage({ action: 'offer', offer: { offerId: 1, from: 'Jordan Reyes', name: 'Cyber Ronin', skin: {} }, standalone: true }, '*');
    else window.postMessage({ action: 'open', data: payload }, '*');
}, 100);
