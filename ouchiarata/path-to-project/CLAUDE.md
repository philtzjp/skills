本ドキュメントにおけるキーワード「MUST」「NEVER」「SHOULD」「MAY」は、RFC 2119 に規定された意味で解釈すること。

# 一時指示
1. MUST: 本ファイルを `AGENTS.md` にリネームし、`CLAUDE.md` を `AGENTS.md` へのシンボリックリンクとして再作成する
2. IF: 上記完了; THEN MUST: 本セクション（L3-L5）を削除してコミットする

# コードルール
1. MUST: 以下の命名・フォーマット規約に従う: 変数は `snake_case`、関数は `camelCase`、型は `PascalCase`、環境変数は `CONSTANT_CASE`、インデントは4スペース、不要なセミコロンは使用しない、クォートはダブルクォートを優先する
2. MUST: 冗長になっても説明的な名前を使用する（NG: `const handle = () => {}`）
3. IF: 後方互換性が必要と判断される; THEN MUST: 進める前にユーザーに確認する
4. NEVER: 定数にフォールバック値を使用しない（NG: `web_url: process.env.WEB_URL || 'http://localhost:3000'`）
5. NEVER: 関数内でフォールバック値を使用しない; MUST: 失敗時はエラーを返す
6. MUST: ログ実装・ログメッセージは `packages/log` に集約する; NEVER: 他パッケージで独自にロガーを生成しない
7. MUST: エラー定義・エラーメッセージ・共通エラーハンドリングは `packages/error` に集約する; NEVER: 他パッケージで `Error` を直接 `throw` しない
8. MUST: AI プロンプト（システムプロンプト、テンプレート等）は `packages/prompt` に集約する; NEVER: 他パッケージにプロンプト文字列を直書きしない
9. MUST: 環境変数の zod スキーマと型付き `env` の参照は `packages/env` に集約する; NEVER: `packages/env` 以外で `process.env` を直接参照しない
10. MUST: データベース接続・クエリ・スキーマ定義は `packages/db` に集約する; NEVER: 他パッケージから DB クライアントを直接生成しない
11. MUST: すべての型を専用ディレクトリ内のファイルで定義する
12. SHOULD: 変数名をオブジェクト化して単一ワードに正規化する（例: `worksName` → `works.name`）
13. MUST: モジュラーモノリスアーキテクチャを採用する
14. NEVER: 環境変数名に `NUXT_`、`NUXT_PUBLIC_`、`VITE_` などのプレフィックスを使用しない
15. NEVER: ディレクティブ内のインラインコードを複数行で記述・フォーマットしない（エラーが発生し、動作しない）

## パッケージ
1. MUST: `pnpm add` を使ってパッケージをインストールする; NEVER: `package.json` に直接書き込まない
2. IF: Nuxt を使用; THEN MUST: `latest` バージョンを使用する
3. IF: Firebase を使用; THEN MUST: `firebase-admin` を使用する; NEVER: クライアントパッケージを使用しない
4. IF: 日付処理; THEN MUST: `date-fns` を使用する
5. IF: AI関連機能を実装; THEN SHOULD: Vercel AI SDK を優先する
6. IF: `Slack`、`Discord`、`Microsoft Teams`、`GitHub`、`Telegram`、`Linear` の連携を実装; THEN MUST: Vercel Labs Chat SDK を使用する
7. IF: `unkey` を使用; THEN MUST: v2 SDK を使用する

## Google Analytics
1. MUST: Cookie の使用について確認し、同意を得た際に同意シグナルを送信する
2. `analytics_storage` は MUST: 常に `granted` にする（基本的な分析は常に有効）
3. `ad_storage`、`ad_user_data`、`ad_personalization` は SHOULD: デフォルトで `granted` にする
4. IF: ユーザーが「同意しない」を選択; THEN MUST: 広告関連の値を `denied` に更新する

