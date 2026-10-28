#!/usr/bin/env bash
# Checks the looks module.
#
#   scripts/check.sh            check formatting and types, run every demo and compare
#                               its --summary and scene.json with testdata/<demo>/, then
#                               run every look x theme pair and compare the traces
#   scripts/check.sh --update   rewrite the goldens in testdata/ from the current compiler
#
# Set SYNOD to the compiler to use (default: synod on the PATH).
set -euo pipefail

cd "$(dirname "$0")/.."
synod="${SYNOD:-synod}"
update=0
[ "${1:-}" = "--update" ] && update=1

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
status=0
fail() { echo "FAIL: $*" >&2; status=1; }

echo "== format and check"
"$synod" fmt --check . || fail "synod fmt --check"
"$synod" check . || fail "synod check"

echo "== demos against goldens"
while IFS= read -r demo; do
  dir="$(dirname "$demo")"
  dir="${dir#./}"
  name="${dir//\//-}"
  gold="testdata/$name"
  # The summary names the trace file, so every demo writes it to the same relative path.
  mkdir -p out
  "$synod" run "$dir" --summary --trace out/trace.jsonl --scene "$work/$name.scene.json" > "$work/$name.summary.txt" \
    || { fail "$dir: synod run"; continue; }
  if [ "$update" = 1 ]; then
    mkdir -p "$gold"
    cp "$work/$name.summary.txt" "$gold/summary.txt"
    cp "$work/$name.scene.json" "$gold/scene.json"
    echo "updated $gold"
    continue
  fi
  cmp -s "$work/$name.summary.txt" "$gold/summary.txt" || fail "$dir: --summary differs from $gold/summary.txt"
  cmp -s "$work/$name.scene.json" "$gold/scene.json" || fail "$dir: scene.json differs from $gold/scene.json"
  echo "checked $dir"
done < <(find . -name demo.synod -not -path './vendor/*' -not -path './out/*' | sort)

[ "$update" = 1 ] && exit "$status"

echo "== every look x theme pair"
# The default look is std/look/basic (no look import); the default theme is std/theme/default (no theme import).
looks="basic lumen doodle"
themes="default solarized/light solarized/dark terminal sketch chalk"
rm -rf out/matrix
n=0
for look in $looks; do
  for theme in $themes; do
    n=$((n + 1))
    dir="out/matrix/p$n"
    mkdir -p "$dir"
    {
      echo "# package main"
      echo "use github.com/synodlang/examples/raft"
      [ "$look" != basic ] && echo "use github.com/synodlang/looks/$look"
      [ "$theme" != default ] && echo "use github.com/synodlang/looks/$theme"
      echo "use std/net"
      echo "use std/sim"
      echo
      echo "define main"
      echo "  sim.Seed 3"
      echo "  net.Latency between 5ms and 15ms"
      echo "  set nodes to (sim.Cluster of 5 running raft)"
      echo "  raft.Meet nodes"
      echo "  after 2s"
      echo "    sim.Crash (item 0 of raft.Leaders)"
      echo "  sim.StopAt 6s"
    } > "$dir/demo.synod"
    "$synod" fmt "$dir" >/dev/null
    "$synod" check "$dir" || { fail "$look x $theme: synod check"; continue; }
    "$synod" run "$dir" --trace "$work/p$n.trace.jsonl" --scene "$work/p$n.scene.json" >/dev/null \
      || { fail "$look x $theme: synod run"; continue; }
    # A trace never depends on look or theme: its events are the same lines.
    tail -n +2 "$work/p$n.trace.jsonl" > "$work/p$n.events"
    if [ "$n" -gt 1 ]; then
      cmp -s "$work/p1.events" "$work/p$n.events" || fail "$look x $theme: trace events differ from basic x default"
    fi
    echo "ok $look x $theme"
  done
done
rm -rf out/matrix

exit "$status"
