---
sidebar_position: 2
---

# 更新(Update)

User テーブルに対して Update を行う機能を実装します。

## サーバサイド

### API

User テーブルの既存のレコードを1件更新する API を実装します。

URL は `/api/user/[id]` とします。
HTTP メソッドは `PUT` とします。

`[id]` は更新するユーザの id です。

参考リンク
- [Dynamic API Routes - Next.js](https://nextjs.org/docs/api-routes/dynamic-api-routes)
  - [動的APIルーティング - Next.js](https://nextjs-ja-translation-docs.vercel.app/docs/api-routes/dynamic-api-routes)

(idを含んだ URL の具体例)
- `/api/user/cl7ts8yvu0045ssa2e2vcrezk`
- `/api/user/cl7ts8yw20054ssa2hxj5ii9h`

これから実装する API のプログラムの中で、URL から id を取得し、データベースに Update 文を実行する際の条件に加えます。

`pages/api/user/[id].ts` を作成し、以下のように実装してください。

今回、主に2つの関数を実装しています
- `handlePut`: 与えられた id のユーザを1件更新する
- `handleGet`: 与えられた id のユーザを1件だけ返す(更新画面に現在のユーザ情報を表示するために使用)

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
  } else {
    return res.status(500).end();
  }
}

const handleGet = async (req: NextApiRequest, res: NextApiResponse<User>) => {
  // URL から [id](の具体的な値) を取得する
  // (例) URL が /api/user/cl7ts8yvu0045ssa2e2vcrezk の場合 id = cl7ts8yvu0045ssa2e2vcrezk 
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
  // URL から [id](の具体的な値) を取得する
  // (例) URL が /api/user/cl7ts8yvu0045ssa2e2vcrezk の場合 id = cl7ts8yvu0045ssa2e2vcrezk 
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
```

参考リンク
- [update - prisma](https://www.prisma.io/docs/reference/api-reference/prisma-client-reference#update)

## クライアントサイド

### ユーザ更新画面の実装

ユーザ更新画面を実装します。

URL は `/pages/user/edit/[id]` とします。

API 実装時の URL と同様、`[id]` は更新するユーザの id です。

参考リンク
- [Dynamic API Routes - Next.js](https://nextjs.org/docs/api-routes/dynamic-api-routes)
  - [動的APIルーティング - Next.js](https://nextjs-ja-translation-docs.vercel.app/docs/api-routes/dynamic-api-routes)

  `pages/user/edit/[id].tsx` を作成し、以下のように実装してください。
  (コメントにいろいろなパターンの実装例を示しています。)

```tsx title="pages/user/edit/[id].tsx"
import type { NextPage } from "next";
import { useRouter } from "next/router";
import React from "react";
import { useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";

import useSWR, { mutate } from "swr";
import { Prisma } from "@prisma/client";

import FormControl from "@mui/material/FormControl";
import InputLabel from "@mui/material/InputLabel";
import TextField from "@mui/material/TextField";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import FormHelperText from "@mui/material/FormHelperText";
import Button from "@mui/material/Button";

import { fetcher } from "@/utils/fetcher";
import { userFormSchema, UserFormData } from "@/formSchema/user";

const UserEdit: NextPage = () => {
  // Dynamic Routes の仕組み([id].tsx)で URL から User の id を取得する
  // reference: https://nextjs.org/docs/routing/dynamic-routes
  const router = useRouter();
  const { id } = router.query;

  type UserPayload = Prisma.UserGetPayload<{}>;
  const { data: targetUser, error: targetUserFetchError } = useSWR<UserPayload>(
    `/api/user/${id}`,
    fetcher
    // suspense: true にすることで useForm 時に targetUser が取得済みであることを保証することができる。
    // 実装時段階において experimental feature (実験的機能) であるため使用していない。
    // reference: https://swr.vercel.app/docs/suspense
    // { suspense: true }
  );

  const [postError, setPostError] = React.useState<string>();
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<UserFormData>({
    resolver: yupResolver(userFormSchema),
    // 例えば useSWR の suspense: true を設定し targetUser が既に取得済みの場合、
    // ここでフォームの初期値をセットすることができる。
    /*
    defaultValues: targetUser,
    */
  });

  const { data: roles, error: rolesFetchError } = useSWR<
    Prisma.RoleCreateInput[]
  >("/api/role", fetcher);

  const { data: departments, error: departmentsFetchError } = useSWR<
    Prisma.DepartmentCreateInput[]
  >("/api/department", fetcher);

  /* targetUser を取得完了したタイミングでフォームに targetUser のプロパティをセットする */
  React.useEffect(() => {
    reset(targetUser);
    /*
    reset({
      ...targetUser,
    });
    */
  }, [reset, targetUser]);

  const onSubmit = handleSubmit(async (formData) => {
    const response = await fetch(`/api/user/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(formData),
    });
    if (response.ok) {
      // const responseJSON = await response.json();
      // mutate で useSWR のキャッシュを更新する
      mutate(`/api/user/${id}`);
      router.push({ pathname: "/user/" });
    } else {
      // TODO: display error message
      setPostError("server error");
    }

    // SWR のキャッシュを手動で更新する場合
    // reference: https://swr.vercel.app/ja/docs/mutation
    /*
    mutate(
      "/api/user",
      async (users: UserPayload[]) => {
        const response = await fetch(`/api/user/${id}`, {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(formData),
        });
        // TODO: 成功時・失敗時の判定
        const updatedUser = await response.json();
        // リストをフィルタリングし、更新されたアイテムを返します
        const filteredUsers = users.filter(
          (user) => user.id !== updatedUser.id
        );
        return [...filteredUsers, updatedUser];
        // API からすでに更新後の情報が取得できるため
        // 再検証する必要はありません
      },
      { revalidate: false }
    );
    */
  });

  if (!targetUser) return <span>loading...</span>;
  if (targetUserFetchError || rolesFetchError || departmentsFetchError) {
    return <span>server error</span>;
  }

  return (
    <>
      <span className="error">{postError}</span>
      <form onSubmit={onSubmit}>
        <FormControl fullWidth>
          <TextField
            label="Name"
            variant="standard"
            error={"name" in errors}
            helperText={errors.name?.message}
            {...register("name")}
          />
        </FormControl>
        {/*
          <label>name: </label>
          <Input {...register("name")} />
        */}
        <FormControl fullWidth>
          <TextField
            label="Email"
            variant="standard"
            required
            error={"email" in errors}
            helperText={errors.email?.message}
            {...register("email")}
          />
        </FormControl>
        <FormControl fullWidth>
          <TextField
            label="Password"
            variant="standard"
            type="password"
            required
            error={"password" in errors}
            helperText={errors.password?.message}
            {...register("password")}
          />
        </FormControl>
        <FormControl fullWidth>
          <InputLabel>Role</InputLabel>
          <Select
            label="role"
            required
            error={"roleId" in errors}
            defaultValue={targetUser?.roleId}
            {...register("roleId")}
          >
            {roles?.map((role) => (
              <MenuItem key={role.id} value={role.id}>
                {role.name}
              </MenuItem>
            ))}
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
            label="department"
            required
            error={"departmentId" in errors}
            defaultValue={targetUser?.departmentId}
            {...register("departmentId")}
          >
            {departments?.map((department) => (
              <MenuItem key={department.id} value={department.id}>
                {department.name}
              </MenuItem>
            ))}
          </Select>
          <FormHelperText error={true}>
            {errors.departmentId?.message}
          </FormHelperText>
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
        <Button type="submit" variant="contained" color="primary">
          Submit
        </Button>
      </form>
    </>
  );
};

export default UserEdit;

/*
  return (
    <form onSubmit={onSubmit}>
      <div>
        <label>name</label>
        <input {...register("name")} />
        <p className="error">{errors.name?.message}</p>
      </div>
      <div>
        <label>email</label>
        <input {...register("email")} />
        <p className="error">{errors.email?.message}</p>
      </div>
      <div>
        <label>password</label>
        <input {...register("password")} type="password" />
        <p className="error">{errors.password?.message}</p>
      </div>
      <div>
        <label>role</label>
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
        <p className="error">{errors.roleId?.message}</p>
      </div>
      <div>
        <label>department</label>
        <select
          {...register("departmentId")}
          defaultValue={departments ? departments[0].id : undefined}
        >
          {departments?.map((department) => {
            return (
              <option key={department.id} value={department.id}>
                {department.name}
              </option>
            );
          })}
        </select>
        <p className="error">{errors.departmentId?.message}</p>
      </div>
      <Button type="submit" variant="contained" color="primary">
        Submit
      </Button>
    </form>
  );
};

export default UserEdit;
*/
```
