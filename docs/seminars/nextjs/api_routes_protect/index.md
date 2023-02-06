---
sidebar_position: 6
---

# API の保護

`next-auth` を導入した際に `middleware.ts` を実装し、ログイン済みでなければ、全ての画面やAPIにアクセス出来ないように実装しました。

しかし、実際のシステムでは「管理者は実行できるが、一般ユーザは実行できないAPI」のように、よりこまかな設定が必要な場合があります。

また、場合によっては、画面はないけれども API のみを認証機能付きで構築したい場合もあります。その場合は現在の「ログイン画面」に相当するものは実装できず、API そのもので認証を行うこととなります(OAuthなどが API 認証に該当します) 。その場合にも、それぞれの API がアクセス制限を行う必要が出てきます。

API プログラムの中でもアクセス制御を行うためのユーティリティ関数を実装します。

(参考)
- [NextAuth.js - Securing pages and API routes](https://next-auth.js.org/tutorials/securing-pages-and-api-routes)

### ログインチェック関数の実装

ここではログイン済みかどうか(正しいトークン付きでアクセスしてるか)を判定する関数を実装します。

この関数を API プログラムの中で使用することで、API 個別でアクセス制限を行うことができます。

`utils/isValidToken.ts` を作成し、以下のように実装してください。

```ts title=utils/isValidToken.ts
// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest } from "next";
import { getToken } from "next-auth/jwt";

export const isValidToken = async (req: NextApiRequest) => {
  const token = await getToken({ req });
  if (token) {
    // Authorized
    return true;
  } else {
    // Unauthorized
    return false;
  }
};
```

次章で実際に API の保護を実装します。