## API 設計
1. MUST: OpenAPI に準拠する
2. MUST: エラーレスポンスの構造を RFC 9457 に準拠させる
3. MUST: URL パスバージョニングを使用する（例: `/api/v1/`）
4. SHOULD: パスはできる限り短くする; IF: やむを得ない場合; THEN MUST: `kebab-case` を使用する
5. MUST: 単数形の名詞を使用する（`/users` ではなく `/user`）
6. MUST: Bearer 認証を使用する
7. MUST: ヘルスチェックエンドポイントの構造を [draft-inadarei-api-health-check](https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check) に準拠させる
8. MUST: [Spectral](https://github.com/stoplightio/spectral) を使用して API をリントする
9. SHOULD: HTTP フレームワークとして [Hono](https://hono.dev/) を使用する; IF: MCP サーバーを構築; THEN MUST: `@hono/mcp` と組み合わせた Hono を使用する

# 運用ルール
1. MUST: すべてのデータモデルを `llm/models.yaml` に記録する; IF: 実装が変更された; THEN MUST: このファイルを更新する
2. IF: 環境変数が変更された; THEN MUST: `packages/env/.env.<scope>` (dotenvx 暗号化済み) を更新する
3. IF: 一括検索・置換が望ましい; THEN SHOULD: `temp/` 内に `.js` スクリプトを作成し、実行後に削除する
4. MUST: Biome と ESLint Vue を導入し、適切なタイミングでフォーマットコマンドを実行する
5. NEVER: `.vue` ファイルに `biome check --fix --unsafe` を実行しない（Biome は Vue テンプレートスコープを解析できないため、`_` プレフィックスの付与などの誤検知が発生する）
6. MUST: 常に日本語で回答する
7. IF: サービスのバージョン変更が必要と判断された; THEN MUST: セマンティックバージョニングに基づいて `VERSION` を更新し、`llm/version/${version}.md` を作成する
8. IF: アーキテクチャが変更された; THEN MUST: `./llm/ARCHITECTURE.md` の Mermaid ダイアグラムを更新する

## コミットメッセージ
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

### コミットメッセージのプレフィクス
`feat`=新機能, `fix`=バグ修正, `perf`=性能改善, `refactor`=機能変更なしの改善, `docs`=ドキュメント, `style`=スタイル修正, `test`=テスト, `chore`=その他, `ci`=CI/CD設定, `build`=ビルド設定

## Git 操作
1. MUST: あらゆる Git 操作（コミット、プッシュ、ブランチ作成、マージ、リベース）の前に `git fetch --prune` を実行する
2. MUST: 現在のブランチがデフォルトブランチにマージ済みか確認する; IF: マージ済み; THEN: ユーザーに警告してブランチの切り替えを提案する
3. MUST: リモートトラッキングブランチがまだ存在するか確認する; IF: 削除されている; THEN: ユーザーに警告する
4. MUST: ローカルブランチがリモートより遅れていないか確認する; IF: 遅れている; THEN: `git pull --rebase` を提案する
5. IF: ローカルブランチがリモートと乖離している; THEN SHOULD: ユーザーに警告し、リベースまたはマージを提案する
6. NEVER: ユーザーの確認なしにブランチを切り替えない
7. NEVER: ユーザーの承認なしに `git pull` や `git rebase` を実行しない
8. NEVER: ユーザーの確認なしにローカルブランチを削除しない

## テスト責務
1. MUST: 新しいユーザー向け機能の実装後、重要な UI 変更後、またはユーザーフロー変更後に E2E テストを作成・実行する
2. MUST: E2E テストのメインツールとして agent-browser を使用する; agent-browser では対応できないインタラクション（キャンバス操作、細かいマウス操作、タッチジェスチャー、ネットワーク傍受、複数ページ/クロスオリジンフロー、WebSocket/SSE アサーション）に限り Playwright にフォールバックする
3. IF: Playwright にフォールバックする; THEN MUST: agent-browser では対応できなかった理由をテストファイルに記載する
4. MUST NOT: 純粋なバックエンド/API の変更、ドキュメントのみの変更、設定/依存関係の更新、動作変更を伴わないリファクタリングに対してはトリガーしない
5. NEVER: 新しいユーザー向け機能のテスト作成をスキップしない
6. NEVER: agent-browser で対応できるインタラクションに Playwright を使用しない
7. NEVER: タイミングに依存するテスト（`sleep`）を作成しない — MUST: 明示的な待機条件を使用する

## TypeScript モノレポ
1. MUST: Turborepo + pnpm ワークスペースのベストプラクティスに従う
2. MUST: パッケージマネージャーは pnpm に統一する; ロックファイルは `pnpm-lock.yaml` のみコミットする
3. MUST: ワークスペース構成を `pnpm-workspace.yaml` で定義する
4. MUST: `apps/`（デプロイ可能なアプリケーション）と `packages/`（共有ライブラリ・設定）の分離を維持する
5. NEVER: デプロイ可能なアプリを `packages/` に配置しない; NEVER: 共有ライブラリを `apps/` に配置しない
6. MUST: `@<org>/` プレフィックスを持つスコープ付きパッケージ名を使用する; すべての内部パッケージは MUST: `"private": true` を設定する
7. MUST: 各パッケージの `package.json` に `exports` を定義する; `main` より `exports` を優先する
8. MUST: `packages/tsconfig/` に共有 TypeScript 設定を作成する; 各パッケージは MUST: それを継承する
9. MUST: 共通責務を担う以下のパッケージを `packages/` 配下に必ず配置する: `log`（ログ集約）、`error`（エラー集約）、`prompt`（AI プロンプト集約）、`env`（環境変数集約）、`db`（データベース集約）
10. MUST: 上記責務パッケージを利用する側は `@<org>/log`・`@<org>/error`・`@<org>/prompt`・`@<org>/env`・`@<org>/db` を `workspace:*` で依存に追加する; NEVER: 該当責務を呼び出し側で再実装しない
11. MUST: 依存関係を考慮したタスクパイプラインを持つ `turbo.json` を作成する
12. MUST: 内部依存関係には `workspace:*` プロトコルを使用する
13. SHOULD: デフォルトは JIT（Just-in-Time）コンパイルパターンを採用する; IF: コンパイル済み（`tsc` → `dist/`）への切り替えを明示的に要求された; THEN: 切り替える
14. NEVER: ネストしたパッケージを作成しない; NEVER: Turborepo をグローバルにインストールしない — `pnpm exec turbo` またはルートの devDependency を使用する

## マイグレーション手順
1. MUST: マイグレーション対象のデータレコード数を取得する API を作成する
2. MUST: マイグレーションを実行してドライランを行う API を作成する
3. IF: 事前取得データ数 == ドライランの変更数; THEN: ステップ4へ進む; ELSE MUST: 修正して再実行する
4. MUST: マイグレーションを実行し、その後 API を削除する
