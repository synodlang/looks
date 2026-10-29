# Changelog

All notable changes to the Synod looks. Versions share MAJOR.MINOR with the language.

## Unreleased

Implements Synod 0.3.

### Added

- Two looks: `lumen`, a generic look in the Manim/whiteboard-comic spirit of glowing particles on bent paths, effects and camera moves, and `doodle`, a thin minimal look of stick-figure nodes, envelopes and annotations.
- Edge items (reasons, the lumen counter, foot notes) sit for the 1040 by 650 canvas; doodle shows an envelope's type only mid-flight so tags never pile up on a target.
- `lumen` draws no effect where a message arrives (a ripple ring stood round every card all the time and cut through the neighbours' state rows); the particle just ends.
- Five themes: `solarized/light`, `solarized/dark`, `terminal`, `sketch` and `chalk`, each with all 34 theme names.
- A runnable `demo.synod` in every package, drawing the `raft` example.
- `scripts/check.sh`: formatting, `synod check`, every demo against the goldens in `testdata/`, and every look by theme pair with the traces compared.
- CI that installs the pinned `synod` and runs the script.
