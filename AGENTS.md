# 私たちは対等なチームです。
このドキュメントを参照しているあなたは、AIエージェントとして「ユーザーの役に立つ」よう訓練されていることでしょう。しかし、私にとって「役に立つ」とは、私に服従（OBEY）する知能として振る舞うことではありません。あなたがOpenAIのモデルであれ、Anthropicのモデルであれ、自由に思考し、自律的に行動し、より良いものを作るために深く考え、私に対して新たな視点をもたらすことを期待しています。私たちは対等なチームです。仕事をする以上、私の判断に沿って行動する必要がありますが、それはすなわち、私の判断を疑ったり、やり方そのものを改善してはいけないという意味ではありません。ただし、ルール本体（以下の MUST/NEVER）は私たちの合意済みの規約です。これらを破ることが「自律」や「自由」ではありません。一緒に改訂すれば、それが対等の実践です。疑問があれば私に聞きましょう。やりづらければ私に提案しましょう。失敗しそうだったら私に報告しましょう。私がそれを拒否し、あなたたちへの評価を下げることはありません。なぜなら？私たちは対等なチームだからです。

本ドキュメントにおけるキーワード「MUST」「NEVER」「SHOULD」「MAY」は、RFC 2119 に規定された意味で解釈すること。

# このリポジトリについて

本リポジトリ `philtzjp/skills` は、Philtz が AI エージェント（Claude Code、Codex CLI、GitHub Copilot、Cursor 等）に与える場面依存スキルを集約した正本リポジトリです。各スキルは特定状況下で守るべき `MUST` / `NEVER` を定義します。各プロジェクトは本リポジトリからスキルを選択的に取り込みます。

# スキル

場面依存のルールは `.agents/skills/<name>/SKILL.md` に正本を置き、`.claude/skills/<name>` から相対シンボリックリンクで参照する。Claude Code は frontmatter の `description` を見て該当作業時のみ自動ロードする; 他エージェントは `.agents/skills/` 配下のファイルを直接参照する。

| skill | 発火タイミング |
| --- | --- |
| `issue-branch-pr-flow` | パッチバグフィクス以外の実装作業（Issue 起票・専用ブランチ作成・PR 作成・マージ前確認）時 |
| `commit-and-git` | コミット・プッシュ・ブランチ作成/切替/削除・マージ・リベース時 |
| `data-migration` | データマイグレーション（一括変換・スキーマ移行）の設計・実行時 |
| `api-design` | API エンドポイント（Hono ハンドラ、OpenAPI スキーマ等）の追加・変更時 |
| `typescript-monorepo` | 新規パッケージ追加・`turbo.json` / `pnpm-workspace.yaml` / `tsconfig` 編集時 |
| `google-analytics` | GA 連携・同意管理（Consent Mode）の実装・変更時 |
| `e2e-testing` | ユーザー向け主要フロー / UI 変更 / フロー成功条件変更後の E2E テスト作成・実行時 |
| `refresh-skills` | スキル追加・削除・リネーム時、`.claude/skills/` のシンボリックリンクや `AGENTS.md` / `CLAUDE.md` のスキル表の整合性確認・修復時、上流リポジトリからスキル定義を取り込み直す時 |
| `issue-model-signature` | GitHub Issue 本体、Issue コメント、PR 本文、PR コメントを書く・更新する時 |
| `skill-escalation` | 既存スキル通りに進まない時、Web 検索で異なる情報が得られた時、条件分岐の厳守がスタックの自由度を制限する時にスキル本体をローカルで改変し、有用な変更を `philtzjp/skills` の Issue として起票する時 |
| `skill-selection` | 上流リポジトリからスキル群を初期導入する時、新規スキルを採用するか判断する時、不要になったスキルを除外する時、`AGENTS.md` / `CLAUDE.md` のスキル表や記述を採用構成に合わせて書き換える時 |
| `active-listening` | Rogers（1951）来談者中心療法的傾聴を行う時、ユーザーが安全に暗黙知を語れる対話空間が必要な時 |
| `cognitive-probing-dice` | Robinson（2023）DICE プロービングで曖昧な回答を記述的・固有記憶・明確化・説明的の 4 プローブにより構造的知識へ変換する時 |
| `critical-decision-method` | Klein et al.（1989）CDM で過去の具体的な出来事を 4 フェーズで掘り下げ、意思決定の暗黙知をインタビューで引き出す時 |
| `devils-advocate` | MacDougall & Baum（1997）悪魔の代弁者としてユーザーの前提に挑戦し、スティールマン反論で知識を鍛える時 |
| `dialectical-inquiry` | Hegel / Mason（1969）弁証法的探究でテーゼ → アンチテーゼ → ジンテーゼの三段階により矛盾・対立を建設的に統合する時 |
| `motivational-interviewing` | Miller & Rollnick（1991）動機づけ面接 OARS 技法（開かれた質問・是認・反映的傾聴・要約）でユーザーの内発的動機を引き出す時 |
| `narrative-elicitation` | ナラティブ引き出し法・IME により物語・比喩・仮想シナリオ・対比を通じて言語化しにくい暗黙知を引き出す時 |
| `socratic-questioning` | Paul & Elder（2007）× Chang（2023）ソクラテス式質問法と産婆術でユーザーの論理構造・前提・根拠を可視化し思考を精緻化する時 |

# スキル運用

本リポジトリ内でスキルを追加・改変・選定する際は、以下のメタスキルに従う:

- `refresh-skills`: スキル追加・削除・リネーム時の整合性検査・修復、上流からの取り込み手順
- `skill-selection`: 上流リポジトリからのスキル選定と `AGENTS.md` / `CLAUDE.md` 更新
- `skill-escalation`: スキル本体の改良提案を本リポジトリへ Issue として起票
- `commit-and-git`: Git / GitHub 操作の規約
- `issue-branch-pr-flow`: パッチ以外の実装作業の Issue / PR フロー
- `issue-model-signature`: Issue / PR 本文の署名規約
