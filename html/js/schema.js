// Mirror of shared/schema.lua plus UI metadata.

export const COMPONENTS = { mask: 1, hair: 2, arms: 3, pants: 4, bag: 5, shoes: 6, accessory: 7, 't-shirt': 8, vest: 9, decals: 10, torso2: 11 };
export const PROPS = { hat: 0, glass: 1, ear: 2, watch: 6, bracelet: 7 };
export const OVERLAYS = {
    blemishes: { id: 0, color: 0 }, beard: { id: 1, color: 1 }, eyebrows: { id: 2, color: 1 }, ageing: { id: 3, color: 0 },
    makeup: { id: 4, color: 2 }, blush: { id: 5, color: 2 }, complexion: { id: 6, color: 0 }, sun_damage: { id: 7, color: 0 },
    lipstick: { id: 8, color: 2 }, moles: { id: 9, color: 0 }, chest_hair: { id: 10, color: 1 }, body_blemishes: { id: 11, color: 0 },
};
export const FEATURES = [
    'nose_0', 'nose_1', 'nose_2', 'nose_3', 'nose_4', 'nose_5', 'eyebrown_high', 'eyebrown_forward', 'cheek_1', 'cheek_2', 'cheek_3',
    'eye_opening', 'lips_thickness', 'jaw_bone_width', 'jaw_bone_back_lenght', 'chimp_bone_lowering', 'chimp_bone_lenght',
    'chimp_bone_width', 'chimp_hole', 'neck_thikness',
];
export const CLOTHING_KEYS = ['mask', 'arms', 'pants', 'bag', 'shoes', 'accessory', 't-shirt', 'vest', 'decals', 'torso2', 'hat', 'glass', 'ear', 'watch', 'bracelet'];
export const BARBER_KEYS = ['hair', 'hair_fade', 'beard', 'eyebrows', 'chest_hair', 'makeup', 'blush', 'lipstick'];
export const HERITAGE_KEYS = ['face', 'face2', 'facemix'];
export const SURGEON_REST = ['eye_color', 'ageing', 'moles', 'blemishes', 'complexion', 'sun_damage', 'body_blemishes'];

export const META = {
    torso2: { label: 'Tops & Jackets', icon: 'jacket', cam: 'torso' },
    't-shirt': { label: 'Undershirt', icon: 'shirt', cam: 'torso' },
    arms: { label: 'Arms & Gloves', icon: 'glove', cam: 'torso' },
    vest: { label: 'Vest & Armor', icon: 'vest', cam: 'torso' },
    decals: { label: 'Decals & Badges', icon: 'badge', cam: 'torso' },
    pants: { label: 'Pants', icon: 'pants', cam: 'legs' },
    shoes: { label: 'Shoes', icon: 'shoe', cam: 'feet' },
    mask: { label: 'Masks', icon: 'mask', cam: 'head' },
    accessory: { label: 'Neck & Chains', icon: 'chain', cam: 'torso' },
    bag: { label: 'Bags & Parachutes', icon: 'bag', cam: 'torso' },
    hat: { label: 'Hats & Helmets', icon: 'hat', cam: 'head' },
    glass: { label: 'Glasses', icon: 'glasses', cam: 'head' },
    ear: { label: 'Earrings', icon: 'ear', cam: 'head' },
    watch: { label: 'Watches', icon: 'watch', cam: 'torso' },
    bracelet: { label: 'Bracelets', icon: 'bracelet', cam: 'torso' },
    hair: { label: 'Hair Style', icon: 'scissors', cam: 'head' },
    hair_fade: { label: 'Fades & Lines', icon: 'scissors', cam: 'head' },
    beard: { label: 'Facial Hair', icon: 'beard', cam: 'head' },
    eyebrows: { label: 'Eyebrows', icon: 'brow', cam: 'head' },
    chest_hair: { label: 'Chest Hair', icon: 'body', cam: 'torso' },
    makeup: { label: 'Eye Makeup', icon: 'palette', cam: 'head' },
    blush: { label: 'Blush', icon: 'palette', cam: 'head' },
    lipstick: { label: 'Lipstick', icon: 'lips', cam: 'head' },
    ageing: { label: 'Ageing', icon: 'clock', cam: 'head' },
    blemishes: { label: 'Blemishes', icon: 'face', cam: 'head' },
    complexion: { label: 'Complexion', icon: 'face', cam: 'head' },
    sun_damage: { label: 'Sun Damage', icon: 'sun', cam: 'head' },
    moles: { label: 'Moles & Freckles', icon: 'face', cam: 'head' },
    body_blemishes: { label: 'Body Blemishes', icon: 'body', cam: 'torso' },
    eye_color: { label: 'Eye Color', icon: 'eye', cam: 'head' },
};

