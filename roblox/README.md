# Alien Breach FPS — Roblox port (Phase 1)

These Luau scripts are an initial playable conversion, **not yet an exact full port**. The browser game remains unchanged.

## Installation
1. Open Roblox Studio > Baseplate. Stop Play mode.
2. Delete or disable the earlier temporary green-block/laboratory scripts in ServerScriptService so they do not create duplicate rooms.
3. In Explorer > ServerScriptService, insert a **Script** named AlienBreach. Paste the contents of `roblox/ServerScriptService/AlienBreach.server.lua`.
4. In Explorer > StarterPlayer > StarterPlayerScripts, insert a **LocalScript** named AlienBreachClient. Paste the contents of `roblox/StarterPlayerScripts/AlienBreach.client.lua`.
5. Press Play. Use WASD and mouse, left click to shoot, R to reload, and walk to supply chests to collect credits. Touch FIRE button is included for phones.

## Converted from GitHub source
- Original 35x27 tile layout and starting location (3.5,3.5).
- 16 furniture positions/types, 14 supply chest locations.
- First-person camera, initial pulse pistol, a stalker-style alien, simple waves, health damage, kill credits and mobile fire button.

## Not yet converted
Full alien types and exact visuals, shop/inventory and weapons, precise balance, pathfinding, multiplayer hardening, cloud saves, complete UI, audio, and faithful materials/lighting. Enemy movement is rudimentary and can get stuck on walls; this is an early playable test.

## Testing status
Source code committed to GitHub. Roblox Studio execution not tested in this environment. Report any Output errors with line numbers for fixes.

## PUBLIC RELEASE STATUS: NOT READY
Do not publish this phase-1 prototype as a finished public game. It has not been run in Roblox Studio or tested with multiple players. Known release blockers include:
- No DataStoreService saving for purchases/progression.
- Chest rewards are shared and destructible, not per-player; multiplayer rules need redesign.
- Alien AI is simplistic and can get stuck behind walls; no tested pathfinding.
- Fire remote requires stronger server-side checks (weapon ownership, ammo, line-of-sight, fire rate, origin).
- No verified phone/tablet gameplay, accessibility, performance, or cross-device QA.
- Incomplete weapon/shop/inventory features compared with the browser game.

Before public release, test using Studio's multi-client server simulation, mobile emulator, live private test, and DataStore API configuration. Publish the Roblox experience from Studio only after these checks pass. GitHub commits alone do not publish to Roblox.
