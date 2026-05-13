#!/bin/bash
# Enleve la quarantaine puis lance GeneaReille.
# A placer dans le meme dossier que GeneaReille.app (ex. dans le zip a distribuer).

cd "$(dirname "$0")"
APP_NAME="GeneaReille.app"

if [ ! -d "$APP_NAME" ]; then
  echo "GeneaReille.app introuvable dans ce dossier."
  echo "Placez ce script dans le meme dossier que GeneaReille.app."
  read -p "Appuyez sur Entree pour fermer."
  exit 1
fi

# Enleve la quarantaine (evite le message « endommagee »)
xattr -cr "$APP_NAME"

# Lance l'app
open "$APP_NAME"
