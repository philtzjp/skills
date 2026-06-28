---
name: api-design
description: API エンドポイントの設計・実装・変更を行うとき（OpenAPI スキーマ、ヘルスチェック、ルーティング、認証方式の追加など）に参照する。OpenAPI 準拠、RFC 9457 エラー、パスバージョニング、認証（ネットワーク公開 API は Bearer、loopback サービスは Origin 検証で代替可）、Spectral リント、単一 HTTP フレームワーク（Hono / Nitro 等から選定）への統一を定義する。
---

# API 設計
1. MUST: OpenAPI に準拠する
2. MUST: エラーレスポンスの構造を RFC 9457 に準拠させる
3. MUST: URL パスバージョニングを使用する（例: `/api/v1/`）
4. SHOULD: パスはできる限り短くする; IF: やむを得ない場合; THEN MUST: `kebab-case` を使用する
5. MUST: 単数形の名詞を使用する（`/users` ではなく `/user`）
6. MUST: ネットワークに公開される API は Bearer 認証を使用する; IF: loopback（127.0.0.1）にのみバインドするローカルサービス; THEN MAY: Bearer 認証に代えて Origin / Host ヘッダ検証で保護する（DNS リバインディング対策）
7. MUST: ヘルスチェックエンドポイントの構造を [draft-inadarei-api-health-check](https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check) に準拠させる
8. MUST: [Spectral](https://github.com/stoplightio/spectral) を使用して API をリントする
9. MUST: プロジェクト内では単一の HTTP フレームワーク / サーバー層に統一する; NEVER: 同一プロジェクトに複数の HTTP フレームワークを混在させない; SHOULD: 推奨例として [Hono](https://hono.dev/) / Nitro(h3) 等から選定する; IF: MCP サーバーを構築; THEN MUST: 採用フレームワークに対応する MCP アダプタを使用する（例: Hono なら `@hono/mcp`）
