---
sidebar_position: 0
---

# リポジトリパターンの適用

`app/_repositories` ディレクトリを作成し、データベースにアクセスするような機能は全てその中に実装することとします。

これは「リポジトリパターン」と呼ばれる設計パターンで、データベースに関する処理を「永続化レイヤー」にまとめておくことで、
例えば「データベースを PostgreSQL から Oracle に変更したい」だとか「サーバロジックとAPI両方からデータベースにアクセスしたい」といった場合に、
データベースアクセスの処理が一元化されているため保守しやすくなります。

ここでは User テーブルに対する リポジトリパターンの実装を行います。

## User リポジトリの作成

User テーブルに対する処理を `app/_repositories/User.ts` に集約します。

今後、User テーブルに対するデータアクセスの処理が追加になった場合 `User.ts` に処理(関数)を追加してください。

```ts title="app/_repositories/User.ts"
import { prisma } from '@/app/_utils/prismaSingleton';
import { User } from '@prisma/client';

export namespace UserRepository {
  export async function findMany() {
    return await prisma.user.findMany({
      include: {
        role: true,
        department: true,
      },
    });
  }

  export async function findUnique(id: string) {
    return await prisma.user.findUnique({
      where: {
        id: id,
      },
    });
  }

  export async function create(user: User) {
    return await prisma.user.create({
      data: user,
    });
  }

  export async function update(id: string, user: User) {
    return await prisma.user.update({
      where: {
        id: id,
      },
      data: {
        ...user,
      },
    });
  }

  export async function remove(id: string) {
    return await prisma.user.delete({
      where: {
        id: id,
      },
    });
  }
}
```

## Role リポジトリの作成

Role テーブルに対する処理を `app/_repositories/Role.ts` に集約します。

```ts title="app/_repositories/Role.ts"
import { prisma } from '@/app/_utils/prismaSingleton';
import { Role } from '@prisma/client';

export namespace RoleRepository {
  export async function findMany() {
    const users = await prisma.role.findMany();
    return users;
  }

  export async function create(role: Role) {
    const createdRole = await prisma.role.create({
      data: role,
    });
    return createdRole;
  }
}
```

## Department リポジトリの作成

Department テーブルに対する処理を `app/_repositories/Department.ts` に集約します。

```ts title="app/_repositories/Department.ts"
import { prisma } from '@/app/_utils/prismaSingleton';
import { Department } from '@prisma/client';

export namespace DepartmentRepository {
  export async function findMany() {
    const users = await prisma.department.findMany();
    return users;
  }

  export async function create(department: Department) {
    const createdDepartment = await prisma.department.create({
      data: department,
    });
    return createdDepartment;
  }
}
```

## ThanksCard リポジトリの作成

ThanksCard テーブルに対する処理を `app/_repositories/ThanksCard.ts` に集約します。

```ts title="app/_repositories/ThanksCard.ts"
import { prisma } from '@/app/_utils/prismaSingleton';
import { Prisma } from '@prisma/client';

// ThanksCardRepository.findMany(ThanksCardとUser(from, to)をjoinした結果) が返すリストの型から
// Promise を取り省いた型を export する
export type ThanksCardWithFromToList = Prisma.PromiseReturnType<
  typeof ThanksCardRepository.findMany
>;

export namespace ThanksCardRepository {
  export async function findMany() {
    return await prisma.thanksCard.findMany({
      include: {
        from: true,
        to: true,
      },
    });
  }

  export async function findUnique(id: string) {
    return await prisma.thanksCard.findUnique({
      include: {
        from: true,
        to: true,
      },
      where: {
        id: id,
      },
    });
  }
}
```
