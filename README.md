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
| `img/layouts/` | Per-deck profile layouts, copied from the product's `docs/profiles/` |

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
| `brand/og-image.png` | 1200 × 630 link-preview card |
| `brand/og-template.html` | Source for `og-image.png` |

The duck is scaled to 80% and centred so it survives a circular avatar crop.
Prefer the **dark-tile** exports for profile pictures — the duck is near-white
and disappears on a light background. Re-export with
`brand/render-logo.ps1`.

### Link previews

`og:image` is `brand/og-image.png` — the Bad Duck mark and wordmark, **not** the
product icon. Its content sits inside the centre 630 × 630 square, because Teams
and Slack crop preview images to a square rather than honouring the 1.91:1 card.

Regenerate it after a logo change by screenshotting the template at exactly
1200 × 630:

```powershell
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
& $edge --headless=new --disable-gpu --window-size=1200,630 `
        --force-device-scale-factor=1 `
        --screenshot="brand\og-image.png" `
        "file:///C:/Users/dswett/repos/bad-duck-site/brand/og-template.html"
```

Consumers cache previews hard. To force a refresh, paste the URL with a throwaway
query string once (`https://bad-duck.com/?v=2`).

Product artwork is generated in the plugin repo; refresh it with:

```powershell
$m = "..\streamdeck-teams-control\marketplace"
Copy-Item "$m\app-icon-288.png"               img\teams-meeting-controls.png
Copy-Item "$m\gallery-1-live-state.png"       img\gallery-live-state.png
Copy-Item "$m\gallery-2-meeting-controls.png" img\gallery-actions.png
Copy-Item "$m\gallery-3-presenting.png"       img\gallery-presenting.png
Copy-Item "$m\gallery-4-watching.png"         img\gallery-watching.png
Copy-Item "$m\gallery-5-profiles.png"         img\gallery-profiles.png
Copy-Item "$m\gallery-6-decks.png"            img\gallery-decks.png
Copy-Item "$m\gallery-7-no-meeting.png"       img\gallery-no-meeting.png
```

The source names carry an index and the destination names do not, so this list
has to be updated whenever the plugin's gallery set changes — as it did when the
set grew from three items to six, and again at seven when the deck grids were
added and `no-meeting` shifted from index 6 to 7.

The **Layouts for your deck** section shows one sheet per Stream Deck, each
holding all three of that deck's profiles. Those are generated in the plugin
repo by `npm run profiles`, which draws them from the `.streamDeckProfile` files
that actually ship, and are copied over whole:

```powershell
Copy-Item "..\streamdeck-teams-control\docs\profiles\*.png" img\layouts\ -Force
```

Names match the plugin's deck slugs (`mini`, `stream-deck`, `plus`, `neo`, `xl`,
`studio`, `plus-xl`), so adding a deck there means adding a `<details>` block
here — nothing picks it up automatically. The sheets are inside collapsed
`<details>` and marked `loading="lazy"`, so none of the 1.6 MB is fetched until
a reader opens one.

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
