---
name: e2etest
description: E2E テストを作成・実行する。e2e（https://e2e.com/）で書き、API と CLI は e2e スキルに従う。テストを書く条件と書かない条件、e2e init のフラグ、agent.act と locator の使い分け、リプレイキャッシュのコミット、秘密情報、sleep の禁止と明示的な待機条件。ユーザー向け主要フローの追加、重要な UI 変更、既存フローの成功条件を変えたときに使う。
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

- `--gateway` は、モデルの費用を誰が払うかをユーザーに確かめてから決める。agent.act を使わないなら `none`。
- CI で動かすなら `--ci github-actions` を足す。生成された workflow の鍵の名前と、アプリの URL を確かめる。
- CLAUDE.md や `.mcp.json`、`.cursor/mcp.json`、`.codex/config.toml` ができていたら消す。
- `.gitignore` に足された `.e2e/cache/` の行を消す。理由はリプレイキャッシュの項にある。
- 生成された `e2e.config.ts` と `tests/` にはコメントが入っている。コメントを禁じる lint があるリポジトリでは消す。
- `tsconfig.json` の `include` が `tests/` を含まなければ足す。
- `vp run verify` のような検査を通す。fallow が `tests/` や e2e の依存を未使用と判定したら、`.fallowrc.jsonc` の `entryPoints` に足す。無視の指示で黙らせない。

## agent.act と locator の使い分け

- 主要フローの成功条件は、locator と `expect` で決定的に確かめる。値、件数、状態、決まった文言がこれにあたる。
- 操作の道筋が UI の変更で変わりやすいところや、手順を言葉で言えば済むところに `agent.act` を使う。
- `agent.act` を使ったテストは、locator の `expect` か `agent.assert` で終える。検証が通らないと記録が保存されない。
- 一度に一つの目標を書く。画面の文言を使い、値は `params` で渡す。
- 道筋そのものを検査したい操作（空のまま送信する、キーボード操作、サインイン）は locator で書く。

## リプレイキャッシュ

`.e2e/cache/` はコミットする。コミットしないと CI が毎回モデルを呼び、費用がかかり、結果もぶれる。

- 記録を作り直したら、テストのコミットと一緒に `.e2e/cache/` もコミットする。テスト名、`describe` 名、ファイルの場所、指示文、`params` を変えると記録が使えなくなる。
- CI では `--strict-cache` を付けて実行する。記録が古ければ、モデルを呼ばずに失敗する。手元で記録し直してコミットする。
- `agent.assert`、`agent.waitFor`、`agent.extract` は記録されず、CI でもモデルを呼ぶ。CI に鍵が要るかは、これらを使うかで決まる。
- 記録には、`Secret` で渡したもの以外の入力値がそのまま残る。PR で `.e2e/cache/` の差分も読み、個人情報や本番のデータが入っていないか確かめる。

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
- `.e2e/cache/` の差分をコミットしたか。差分に個人情報や本番のデータがないか。
- 秘密情報がテストコードにないか。
- `sleep` が残っていないか。待機が明示的な条件になっているか。
- テストが CI で通るか。ローカルでしか通らない前提を持ち込んでいないか。