export const FEATURE_GROUPS = [
    { label: 'Nose', icon: 'face', keys: [['nose_0', 'Width'], ['nose_1', 'Peak height'], ['nose_2', 'Peak length'], ['nose_3', 'Bone height'], ['nose_4', 'Peak lowering'], ['nose_5', 'Bone twist']] },
    { label: 'Brows', icon: 'brow', keys: [['eyebrown_high', 'Height'], ['eyebrown_forward', 'Depth']] },
    { label: 'Cheeks', icon: 'face', keys: [['cheek_1', 'Bone height'], ['cheek_2', 'Bone width'], ['cheek_3', 'Width']] },
    { label: 'Eyes & Lips', icon: 'eye', keys: [['eye_opening', 'Eye opening'], ['lips_thickness', 'Lip thickness']] },
    { label: 'Jaw', icon: 'face', keys: [['jaw_bone_width', 'Width'], ['jaw_bone_back_lenght', 'Shape']] },
    { label: 'Chin', icon: 'face', keys: [['chimp_bone_lowering', 'Lowering'], ['chimp_bone_lenght', 'Length'], ['chimp_bone_width', 'Width'], ['chimp_hole', 'Cleft']] },
    { label: 'Neck', icon: 'body', keys: [['neck_thikness', 'Thickness']] },
];

export const FATHERS = [[0, 'Benjamin'], [1, 'Daniel'], [2, 'Joshua'], [3, 'Noah'], [4, 'Andrew'], [5, 'Juan'], [6, 'Alex'], [7, 'Isaac'], [8, 'Evan'], [9, 'Ethan'], [10, 'Vincent'], [11, 'Angel'], [12, 'Diego'], [13, 'Adrian'], [14, 'Gabriel'], [15, 'Michael'], [16, 'Santiago'], [17, 'Kevin'], [18, 'Louis'], [19, 'Samuel'], [20, 'Anthony'], [42, 'Claude'], [43, 'Niko'], [44, 'John']];
export const MOTHERS = [[21, 'Hannah'], [22, 'Audrey'], [23, 'Jasmine'], [24, 'Giselle'], [25, 'Amelia'], [26, 'Isabella'], [27, 'Zoe'], [28, 'Ava'], [29, 'Camila'], [30, 'Violet'], [31, 'Sophia'], [32, 'Evelyn'], [33, 'Nicole'], [34, 'Ashley'], [35, 'Grace'], [36, 'Brianna'], [37, 'Natalie'], [38, 'Olivia'], [39, 'Elizabeth'], [40, 'Charlotte'], [41, 'Emma'], [45, 'Misty']];

// GTA portrait textures (served through nui-img once the texture dict is loaded)
export function parentImage(id) {
    if (typeof window.GetParentResourceName !== 'function') return '';
    let tex;
    if (id <= 20) tex = `male_${id}`;
    else if (id <= 41) tex = `female_${id - 21}`;
    else if (id <= 44) tex = `special_male_${id - 42}`;
    else tex = 'special_female_0';
    return `https://nui-img/char_creator_portraits/${tex}`;
}

export const EYE_COLORS = ['Green', 'Emerald', 'Light Blue', 'Ocean Blue', 'Light Brown', 'Dark Brown', 'Hazel', 'Dark Gray', 'Light Gray', 'Pink', 'Yellow', 'Purple', 'Blackout', 'Shades of Gray', 'Tequila Sunrise', 'Atomic', 'Warp', 'ECola', 'Space Ranger', 'Ying Yang', 'Bullseye', 'Lizard', 'Dragon', 'Extra Terrestrial', 'Goat', 'Smiley', 'Possessed', 'Demon', 'Infected', 'Alien', 'Undead', 'Zombie'];

export const ZONES = [
    { id: 0, label: 'Torso', icon: 'torso', cam: 'torso' },
    { id: 1, label: 'Head', icon: 'head', cam: 'head' },
    { id: 2, label: 'Left Arm', icon: 'glove', cam: 'torso' },
    { id: 3, label: 'Right Arm', icon: 'glove', cam: 'torso' },
    { id: 4, label: 'Left Leg', icon: 'legs', cam: 'legs' },
    { id: 5, label: 'Right Leg', icon: 'legs', cam: 'legs' },
];

export function isProp(key) { return key in PROPS; }
export function isComponent(key) { return key in COMPONENTS; }
export function isOverlay(key) { return key in OVERLAYS; }

export const clone = (o) => JSON.parse(JSON.stringify(o));

const num = (v, d = 0) => (v === undefined || v === null || isNaN(+v) ? d : +v);
export function entryEqual(a, b) {
    if (!a || !b) return a === b;
    for (const f of ['item', 'texture', 'highlight', 'shapeMix', 'skinMix']) {
        const x = a[f], y = b[f];
        if (x === undefined && y === undefined) continue;
        if (Math.abs(num(x, NaN) - num(y, NaN)) > 0.001 && !(isNaN(num(x, NaN)) && isNaN(num(y, NaN)))) return false;
    }
    if ((a.collection || '') !== (b.collection || '') || (a.name || '') !== (b.name || '')) return false;
    return Math.abs(num(a.opacity, 1) - num(b.opacity, 1)) < 0.01;
}

export const tattooId = (t) => `${t.collection || ''}:${t.name || ''}`;
