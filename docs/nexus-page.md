# g13-hud - the Nexus mod page

Written for the five boxes the upload wizard gives you, in that order. Each block below is ready to paste into the
box named above it; the files it refers to are beside this one in the folder.

---

## Fields

| field | value |
|---|---|
| **Game** | Cyberpunk 2077 |
| **Title** | `g13-hud - the game's numbers on a Logitech G13 screen` |
| **Version** | `1.0` |
| **Category** | whichever of **Utilities** or **User Interface** the wizard offers - I could not read CP2077's exact category list without a logged-in session |
| **Summary** | see below |
| **Requirements** | also add **Cyber Engine Tweaks** (Nexus mod `107`) in the requirement slot, so it shows as a hard dependency |
| **Adult content** | no |
| **Permissions** | the preset that allows use, modification and redistribution **with credit**, which is what the code's MIT OR Apache-2.0 already grants |
| **File** | `g13-hud-1.0.zip` - one file: the Lua, at the path CET loads from |
| **Images** | `main-image.png` (main), `second-image-pad.jpg` (the hardware) |
| **Tags** | `UI`, `Quality of Life`, `Advanced Setup` - see below |

### What is in the archive

```
bin/x64/plugins/cyber_engine_tweaks/mods/g13-hud/init.lua
```

That is the mod, and it is all of it: one Lua file, 17 KB. Nothing else belongs in the archive, because a mod manager
deploys everything it contains into the game folder - a README beside the Lua would appear in the player's game
directory as a stray file. This is the shape the single-file CET mods on Nexus already have, and it is what Amethyst,
Vortex and a manual drag-and-drop all expect. Checked against a CET mod Amethyst itself installed here:

```
No Crowd panic from devices CET 1.2.0/bin/x64/plugins/cyber_engine_tweaks/mods/No Crowd panic from devices/init.lua
```

One file, same path shape, and that mod is installed and deployed from Nexus.

