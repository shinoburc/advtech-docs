---
sidebar_position: 0
---

# 読み出し(Read)

User テーブルに対して Read を行う機能を実装します。

## サーバサイド

### API

User テーブル全件を取得するための API を実装します。

URL は `/api/user` とします。
HTTP メソッドは `GET` とします。

```ts title="pages/api/user/index.ts"
import type { NextApiRequest, NextApiResponse } from "next";

import { User } from "@prisma/client";
import { prisma } from "@/utils/prismaSingleton";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "GET") {
    return handleGet(req, res);
  } else {
    return res.status(500).end();
  }
}

const handleGet = async (req: NextApiRequest, res: NextApiResponse<User[]>) => {
  const users = await prisma.user.findMany({
    include: {
      role: true,
      department: true,
    },
  });
  res.status(200).json(users);
};
```

参考リンク
- [findMany - prisma](https://www.prisma.io/docs/reference/api-reference/prisma-client-reference#findmany)
- [include - prisma](https://www.prisma.io/docs/reference/api-reference/prisma-client-reference#include)
- [API Routes - Next.js](https://nextjs.org/docs/api-routes/introduction)
    - [API ルート - Next.js](https://nextjs-ja-translation-docs.vercel.app/docs/api-routes/introduction)
- [API Routes Request Helpers(req: NextApiRequest)](https://nextjs.org/docs/api-routes/request-helpers)
- [API Routes Response Helpers(res: NextApiResponse)](https://nextjs.org/docs/api-routes/response-helpers)

この状態で [http://localhost:3000/api/user](http://localhost:3000/api/user) にアクセスすると、User テーブル全件が JSON で取得できます。

## クライアントサイド

### SWR


サーバサイドで作成した `/api/user` API を利用してデータを取得し、ユーザ一覧画面を作成します。

TypeScript には組み込みの `fetch` 関数が用意されており、`fetch` 関数を使用すれば HTTP リクエスト・レスポンスを扱うことができます。
ここでは、データの取得をより便利にしてくれるライブラリ SWR を利用します。

[SWR](https://swr.vercel.app/ja/docs/with-nextjs)

本設定では SWR は内部的に `fetch` 関数を使用しますが、加えて以下の機能を提供します。

- データの再フェッチ: 自動的にデータを再フェッチします。これにより、データに変更があっても自動的に変更後のデータが表示されるようになります。
- データのキャッシュ: 一度取得したデータはキャッシュされ、2度目からは高速にデータが表示されます。

ここからプロジェクトに SWR を組み込み「ユーザ一覧画面」を作成します。

以下で swr パッケージをインストールしてください。

```shell
npm install --save swr
```

swr に fetch 関数を渡す処理が度々でてくるため、`fetcher` という変数を用意し、使いまわすこととします。` utils/fetcher.ts` を以下のように作成してください。

```ts title="utils/fetcher.ts"
export const fetcher = (url: string) => fetch(url).then((res) => res.json());
```

### ユーザ一覧画面の実装

`/api/user` API から swr でデータを取得し、ユーザ一覧を表示する画面を作成します。

`pages/user/index.tsx` を以下のように実装してください。

今後「ユーザの作成」「ユーザの更新」「ユーザの削除」を行うためのリンクも以下に実装しています。

```tsx title="pages/user/index.tsx"
import type { NextPage } from "next";
import Link from "next/link";
import React from "react";

import Button from "@mui/material/Button";

import useSWR, { mutate } from "swr";
import { Prisma } from "@prisma/client";

/* ライブラリ Material-UI が提供するコンポーネントの import */
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";

/* icons */
import PersonAddIcon from "@mui/icons-material/PersonAdd";

import { fetcher } from "@/utils/fetcher";

const UserList: NextPage = () => {
  /* User の外部キー(role, department)も含んだ型を定義している */
  type UserPayload = Prisma.UserGetPayload<{
    include: {
      role: true;
      department: true;
    };
  }>;
  /* SWR を使用して /api/user からデータを取得し、 users 配列で受け取る */
  const { data: users, error } = useSWR<UserPayload[]>("/api/user", fetcher);

  const onDelete = async (id: string) => {
    const response = await fetch(`/api/user/${id}`, {
      method: "DELETE",
    });
    // mutate を使用して swr がユーザ一覧データを再取得するようにする。つまりユーザ一覧の更新。
    mutate("/api/user");
  };

  if (error) return <div>An error has occurred.</div>;
  if (!users) return <div>Loading...</div>;

  return (
    <>
      <Link href="/user/create" passHref>
        <Button variant="contained" color="primary">
          <PersonAddIcon /> Create User
        </Button>
      </Link>
      <div>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>id</TableCell>
              <TableCell>name</TableCell>
              <TableCell>email</TableCell>
              <TableCell>role</TableCell>
              <TableCell>department</TableCell>
              <TableCell></TableCell>
              <TableCell></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {/* users 全件をテーブル出力する */}
            {users?.map((user: UserPayload) => {
              return (
                /* 一覧系の更新箇所を特定するために一意となる key を設定する必要がある */
                <TableRow key={user.id}>
                  <TableCell>{user.id}</TableCell>
                  <TableCell>{user.name}</TableCell>
                  <TableCell>{user.email}</TableCell>
                  <TableCell>{user.role.name}</TableCell>
                  <TableCell>{user.department.name}</TableCell>
                  <TableCell>
                    <Link href={`/user/edit/${user.id}`} passHref>
                      <Button variant="contained" color="primary">
                        Edit
                      </Button>
                    </Link>
                  </TableCell>
                  <TableCell>
                    <Button
                      onClick={() => onDelete(user.id)}
                      variant="contained"
                      color="warning"
                    >
                      Delete
                    </Button>
                  </TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </div>
    </>
  );
};

export default UserList;

```

この状態で [http://localhost:3000/user](http://localhost:3000/user) にアクセスすると、User 一覧が表示されます。