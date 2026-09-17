---
name: api-design
description: API エンドポイントの設計・実装・変更を行うとき（OpenAPI スキーマ、ヘルスチェック、ルーティング、認証方式の追加など）に参照する。このスキルは hono スキルに統合した。内容は hono スキルを使う。
---

# api-design

このスキルは hono スキルに統合しました。ここには規約を書いていません。

## すること

1. hono スキルを読み、その規約に従う。
2. hono スキルが見つからなければ、次のどちらかで読む。
   - `npx skills add philtzjp/skills -g -a claude-code -a codex -a cursor -s hono -y` でホームに導入する。導入はユーザーの許可を得てから行う。
   - https://raw.githubusercontent.com/philtzjp/skills/main/.agents/skills/hono/SKILL.md を取得する。
3. 作業中のリポジトリに、このスキルの古い規約本文がコピーされて残っていたら、hono スキルを優先する。そのうえで、古いコピーの削除をユーザーに提案する。

## 経緯

philtzjp/skills の api-design を改良した hono スキルを正本にしました。refresh-skills で同期している各リポジトリが壊れないように、このスキルは削除もリネームもせず、案内として残しています。