Two things live on the driver's side of the pair rather than in this archive: the **pad screen**
(`applets/cp2077-hud.json`, which the driver's own installer puts in `~/.config/g13/applets/`) and `install.sh`.

### The tags, from the live list

The tags offered for a Cyberpunk 2077 mod are a fixed set of 25, read from Nexus's own API
(`game.availableTags`), not invented here:

`Adult, Advanced Setup, All-In-One, Animation, Audio, Bug Fixes, Cheating, DLC Required, Environment,
Fair and Balanced, Fallout Collectionathon 2026, Gameplay, Items, Lore-friendly, Magic, PS4, Quality of Life,
Real World Issues, Replacer, UI, VR, Visual, Wabbajack Compatible, Xbox`

Pick these three:

- **`UI`** - the mod's entire purpose is putting an interface on a second screen.
- **`Quality of Life`** - a glance down instead of opening the map. This is the most-used tag among the top 22
  CP2077 mods (10 of them carry it).
- **`Advanced Setup`** - the honest signal that this is not a drag-and-drop install: it needs a Linux driver, which
  lives outside Nexus. Better a smaller, correct audience than one-star reviews from people who expected an overlay.

If the wizard also offers the older, richer tag names that established pages show - `User Interface`,
`Utilities for Players`, `English`, and especially **`Cyber Engine Tweaks`** (four of the top 22 carry it, including
CET itself) - those are worth taking too: `Cyber Engine Tweaks` is how someone finds every CET mod at once.

Leave alone: `Gameplay`, `Visual`, `Audio`, `Items`, `Animation`, `Replacer`, `Cheating`, `Adult`, `DLC Required` -
none of them are true of this mod, and a wrong tag is what makes a page look like spam.

**Donation Points are live for this game.** Every one of the top 22 CP2077 mods reports
`isBlockedFromEarningDp: false`, Cyber Engine Tweaks included, so the game is in the programme.

**Summary** (the short field, not the long description):

> Cyberpunk 2077's own numbers on a Logitech G13's screen: health, stamina, level, street cred, the objective you are on, the district you are in. The game half of a pair - this mod writes them out, a Linux driver draws them.

---

## 1. Description

*Describe the main purpose of your mod*

Cyberpunk 2077's own numbers, on the screen of a Logitech G13 - health, stamina, level, street cred, the objective
you are on, the district you are in, and what is in front of you. The pad's 160x43 screen is updated about five
times a second while you play, so a glance down replaces opening the map.

**This is the game half of a pair, and on its own it does nothing visible.** It is a Cyber Engine Tweaks mod: it
reads game state and writes it to a small JSON file in its own folder. The half that draws it on the pad is a Linux
driver, which is not on Nexus:

https://github.com/npc-nathan/logitech-g13-linux-driver

So: if you do not have a G13 and that driver, this will write a file and stop there - it is worth knowing before you
download. If you do have the pad, this is what puts Night City's numbers on it.

*[insert `main-image.png` here - the pad's screen, drawn from live game data]*

## 2. Installation instructions

*Lay out any steps users must follow to install your mod*

**Before you start:** Cyber Engine Tweaks must already be installed and working.

**With a mod manager** - Amethyst, Vortex, or whatever else you use: install the archive, or its Nexus page, and you
are done. It is one Lua file at the path CET loads from, so there is nothing to configure.

**By hand:** copy the `bin` folder from the archive into your Cyberpunk 2077 folder - the one holding
`Cyberpunk2077.exe` - and let it merge. The file lands here:

    <game>/bin/x64/plugins/cyber_engine_tweaks/mods/g13-hud/init.lua

That is the whole install. The screen then appears on the pad while you play.

## 3. Main features

*Describe the core features of your mod*

- **The game's real numbers on the pad's screen**: health, stamina, level, street cred, the tracked objective, the
  district you are standing in, what is nearest to you, and your heading.
- **It takes the screen while you play and gives it back**: the applet declares a `follow` window, so the HUD
  appears while the game is writing and returns the screen to your other applets about twenty seconds after the
  writing stops. You can also walk to it by hand with **LR**.
- **A map pin, where the build exposes one**: an arrow pointing relative to the way you are facing, with the
  distance, in the same line as the district.
- **One file, replaced whole**: `hud.json`, written beside itself and renamed over, so a read never catches half a
  file. Nothing about the game is modified and no save is touched.
- **Nothing invented**: a value the game will not answer is left out of the file rather than guessed at, so a build
  that refuses a call shows a gap on the screen, not something wrong.

## 4. Requirements

*Provide info on additional required steps, resources, or mods*

- **Cyberpunk 2077** - written and tested against **3.0.80.51928**.
- **Cyber Engine Tweaks 1.37 or newer** - tested against **v1.37.1** - https://www.nexusmods.com/cyberpunk2077/mods/107
- **A Logitech G13**, and **g13**, the Linux driver that draws on it:
  https://github.com/npc-nathan/logitech-g13-linux-driver
  Without both of those, nothing will appear on the pad - this mod only writes the numbers out.

## 5. Shout outs

*Say thanks to anyone who inspired or helped you*

> **This one is yours to write** - I do not know who helped you with it, and inventing names on a public page would
> be worse than leaving it out. A starting point:
>
> "Cyber Engine Tweaks, without which none of this would be possible: https://github.com/maximegmd/CyberEngineTweaks
> - and the REDmodding wiki, which is where the API answers came from."

---

## If it is quarantined anyway

The first upload was, because that archive carried a shell script beside the Lua - Nexus's first stated reason is
*"executables and similar file types"*. There is no script in it now: one Lua file, nothing executable, nothing
compiled, nothing nested.

If a Lua file is still flagged, it is one email. Their own wording asks for the source link and the build steps:

> **To:** support@nexusmods.com
> **Subject:** Quarantine review - g13-hud (Cyberpunk 2077)
>
> Hello,
>
> The file `g13-hud-1.0.zip` for my mod g13-hud was quarantined by the automated check. It contains a single file -
> `bin/x64/plugins/cyber_engine_tweaks/mods/g13-hud/init.lua` - which is plain Lua source for a Cyber Engine Tweaks
> mod. No compiled code, no executables, no nested archives.
>
> The source is public: https://github.com/npc-nathan/logitech-g13-linux-driver - the Lua is `cet-mod/init.lua` in
> that repository, and `cet-mod/packaging.sh` copies it into the archive. There is no build step, because there is
> nothing to compile.
>
> At run time it reads a few values from the game and writes them to a small JSON file in its own folder, which a
> Linux driver reads. Nothing else.
>
> Thanks.

---

## Before you publish - what to check, and how

1. **The archive builds from the tree, and the Lua inside it is the repository's**:
   ```bash
   cd ~/Projects/g13-public/cet-mod && ./packaging.sh
   mkdir -p /tmp/zc && unzip -o -q dist/g13-hud-1.0.zip -d /tmp/zc
   diff /tmp/zc/bin/x64/plugins/cyber_engine_tweaks/mods/g13-hud/init.lua init.lua && echo identical
   ```
2. **It contains exactly one file, and nothing a scanner can cite**:
   ```bash
   cd ~/Projects/g13-public/cet-mod && python3 ~/nexus/g13-hud/zip-audit.py
   ```
3. **The image shows real values, not placeholders.** It was rendered from your own `hud.json` (health 153, level
   13, Kabuki, "Leave Lizzie's Bar."). If you would rather not publish that particular quest state, load a save
   somewhere anonymous, let the mod write once, and re-render: `python3 /tmp/g13_nexus_image.py`.
4. **It still works in the current game build.** CET's own log names the build it last ran against - 3.0.80.51928 -
   and the CET version, v1.37.1. If the game has patched since, load a save with the mod installed and confirm the
   pad updates before publishing.
5. **The version on the page matches the file**: `1.0`, taken from `init.lua`'s own `VERSION` and used for the
   archive's name. When the mod changes, bump that one constant and rebuild - the script reads it from there.
6. **Tags**: the three above, from the 25 that actually exist for this game. Not the ones that sound nice.
7. **The claim worth checking twice** is the pin arrow in section 3. Your README records those fields as *probed*
   rather than verified in use - if your build does not answer, cut that bullet rather than shipping a feature
   nobody can see.
8. **The pad screen is not in this download.** It is the driver's configuration: `applets/cp2077-hud.json` in the
   repository, placed by `install.sh` or copied into `~/.config/g13/applets/` by hand. If you would rather nobody had
   to fetch it at all, the place for it is the driver's own shipped defaults - a `g13` change, not a mod one.
