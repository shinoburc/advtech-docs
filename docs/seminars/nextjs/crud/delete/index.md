---
sidebar_position: 4
---

# 削除(Delete)

User テーブルに対して Delete を行う機能を実装します。

## ユーザ削除APIの実装

`app/api/user/[id]/route.ts` を以下のように変更してください。
(DELETE 関数を追加しています。)

```ts title="app/api/user/[id]/route.ts"
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

import { User } from '@prisma/client';
import { UserRepository } from '@/app/_repositories/User';

export async function PUT(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const user: User = await request.json();
    const updatedUser = await UserRepository.update(params.id, user);
    return NextResponse.json(updatedUser);
  } catch (e) {
    //return NextResponse.next({ status: 500 });
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

// highlight-start
export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const deletedUser = await UserRepository.remove(params.id);
    return NextResponse.json(deletedUser);
  } catch (e) {
    //return NextResponse.next({ status: 500 });
    console.log(e);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
// highlight-end
```

参考リンク
- [delete - prisma](https://www.prisma.io/docs/reference/api-reference/prisma-client-reference#delete)

### pageコンポーネント(page.tsx)の実装

ユーザ削除画面はユーザ一覧画面に「DELETE」ボタンとして既に実装済みです。

「DELETE」ボタンで実際にユーザが削除されることを確認してください。
