#!/usr/bin/env bash
# Cree dist/GeneaReille-mac-avec-lanceur.zip = GeneaReille.app + Lancer-GeneaReille.command
# Prérequis : npm run pack (ou electron-builder --dir)

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

APP=""
for candidate in dist/mac/GeneaReille.app dist/mac-universal/GeneaReille.app dist/mac-arm64/GeneaReille.app dist/mac-x64/GeneaReille.app; do
  if [ -d "$candidate" ]; then
    APP="$candidate"
    break
  fi
done
if [ -z "$APP" ] && [ -d dist ]; then
  APP="$(find dist -path '*/GeneaReille.app' -type d 2>/dev/null | head -1 || true)"
fi

if [ -z "$APP" ]; then
  echo "GeneaReille.app introuvable sous dist/. Lance d'abord : npm run pack"
  exit 1
fi

LANCEUR="$ROOT/scripts/Lancer-GeneaReille.command"
OUT="$ROOT/dist/GeneaReille-mac-avec-lanceur.zip"

if [ ! -f "$LANCEUR" ]; then
  echo "Fichier lanceur introuvable : $LANCEUR"
  echo "Remettez scripts/Lancer-GeneaReille.command dans le depot (git) ou recreez-le."
  exit 1
fi

chmod +x "$LANCEUR"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp -R "$APP" "$TMP/GeneaReille.app"
cp "$LANCEUR" "$TMP/Lancer-GeneaReille.command"
chmod +x "$TMP/Lancer-GeneaReille.command"

( cd "$TMP" && zip -r -q "$OUT" GeneaReille.app Lancer-GeneaReille.command )
echo "OK → $OUT"
