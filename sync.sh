#!/usr/bin/env bash
# Синхронизация снимка: копирует market-stats.json из корня рабочей
# директории в этот репозиторий, коммитит и пушит.
set -euo pipefail
cd "$(dirname "$0")"
SRC="../market-stats.json"
if [ ! -f "$SRC" ]; then
  echo "нет файла $SRC — снимок ещё не создавался"
  exit 1
fi
cp "$SRC" ./market-stats.json
if ! git diff --quiet; then
  runs=$(python3 -c 'import json;print(json.load(open("market-stats.json"))["runs"])')
  at=$(python3 -c 'import json;print(json.load(open("market-stats.json"))["updated_at"])')
  git add market-stats.json
  git commit -m "stats: runs=$runs · $at"
  git push
  echo "закоммичено и запушено: runs=$runs"
else
  echo "изменений нет"
fi
