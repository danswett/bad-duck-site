# bad-duck.com

Static marketing site for **Bad Duck Software**, served by GitHub Pages at
<https://bad-duck.com>.

Plain HTML and CSS in a single `index.html` — no build step, no dependencies.
Push to `main` and GitHub Pages publishes it.

| Path | Purpose |
|---|---|
| `index.html` | The whole site |
| `favicon.svg` | Bad Duck mark on a dark tile |
| `brand/` | Logo masters and exported PNGs for profiles and listings |
| `CNAME` | Custom domain for GitHub Pages (`bad-duck.com`) |
| `img/` | Artwork copied from the product's `marketplace/` assets |

The Bad Duck logo is an inline SVG in `index.html`, and again in `favicon.svg`
and both `brand/*.svg` masters — a rubber-duck silhouette in shades. It has no
background tile in the header, so it sits directly on the page. The shades are
clipped to the head circle so they cannot overhang the silhouette at large
sizes. **Keep all four copies in sync when editing it.**

## Brand assets

| File | Use |
|---|---|
| `brand/bad-duck-logo.svg` | Master, transparent background |
| `brand/bad-duck-logo-dark.svg` | Master, `#1A1A1D` square tile |
| `brand/bad-duck-logo-{288,512,1024}.png` | Transparent PNG exports |
| `brand/bad-duck-logo-dark-{288,512,1024}.png` | Dark-tile PNG exports |

The duck is scaled to 80% and centred so it survives a circular avatar crop.
Prefer the **dark-tile** exports for profile pictures — the duck is near-white
and disappears on a light background. Re-export with
`brand/render-logo.ps1`.

Product artwork is generated in the plugin repo; refresh it with:

```powershell
Copy-Item ..\streamdeck-teams-control\marketplace\app-icon-288.png        img\teams-meeting-controls.png
Copy-Item ..\streamdeck-teams-control\marketplace\gallery-1-live-state.png img\gallery-live-state.png
Copy-Item ..\streamdeck-teams-control\marketplace\gallery-2-actions.png    img\gallery-actions.png
Copy-Item ..\streamdeck-teams-control\marketplace\gallery-3-no-meeting.png img\gallery-no-meeting.png
```

Brand palette, taken from the Teams Meeting Controls app icon:

| Colour | Hex |
|---|---|
| Indigo | `#5059C9` |
| Near-black | `#1A1A1D` |
| Amber | `#FFC83D` |
| Coral | `#F1707B` |

DNS lives in Cloudflare: apex `A` records point at the four GitHub Pages
addresses (DNS-only, not proxied, so GitHub can issue the TLS certificate) and
`www` is a `CNAME` to `danswett.github.io`.
