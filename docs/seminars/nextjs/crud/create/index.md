---
sidebar_position: 1
---

# 作成(Create)

User テーブルに対して Create を行う機能を実装します。

## サーバサイド

### API

User テーブルにレコードを1件挿入する API を実装します。

URL は `/api/user` とします。
HTTP メソッドは `POST` とします。

`pages/api/user/index.ts` を以下のように書き換えてください。
(主に handlePost 関数を追加しています。)

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
  // highlight-start
  } else if (req.method === "POST") {
    return handlePost(req, res);
  }
  // highlight-end
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

  // highlight-start
const handlePost = async (req: NextApiRequest, res: NextApiResponse<User>) => {
  //const user: User = req.body;
  //const createdUser = await prisma.user.create({ data: user });

  /*
  // スプレッド構文を使用しない場合。
  // (補足)プロパティ名と変数名が一致しているため、プロパティ名は省略できる。
  const { name, email, password, roleId, departmentId } = req.body;
  const createdUser = await prisma.user.create({
    data: {
      name: name,
      email: email,
      password: password,
      roleId: roleId,
      departmentId: departmentId,
    },
  });
  */

  // スプレッド構文を使用する場合
  try {
    const createdUser = await prisma.user.create({
      data: {
        ...req.body,
      },
    });
    res.status(200).json(createdUser);
  } catch (e) {
    //if (e instanceof Prisma.PrismaClientKnownRequestError) {
    res.status(500).end();
  }
};
// highlight-end
```

参考リンク
- [create - prisma](https://www.prisma.io/docs/reference/api-reference/prisma-client-reference#create)

### Role and Department API

ユーザ登録機能を実装するためには、ユーザに設定された Role、ユーザが所属する Department も扱う必要がります。

ここで、Role を全件取得する API、Department を全件取得する API を実装します。
プログラムの内容は「User テーブル全件を取得するための API」とほとんど同じです。

`pages/api/role/index.ts` と `pages/api/department/index.ts` を以下のように実装してください。

```ts title="pages/api/role/index.ts"
// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from "next";

import { Role } from "@prisma/client";
import { prisma } from "@/utils/prismaSingleton";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<Role[]>
) {
  const roles = await prisma.role.findMany();
  res.status(200).json(roles);
}
```

```ts title="pages/api/department/index.ts"
// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from "next";

import { Department } from "@prisma/client";
import { prisma } from "@/utils/prismaSingleton";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<Department[]>
) {
  const departments = await prisma.department.findMany();
  res.status(200).json(departments);
}
```


## クライアントサイド

### バリデーションライブラリの導入

「ユーザ登録機能」では利用者がユーザに関する情報を入力して、新しいデータを作成します。こういった「ユーザがデータを入力する画面」のことを「入力フォーム」と言います。

入力フォームでは、利用者が「正しく情報を入力しているか」をチェックする必要があります。そうしなければ、不正なデータが作成されてしまい、後々利用できない場合も出てきます。このような「利用者が正しく情報を入力しているか」をチェックする仕組みのことを「バリデーションチェック(妥当性検証)」と呼びます。

バリデーションチェックはいろいろなバリエーションがありますが、例を以下に示します。

バリデーションの例
- 必須入力の項目に値が入力されているか
- パスワードが8文字以上になっているか
  - OK: longpass
  - NG: shortp
- 数量が数字になっているか
  - OK: 0, 100
  - NG: ゼロ, １００(マルチバイト文字), 1,980
- メールアドレスがちゃんとしたフォーマットになっているか
  - OK: test@occ.co.jp
  - NG: testocc.co.jp

これらバリデーションの機能は多くのシステムで汎用的に利用されるため、良く設計された「バリデーションライブラリ」を利用すると、私たちの開発コストを低減することができます。

ここでは `yup` というバリデーションライブライを利用します。yup には上で示したような良くあるバリデーションの機能が実装されています。

- [yup](https://github.com/jquense/yup)

以下で yup パッケージをインストールしてください。

```shell
npm install --save yup
```

### yup のスキーマ定義

yup ではスキーマと呼ばれるデータ構造でバリデーションの設定を行います。

今回はユーザ作成で使用する yup スキーマですので User モデルに関するスキーマを定義します。

`formSchema/user.ts` を作成し、以下のように編集してください。

```ts title="formSchema/user.ts"
import * as yup from "yup";

export const userFormSchema = yup
  .object({
    // Prismaが生成する型と整合性を取るために nullable() を追加している
    name: yup.string().nullable(),
    email: yup
      .string()
      .email("Invalid mail format.")
      .required("email is a required field"),
    password: yup.string().min(4).required("password is a required field"),
    roleId: yup.string().required(),
    departmentId: yup.string().required(),
  })
  .required();
export type UserFormData = yup.InferType<typeof userFormSchema>;

