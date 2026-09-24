# drobe-site

Marketing and explanation site for **DROBE**. Hugo, no theme, no external
dependencies at build or at runtime.

Published to GitHub Pages by `.github/workflows/pages.yml` on every push to
`main`. The workflow takes baseURL from the Pages settings, so the build works
at `<user>.github.io/drobe-site/` and on a custom domain alike. Link to site
pages in Markdown as `/product/roadmap/`; the link render hook makes them
base-path aware. In templates use `"product/roadmap/" | relURL`, without the
leading slash.

## Run it

```bash
make dev      # local server, picks a free port, opens a browser
make build    # production build into public/
make check    # build to a temp dir and report OK / FAIL
make clean    # remove public/, resources/_gen, the lock file
```

`build` and `check` pass `--panicOnWarning`, which turns every Hugo warning into
a build failure. Deprecated APIs warn before they are removed, so this is what
stops a deprecation reaching main. Do not remove it to make a build pass.

## Where the design comes from

`assets/css/tokens.css` is copied from the app's own theme - not sampled from
a screenshot.
Both the light and dark palettes are reproduced, so the site follows the
reader's system setting the way the app follows the device's.

**When the app's palette changes, tokens.css is the one file to change.**

Two other rules carried over from the app:

- **No emoji.** Icons are inline SVG with Lucide geometry - 24×24 viewBox,
  stroke 1.75, round caps and joins, no fill. They live in
  `layouts/partials/icons/` and ship inline rather than as extra requests.
- **No webfont.** The app uses the platform system font. So does this.
  Nothing is loaded from Google or anywhere else.

## Screenshots

`static/screenshots/` holds five screens of the running demo at three
breakpoints (390, 768, 1280). They are captures, not renderings. Refresh them
from the app when it changes.

## The avatar video

`static/media/avatar.mp4` is the demo's animated avatar GIF, converted. The
GIF is 3.5 MB for 150 frames; the MP4 is 152 KB for the same, and unlike a GIF
a video can be paused, which is what makes the reduced-motion case work at all.

It plays twice and stops. `loop` is all-or-nothing, so the count lives in
`data-plays` on the element and `layouts/partials/video-behaviour.html` counts
`ended` events. With scripting off it plays once, which is a reasonable place
to land. That partial also pauses it when the reader prefers reduced motion,
which CSS cannot do.

The source has an alpha channel and MP4 does not, so the app's sage card colour
is composited in at encode time rather than set in CSS. That is why the well
keeps a light ground in dark mode - the same as every screenshot here, which
are all of the light theme.

To regenerate after the demo's avatar changes:

```bash
SRC=path/to/avatar-animated.gif   # from the app

ffmpeg -y -f lavfi -i "color=c=0xE2EEDC:s=720x900:r=25" -i "$SRC" \
  -filter_complex "[1:v]scale=720:900[fg];[0:v][fg]overlay=shortest=1,format=yuv420p" \
  -movflags +faststart -crf 26 -an static/media/avatar.mp4

ffmpeg -y -ss 0.8 -f lavfi -i "color=c=0xE2EEDC:s=720x900" -i "$SRC" \
  -filter_complex "[1:v]scale=720:900[fg];[0:v][fg]overlay=shortest=1" \
  -frames:v 1 -q:v 4 static/media/avatar-poster.jpg
```

`0xE2EEDC` is `--sage-bg` from the light palette. If that token changes, this
changes with it.

## Structure

```
content/
  _index.md              home - the copy lives in layouts/home.html
  use-cases/             eight situations, ordered everyday -> specialised
  for/                   women, men - two entry points, same product
  product/               every screen, and the roadmap
  beta.md beta-thanks.md the waitlist form and its thank-you page
  imprint.md privacy.md  legal pages
layouts/
  home.html              the home page sections
  page.html list.html    everything else
  partials/icons/*.svg   Lucide-geometry icons
  shortcodes/
    pair.html            a situation and what DROBE does about it, side by side
    shot.html shots.html one screenshot, or the breakpoint trio
    note.html            what is real versus what is planned
    steps.html           a numbered sequence
    img.html             a library image, with its AI credit
    imprint.html         the Austrian Impressum (same as lindamohamed.com)
  _markup/render-link.html  base-path-aware Markdown links
assets/css/
  tokens.css             the palette, from the app
  base.css               elements and layout primitives
  components.css         the app's visual language
```

## A note on honesty

The demo is a demo. Every page that shows a feature says whether it is running
today or on the roadmap, using the `note` shortcode. Keep that up - a site that
presents planned features as shipped is the fastest way to lose the reader who
matters.
