# Synod looks

Looks and themes for Synod: new ways to draw a run, and new skins to draw it in.

[![ci](https://github.com/synodlang/looks/actions/workflows/ci.yml/badge.svg)](https://github.com/synodlang/looks/actions/workflows/ci.yml)
[![licence](https://img.shields.io/badge/licence-Apache--2.0-blue)](LICENSE)

This is the module `github.com/synodlang/looks`. It holds two **looks** and five
**themes**. A look says what is drawn and how it moves (arcs, trails, entrances,
effects, camera). A theme says how it is skinned (colors, type, stroke, sketch
wobble, glow, node shape). Any look works with any theme.

## Where it fits

| Repository | Its part |
| --- | --- |
| [dsl](https://github.com/synodlang/dsl) | The language: `# theme` headers (`spec/06` §6.7), the visual layer (`spec/09`) |
| [std](https://github.com/synodlang/std) | `std/theme`, `std/theme/default`, `std/look` and `std/look/basic` |
| [compiler](https://github.com/synodlang/compiler) | `synod`, which fetches this module with `synod get` |
| [examples](https://github.com/synodlang/examples) | The programs the demos here draw |
| `looks` (this one) | Extra looks and themes |

## Use it

Add the module to your `synod.mod` and run `synod get`:

```
module example.com/mine
synod 0.3

require github.com/synodlang/looks v0.3.0
```

A main file imports a look, and at most one theme. A program that imports no
theme uses `std/theme/default`; one that imports no look uses `std/look/basic`.

```synod
# package main
use github.com/synodlang/examples/raft
use github.com/synodlang/looks/doodle
use github.com/synodlang/looks/sketch
use std/sim

define main
  set nodes to (sim.Cluster of 5 running raft)
  raft.Meet nodes
  sim.StopAt 8s
```

The theme folder name is the theme word: `solarized/light` begins with
`# theme light`, and you import it as `use github.com/synodlang/looks/solarized/light`.
A theme exports no phrase and cannot change a run: the trace is the same under
every look and theme.

## Looks

| Package | What it draws |
| --- | --- |
| `lumen` | A ring of cards drawn on, state rows that pop in, glowing particles that fly on bent paths with a trail, ripples on arrival, flashes on loss, a rolling message counter, a framed warning when a rule breaks, camera pushes at start and end. Best with a dark theme; node cards are nicest with `NodeShape "circle"` and `NodeFill "outline"` as in `chalk`. |
| `doodle` | Thin and minimal: a stick-figure head over each card, envelopes for messages (a cross when lost), dashed outlines for crashes and partitions, changes written beside the card with a leader line. Best with `sketch`. |

## Themes

| Package | Import | Feel |
| --- | --- | --- |
| `solarized/light` | `github.com/synodlang/looks/solarized/light` | Solarized light, soft shadow |
| `solarized/dark` | `github.com/synodlang/looks/solarized/dark` | Solarized dark, vignette |
| `terminal` | `github.com/synodlang/looks/terminal` | Green phosphor, square outlined cards, mono type |
| `sketch` | `github.com/synodlang/looks/sketch` | Black ink on white paper, fully hand-drawn, handwritten type |
| `chalk` | `github.com/synodlang/looks/chalk` | Chalk on a dark board, lightly hand-drawn, round outlined nodes |

Every theme gives all 34 names. To make your own, copy `std/theme/default` (or
one of these) into a folder, set the first line to `# theme <folder name>` and
change the values.

## Demos

Every package has a `demo.synod` that draws the Raft leader election of the
examples module. The looks use the default theme; the themes use a look:

| Folder | Look and theme |
| --- | --- |
| `lumen` | lumen, default |
| `doodle` | doodle, default |
| `solarized/light` | doodle, solarized light |
| `solarized/dark` | lumen, solarized dark |
| `terminal` | lumen, terminal |
| `sketch` | doodle, sketch |
| `chalk` | lumen, chalk |

```
synod get
synod run ./lumen
synod run ./sketch --summary
```

Open `out/scene.json` in the Synod player to watch.

## Checks

```
scripts/check.sh            # fmt, check, demos against testdata/, every look x theme pair
scripts/check.sh --update   # rewrite the goldens
```

The script compares each demo's `--summary` and `scene.json` with `testdata/`,
and runs the raft program under the default look, `lumen` and `doodle` with each
of the six themes (default included) to check that all 18 traces have the same
events.

## Why Synod

Synod is named after the Synod protocol, the core consensus algorithm in Leslie Lamport's paper "The Part-Time Parliament" (ACM Transactions on Computer Systems, 1998; first submitted in 1990). The paper tells it as the story of the parliament of the ancient Greek island of Paxos, whose part-time legislators could agree on decrees although they came and went; today the algorithm is known as Paxos. Lamport later explained it plainly in "Paxos Made Simple" (2001), and in 2013 he received the ACM A.M. Turing Award for fundamental contributions to the theory and practice of distributed and concurrent systems. His "Time, Clocks, and the Ordering of Events in a Distributed System" (1978) and his TLA+ specification language shaped how we reason about such systems. We are grateful for his work, and we hope Synod honours it by making these ideas easier to watch and understand. These looks are one way of watching them.

## Credits

The `lumen` and `doodle` looks are inspired by the Manim/whiteboard-comic style of explaining ideas by drawing. The Solarized colour values are by Ethan Schoonover (MIT); see [NOTICE](NOTICE).

Implements Synod 0.3 (specification: https://github.com/synodlang/dsl).

Licensed under the [Apache License 2.0](LICENSE).
