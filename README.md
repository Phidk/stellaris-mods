Stellaris Mods Development Workspace

This repository serves as a development area for Stellaris mods. It collects selected local mods under version control to track changes, collaborate, and back up work.

Included mods
- "STNC - AI Federation Charter" -> mods/stnc_ufp_charter/, descriptors/stnc_ufp_charter.mod
- "Star Trek - Stellar Cartography Map (Simple) - Remade" -> mods/simple/, descriptors/simple.mod
- "Star Trek - Stellar Cartography Map (2 Quadrants) - Remade" -> mods/2_quadrants/, descriptors/2_quadrants.mod
- "Star Trek - Stellar Cartography Map (4 Quadrants) - Remade" -> mods/4_quadrants/, descriptors/4_quadrants.mod

Repository structure
- mods/<modname>/ - the mod content directories (common, events, gfx, localisation, etc.)
- descriptors/*.mod - the Stellaris .mod descriptor files as used by the launcher

Exports and assets
- mods/exports/ - rendered images exported from the mods for sharing, previews, and tooling.
  - submod_maps/ - base map renders (PNG) for Simple, 2 Quadrants, 4 Quadrants.
  - submod_maps_color_overlay/ - map renders with color overlay (PNG).
  - submod_maps_color_overlay_2mb/ - compressed JPG variants (~2 MB) for easier distribution.
  - grid_stars_png/ - PNG exports of the star grid layers used by the particle assets.
- Each mod folder also contains a thumbnail at mods/<modname>/thumbnail.png used by the Launcher.
- A .dds mask (e.g., mods/2_quadrants/gfx/particles/grid_stars_3.dds.mask.png) may be present to guide channel/alpha when preparing DDS textures.

Descriptor files
- Each mod directory contains its own descriptor at mods/<modname>/descriptor.mod for packaging and Workshop metadata (name, picture, supported_version, remote_file_id).
- The descriptors/*.mod copies are convenience files for a local Launcher setup pointing to the working copy under Documents/Stellaris/mod. Keep these in sync with the mod folder names.

Using these mods with Stellaris
Option A - Subscribe on Steam Workshop (recommended for players)
- Open the mod's Workshop page and click Subscribe. For all mods, see: https://steamcommunity.com/profiles/76561198067471567/myworkshopfiles/ or search by name in Steam.
- Launch the Paradox Launcher once so it downloads the subscribed mods. Workshop mods appear as `ugc_<id>.mod` files in your Stellaris `mod` folder and are stored as archives under Steam's `steamapps/workshop/content/281990/`.
- In the Launcher, enable the mod(s) and add them to your playset. Adjust load order as needed.
- Workshop mods auto‑update. If an update doesn't show, restart the Launcher.

If you have both Workshop and local copies
- The Launcher may show two entries for the same mod (Workshop and local). Enable only one variant in a playset to avoid duplicates.
- Prefer Workshop for regular play. Use the local copy only when you actively develop/test.
- To remove the Workshop version, unsubscribe in Steam. The Launcher cleans up on refresh.


Option B - Copy into Stellaris mod folder
1) Copy each folder under `mods/` into:
   `C:\Users\<you>\Documents\Paradox Interactive\Stellaris\mod\`
2) Copy the matching `.mod` files from `descriptors/` into the same `mod` directory.
3) Ensure each `.mod` file's `path` points to `mod/<modname>`.


Option C - Symlink for live editing (Windows)
1) Open an elevated Command Prompt.
2) For each mod, create a directory link from the Stellaris mod directory to this repo, e.g.:
   `mklink /D "C:\\Users\\<you>\\Documents\\Paradox Interactive\\Stellaris\\mod\\simple" "C:\\Users\\<you>\\Documents\\GitHub\\stellaris-mods\\mods\\simple"`
3) Copy the `.mod` descriptor(s) into the Stellaris `mod` directory (or symlink them too).


Notes
- Keep the `.mod` descriptors under `descriptors/` in sync with your launcher setup. If you change a folder name under `mods/`, update the corresponding `.mod` file's `path`.
- This repo is intended for source content only.
