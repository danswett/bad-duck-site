# bad-duck.com

Static marketing site for **Bad Duck Software**, served by GitHub Pages at
<https://bad-duck.com>.

Plain HTML and CSS, no build step and no dependencies. Push to `main` and
GitHub Pages publishes it.

| Path | Purpose |
|---|---|
| `index.html` | Home — hero and the product list |
| `teams-meeting-controls.html` | Product page |
| `audiofuse-control.html` | Product page |
| `now-playing.html` | Product page |
| `css/site.css` | Every style on the site |
| `favicon.svg` | Bad Duck mark on a dark tile |
| `brand/` | Logo masters and exported PNGs for profiles and listings |
| `CNAME` | Custom domain for GitHub Pages (`bad-duck.com`) |
| `img/` | Artwork copied from each product's `marketplace/` assets |
| `img/layouts/` | Per-deck profile layouts, copied from the Teams plugin's `docs/profiles/` |

## Structure

One page per product, plus a home page that lists them. It was a single
scrolling page while there was one product; three would have put several
screens of unrelated material in front of the one a reader came for, and a page
each gives every product its own title, description and canonical URL for
search.

Adding a product means: a new `<product>.html`, a card in the `.products` list
on `index.html`, and a link in **both** navs (`nav.site` in the header and
`footer nav`) of **every** page. Nothing picks it up automatically.

The header nav marks the current page with `aria-current="page"` rather than
linking it, so the nav says where you are instead of offering a link that goes
nowhere. The CSS styles that state; forgetting the attribute loses the
highlight but breaks nothing.

### Why there is no template

Four pages repeat the `<head>` block, the header and the footer. That is
deliberate: a build step or an include mechanism would mean the site could no
longer be opened straight from disk or published by pushing. The cost is real
though — **a change to the header or footer has to be made in all four pages**.
The styles do not, because they live in `css/site.css`.

## The logo

The mark appears in four files and they must be kept in sync:

| File | Use |
|---|---|
| `brand/bad-duck-mark.svg` | The header mark. No padding, no tile — the artwork fills the box. |
| `favicon.svg` | Browser tab, on a dark tile |
| `brand/bad-duck-logo.svg` | Master, transparent, padded for avatar crops |
| `brand/bad-duck-logo-dark.svg` | Master, `#1A1A1D` tile, padded for avatar crops |

The header references `bad-duck-mark.svg` with an `<img>` rather than inlining
the SVG, so adding pages does not add copies of the artwork.

The masters wrap the same paths in `translate(6 7.2) scale(0.8)` so the duck
survives a circular avatar crop. `bad-duck-mark.svg` deliberately omits that
transform — at 40px in the header the padding would only make the duck small.
**That transform is the only difference; the paths are identical.**

## Brand assets

| File | Use |
|---|---|
| `brand/bad-duck-logo-{288,512,1024}.png` | Transparent PNG exports |
| `brand/bad-duck-logo-dark-{288,512,1024}.png` | Dark-tile PNG exports |
| `brand/og-image.png` | 1200 × 630 link-preview card |
| `brand/og-template.html` | Source for `og-image.png` |

Prefer the **dark-tile** exports for profile pictures — the duck is near-white
and disappears on a light background. Re-export with `brand/render-logo.ps1`.

### Link previews

`og:image` is `brand/og-image.png` on every page — the Bad Duck mark and
wordmark, **not** the product icon. Its content sits inside the centre
630 × 630 square, because Teams and Slack crop preview images to a square
rather than honouring the 1.91:1 card.

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

## Product artwork

Every image under `img/` is generated in its plugin repo by `npm run marketplace`
and copied here. Nothing is screenshotted by hand, so the site cannot show a key
the product no longer draws.

The source names carry an index and the destinations do not, so **these lists
have to be updated whenever a plugin's gallery set changes** — as the Teams list
did when its set grew from three items to six, and again at seven.

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

$m = "..\streamdeck-audiofuse\marketplace"
Copy-Item "$m\app-icon-288.png"      img\audiofuse-control.png
Copy-Item "$m\gallery-1-keys.png"    img\audiofuse-keys.png
Copy-Item "$m\gallery-2-dials.png"   img\audiofuse-dials.png
Copy-Item "$m\gallery-3-state.png"   img\audiofuse-state.png
Copy-Item "$m\gallery-4-offline.png" img\audiofuse-offline.png

$m = "..\streamdeck-nowplaying\marketplace"
Copy-Item "$m\app-icon-288.png"       img\now-playing.png
Copy-Item "$m\gallery-1-panel.png"    img\nowplaying-panel.png
Copy-Item "$m\gallery-2-controls.png" img\nowplaying-controls.png
Copy-Item "$m\gallery-3-volume.png"   img\nowplaying-volume.png
Copy-Item "$m\gallery-4-players.png"  img\nowplaying-players.png
```

The **Layouts for your deck** section on the Teams page shows one sheet per
Stream Deck, each holding all three of that deck's profiles. Those are generated
by `npm run profiles` in the plugin repo, which draws them from the
`.streamDeckProfile` files that actually ship, and are copied over whole:

```powershell
Copy-Item "..\streamdeck-teams-control\docs\profiles\*.png" img\layouts\ -Force
```

Names match the plugin's deck slugs (`mini`, `stream-deck`, `plus`, `neo`, `xl`,
`plus-xl`), so adding a deck there means adding a `<details>` block here. The
sheets are inside collapsed `<details>` and marked `loading="lazy"`, so none of
the megabyte-plus is fetched until a reader opens one.

### Claims about the products

Platform and version requirements on each product page come from that plugin's
`manifest.json` (`OS`, `Software.MinimumVersion`), and feature counts from its
property inspector. Re-check them when a plugin ships a new version — the first
draft of this refactor claimed Stream Deck 6.5 and six preset slots, and the
real values are 7.1 and eight.

## Checking a change

There is no test suite, so before pushing, serve the site and confirm every link
and image resolves and nothing overflows horizontally:

```powershell
python -m http.server 8777 --bind 127.0.0.1
```

Headless Edge clamps `--window-size` to a minimum width of about **477px**, so a
narrower `--screenshot` is a *crop of a 477px render*, not a narrow viewport.
Measuring pixels in one of those will suggest a horizontal overflow that does
not exist — `--force-device-scale-factor` does not help either, because it
scales rendering rather than the CSS viewport. Compare
`document.documentElement.scrollWidth` with `clientWidth` inside the page
instead. 477px is still below both breakpoints (760px and 600px), so it does
exercise the responsive rules.

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
