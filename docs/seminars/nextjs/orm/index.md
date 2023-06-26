---
sidebar_position: 2
---

# ORM(プログラムとDBの接続)

ORM(Object-Relational Mapping) とはオブジェクト(Object)と関係データベース(RDB)とのマッピング(Mapping)を行うものです。

## npm パッケージのインストール

`create-next-app` で作成したプロジェクトには ORM は組み込まれていません。
next.js で利用できる ORM は複数ありますが、ここでは `prisma` を使用します。

[Prisma](https://www.prisma.io/)

prisma は Node.js で動作する ORM です。
TypeScript で使用しやすいように設計されています。つまり、型安全に利用できる機能が提供されています。

以下のコマンドを実行し `prisma` をインストールしてください。

```shell
npm install --save @prisma/client 
npm install --save-dev prisma ts-node
```

- ts-node: コマンドで TypeScript を実行するためのパッケージ。初期データ投入時に使用。

## prisma の初期化

以下のコマンドを実行することで prsima の設定ファイル(スキーマ設定ファイル) `prisma/schema.prisma` が生成されます。

```shell
npx prisma init 
```

スキーマ設定ファイル `prisma/schema.prisma` には以下ような設定を記述します。

- アクセス先DBの種類やURLの情報
- テーブルと対になる model の情報
    - テーブル間の関係(model 間の関係)も model の情報として記述する

`prisma/schema.prisma` を適切に記述することで、後に行うように「DB、テーブルの自動生成」を行うことができます。

今回は PostgreSQL に接続し Account, User, ThanksCard, Department, Role, Session, VerificationToken という model(テーブル)を設定します。
(Account, User, Session, VerificationToken については、後に認証機能実装時に利用する `next-auth` が推奨している model 構成をほぼそのまま記述しています。)

`prisma/schema.prisma` を以下のように変更してください。

```ts title="prisma/schema.prisma" showLineNumbers
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

//datasource db {
//  provider = "sqlite"
//  url      = "file:./dev.db"
//}


model Account {
  id                 String    @id @default(cuid())
  userId             String
  providerType       String
y  providerId         String
  providerAccountId  String
  refreshToken       String?
  accessToken        String?
  accessTokenExpires DateTime?
  createdAt          DateTime  @default(now())
  updatedAt          DateTime  @updatedAt
  user               User      @relation(fields: [userId], references: [id])

  @@unique([providerId, providerAccountId])
}

model Session {
  id           String   @id @default(cuid())
  userId       String
  expires      DateTime
  sessionToken String   @unique
  accessToken  String   @unique
  createdAt    DateTime @default(now())
  updatedAt    DateTime @updatedAt
  user         User     @relation(fields: [userId], references: [id])
}

model User {
  id            String    @id @default(cuid())
  name          String?
  // next-auth のドキュメントでは email をオプショナルにしているが、必須に変更している
  // name か email どちらかがセットされていれば良い仕様の場合は元に戻す
  // reference: https://next-auth.js.org/adapters/prisma
  email         String   @unique
  emailVerified DateTime?
  image         String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  accounts      Account[]
  sessions      Session[]

  password   String
  roleId    String
  role    Role     @relation(fields: [roleId], references: [id])
  fromThanksCards ThanksCard[] @relation("FromThanksCards")
  toThanksCards ThanksCard[] @relation("ToThanksCards")
  departmentId String
  department Department     @relation(fields: [departmentId], references: [id])
}


model VerificationRequest {
  id         String   @id @default(cuid())
  identifier String
  token      String   @unique
  expires    DateTime
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt

  @@unique([identifier, token])
}

model Role {
  id            String    @id @default(cuid())
  name      String    @unique
  users User[]
}

model ThanksCard {
  id            String    @id @default(cuid())
  title      String
  body      String
  from    User     @relation("FromThanksCards", fields: [fromId], references: [id])
  fromId  String
  to    User     @relation("ToThanksCards", fields: [toId], references: [id])
  toId  String
  createdAt DateTime @default(now())
}

model Department {
  id            String    @id @default(cuid())
  code      Int   @unique
  name      String
  parentId  String?
  parent    Department?     @relation("Parent Children", fields: [parentId], references: [id])
  children Department[]     @relation("Parent Children")
  users User[]
}
```

## .env ファイルに接続先DBのURLを設定

`prisma/schema.prisma` にある `url      = env("DATABASE_URL")` という設定は、DATABASE_URL を環境変数から取得するという意味です。next.jsでは `.env` に環境変数を設定することができます。

`.env` を以下となるように変更してください。

```shell title=".env" showLineNumbers
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/thankscard?schema=public"
```

## DBの自動生成

`prisma/schema.prisma` を元に DB を自動生成します。

以下のコマンドを実行してください。

```sh
npx prisma migrate dev --name init
```

これで PostgreSQL に `thankscard` という名前の DB が生成されているはずです。

## 初期データ(seed)自動登録プログラムの作成

ここまでの作業で `thankscard` という名前の DB が生成され、User や ThanksCard というデータのない空のテーブルが生成されています。

今後の開発を効率的に進めるために、初期データを自動登録するように設定します。

(補足) 初期データのことを `seed` と言います。

まずは、初期データをどう作成するか TypeScript プログラムで指示する必要があります。プログラムはどこに配置しても問題ありませんが、`prisma/seed.ts` に配置するのが一般的です。

ここでは `prisma/seed.ts` を作成し以下の初期データを登録するように設定します。

- Roleテーブルに admin, user を作成
- Departmentテーブルに 全体, 管理本部, 開発本部 を作成
- Userテーブルに admin, user を作成
- ThanksCardテーブルにthankscard1, thankscard2, thankscard3 を作成

`prisma/seed.ts` を作成し以下のように記述してください。

```ts title="prisma/seed.ts" showLineNumbers
import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

async function main() {
  const role_admin = await prisma.role.upsert({
    where: { name: "admin" },
    update: {},
    create: {
      name: "admin",
    },
  });
  const role_user = await prisma.role.upsert({
    where: { name: "user" },
    update: {},
    create: {
      name: "user",
    },
  });
  const dept1 = await prisma.department.upsert({
    where: { code: 0 },
    update: {},
    create: {
      name: "全体",
      code: 0,
    },
  });
  const dept2 = await prisma.department.upsert({
    where: { code: 100 },
    update: {},
    create: {
      name: "管理本部",
      code: 100,
      parentId: dept1.id,
    },
  });
  const dept3 = await prisma.department.upsert({
    where: { code: 200 },
    update: {},
    create: {
      name: "開発本部",
      code: 200,
      parentId: dept1.id,
    },
  });
  const admin = await prisma.user.upsert({
    where: { email: "admin@ts.occ.co.jp" },
    update: {},
    create: {
      name: "admin",
      email: "admin@ts.occ.co.jp",
      password: "admin",
      roleId: role_admin.id,
      departmentId: dept2.id,
    },
  });

  const user = await prisma.user.upsert({
    where: { email: "user@ts.occ.co.jp" },
    update: {},
    create: {
      name: "user",
      email: "user@ts.occ.co.jp",
      password: "user",
      roleId: role_user.id,
      departmentId: dept3.id,
    },
  });
  console.log({ admin, user });

  const tc1 = await prisma.thanksCard.upsert({
    where: { id: "thanks_card_test1" },
    update: {},
    create: {
      title: "thankscard1 title",
      body: "thankscard1 body",
      fromId: admin.id,
      toId: user.id,
    },
  });
  const tc2 = await prisma.thanksCard.upsert({
    where: { id: "thanks_card_test2" },
    update: {},
    create: {
      title: "thankscard2 title",
      body: "thankscard2 body",
      fromId: user.id,
      toId: admin.id,
    },
  });
  const tc3 = await prisma.thanksCard.upsert({
    where: { id: "thanks_card_test3" },
    update: {},
    create: {
      title: "thankscard3 title",
      body: "thankscard3 body",
      fromId: user.id,
      toId: admin.id,
    },
  });
  console.log({ tc1, tc2, tc3 });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

## package.json に 初期データ自動登録プログラムを追加

作成した `seed.ts` を package.json に設定します。

package.json の scripts の次の項目に `prisma` を設定してください。

```json title="package.json" showLineNumbers
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "format": "prettier --write --ignore-path .gitignore ./**/*.{js,jsx,ts,tsx,json}"
  },
↓以下3行を追記。
  "prisma": {
    "seed": "ts-node --compiler-options {\"module\":\"CommonJS\"} prisma/seed.ts"
  },
```

## 初期データ自動登録プログラムの実行

以下コマンドで `prisma/seed.ts` が実行され、テーブルに初期データが作成されます。

```shell
npx prisma db seed
```
