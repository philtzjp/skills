#!/bin/sh
set -eu

VERSION="${1:-latest}"
ROOT=$(git rev-parse --show-toplevel)
DEST="$ROOT/.agents/skills/e2e"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

RESOLVED=$(npm view "e2e@$VERSION" version | tail -n 1 | sed "s/.*'\(.*\)'.*/\1/")
if [ -z "$RESOLVED" ]; then
    echo "e2e@$VERSION が npm にありません"
    exit 1
fi

npm pack "e2e@$RESOLVED" --pack-destination "$WORK" --silent >/dev/null
tar -xzf "$WORK/e2e-$RESOLVED.tgz" -C "$WORK"

if [ ! -f "$WORK/package/skills/e2e/SKILL.md" ]; then
    echo "e2e@$RESOLVED のパッケージに skills/e2e/SKILL.md がありません"
    exit 1
fi

rm -rf "$DEST"
cp -R "$WORK/package/skills/e2e" "$DEST"
cp "$WORK/package/LICENSE" "$WORK/package/NOTICE" "$DEST/"
printf '%s\n' "$RESOLVED" > "$DEST/VERSION"
ln -sfn ../../.agents/skills/e2e "$ROOT/.claude/skills/e2e"

echo "e2e $RESOLVED のスキルを .agents/skills/e2e に写しました"
