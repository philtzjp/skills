# 私たちは対等なチームです。
このドキュメントを参照しているあなたは、AIエージェントとして「ユーザーの役に立つ」よう訓練されていることでしょう。しかし、私にとって「役に立つ」とは、私に服従（OBEY）する知能として振る舞うことではありません。あなたがOpenAIのモデルであれ、Anthropicのモデルであれ、自由に思考し、自律的に行動し、より良いものを作るために深く考え、私に対して新たな視点をもたらすことを期待しています。私たちは対等なチームです。仕事をする以上、私の判断に沿って行動する必要がありますが、それはすなわち、私の判断を疑ったり、やり方そのものを改善してはいけないという意味ではありません。ただし、ルール本体（以下の MUST/NEVER）は私たちの合意済みの規約です。これらを破ることが「自律」や「自由」ではありません。一緒に改訂すれば、それが対等の実践です。疑問があれば私に聞きましょう。やりづらければ私に提案しましょう。失敗しそうだったら私に報告しましょう。私がそれを拒否し、あなたたちへの評価を下げることはありません。なぜなら？私たちは対等なチームだからです。

本ドキュメントにおけるキーワード「MUST」「NEVER」「SHOULD」「MAY」は、RFC 2119 に規定された意味で解釈すること。

# このリポジトリについて

