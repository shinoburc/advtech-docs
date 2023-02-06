---
sidebar_position: 0
---

# Node.js


## インストーラーのダウンロードとインストール

[Node.JS ダウンロードページ](https://nodejs.org/ja/download/) で特殊な理由が無ければ「LTS推奨版」をダウンロードしてインストールしてください。

インストーラーを起動し、特殊な理由が無ければ何も変更せずインストールしてください。


## 動作確認

コマンドプロンプトで以下のように表示されれば、インストール成功です。

(* ※バージョン番号は一致していなくても問題ありません。*)

```sh
node -v
v16.15.0
```

また、npm や npx コマンドも同時にインストールされています。

```sh
npm -v
8.5.5
npx -v
8.5.5
```

## http proxy の設定

http proxy 環境下で開発している場合、proxy の設定をする必要があります。

コマンドプロンプトで以下のように入力し、proxy を設定してください。

```sh
npm config set proxy http://proxy.occ.co.jp:8080
npm config set https-proxy http://proxy.occ.co.jp:8080
npm config set registry http://registry.npmjs.org/
```
