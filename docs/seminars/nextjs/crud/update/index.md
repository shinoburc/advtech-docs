---
sidebar_position: 3
---

# 更新(Update)

User テーブルに対して Update を行う機能を実装します。

## ユーザ更新APIの実装

User テーブルの既存のレコードを1件更新する API を実装します。

URL は `/api/user/[id]` とします。
HTTP メソッドは `PUT` とします。

`[id]` は更新するユーザの id です。

参考リンク
- [Dynamic Route Segments - Next.js](https://nextjs.org/docs/app/building-your-application/routing/router-handlers#dynamic-route-segments)

(idを含んだ URL の具体例)
- `/api/user/cl7ts8yvu0045ssa2e2vcrezk`
- `/api/user/cl7ts8yw20054ssa2hxj5ii9h`

これから実装する API のプログラムの中で、URL から id を取得し、データベースに Update 文を実行する際の条件に加えます。

`app/api/user/[id]/route.ts` を作成し、以下のように実装してください。

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
```

参考リンク
- [update - prisma](https://www.prisma.io/docs/reference/api-reference/prisma-client-reference#update)

### ユーザ更新フォーム表示コンポーネントの実装

ユーザ作成の際に作成した `app/user/_components/user-form.tsx` 
はユーザ更新用としても使えるように作成してありますので、追加実装は必要ありません。

### pageコンポーネント(page.tsx)の実装

```tsx title="app/user/edit/[id]/page.tsx"
import UserForm from '@/app/user/_components/user-form';
import { UserRepository } from '@/app/_repositories/User';
import { DepartmentRepository } from '@/app/_repositories/Department';
import { RoleRepository } from '@/app/_repositories/Role';

// Dynamic Segments (/user/edit/[id]) から [id] を取得する
type Props = {
  id: string;
};

export default async function UserEdit({ params }: { params: Props }) {
  const user = await UserRepository.findUnique(params.id);
  const roles = await RoleRepository.findMany();
  const departments = await DepartmentRepository.findMany();

  return <UserForm user={user} departments={departments} roles={roles} onSuccessUrl='/user/' />;
}
```
