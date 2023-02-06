---
sidebar_position: 3
---

# 削除(Delete)

User テーブルに対して Delete を行う機能を実装します。

## サーバサイド

### API

User テーブルの既存のレコードを1件削除する API を実装します。

URL は `/api/user/[id]` とします。
HTTP メソッドは `DELETE` とします。

`[id]` は削除するユーザの id です。

参考リンク
- [Dynamic API Routes - Next.js](https://nextjs.org/docs/api-routes/dynamic-api-routes)
  - [動的APIルーティング - Next.js](https://nextjs-ja-translation-docs.vercel.app/docs/api-routes/dynamic-api-routes)

(idを含んだ URL の具体例)
- `/api/user/cl7ts8yvu0045ssa2e2vcrezk`
- `/api/user/cl7ts8yw20054ssa2hxj5ii9h`

これから実装する API のプログラムの中で、URL から id を取得し、データベースに Delete 文を実行する際の条件に加えます。

`pages/api/user/[id].ts` を以下のように変更してください。
(主に handleDelete 関数を追加しています。)

```ts title="pages/api/user/[id].ts"
import type { NextApiRequest, NextApiResponse } from "next";
import { Prisma, User } from "@prisma/client";
import { prisma } from "@/utils/prismaSingleton";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "GET") {
    return handleGet(req, res);
  } else if (req.method === "PUT") {
    return handlePut(req, res);
  // highlight-start
  } else if (req.method === "DELETE") {
    return handleDelete(req, res);
  } else {
    return res.status(500).end();
  }
  // highlight-end
}

const handleGet = async (req: NextApiRequest, res: NextApiResponse<User>) => {
  const id = req.query.id as string;
  const targetUser = await prisma.user.findUnique({
    where: {
      id: id,
    },
  });
  if (targetUser) {
    res.status(200).json(targetUser);
  } else {
    res.status(404).end();
  }
};

const handlePut = async (req: NextApiRequest, res: NextApiResponse<User>) => {
  const id = req.query.id as string;

  try {
    const updatedUser = await prisma.user.update({
      where: {
        id: id,
      },
      data: {
        ...req.body,
      },
    });
    res.status(200).json(updatedUser);
  } catch (e) {
    //if (e instanceof Prisma.PrismaClientKnownRequestError) {
    res.status(500).end();
  }
};

// highlight-start
const handleDelete = async (
  req: NextApiRequest,
  res: NextApiResponse<User>
) => {
  const id = req.query.id as string;
  const deletedUser = await prisma.user.delete({
    where: {
      id: id,
    },
  });
  res.status(200).json(deletedUser);
};
// highlight-end
```

参考リンク
- [delete - prisma](https://www.prisma.io/docs/reference/api-reference/prisma-client-reference#delete)

## クライアントサイド

### ユーザ更新画面の実装

ユーザ削除画面はユーザ一覧画面に「DELETE」ボタンとして既に実装済みです。

「DELETE」ボタンで実際にユーザが削除されることを確認してください。
