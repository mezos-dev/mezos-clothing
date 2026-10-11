# mezos-clothing

Next-gen appearance suite for QBCore, and a drop-in replacement for `qb-clothing`.

It covers:
- the first-spawn character creator ("Genesis")
- clothing stores, barbers, tattoo parlors and plastic surgeons
- wardrobes and job uniforms
- outfit sharing: share codes, gifts to nearby players and a public gallery
- a giveable **outfit bag** item

The UI is plain HTML/CSS/JS with no build step.

## Install

1. Put the folder in `resources/[Mezos]/mezos-clothing`.
2. Stop the old `qb-clothing`. Its folder was moved to `resources/[disabled]/qb-clothing-legacy`. Keep it out of any ensured folder, and don't name it `qb-clothing`.
3. In `server.cfg`, ensure the resource right after qb-core:
   ```
   ensure qb-core
   ensure mezos-clothing
   ensure [qb]
   ```
4. Add the item to `qb-core/shared/items.lua`. This is already done here:
   ```lua
   mezos_outfitbag = { name = 'mezos_outfitbag', label = 'Outfit Bag', weight = 1500, type = 'item', image = 'mezos_outfitbag.png', unique = true, useable = true, shouldClose = true, description = '...' },
   ```
   The icon is at `qb-inventory/html/images/mezos_outfitbag.png`. A copy is also in `html/img/`.
5. Database: tables are created and upgraded automatically on start. `sql/install.sql` is there for manual installs. Existing `playerskins` / `player_outfits` data keeps working.

## Features

| Area | What's inside |
|---|---|
| **Genesis creator** | Holographic boot intro and an 8-step wizard: identity, heritage, face sculpt, skin, hair, makeup, outfit, review. Includes randomize per step or everything, undo/redo, lighting presets, and drag-to-rotate. The player is moved to a private studio in their own routing bucket and returned afterwards. |
| **Clothing store** | 15 categories with a numbered tile browser, favorites (right-click a tile), texture variants and a live cart. Payment is computed by the server. Wardrobe and gallery are available in-store. Outfit bags are sold here. |
| **Barber** | Hair style, color and highlight with real game palette swatches. 126 GTA fades and lines, beard, brows, chest hair and makeup, each with opacity. |
| **Plastic surgeon** | Parents with real GTA portraits, resemblance, skin tone, 20 face features, eye color and skin details. |
| **Tattoo parlor** | 743 base and DLC tattoos with real names, browsed by body zone and collection with search. Preview before buying, paid removal. |
| **Wardrobe** | Folders, tags, search, wear, try on, rename, overwrite, duplicate, delete, share code, publish and send. Job uniforms appear in locker rooms. |
| **Sharing** | `MZ-XXXXX` share codes, send to a player within 5 m (they get an accept/decline popup), and a public gallery (trending / new / top / mine, likes, try on, save). |
| **Outfit bag** | A useable item. Using it drops the bag on the ground and opens its UI, where you can pack your current look or a wardrobe outfit. Wearing from the bag plays a changing animation. The outfits are stored with the bag, so giving it to someone (normal qb-inventory give) hands over everything inside. |

## Security model

- Every edit runs in a **server session**. The server checks that the player is near the store and only allows that store's keys to change. A clothing store can't change your face. The server also re-prices the change itself.
- The creator is only allowed for characters with no saved look, or after an admin uses `/resetlook`. The full admin menu needs the `admin` permission or a one-time grant from qb-adminmenu / `/appearance`.
- Saving an outfit always stores what the character is actually wearing (taken from the database), never what the client sends. Unknown tattoos and fades are stripped.

## Compatibility (no edits needed elsewhere)

| Legacy API | Behaviour |
|---|---|
| `qb-clothes:client:CreateFirstCharacter` | Opens Genesis (qb-multicharacter, qb-interior) |
| `qb-clothing:client:openOutfitMenu` | Wardrobe (apartments, houses, boss and gang menus) |
| `qb-clothing:client:openMenu` | Full admin menu (qb-adminmenu "Clothing") |
| `qb-clothing:client:loadPlayerClothing` | Applies a skin to any ped (multicharacter preview) |
| `qb-clothing:client:loadOutfit` | Temporary outfit, not saved (tracker, prison, parachute) |
| `qb-clothes:loadSkin`, `qb-clothes:loadPlayerSkin`, `qb-clothing:loadPlayerSkin` | Load the saved look |
| `qb-clothing:saveSkin`, `qb-clothes:saveOutfit`, `qb-clothing:server:removeOutfit`, `qb-clothing:server:getOutfits` | Legacy server API |
| `exports['qb-clothing']:reloadSkin / IsCreatingCharacter / getOutfits` | Answered through `provide 'qb-clothing'` |

## Exports & commands

```lua
-- client
exports['mezos-clothing']:OpenMenu('clothing' | 'barber' | 'tattoo' | 'surgeon' | 'wardrobe' | 'admin', ctx)
exports['mezos-clothing']:OpenWardrobe('My Locker')
exports['mezos-clothing']:GetSkin()
exports['mezos-clothing']:ApplySkin(skin)
exports['mezos-clothing']:IsMenuOpen()
-- server
exports['mezos-clothing']:GetSkin(source)    -- skin, model
exports['mezos-clothing']:GetOutfits(source)
```

Commands:
- `/appearance [id]` (admin): full menu
- `/resetlook id` (admin): send a player back through Genesis
- `/refreshskin`: reload your saved look

## Config

- `config/config.lua`: theme colors and server name, camera, sharing limits, gallery, outfit bag, blips, admin permission.
- `config/prices.lua`: prices per clothing category, barber, surgeon (heritage and per feature) and tattoo zone, plus the removal fee, bag price and an optional outfit import fee.
- `config/stores.lua`: stores (clothing, barber, tattoo, surgeon), outfit changers and job locker rooms.
- `config/creator.lua`: studio location, private bucket, gender swap, intro, starter outfits.
- `config/joboutfits.lua`: job uniforms (migrated verbatim from qb-clothing).
- `shared/tattoos.lua`: the tattoo catalogue. Add addon tattoos to `Tattoos.Custom`.

## UI dev mode

Serve the `html/` folder over http (for example `npx http-server html`) and open `index.html?mode=clothing`. Other modes: `barber`, `surgeon`, `tattoo`, `wardrobe`, `creator`, `admin`, `bag`, `offer`, `prompt`. `js/dev.js` mocks the game and server.

## In-game test checklist

- [x] An existing character spawns with their old qb-clothing look, including the multicharacter preview.
- [x] A new character goes through Genesis both with and without starting apartments, and comes back to the right spot.
- [x] Clothing / barber / surgeon / tattoo purchase: the charge matches the cart, and the look persists after relog.
- [x] Exiting a store with unpaid changes reverts them.
- [x] Wardrobe: save, rename, folder, overwrite, duplicate, delete, wear.
- [x] A share code imports on a second account. Send to a nearby player and accept. Gallery publish, like, try on and save.
- [x] Outfit bag: buy at a clothing store, pack outfits, give it to another player, they can wear the outfits.
- [x] Apartment, house, boss and gang wardrobes open. Police and EMS locker rooms show uniforms.
- [x] Police tracker, prison uniform and release, and the parachute outfit still work.
- [x] qb-adminmenu "Clothing" opens the full menu on the target.
