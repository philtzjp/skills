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

各プロジェクトで本リポジトリのスキルを採用する場合は、`.agents/skills/<name>/SKILL.md` を取り込み、`.claude/skills/<name>` から `../../.agents/skills/<name>` への相対シンボリックリンクで参照する構造を作ってください。導入手順とスキル選定の詳細は `.agents/skills/skill-selection/SKILL.md` と `.agents/skills/refresh-skills/SKILL.md` を参照してください。

`AGENTS.md` は Codex CLI / GitHub Copilot / Cursor などが、`CLAUDE.md` は Claude Code がプロジェクトのコンテキストとして読み込む設定ファイルです。本リポジトリでは `CLAUDE.md` を `AGENTS.md` への symlink としています。

## License

[MIT](./LICENSE)

## Connect with Us

私たちの活動に関するより詳しい情報は、公式サイトをご覧ください。

- **Official Website:** https://philtz.com
