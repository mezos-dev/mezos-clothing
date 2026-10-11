// Tab definitions for every editing category.

import { h } from '../ui.js';
import { S } from '../state.js';
import { itemPicker, overlayPicker, hairPicker, fadePicker, heritagePanel, featureSlider, eyeColorPicker, section } from '../components.js';
import { FEATURE_GROUPS } from '../schema.js';
import { tattooView } from './tattoo.js';
import { wardrobeView } from './wardrobe.js';
import { galleryView } from './gallery.js';
import { pedsView } from './peds.js';

const freemodeOnly = (el) => (S.data.freemode ? el : h('div', { class: 'empty' }, h('b', {}, 'Not available'), 'This option only works on the freemode character models.'));

export const TAB = {
    tops: {
        label: 'Tops', icon: 'jacket', eyebrow: 'Apparel', title: 'Tops & Layers', desc: 'Jackets, shirts and everything above the belt.', cam: 'torso',
        render: (pt) => [itemPicker('torso2', { priceTable: pt }), itemPicker('t-shirt', { priceTable: pt }), itemPicker('arms', { priceTable: pt }), itemPicker('vest', { priceTable: pt }), itemPicker('decals', { priceTable: pt })],
    },
    bottoms: {
        label: 'Bottoms', icon: 'pants', eyebrow: 'Apparel', title: 'Pants & Shoes', desc: 'Complete the silhouette.', cam: 'legs',
        render: (pt) => [itemPicker('pants', { priceTable: pt }), itemPicker('shoes', { priceTable: pt })],
    },
    accessories: {
        label: 'Accessories', icon: 'chain', eyebrow: 'Apparel', title: 'Accessories', desc: 'Masks, chains and bags.', cam: 'torso',
        render: (pt) => [itemPicker('mask', { priceTable: pt }), itemPicker('accessory', { priceTable: pt }), itemPicker('bag', { priceTable: pt })],
    },
    props: {
        label: 'Props', icon: 'hat', eyebrow: 'Apparel', title: 'Headwear & Jewelry', desc: 'Hats, glasses, earrings, watches and bracelets.', cam: 'head',
        render: (pt) => [itemPicker('hat', { priceTable: pt }), itemPicker('glass', { priceTable: pt }), itemPicker('ear', { priceTable: pt }), itemPicker('watch', { priceTable: pt }), itemPicker('bracelet', { priceTable: pt })],
    },
    hair: {
        label: 'Hair', icon: 'scissors', eyebrow: 'Barber', title: 'Hair', desc: 'Style, color, highlights and fades.', cam: 'head',
        render: (pt) => [hairPicker({ priceTable: pt }), freemodeOnly(fadePicker({ priceTable: pt }))],
    },
    facial: {
        label: 'Facial Hair', icon: 'beard', eyebrow: 'Barber', title: 'Facial Hair', desc: 'Beards, brows and body hair.', cam: 'head',
        render: (pt) => freemodeOnly(h('div', {}, overlayPicker('beard', { priceTable: pt }), overlayPicker('eyebrows', { priceTable: pt }), overlayPicker('chest_hair', { priceTable: pt }))),
    },
    makeup: {
        label: 'Makeup', icon: 'palette', eyebrow: 'Barber', title: 'Makeup', desc: 'Eyes, blush and lips.', cam: 'head',
        render: (pt) => freemodeOnly(h('div', {}, overlayPicker('makeup', { priceTable: pt }), overlayPicker('blush', { priceTable: pt }), overlayPicker('lipstick', { priceTable: pt }))),
    },
    heritage: {
        label: 'Heritage', icon: 'dna', eyebrow: 'Genetics', title: 'Heritage', desc: 'Choose your parents and blend their traits.', cam: 'head',
        render: (pt) => freemodeOnly(heritagePanel(pt)),
    },
    features: {
        label: 'Face', icon: 'face', eyebrow: 'Sculpt', title: 'Face Sculpt', desc: 'Fine-tune every feature. Double-click a slider to reset it.', cam: 'head',
        render: (pt) => freemodeOnly(h('div', {}, FEATURE_GROUPS.map((g) => section(g.label, g.icon, g.keys.map((k) => k[0]),
            h('div', {}, g.keys.map(([k, label]) => featureSlider(k, label))), { cam: 'head', priceTable: pt, priceKey: 'feature' })))),
    },
    skin: {
        label: 'Skin', icon: 'sparkle', eyebrow: 'Details', title: 'Skin & Eyes', desc: 'Complexion, age and the windows to the soul.', cam: 'head',
        render: (pt) => freemodeOnly(h('div', {}, eyeColorPicker(pt), ['ageing', 'complexion', 'blemishes', 'sun_damage', 'moles', 'body_blemishes'].map((k) => overlayPicker(k, { priceTable: pt })))),
    },
    tattoos: {
        label: 'Tattoos', icon: 'ink', eyebrow: 'Ink', title: 'Tattoo Parlor', desc: 'Preview any design before you commit.', cam: 'torso',
        render: () => freemodeOnly(tattooView()),
    },
    wardrobe: {
        label: 'Wardrobe', icon: 'hanger', eyebrow: 'Wardrobe', title: 'My Outfits', desc: 'Wear, organize and share your saved looks.', cam: 'full',
        render: () => wardrobeView(),
    },
    gallery: {
        label: 'Gallery', icon: 'globe', eyebrow: 'Community', title: 'Outfit Gallery', desc: 'Discover looks published by other citizens.', cam: 'full',
        render: () => galleryView(),
    },
    peds: {
        label: 'Models', icon: 'users', eyebrow: 'Admin', title: 'Ped Models', desc: 'Switch the character model.', cam: 'full',
        render: () => pedsView(),
    },
};

// Tabs and price table per mode
export const MODES = {
    clothing: { title: 'Clothing Store', tabs: ['tops', 'bottoms', 'accessories', 'props', '|', 'wardrobe', 'gallery'], prices: 'clothing' },
    barber: { title: 'Barber Shop', tabs: ['hair', 'facial', 'makeup'], prices: 'barber' },
    surgeon: { title: 'Plastic Surgeon', tabs: ['heritage', 'features', 'skin'], prices: 'surgeon' },
    tattoo: { title: 'Tattoo Parlor', tabs: ['tattoos'], prices: 'tattoo' },
    wardrobe: { title: 'Wardrobe', tabs: ['wardrobe', 'gallery'], readonly: true },
    admin: { title: 'Appearance', tabs: ['heritage', 'features', 'skin', 'hair', 'facial', 'makeup', '|', 'tops', 'bottoms', 'accessories', 'props', 'tattoos', '|', 'wardrobe', 'gallery', 'peds'] },
};
