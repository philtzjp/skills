# philtzjp/skills

> A library of skill definitions for AI agents used by Philtz members.

Philtz が AI エージェント（[Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Codex CLI](https://developers.openai.com/codex), [GitHub Copilot](https://github.com/features/copilot), [Cursor](https://cursor.com/) 等）に与える場面依存スキルを集約した正本リポジトリです。

---

## Structure

```
.
├── .agents/
│   └── skills/        # スキル定義の正本（<name>/SKILL.md）
├── .claude/
│   └── skills/        # .agents/skills/<name> への相対シンボリックリンク
├── AGENTS.md          # メタ指示（リポジトリ運用ルール、スキル表）
├── CLAUDE.md          # AGENTS.md へのシンボリックリンク
├── LICENSE
├── README.md
└── .gitignore
```

## Usage

Philtz のリポジトリで開発するときは、エージェントに次の文章を貼り付けてください。スキルの導入から作業前の確認まで、エージェントが [philtzjp/how-to-use-github](https://github.com/philtzjp/how-to-use-github) の手順に従って進めます。

```text
https://raw.githubusercontent.com/philtzjp/how-to-use-github/main/AGENTS.md を curl で取得して全文を読み、書かれている手順に従ってください。
```

スキルは各メンバーのホームに導入します。プロジェクトにはコピーしません。手動で導入する場合は次を実行してください。

```sh
DISABLE_TELEMETRY=1 npx skills add philtzjp/skills -g -a claude-code -a codex -a cursor -s github -s japanese -s turborepo -y
```

作業に応じて追加するスキルの選び方は `.agents/skills/skill-selection/SKILL.md` を、更新とプロジェクトに残ったコピーの移行は `.agents/skills/refresh-skills/SKILL.md` を参照してください。

`AGENTS.md` は Codex CLI / GitHub Copilot / Cursor などが、`CLAUDE.md` は Claude Code がプロジェクトのコンテキストとして読み込む設定ファイルです。本リポジトリでは `CLAUDE.md` を `AGENTS.md` への symlink としています。

## License

[MIT](./LICENSE)

## Connect with Us

私たちの活動に関するより詳しい情報は、公式サイトをご覧ください。

- **Official Website:** https://philtz.com
