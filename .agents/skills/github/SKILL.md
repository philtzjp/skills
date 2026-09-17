---
name: github
description: Issue 起票からブランチ、実装、PR、マージまでの標準フローと、Git / GitHub 操作の規約。コミットメッセージの type(scope) 形式、scope の決め方、--author の扱い、Co-Authored-By と git add . の禁止、merge commit での PR マージ、ahead/behind の確認。コミット、プッシュ、ブランチ作成や切り替え、マージ、リベース、Issue や PR の作成、gh pr merge を行うときに使う。
---

# github

## フロー

パッチバグフィクス以外の実装作業は、この順で進める。

1. Issue を起票する。
2. Issue 番号を含む専用ブランチを作る。
3. 実装する。
4. PR を作る。
5. ahead / behind とマージ可否を確認する。
6. merge commit でマージする。

判断に迷う作業はパッチバグフィクスではなく通常フローとして扱う。通常フロー対象の実装を、Issue なし、専用ブランチなし、PR なしで進めない。デフォルトブランチ上で始めない。

会社、チーム、担当領域をまたぐ変更では、影響範囲、検証内容、残リスクを Issue と PR に明記する。

## フローを省略できる場合

次をすべて満たすときだけ、パッチバグフィクスとして省略できる。

- 既存挙動の明確な不具合を直す最小差分である。
- 仕様追加、設計変更、データモデル変更、API 契約変更、依存関係変更、権限・課金・認証の変更を含まない。
- 変更範囲が局所的で、他チームの作業や統合予定リポジトリに影響しない。
- Issue 化して合意形成する価値より、即時修正する価値が明らかに高い。
- ユーザーがパッチ対応を明示している、または同等の Issue や PR の文脈が既にある。

## 開始前

```sh
git status --short --branch
git fetch --prune
```

- デフォルトブランチ、現在ブランチ、リモート追跡ブランチの状態を確認する。
- 未コミット変更があれば、内容と所有者を確認する。今回の作業に無関係な変更をステージ、コミット、修正しない。
- 現在ブランチがデフォルトブランチでなければ、今回の作業用か確認する。
- gh など Issue や PR の操作に必要なツールや権限がなければ、不足を報告し、ローカル実装だけ先行してよいか確認する。

## Issue

- 既存 Issue があるか先に確認する。なければ実装前に作る。
- 目的、背景、受け入れ条件、影響範囲、検証方針を書く。
- 受け入れ条件は task list（`- [ ]`）で書き、達成状況を追跡できるようにする。
- 複数会社や複数領域に影響するなら、担当境界とレビュー観点を書く。
- 実装単位が大きすぎない粒度に分割する。
- Issue が曖昧なまま大きな変更に着手しない。

## ブランチ

- Issue 番号を含む専用ブランチを作る。
- 名前は `<type>/<issue-number>-<short-kebab-summary>`。
- type は feat、fix、refactor、docs、test、chore、ci、build のいずれか。
- 作成前にベースブランチが最新であることを確認する。
- 複数 Issue の実装を1ブランチに混ぜない。
- ユーザーの確認なしにブランチを切り替えない。

## 実装

- Issue の受け入れ条件に沿って、最小の論理単位で実装する。
- スコープが広がったら Issue と PR の説明を更新する。必要なら別 Issue に分割する。
- 変更に応じてテスト、Lint、型チェック、E2E、ドキュメント更新を行う。
- レビューしづらい巨大差分を、理由なく1 PR にまとめない。

## コミットメッセージ

`type: 説明` の形式。日本語の短い文にする。モノレポでは `type(scope): 説明` にし、説明を短く保つためにカッコ表記は使わない。

type は次のいずれか。

- feat 新機能 / fix バグ修正 / perf 性能改善 / refactor 機能変更なしの改善
- docs ドキュメント / style スタイル修正 / test テスト / chore その他
- ci CI/CD 設定 / build ビルド設定 / merge PR のマージ（マージコミット専用）

scope の決め方。

- ファイル変更のあったトップレベルディレクトリ名（リポジトリ直下のディレクトリ名）を使う。
- Turborepo などのモノレポで apps/ や packages/ 配下を変更するなら、配下のパッケージ名やアプリ名（leaf 名）を使う。apps/dashboard なら dashboard、packages/log なら log。
- リポジトリ全体に関わる変更は repo。
- 隠しディレクトリは先頭のドットを含めて書く。agents ではなく .agents。
- スラッシュで階層を表現しない。
- apps や packages などモノレポの親ディレクトリ自体を scope にしない。
- workspace、design のような実体のない総称や、存在しないフォルダ名を使わない。

```
NG: feat(workspace): / feat(design): / feat(agents): / feat(apps): / feat(apps/dashboard): / feat(packages/log):
OK: feat(repo): / feat(.agents): / feat(.claude): / feat(dashboard): / feat(log):
```

説明の書き方。