// Same as...
/*
type UserFormData = {
  name: string | null | undefined;
  email: string;
  password: string;
  roleId: string;
  departmentId: string;
};
*/
```

上記 yup スキーマ定義は以下を意味しています。
- **name: yup.string().nullable()**
  - → name プロパティは文字列 `string()` である
  - → name プロパティは Null でも良い `nullable()`
- **email: yup.string().email("Invalid mail format.").required("email is a required field")**
  - → email プロパティは文字列 `string()` である
  - → email プロパティは email フォーマット `email()` で、バリデーションエラー時のメッセージは「`Invalid mail format.`」とする
  - → email プロパティは必須入力 `required()` で、バリデーションエラー時のメッセージは「`email is a required field.`」とする
- **password: yup.string().min(4).required("password is a required field")**
  - → password プロパティは文字列 `string()` である
  - → password プロパティは4文字以上 `min(4)` でなければならない
    - (必要であれば `max()` も用意されています)
  - → password プロパティは必須入力 `required()` で、バリデーションエラー時のメッセージは「`password is a required field.`」とする

最後の行にある `export type UserFormData = yup.InferType<typeof userFormSchema>;`  は、yup で定義した User モデルのスキーマから TypeScript の型を生成(型推論)しています。手動で型を定義する場合の例をコメントで残していますが、スキーマ定義と型定義で同じような文言が重複しますので、`yup.InferType` を使用して自動生成している現状の書き方の方が好ましいです。


参考リンク
- [string - yup](https://github.com/jquense/yup#string)
- [number - yup](https://github.com/jquense/yup#number)
- [date - yup](https://github.com/jquense/yup#date)

### 入力フォームの状態管理ライブラリの導入

入力フォームではバリデーション以外でも以下のことを考慮する必要があります。

- フォームの初期値(デフォルト値)をどうするか
- バリデーションチェックがエラーの場合、どのように利用者に通知するか

これら機能も多くのシステムで汎用的に利用されるため、良く設計された「入力フォーム管理ライブラリ」を利用すると、私たちの開発コストを低減することができます。

React には様々な入力フォーム管理ライブラリがありますが、2022年現在、`Formik` と `React Hook Form` が良く使われています。

ここでは `React Hook Form` ライブライを利用します。

- [React Hook Form](https://react-hook-form.com/jp/)
- [Formik](https://formik.org/)

以下で Reac Hook Form パッケージをインストールしてください。

```shell
npm install --save react-hook-form @hookform/resolvers
```

### ユーザ登録画面の実装

```tsx title="pages/user/create.tsx"

import type { NextPage } from 'next';
import { useRouter } from 'next/router';
import React from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';

import useSWR from 'swr';
import { Prisma } from '@prisma/client';

import FormControl from '@mui/material/FormControl';
import InputLabel from '@mui/material/InputLabel';
import TextField from '@mui/material/TextField';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import FormHelperText from '@mui/material/FormHelperText';
import Button from '@mui/material/Button';

import { fetcher } from '@/utils/fetcher';
import { userFormSchema, UserFormData } from '../../formSchema/user';

const UserCreate: NextPage = () => {
  const router = useRouter();

  const [postError, setPostError] = React.useState<string>();
  const {
    register,
    //setValue,
    handleSubmit,
    formState: { errors },
  } = useForm<UserFormData>({
    resolver: yupResolver(userFormSchema),
  });

  const onSubmit = handleSubmit(async (formData) => {
    const response = await fetch('/api/user', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(formData),
    });
    if (response.ok) {
      const responseJSON = await response.json();
      router.push('/user/');
    } else {
      // TODO: display error message
      setPostError('server error');
    }
  });

  const { data: roles, error: role_error } = useSWR<Prisma.RoleCreateInput[]>('/api/role', fetcher);
  const { data: departments, error: department_error } = useSWR<Prisma.DepartmentCreateInput[]>(
    '/api/department',
    fetcher
  );

  return (
    <>
      <span className='error'>{postError}</span>
      <form onSubmit={onSubmit}>
        <FormControl fullWidth>
          <TextField
            label='Name'
            variant='standard'
            error={'name' in errors}
            helperText={errors.name?.message}
            {...register('name')}
          />
        </FormControl>
        {/*
            <label>name: </label>
            <Input {...register("name")} />
        */}
        <FormControl fullWidth>
          <TextField
            label='Email'
            variant='standard'
            required
            error={'email' in errors}
            helperText={errors.email?.message}
            {...register('email')}
          />
        </FormControl>
        <FormControl fullWidth>
          <TextField
            label='Password'
            variant='standard'
            type='password'
            required
            error={'password' in errors}
            helperText={errors.password?.message}
            {...register('password')}
          />
        </FormControl>
        <FormControl fullWidth>
          <InputLabel>Role</InputLabel>
          <Select
            label='role'
            required
            defaultValue=''
            error={'roleId' in errors}
            {...register('roleId')}
          >
            {roles?.map((role) => {
              return (
                <MenuItem key={role.id} value={role.id}>
                  {role.name}
                </MenuItem>
              );
            })}
          </Select>
          <FormHelperText error={true}>{errors.roleId?.message}</FormHelperText>
        </FormControl>
        {/*
            <label>role: </label>
            <select
            {...register("roleId")}
            defaultValue={roles ? roles[0].id : undefined}
            >
            {roles?.map((role) => {
                return (
                <option key={role.id} value={role.id}>
                    {role.name}
                </option>
                );
            })}
            </select>
            */}
        <FormControl fullWidth>
          <InputLabel>Department</InputLabel>
          <Select
            label='department'
            required
            defaultValue=''
            error={'departmentId' in errors}
            {...register('departmentId')}
          >
            {departments?.map((department) => {
              return (
                <MenuItem key={department.id} value={department.id}>
                  {department.name}
                </MenuItem>
              );
            })}
          </Select>
          <FormHelperText error={true}>{errors.departmentId?.message}</FormHelperText>
        </FormControl>
        {/*
            <button
            type="button"
            onClick={() => {
                setValue("lastName", "MIYAZATO");
                setValue("firstName", "Shinobu");
            }}
            >
            SetValue
            </button>
            <input type="submit" value="Submit" />
        */}
        <Button type='submit' variant='contained' color='primary'>
          Submit
        </Button>
      </form>
    </>
  );
};

export default UserCreate;
```

この状態で [http://localhost:3000/user/create](http://localhost:3000/user/create) にアクセスすると、User 登録が表示されます。
