# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is a **content output repository**, not a code project. It holds the visualization pack generated for
Kindle book #44, 《剪映：剪出新視野》(a JianYing/CapCut short-video editing tutorial book), produced by the
global `book-viz-pack` skill (`~/.claude/skills/book-viz-pack/`).

There is no build system, package manifest, lint config, or test suite — the repo is purely generated
Mermaid diagrams and a PowerPoint compilation. Do not invent build/lint/test commands for it.

## Structure

```
mermaid/剪映/
├── mmd/                          # Mermaid source (.mmd), one per diagram
│   ├── 1-心智圖.mmd               # Mind map — radial overview of the whole book
│   ├── 2-學習流程圖.mmd            # Learning flow — suggested reading/practice order
│   ├── 3-架構分層圖.mmd            # Layered architecture — feature layers of the app
│   ├── 4-能力堆疊圖.mmd            # Capability stack — skills building on each other
│   └── 5-概念關係圖.mmd            # Concept relationship graph
├── png/                          # Rendered PNG for each .mmd above (same numbering)
├── 剪映-圖表合輯.pptx              # Compiled slide deck (one diagram per slide)
└── kindle-44-剪映-圖表合輯.pptx    # Same deck, filename prefixed with the book ID
```

The `book-viz-pack` skill always produces exactly these 5 fixed diagram types (mind map / learning flow /
layered architecture / capability stack / concept relationships) plus one merged PPTX — this is a fixed
5-diagram contract, unlike the more freeform `mmd-gen` skill. If asked to add more diagram types here, that
is out of scope for `book-viz-pack`; use `mmd-gen` instead and keep its output in a separate location.

## Working with this repo

- To regenerate or extend the diagrams, re-invoke the `book-viz-pack` skill rather than hand-editing the
  `.mmd`/`.png`/`.pptx` files — it re-derives content from the source book and keeps the 5-diagram + PPTX
  contract consistent.
- `.mmd` files are UTF-8 Mermaid source; render changes to PNG via the same pipeline the skill uses, not
  ad hoc mermaid-cli calls, so styling stays consistent with other Kindle book-viz-pack outputs.
- Two PPTX files currently coexist with slightly different names (`剪映-圖表合輯.pptx` vs
  `kindle-44-剪映-圖表合輯.pptx`) — the `kindle-44-` prefixed one is the canonical, book-ID-qualified name;
  treat the unprefixed one as legacy unless told otherwise.

## CapCut hands-on practice extension

This repo also grew a second, unrelated body of work: live CapCut (剪映) desktop-automation practice
sessions built on top of the book's content. History, coordinates, and every discovered CapCut bug/limit
live in `doc/交接文件-capcut-practice.md` — read it before starting a new hands-on practice round in this
repo, don't rediscover the same pitfalls.

Three **global** skills (in `~/.claude/skills/`, usable from any project, not just this repo) came out of
that practice work:

- `capcut-narration-video` — narration script → fully rendered + published YouTube video, fixed background/
  music/subtitle style, only the narration text varies
- `capcut-photo-video` — a batch of photos → celebration/tribute video with blur-fill background, music,
  closing title card
- `capcut-chapter-livedemo` — a teaching-chapter source (PDF/PPTX/DOCX/tutorial video/plain text) → parsed
  into an N-module course outline → live-demoed step by step in CapCut with spoken TTS narration, with a
  silent screen recording + written recap notes saved to `doc/demo-recordings/<chapter>-<date>/` so the
  demo doesn't need to be redone just to review it. Checks in with the user after every module (continue /
  redo / stop) and only exports/publishes if the user explicitly asks. Built 2026-08-09 from a Chapter 10
  "audio & music" live demo run in this repo.

None of these three skills live in this repo — they're global and apply to whatever CapCut project is open
at the time, so don't expect to find their implementation here. This repo is just where they were born,
where the practice history is documented, and — for `capcut-chapter-livedemo` specifically — where its
demo recordings/notes land by default (`doc/demo-recordings/`).