- 動作で終える。〜する、〜追加、〜修正、〜削除、〜実装など。
- 動作を伴わない名詞で終えない。`feat(api): ユーザー認証` ではなく `feat(api): ユーザー認証を追加`。
- emoji を含めない。
- 論理的なスコープ（パッケージ、機能）ごとにコミットを分割する。無関係な変更を1つのコミットに混ぜない。

## コミットの実行

- ファイルごとに `git diff` を実行し、各変更の作者を確認する。
- `git add .` と `git add -A` を使わない。
- committer を上書きしない。常にユーザーの git config を使う。
- `Co-Authored-By` を、コミットメッセージ、PR 本文、マージコミットメッセージのいずれにも含めない。

すべての変更がエージェントによるもので、ユーザーが編集した行がない場合だけ、`--author` で自身のエージェント種別を明示する。

```sh
git commit --author="Claude <noreply@anthropic.com>" -m "<message>"
git commit --author="Codex <noreply@openai.com>" -m "<message>"
git commit --author="Cursor Agent <cursoragent@cursor.com>" -m "<message>"
```

実際に動作しているエージェント種別と一致する行を使う。他エージェントの例を流用しない。一部でもユーザーによる変更があれば、通常の `git commit` を使う。

- commit-msg hook が未承認の `Co-authored-by:` を自動付与する環境では、それを除去する hook を入れて対処する。`git commit --no-verify` で hook を迂回しない。
- 履歴修正で force push が必要なら、guard の許可を一時的に有効にして push し、作業後に戻す。

## Git 操作の安全確認

あらゆる Git 操作（コミット、プッシュ、ブランチ作成、マージ、リベース）の前に `git fetch --prune` を実行する。そのうえで確認する。

- 現在のブランチがデフォルトブランチにマージ済みでないか。済みなら警告してブランチの切り替えを提案する。
- リモート追跡ブランチがまだ存在するか。削除されていれば警告する。
- ローカルブランチがリモートより遅れていないか。遅れていれば `git pull --rebase` を提案する。
- リモートと乖離していないか。乖離していれば警告し、リベースかマージを提案する。

ユーザーの承認なしに `git pull` や `git rebase` を実行しない。確認なしにローカルブランチを削除しない。

## PR

```sh
gh pr create --body "<本文>"
gh pr create --body-file <file>
```

- 本文を必ず明示する。`--fill` やエディタ生成で `Co-Authored-By` が混入し得る場合は使わない。
- 本文に概要、変更内容、検証結果、影響範囲、レビューしてほしい観点、残リスクを書く。
- 対象 Issue を自然言語で参照する。本文の背景や概要に `#<issue-number>` を書く。
- 自動クローズが必要な場合だけ、英語キーワード（`Closes #N` など）を使うか、GitHub の Development で Issue をリンクする。日本語の同義表現（「#N をクローズする」）では自動クローズは発火しない。
- 作成前にローカルブランチを upstream へ push する。
- Draft で早めに作り、実装完了後に Ready for review へ切り替える。
- レビュー、CI、必要な検証を迂回してマージしない。

## マージ前チェック

```sh
git fetch --prune
git status --short --branch
```

- ローカルブランチが upstream に対して ahead / behind / diverged していないこと。
- PR ブランチがベースブランチに対して behind していないこと。
- PR が mergeable で、コンフリクトがなく、必須の CI、レビュー、チェックが通っていること。

対処。

- ahead なら push して再確認する。
- behind か diverged なら、ユーザーに報告し、rebase / merge / pull の方針を確認してから同期する。
- PR ブランチがベースブランチに対して behind なら、ベースブランチを取り込んで検証を再実行する。
- コンフリクト、失敗した CI、未解決レビュー、未確認の ahead / behind があるならマージしない。

## マージ

直前にもう一度 `git fetch --prune` と ahead / behind の確認を行う。

```sh
gh pr merge <番号> --merge --subject "merge(scope): 説明" --body ""
```

- マージ方式は merge commit。squash merge と squash commit は使わない。ユーザーが明示的に指示した場合だけ例外。
- 件名と空の本文を明示する。デフォルトのマージコミットメッセージ（`Merge pull request #N from ...`）を使わない。
- 件名にも本文にも PR 番号や Issue 番号（`#N`）を含めない。
- merge プレフィクスでマージであることは明示されるので、説明文に「マージ」と書かない。`merge(api): foo をマージ` ではなく `merge(api): foo を追加`。

## マージ後

- 対象 Issue の状態を確認する。自動クローズを設定していたならクローズされたことを確認する。設定していなければ `gh issue close <番号>` で手動クローズする。
- 作業ブランチの削除は、リモート状態とユーザーの意図を確認してから行う。
- マージ、レビュー、検証を保留する場合や解決が pending の場合は、Issue をクローズせず、保留（pending review）として状況と再開条件をコメントに残す。重複起票を防ぐため。
- 未解決の同一事象について Issue を重複起票しない。
- 同一事象で複数の Issue が起票・クローズされていたら、最古の Issue を親（正本）として sub-issue 関係を付け、後発を duplicate としてクローズし、変更内容を各 Issue にコメントする。
