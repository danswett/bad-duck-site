# bad-duck.com

Static marketing site for **Bad Duck Software**, served by GitHub Pages at
<https://bad-duck.com>.

Plain HTML and CSS in a single `index.html` — no build step, no dependencies.
Push to `main` and GitHub Pages publishes it.

| Path | Purpose |
|---|---|
| `index.html` | The whole site |
| `CNAME` | Custom domain for GitHub Pages (`bad-duck.com`) |
| `img/` | Artwork copied from the product's `marketplace/` assets |

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
