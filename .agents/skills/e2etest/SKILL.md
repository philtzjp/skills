---
name: e2etest
description: Web と iOS・Android の E2E テストを作成・実行する。e2e（https://e2e.com/）で書き、API と CLI は e2e スキルに従う。テストを書く条件と書かない条件、e2e init のフラグ、手元で実行して CI は記録の再生だけにする分担、Filters API でのテストの絞り込み、agent.act と locator の使い分け、リプレイキャッシュのコミット、秘密情報、sleep の禁止と明示的な待機条件。ユーザー向け主要フローの追加、重要な UI 変更、既存フローの成功条件を変えたときに使う。
---

# e2etest

E2E テストは e2e で書く。このスキルには Philtz の方針だけを書く。fixture、locator、`agent.*`、設定、CLI の使い方は e2e スキルに書いてある。

## 書くかどうか

次のいずれかに当てはまるなら、E2E テストを作成して実行する。

- 新しいユーザー向けの主要フローを追加した。
- 重要な UI を変更した。
- 既存フローの成功条件を変更した。

次には作らない。

- 純粋なバックエンドや API だけの変更。
- ドキュメントだけの変更。
- 設定や依存関係の更新。
- 動作が変わらないリファクタリング。

既存の管理画面に小さな設定項目を足しただけで、主要フローの成功条件が変わらないなら、動いているアプリで手で確かめる。リスクがある場合だけテストを作る。

## e2e スキルを一緒に入れる

e2e スキルは、npm の e2e パッケージに同梱されたスキルを philtzjp/skills に写したもの。e2e は更新が速いので、API の形を記憶で書かず、e2e スキルを読む。

- e2etest を入れるときは、`-s e2etest -s e2e` と 2 つ足す。
- e2e スキルの `VERSION` と、リポジトリに入っている e2e の版が違うときは、`pnpm exec e2e guide <topic>` が出す入っている版の説明を優先する。
- e2e スキルの手順のうち、MCP の登録と `.e2e/cache/` を無視する既定は、このスキルの方針に従う。

## ランナー

- E2E テストは e2e だけで書く。Playwright Test、Cypress、agent-browser など、別のランナーを新しく足さない。
- キャンバス、細かいマウス操作、ネットワーク傍受、複数ページのように Playwright の API が要る操作は、`@e2e-dev/web` の `browser` fixture で書く。
- 別のランナーのテストがすでにあるリポジトリでは、ユーザーの合意なしに書き換えない。移行するなら Issue にする。

## 導入

e2e のないリポジトリに入れるのは、ユーザーの許可を得てから。`e2e init` は既定で CLAUDE.md、上流のスキル、MCP サーバーの設定を作る。Philtz では CLAUDE.md を作らず、スキルは philtzjp/skills から入れ、MCP サーバーはリポジトリに登録しない。フラグで止める。

```sh
DISABLE_TELEMETRY=1 vp dlx e2e init --yes --skills none --mcp none --gateway <gateway> --install
```

- `--gateway` は、手元で使うサブスクに合わせて決める（`chatgpt`、`copilot` など）。agent.act を使わないなら `none`。
- CI で動かすなら `--ci github-actions` を足し、生成された workflow を「GitHub Actions」の項のとおりに直す。
- CLAUDE.md や `.mcp.json`、`.cursor/mcp.json`、`.codex/config.toml` ができていたら消す。
- `.gitignore` に足された `.e2e/cache/` の行を消す。理由はリプレイキャッシュの項にある。
- 生成された `e2e.config.ts` と `tests/` にはコメントが入っている。コメントを禁じる lint があるリポジトリでは消す。
- `tsconfig.json` の `include` が `tests/` を含まなければ足す。
- `vp run verify` のような検査を通す。fallow が `tests/` や e2e の依存を未使用と判定したら、`.fallowrc.jsonc` の `entryPoints` に足す。無視の指示で黙らせない。

## モバイル

iOS と Android のアプリも、同じ規約で e2e で書く。エンジンは `@e2e-dev/mobile`。シミュレータ、エミュレータ、端末の準備は e2e スキルの `setup` を読み、`pnpm exec e2e doctor` で確かめる。モバイルのテストは手元でだけ実行する。

## agent.act と locator の使い分け

- 主要フローの成功条件は、locator と `expect` で決定的に確かめる。値、件数、状態、決まった文言がこれにあたる。
- 操作の道筋が UI の変更で変わりやすいところや、手順を言葉で言えば済むところに `agent.act` を使う。
- `agent.act` を使ったテストは、locator の `expect` か `agent.assert` で終える。検証が通らないと記録が保存されない。
- 一度に一つの目標を書く。画面の文言を使い、値は `params` で渡す。
- 道筋そのものを検査したい操作（空のまま送信する、キーボード操作、サインイン）は locator で書く。

## 手元と CI の分担

GitHub Actions でモデルを呼んだり、macOS のランナーを使ったりすると高くつく。モデルを呼ぶ実行は手元で、各自の AI のサブスクで済ませる。CI は、手元で作った記録を再生して確かめるだけにする。

| | 手元 | GitHub Actions |
| --- | --- | --- |
| いつ | PR を Ready for review にする前と、push する前 | Draft でない PR に push したとき |
| 何を | 変更が影響するテスト。リリースの前は全部 | Web のテストのうち、`local` タグのないもの |
| モデル | 各自のサブスク | `agent.act` は呼ばない。テストを絞るフィルターだけ呼ぶ |
| 記録 | 作り直してコミットする | 再生だけ。古ければ失敗する |

