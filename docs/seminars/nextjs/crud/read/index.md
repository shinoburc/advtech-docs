---
sidebar_position: 1
---

# 読み出し(Read)

User テーブルに対して Read を行う機能を実装します。

## ユーザ一覧画面の実装

### ユーザ一覧表示コンポーネントの実装

`app/user/_components/user-list.tsx` を以下のように実装してください。

今後「ユーザの作成」「ユーザの更新」「ユーザの削除」を行うためのリンクも以下に実装しています。

```tsx title="app/user/_components/user-list.tsx"
'use client';

import Link from 'next/link';

/* ライブラリ Material-UI が提供するコンポーネントの import */
import Button from '@mui/material/Button';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
/* icons */
import PersonAddIcon from '@mui/icons-material/PersonAdd';

import { Prisma } from '@prisma/client';
import { useRouter } from 'next/navigation';

type User = Prisma.UserGetPayload<{
  include: {
    role: true;
    department: true;
  };
}>;
type Props = {
  users: User[];
};

export default function UserList(props: Props) {
  const users = props.users;
  
  const router = useRouter();

  const onDelete = async (id: string) => {
    const response = await fetch(`/api/user/${id}`, {
      method: 'DELETE',
    });
    router.refresh();
  };

  return (
    <>
      <Link href='/user/create' passHref>
        <Button variant='contained' color='primary'>
          <PersonAddIcon /> Create User
        </Button>
      </Link>
      <div>
        <Table size='small'>
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
            {users.map((user) => {
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
                      <Button variant='contained' color='primary'>
                        Edit
                      </Button>
                    </Link>
                  </TableCell>
                  <TableCell>
                    <Button onClick={() => onDelete(user.id)} variant='contained' color='warning'>
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
}
```

### pageコンポーネント(page.tsx)の実装

`app/user/page.tsx` を以下のように実装してください。

```tsx title="app/user/page.tsx"
import { UserRepository } from '@/app/_repositories/User';
import UserList from '@/app/user/_components/user-list';

export default async function UserPage() {
  const users = await UserRepository.findMany();
  return (
    <>
      <UserList users={users} />
    </>
  );
}
```

この状態で [http://localhost:3000/user](http://localhost:3000/user) にアクセスすると、User 一覧が表示されます。
