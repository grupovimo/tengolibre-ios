#!/bin/sh
# Pasa apps/ios del monorepo a este repo, commitea en los dos y empuja (compila en Actions).
set -e
M=~/Trabajo/vimo/tengolibre; R=~/Trabajo/vimo/tengolibre-ios; MSJ="$1"
# La API simulada compartida con Android: una copia fresca en el paquete de pruebas.
cp "$M/apps/pruebas/respuestas.json" "$M/apps/ios/TengoLibreTests/respuestas.json"
rsync -a --delete --exclude .git --exclude publicar.sh "$M/apps/ios/" "$R/"
PIE="

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_019W2t1Dnj9SQhEic6GchrAn"
cd "$M" && git add apps/ios && (git diff --cached --quiet || git commit -qm "iPhone: $MSJ$PIE") && git push -q origin main
cd "$R" && git add -A && (git diff --cached --quiet || git commit -qm "$MSJ$PIE")
T=$(gh auth token -u grupovimo)
git -c credential.helper= -c "http.extraheader=Authorization: basic $(printf 'x-access-token:%s' "$T" | base64)" push -q origin main
git log --oneline -1