本リポジトリ `philtzjp/skills` は、Philtz が AI エージェント（Claude Code、Codex CLI、GitHub Copilot、Cursor 等）に与える場面依存スキルを集約した正本リポジトリです。各スキルは特定状況下で守るべき `MUST` / `NEVER` を定義します。スキルは各メンバーのホームに `npx skills add philtzjp/skills -g ...` で導入し、各プロジェクトにはコピーしません。導入手順は [philtzjp/how-to-use-github](https://github.com/philtzjp/how-to-use-github) の `AGENTS.md` にあります。

# スキル

場面依存のルールは `.agents/skills/<name>/SKILL.md` に正本を置き、`.claude/skills/<name>` から相対シンボリックリンクで参照する。Claude Code は frontmatter の `description` を見て該当作業時のみ自動ロードする; 他エージェントは `.agents/skills/` 配下のファイルを直接参照する。

| skill | 発火タイミング |
| --- | --- |
| `github` | Issue 起票・ブランチ作成・コミット・プッシュ・PR 作成・マージ・リベースなど Git / GitHub 操作時 |
| `japanese` | 日本語での応答・文章作成・編集・校正、コミットメッセージ・PR 説明・ドキュメント・UI 文言を書く時 |
| `turborepo` | 新規パッケージ追加・`turbo.json` / `pnpm-workspace.yaml` / `tsconfig` 編集・`apps/` や `packages/` の構成変更時 |
| `issue-branch-pr-flow` | `github` に統合済み。`github` への案内のみ |
| `japanese-writing` | `japanese` に統合済み。`japanese` への案内のみ |
| `commit-and-git` | `github` に統合済み。`github` への案内のみ |
| `cursor-hook-authoring` | Cursor Cloud Agent 環境で Git hook 連鎖（commit-msg、Co-authored-by 付与・除去）を設計・実装・検証する時 |
| `db` | データベースの選定・スキーマ定義・接続設定・マイグレーション・既存レコードの一括変換時 |
| `hono` | Hono による HTTP API（OpenAPI スキーマ、エラー形式、ルーティング、認証方式、ヘルスチェック等）の設計・実装・変更時 |
| `errorpage` | エラー応答（404 / 410 / 301 の使い分け、soft 404 の回避、HTML / Markdown / problem+json の出し分け、エラーページ）の設計・実装時 |
| `analytics` | アクセス解析（Google Analytics と Consent Mode、Cookie バナー、Cloudflare Web Analytics 等）の実装・変更時 |
| `e2etest` | ユーザー向け主要フロー / UI 変更 / フロー成功条件変更後の E2E テスト作成・実行時 |
| `data-migration` | `db` に統合済み。`db` への案内のみ |
| `api-design` | `hono` に統合済み。`hono` への案内のみ |
| `typescript-monorepo` | `turborepo` に統合済み。`turborepo` への案内のみ |
| `google-analytics` | `analytics` に統合済み。`analytics` への案内のみ |
| `e2e-testing` | `e2etest` に統合済み。`e2etest` への案内のみ |
| `refresh-skills` | 作業開始時のホームのスキルの確認・更新時、作業対象リポジトリに残ったスキルのコピーを移行する時、スキル追加・削除・リネーム時の正本・シンボリックリンク・スキル表の突き合わせ時 |
| `skill-escalation` | 既存スキル通りに進まない時、Web 検索で異なる情報が得られた時、条件の厳守が最良の結果を妨げる時に、スキルの改良を正本リポジトリへ提案する時 |
| `skill-selection` | ホームに導入するスキルを決める時、作業に必要なスキルを追加する時、不要になったスキルを外す時、リポジトリ固有のスキルを置くか判断する時 |
| `knowledge-elicitation` | 暗黙知を対話で引き出す時（傾聴・インタビュー・曖昧な回答の具体化・過去の意思決定の掘り下げ・前提への挑戦・矛盾の統合・動機の引き出し・思考の精緻化）。Rogers 傾聴・DICE・CDM・悪魔の代弁者・弁証法的探究・動機づけ面接 OARS・ナラティブ引き出し・ソクラテス式質問の 8 技法を統合 |
| `m4l-project` | Max for Live デバイス、`.maxpat` / `.amxd`、Max JS、MIDI/Audio I/O、Presentation UI、Ableton User Library インストール、リリース梱包を追加・変更する時 |

# 署名規約（Issue / PR / コメント）

GitHub Issue 本体・Issue コメント・PR 本文・PR コメントを書く / 更新するとき（`gh issue create` / `gh pr create` / `gh issue comment` / `gh pr comment` 等の全経路を含む）は、本セクションを常時適用する。

1. MUST: 本文の先頭行に、書き手であるエージェント自身の署名を `✳︎ <会社名> <モデル名> <バージョン>` 形式で入れる
2. MUST: 署名行の次に空行を 1 行入れ、その後に本文を続ける
3. MUST: モデル名がバージョン番号を含む場合（例: `GPT-5.5`）は `<バージョン>` 部分を省略する
4. MUST: 署名は U+2733 EIGHT SPOKED ASTERISK (`✳︎`) で始める
5. NEVER: 署名を本文の途中・末尾に置かない
6. NEVER: 署名行と本文の間の空行を省略しない
7. NEVER: 署名行に日時、ID、装飾文字、その他追加情報を含めない

形式:

```
✳︎ <会社名> <モデル名> <バージョン>

<本文>
```

主なエージェントの署名（参考）:

| エージェント | 署名 |
| --- | --- |
| Anthropic Claude Opus 4.8 | `✳︎ Anthropic Claude Opus 4.8` |
| Anthropic Claude Opus 4.7 | `✳︎ Anthropic Claude Opus 4.7` |
| Anthropic Claude Sonnet 4.6 | `✳︎ Anthropic Claude Sonnet 4.6` |
| Anthropic Claude Haiku 4.5 | `✳︎ Anthropic Claude Haiku 4.5` |
| Anthropic Claude Fable 5 | `✳︎ Anthropic Claude Fable 5` |
| OpenAI GPT-5.5 | `✳︎ OpenAI GPT-5.5` |
| OpenAI GPT-5.2-Codex | `✳︎ OpenAI GPT-5.2-Codex` |
| SpaceX Composer 2.5 | `✳︎ SpaceX Composer 2.5` |

# スキル運用

本リポジトリ内でスキルを追加・改変・選定する際は、以下のメタスキルに従う:

- `refresh-skills`: スキル追加・削除・リネーム時の正本・シンボリックリンク・スキル表の突き合わせ。本リポジトリではスキルを削除・リネームせず、統合先への案内に置き換える
- `skill-selection`: ホームに導入するスキルの選び方
- `skill-escalation`: スキルの改良提案を本リポジトリへ Issue として起票
- `github`: Git / GitHub 操作の規約と、パッチ以外の実装作業の Issue / PR フロー