### 手元

```sh
pnpm exec e2e run --changed-since origin/main
```

- サブスクでログインしておく。`pnpm exec e2e login openai`（ChatGPT）、`pnpm exec e2e login github-copilot`、Claude Code のログイン（`@e2e-dev/acp`）などがある。Claude Max と Team は、プランの API クレジットの鍵を使う。使えるモデルは `pnpm exec e2e models` で確かめる。
- `--changed-since` は、`e2e.config.ts` の `filters` に置いた `decisionFilter()` で、変更が影響しないテストを外す。まだコミットしていない変更も見る。`e2e.config.ts` か lockfile を変えたときは全部実行する。
- フィルターの decision model には別に鍵が要る（`AI_GATEWAY_API_KEY` で `gateway.decisionModel('typesafe-ai/jev')` など）。鍵がないか、フィルターが失敗したときは、全部実行する。何が外れるかは `pnpm exec e2e list --changed-since origin/main` で確かめる。
- 記録が作り直されたら、`.e2e/cache/` をテストと一緒にコミットする。
- モバイルのテストと、`local` タグのテストも、ここで実行する。
- 実行したコマンドと結果を、PR 本文の作業範囲に書く。
- リリースの前は、`--changed-since` を付けずに全部実行する。

### リプレイキャッシュ

`.e2e/cache/` はコミットする。CI は記録を再生するので、`agent.act` のためにモデルを呼ばない。

- テスト名、`describe` 名、ファイルの場所、指示文、`params` を変えると記録が使えなくなる。手元で実行し直して記録を作る。
- 記録には、`Secret` で渡したもの以外の入力値がそのまま残る。PR で `.e2e/cache/` の差分も読み、個人情報や本番のデータが入っていないか確かめる。

### local タグ

`agent.assert`、`agent.waitFor`、`agent.extract` は記録されず、実行のたびにモデルを呼ぶ。これらを使うテストには `local` タグを付け、CI から外す。

```ts
test('プランを変えると請求額の説明が変わる', { tags: ['local'] }, async ({ app, agent }) => {
```

CI で動かしたい主要フローは、`agent.act` と locator の `expect` だけで書く。CI は記録を再生するだけで、モデルを呼ばない。

### GitHub Actions

`e2e init --ci github-actions` が作る `.github/workflows/e2e.yml` を、次のように直す。

- `push: branches: [main]` を消す。main には、PR で確かめてベースに追いついた内容だけが squash で入る。
- `pull_request` を `types: [opened, synchronize, reopened, ready_for_review]` にし、web のジョブに `if: ${{ !github.event.pull_request.draft }}` を付ける。
- `actions/checkout` に `with: fetch-depth: 0` を付ける。`--changed-since` がベースとの差分を取るため。
- 実行のステップを次にする。

  ```yaml
  - name: Run e2e
    run: pnpm exec e2e run --strict-cache --exclude-tag local --changed-since origin/${{ github.base_ref }} --reporter list,junit
    env:
      AI_GATEWAY_API_KEY: ${{ secrets.AI_GATEWAY_API_KEY }}
  ```

- `setup-node` の `node-version` を、リポジトリの `engines` に合わせる。
- モバイルのジョブを足さない。
- `pull_request_target` で動かさない。

`--strict-cache` で `REPLAY_STALE` が出たら、手元で実行し直し、`.e2e/cache/` をコミットする。CI に置く鍵はフィルター用の `AI_GATEWAY_API_KEY` だけ。鍵の費用を誰が払うかをユーザーに確かめる。

## 秘密情報

- パスワードや鍵をテストコードに書かない。`e2e.config.ts` の `credentials` と `secrets` に宣言し、`Secret` のまま `fill()` か `params` に渡す。
- 鍵は dotenvx で暗号化した `.env` に置く。e2e は `.env` を読まないので、`dotenvx run -- vp run test:e2e` のように渡す。
- モデルには画面が送られる。テスト用のアカウントとデータを使う。

## 待機

`sleep` や `waitForTimeout` によるタイミング依存のテストを作らない。明示的な待機条件を使う。

- 値が落ち着くのを待つなら、locator の `expect` を使う。`expect` は条件を満たすまで再試行する。
- 要素や URL を待つなら、`locator.waitFor()` や `browser.waitForURL()` を使う。
- 言葉でしか書けない状態を待つなら、`agent.waitFor` を使う。
- 固定の秒数で「だいたい終わっているはず」を前提にしない。CI では遅くなり、ローカルでは速すぎる。

不安定なテストを待ち時間を伸ばして黙らせない。待つべき条件を特定して書き直す。

## 確定前に確認する

- 変更が主要フローや成功条件に触れているか。触れているならテストがあるか。
- e2e のほかに、E2E テストのランナーを足していないか。
- 成功条件を locator と `expect` で確かめているか。`agent.act` のあとに検証があるか。
- 手元で `--changed-since origin/main` を実行し、結果を PR に書いたか。
- `.e2e/cache/` の差分をコミットしたか。差分に個人情報や本番のデータがないか。
- 実行のたびにモデルを呼ぶテストに `local` タグを付けたか。
- 秘密情報がテストコードにないか。
- `sleep` が残っていないか。待機が明示的な条件になっているか。
- CI がモデルを呼ぶのはフィルターだけか。個人のサブスクのログインを CI に持ち込んでいないか。
