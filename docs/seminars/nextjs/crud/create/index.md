---
sidebar_position: 2
---

# 作成(Create)

User テーブルに対して Create を行う機能を実装します。

## ユーザ作成APIの実装

User テーブルにレコードを1件挿入する API を実装します。

URL は /api/user とします。 HTTP メソッドは POST とします。

`pages/api/user/route.ts` を作成し、以下のように実装してください。

```ts title="app/api/user/route.ts"
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

import { User } from '@prisma/client';
import { UserRepository } from '@/app/_repositories/User';

export async function POST(request: NextRequest) {
  try {
    const user: User = await request.json();
    const createdUser = UserRepository.create(user);
    return NextResponse.json(createdUser);
  } catch (e) {
    //return NextResponse.next({ status: 500 });
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
```

## ユーザ作成画面の実装

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

### ユーザ作成フォーム表示コンポーネントの実装

```tsx title="app/user/_components/user-form.tsx"
'use client';

import { useRouter } from 'next/navigation';
import React from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';

import FormControl from '@mui/material/FormControl';
import InputLabel from '@mui/material/InputLabel';
import TextField from '@mui/material/TextField';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import FormHelperText from '@mui/material/FormHelperText';
import Button from '@mui/material/Button';

import { userFormSchema, UserFormData } from '@/app/_formSchema/user';
import { Department, Role, User } from '@prisma/client';

type Props = {
  user?: User | null;
  roles: Role[];
  departments: Department[];
  onSuccessUrl: string;
};

export default function UserForm(props: Props) {
  const user = props.user;
  const roles = props.roles;
  const departments = props.departments;
  const onSuccessUrl = props.onSuccessUrl;

  const router = useRouter();

  // props.user が与えられていれば「編集モード(edit)」とする。
  // props.user が与えられていなれば「作成モード(create)」とする。
  let mode: 'edit' | 'create';
  if (user) {
    mode = 'edit';
  } else {
    mode = 'create';
  }

  const [postError, setPostError] = React.useState<string>();
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
//  } = useForm<IFormInputs>({
  } = useForm({
    resolver: yupResolver(userFormSchema),
    defaultValues: { ...user },
  });

  // フォームに初期値を入力する
  /*
  React.useEffect(() => {
    if (user) {
      reset(user);
    }
  }, [reset, user]);
  */

  const onSubmit = handleSubmit(async (formData) => {
    let response: Response;
    if (mode == 'edit') {
      response = await fetch(`/api/user/${user?.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });  
    } else { // mode == 'create'
      response = await fetch(`/api/user`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });  
    }
    if (response.ok) {
      //const response_json = await response.json();
      router.refresh();
      router.push(onSuccessUrl);
    } else {
      setPostError('server error');
    }
  });

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
            defaultValue={user ? user.roleId : ''}
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
        <FormControl fullWidth>
          <InputLabel>Department</InputLabel>
          <Select
            label='department'
            required
            defaultValue={user ? user.departmentId : ''}
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
        <Button type='submit' variant='contained' color='primary'>
          Submit
        </Button>
      </form>
    </>
  );
}
```

### pageコンポーネント(page.tsx)の実装

```tsx title="app/user/create/page.tsx"
import UserForm from '@/app/user/_components/user-form';
import { DepartmentRepository } from '@/app/_repositories/Department';
import { RoleRepository } from '@/app/_repositories/Role';

export default async function UserCreate() {
  const roles = await RoleRepository.findMany();
  const departments = await DepartmentRepository.findMany();

  return <UserForm departments={departments} roles={roles} onSuccessUrl='/user/' />;
}
```
