# F1 2026 — Live Season Timing Board

A single-file, self-hosting dashboard for the 2026 FIA Formula One World Championship. One row per Grand Prix with race day, location, US Eastern start time, and a live podium rostrum — plus a self-updating Drivers' Championship strip and a countdown to the next race.

No build step, no dependencies, no backend. It's one `index.html` you can drop on any static host.

**Live demo:** _add your GitHub Pages URL here once deployed_

---

## What it does

- **All 22 rounds** of the final 2026 calendar (Australia → Abu Dhabi), one row each.
- **US Eastern start times** computed from each race's UTC start, so EST/EDT and night-before airings are handled automatically.
- **Live podiums** (P1/P2/P3) shown as a gold/silver/bronze rostrum, colour-coded by constructor.
- **Drivers' Championship** strip with positions, points, and leader highlight.
- **Live countdown** to the next Grand Prix, ticking from the viewer's own clock.
- **Filters:** All · Completed · Upcoming · Sprint.
- **Status pill:** shows `Live · synced HH:MM`, `Syncing…`, or `Offline · saved snapshot`, with a manual Refresh.
- **Responsive:** a timing-table on desktop, stacked cards on mobile.
- **Accessible-ish:** respects `prefers-reduced-motion`.

---

## How the live data works

Results and standings are pulled client-side from the **[Jolpica F1 API](https://github.com/jolpica/jolpica-f1)** (`api.jolpi.ca`), the open-source, Ergast-compatible successor maintained by the F1 data community.

On load the board paints instantly from a baked-in snapshot, then fetches live data and overlays it. It re-syncs every 5 minutes and on demand via Refresh.

Calls per sync (4 total, well under Jolpica's ~200/hr unauthenticated limit):

| Endpoint | Purpose |
|---|---|
| `/2026/results/1.json` | Race winners (P1) for every completed round |
| `/2026/results/2.json` | Second places (P2) |
| `/2026/results/3.json` | Third places (P3) |
| `/2026/driverStandings.json` | Drivers' championship standings |

The 22-race **schedule is fixed in the file** (it doesn't change mid-season), so only results/standings are fetched. If the feed is unreachable, the board falls back to the saved snapshot and never goes blank.

> Note: Jolpica typically posts results within a day of each race, not in real time. For instant in-race timing you'd swap in a real-time feed (see Upgrades).

---

## Run it

**Locally:** just open `index.html` in a browser. Live sync works from `file://` because Jolpica sends open CORS headers.

**Deploy (GitHub Pages — automatic):** this repo ships a GitHub Actions
workflow (`.github/workflows/deploy-pages.yml`) that **auto-enables Pages and
publishes** on every push. The only one-time step is setting the Pages source
to GitHub Actions:

```
Settings → Pages → Build and deployment → Source: "GitHub Actions"
```

The workflow's `configure-pages` step attempts to enable Pages for you, so in
most cases even that toggle is automatic. Your URL will be
`https://<user>.github.io/<repo>/`.

**Deploy from a branch (alternative):**

```
Settings → Pages → Source: "Deploy from a branch" → <branch> / root
```

Or use the included `deploy.sh` (needs the GitHub CLI `gh`, authenticated):

```bash
chmod +x deploy.sh && ./deploy.sh
```

Other one-drag hosts that work as-is: Netlify Drop, Cloudflare Pages, Vercel, tiiny.host.

---

## File structure

```
f1-2026-board/
├── index.html                       # the entire app (HTML + CSS + JS, self-contained)
├── README.md                        # this file
├── LICENSE                          # MIT
├── deploy.sh                        # optional: create repo + push + enable Pages via gh CLI
└── .github/workflows/deploy-pages.yml  # CI: auto-enables Pages and deploys on push
```

---

## Version

**v1.0.0 — "Barcelona"** · data snapshot 14 Jun 2026 (through Round 7).

- Live podiums + standings via Jolpica
- 22-round calendar, ET time conversion, countdown, filters, offline fallback
- Fixed mobile podium overlap; softened motion; reduced-motion support

---

## Possible upgrades

Roughly ordered easy → ambitious:

- **Constructors' Championship** strip alongside the drivers' one (`/2026/constructorStandings.json`).
- **Per-race expander:** click a row to reveal full classification, grid, gaps, fastest lap, and DNFs.
- **More columns:** pole sitter, fastest lap, sprint result for sprint weekends.
- **Team logos / driver headshots** in place of three-letter codes.
- **ICS calendar export** so viewers can subscribe to race times in their own timezone.
- **Timezone switcher** (ET / local / UTC) instead of ET-only.
- **Caching proxy** (a tiny Cloudflare Worker) to sidestep Jolpica's rate limit and add CDN caching if traffic grows.
- **Real-time data:** swap Jolpica for **OpenF1** (free, live timing/telemetry) or **Hyprace** (production-grade) for in-session updates and lap-by-lap.
- **Push/email alerts** before each race using the existing countdown logic.
- **Historical mode:** a season selector to browse any year back to 1950 (Jolpica covers it).
- **Theming:** light mode + per-constructor accent themes.

---

## Credits & licence

Data: Jolpica F1 API (Apache-2.0), the community successor to Ergast. Not affiliated with Formula 1, the FIA, or any team. "F1" and related marks belong to their owners. Use of this dashboard is non-commercial/fan use.

Licensed under the [MIT License](LICENSE).
