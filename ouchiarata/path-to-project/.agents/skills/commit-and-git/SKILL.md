---
name: commit-and-git
description: "コミット、プッシュ、ブランチ作成/切り替え/削除、マージ、リベースなどあらゆる Git 操作を行うときに参照する。コミットメッセージのフォーマット (`type(scope): 説明`)、`--author` の扱い、`git fetch --prune` などの安全チェック、`Co-Authored-By` 禁止、`git add .` 禁止などを定義する。"
---

# コミットメッセージ
1. MUST: `type: 説明（日本語、短い文）` のフォーマットを使用する
2. IF: モノレポ; THEN MUST: `type(scope): 説明（日本語、短い文）` のフォーマットを使用し、説明を短く保つためにカッコ表記は用いない。
3. MUST: 論理的なスコープ（パッケージ、機能）ごとにコミットを分割する; NEVER: 無関係な変更をまとめてコミットしない
4. 変更をコミットする際:
   - ファイルごとに `git diff` を実行して各変更の作者を確認する。
   - NEVER: committer を上書きしない（常にユーザーの git config を使用する）
   - IF: すべての変更がエージェントによって生成された（ユーザー編集行がない）; THEN MUST: `--author` のみで自身のエージェント種別を明示する:
      - OpenAI (Codex): `git commit --author="Codex <noreply@openai.com>" -m "<message>"`
      - Anthropic (Claude): `git commit --author="Claude <noreply@anthropic.com>" -m "<message>"`
   - IF: 一部でもユーザーによる変更がある; THEN MUST: 通常の `git commit` を使用する。
5. NEVER: `Co-Authored-By` を追加しない
6. NEVER: `git add .` や `git add -A` を使用しない
7. NEVER: 無関係な変更を1つのコミットに混在させない

## コミットメッセージのプレフィクス
`feat`=新機能, `fix`=バグ修正, `perf`=性能改善, `refactor`=機能変更なしの改善, `docs`=ドキュメント, `style`=スタイル修正, `test`=テスト, `chore`=その他, `ci`=CI/CD設定, `build`=ビルド設定

# Git 操作
1. MUST: あらゆる Git 操作（コミット、プッシュ、ブランチ作成、マージ、リベース）の前に `git fetch --prune` を実行する
2. MUST: 現在のブランチがデフォルトブランチにマージ済みか確認する; IF: マージ済み; THEN: ユーザーに警告してブランチの切り替えを提案する
3. MUST: リモートトラッキングブランチがまだ存在するか確認する; IF: 削除されている; THEN: ユーザーに警告する
4. MUST: ローカルブランチがリモートより遅れていないか確認する; IF: 遅れている; THEN: `git pull --rebase` を提案する
5. IF: ローカルブランチがリモートと乖離している; THEN SHOULD: ユーザーに警告し、リベースまたはマージを提案する
6. NEVER: ユーザーの確認なしにブランチを切り替えない
7. NEVER: ユーザーの承認なしに `git pull` や `git rebase` を実行しない
8. NEVER: ユーザーの確認なしにローカルブランチを削除しない
