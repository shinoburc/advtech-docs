---
sidebar_position: 3
---

# 認証機能の実装

大半のシステムではシステムを使用できるユーザを識別したり、
権限を制御したりするために `認証機能` が必要になります。

## npm パッケージのインストール

ここでは `next-auth` を使用して認証機能を実現します。

[next-auth](https://next-auth.js.org/)

`next-auth` は Next.js に特化した認証機能を提供するライブラリで、
Google認証やGitHub認証、DB認証、LDAP認証等を簡単に実装することができます。

ここでは `DB認証` を実装します。DB認証とは私たちが作成した DB に「ユーザID(ユーザ名やメールアドレスなど)、パスワード」を保存して、それにマッチするかどうかで認証を行う古くからある方法です。

以下のコマンドを実行し `next-auth` をインストールしてください。

```shell
npm install --save next-auth
```

また、これから UI(画面) の変更も行います。UI のボタンやプルダウンメニューやテキスト入力などの部品(UIコントロールと呼ばれます)を統一的にデザインするため、今回は `material-ui` を利用します。material-ui は Google が提唱している「マテリアルデザイン」の React における実装です。「マテリアルデザイン」において画面設計に関するガイドラインが定められているため、私たちが画面デザインについて考慮する量を減らすことができます。

以下のコマンドを実行し `material-ui` をインストールしてください。

```shell
npm install --save @mui/material @mui/icons-material @emotion/react @emotion/styled
```

(参考リンク)
- [マテリアルデザイン](https://ja.wikipedia.org/wiki/%E3%83%9E%E3%83%86%E3%83%AA%E3%82%A2%E3%83%AB%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3)
- [material-ui](https://mui.com/)

## `Session` の拡張

`next-auth` で認証に成功すると `Session` が生成されます。

`Session` にはデフォルトで name, email, image (session.user.name, session.user.email, session.user.image) が含まれますが、拡張することで任意の値を持たせることができます。

ここでは `Session` を拡張し id, accessToken, refreshToken, accessTokenExpires を保持するようにします。

id は後々、ThanksCard API を呼び出すときに「誰からのAPIアクセスか判定」するために使用します。

accessToken, refreshToken, accessTokenExpires は今回は使用しませんが、通常 API を呼び出す際「認証済みであること」を証明するために使用されます。
例えば、Google 認証をして Google API を呼び出すような場合に使用されます。

`types/next-auth.d.ts` を作成し、以下のように記述してください。

```ts title="types/next-auth.d.ts" showLineNumbers
// reference: https://next-auth.js.org/getting-started/typescript
// To extend/augment this type, create a types/next-auth.d.ts file in your project:

import NextAuth, { DefaultSession } from 'next-auth';

declare module "next-auth/jwt" {
  /** Returned by the `jwt` callback and `getToken`, when using JWT sessions */
  interface JWT {
    sessionExpires: number;
  }
}

declare module 'next-auth' {

  /**
   * Returned by `useSession`, `getSession` and received as a prop on the `SessionProvider` React Context
   */
  interface Session {
    user: {
      /** The user's postal address. */
      id: string;
      accessToken: string;
      refreshToken: string;
      accessTokenExpires: string;
      sessionExpires: number;
    } & DefaultSession['user'];
  }
}
```

## next-auth の設定

`next-auth` の設定は `/app/api/auth/[...nextauth]/route.ts` にファイルを作成し、その中で行います。

これから `app/api/auth/[...nextauth]/route.ts` に「DB認証機能」を実装します。プログラムからDBに接続するために `@prisma/client` を使用します。`@prisma/client` を効率よく使用するためのプログラム `app/_utils/prismaSingleton.ts` を作成し、以下のように記述してください。

(`_utils` のようにアンダーバー( _ )を付けると Next.js App Router のルーティング規約から除外されます。`_utils` には Next.js App Router と無関係な機能を実装するため、アンダーバーを付けています。)


```ts title="app/_utils/prismaSingleton.ts" showLineNumbers
import { PrismaClient } from "@prisma/client";

// ページがリロードされるたびに PrismaClient インスタンスが生成され、
// それらが DB 接続をして「 FATAL: too many connections」となることを抑制するため
// PrismaClient のインスタンスをシングルトンにするための処理。

declare global {
  // allow global `var` declarations
  // eslint-disable-next-line no-var
  var prisma: PrismaClient | undefined;
}

export const prisma =
  global.prisma ||
  new PrismaClient({
    //log: ["query"],
  });

if (process.env.NODE_ENV !== "production") global.prisma = prisma;
```


`app/api/auth/[...nextauth]/route.ts` を作成し、以下のように記述してください。

(next-auth では複数方法の認証機能を同時に実現でき、以下ではDB認証に加えてGitHub認証、LDAP認証のための設定をコメントで残しています。)

```ts title="app/api/auth/[...nextauth]/route.ts" showLineNumbers
//const ldap = require("ldapjs");
import NextAuth, { Session } from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';
//import GithubProvider from "next-auth/providers/github";
//import { PrismaAdapter } from "@next-auth/prisma-adapter";

//import { PrismaClient } from "@prisma/client";
//const prisma = new PrismaClient();
import { prisma } from '@/app/_utils/prismaSingleton';

const handler = NextAuth({
  // CredentialsProviderの場合 adapter は使用できない模様。
  //adapter: PrismaAdapter(prisma),
  theme: {
    colorScheme: 'light',
  },
  providers: [
    /*
      GithubProvider({
        clientId: process.env.GITHUB_ID ?? "",
        clientSecret: process.env.GITHUB_SECRET ?? "",
      }),
      */
    CredentialsProvider({
      id: 'credentials',
      name: 'credentials',
      credentials: {
        email: {
          label: 'User email',
          type: 'text',
          placeholder: 'User email',
        },
        password: { label: 'Password', type: 'password' },
      },
      authorize: async (credentials, req) => {
        const user = await prisma.user.findFirst({
          where: {
            email: credentials?.email,
            password: credentials?.password,
          },
        });
        if (user) {
          return user;
        } else {
          return null;
        }
      },
    }),
    /*
      // LDAP Credentials
      CredentialsProvider({
        id: "ldap",
        name: "LDAP",
        credentials: {
          name: { label: "LDAP User", type: "text", placeholder: "" },
          password: { label: "Password", type: "password" },
        },
        async authorize(credentials, req) {
          console.log(credentials);
          // You might want to pull this call out so we're not making a new LDAP client on every login attemp
          const client = ldap.createClient({
            url: "ldap://ldap.es.occ.co.jp:389",
          });
  
          // Essentially promisify the LDAPJS client.bind function
          return new Promise((resolve, reject) => {
            client.bind(
              `uid=${credentials?.name},ou=Users,dc=occ,dc=co,dc=jp`,
              credentials?.password,
              (error: any) => {
                if (error) {
                  console.error("Failed");
                  reject();
                } else {
                  console.log("Logged in");
                  // Add user if user is not exist in DB.
                  resolve({
                    email: credentials?.name + "@occ.co.jp",
                    name: credentials?.name,
                  });
                }
              }
            );
          });
        },
      }),
      */
  ],
  callbacks: {
    async jwt({ token, user, account }) {
      console.log("token: ", token)
      // セッションの有効秒
      const SESSION_EXPIRES_SECOND = 60 * 60;
      // 秒までの現在時刻を UNIXTIME で取得する
      const nowUnixtime = Math.floor(Date.now() / 1000);

      // 最初のサインイン
      if (account && user) {
        // 現在時刻+セッション有効秒を計算し、セッション期限を生成する
        const sessionExpires = nowUnixtime + SESSION_EXPIRES_SECOND;
        // JWT に独自のフィールドを追加するため、型を拡張しておく
        // reference: https://next-auth.js.org/getting-started/typescript#submodules
        // reference: https://techlab.q-co.jp/articles/111/
        return {
          ...token,
          accessToken: account.access_token,
          refreshToken: account.refresh_token,
          accessTokenExpires: account.accessTokenExpires,
          sessionExpires: sessionExpires,
        };
      }

      if(token.sessionExpires > nowUnixtime){
        // セッション有効期限を更新する
        token.sessionExpires = nowUnixtime + SESSION_EXPIRES_SECOND;
      } else {
        // セッション切れのため、Promise.rejectを return する
        return Promise.reject({
          error: new Error("token has expired. Please log in again."),
        });
      }

      return token;
    },
    async session({ session, token }: { session: Session; token: any }) {
      session.user.accessToken = token.accessToken;
      session.user.refreshToken = token.refreshToken;
      session.user.accessTokenExpires = token.accessTokenExpires;
      return session;
    },
  },
  session: {
    strategy: 'jwt',
    //maxAge: 10,
  },
  secret: process.env.NEXTAUTH_SECRET,
  // サインイン・サインアウトで飛ぶカスタムログインページを指定
  /*
    pages: {
      signIn: "/login",
      signOut: "/login",
    },
    */
  // Enable debug messages in the console if you are having problems
  debug: process.env.NODE_ENV === 'development',
});

export { handler as GET, handler as POST };
```

## .env ファイルに NEXTAUTH_SECRET を設定

`app/api/auth/[...nextauth]/route.ts` の中で `process.env.NEXTAUTH_SECRET` と記載されていますが、これは環境変数 `NEXTAUTH_SECRET` を参照するという意味です。

`.env` に `NEXTAUTH_SECRET` を以下のように設定してください。

(`akaCCo...` は本来はセキュリティを確保するための秘密フレーズであるため、本番環境で設定する場合は `openssl` コマンド等を使用してランダムのフレーズを生成します。)

```shell showLineNumbers
# generated command: $ openssl rand -base64 32
NEXTAUTH_SECRET=akaCCoY3Gc2jTsid7Ofsl2nxbIdkzoGk3HEW/QM0PV0=
```

## ログイン画面の表示

`next-auth` ではプロジェクト直下に `middleware.ts` というプログラムを配置すると、どういった場合にログイン画面を表示するか設定することができます。

ここでは「全てのページ」でログイン画面を表示するように設定します。つまり、この設定をされたシステムは認証をパスしなければ全ての機能にアクセスできないようになります。

`middleware.ts` を作成し、以下のように記述してください。

```ts title="middleware.ts" showLineNumbers
// reference: https://next-auth.js.org/configuration/nextjs#middleware
export { default } from "next-auth/middleware";

/*
// 特定のページにのみ認証を要求する場合。
export const config = {
  matcher: "/user/:path*",
};
*/
```

## ログアウト機能の実装

画面上に「SIGN OUT」ボタンを配置しログアウト機能を実装します。

`app/page.tsx` を以下のように書き換えてください。
(グレー部分を追記してください。)

```tsx title="app/page.tsx" showLineNumbers
// highlight-start
'use client'

// next-auth の signOut はクライアントサイドでのみ動作するため use client を付けている。
// highlight-end

import Image from 'next/image';
import styles from './page.module.css';
import Link from 'next/link';

// highlight-start
// next-auth が提供する signOut 関数を import する。
import { signOut } from 'next-auth/react';
// material-ui が提供する Button を import する。
import Button from '@mui/material/Button';
// highlight-end

export default function Home() {
  return (
    <main className={styles.main}>
      <div className={styles.description}>
        // highlight-start
        {/* Button を配置し onClick イベント(ボタンをクリックしたとき)に signOut 関数を実行するようにする。 */}
        <Button
          onClick={() => signOut()}
          variant="contained"
          color="secondary"
        >
          Sign out
        </Button>
        // highlight-end
        <p>
          Get started by editing&nbsp;
          <code className={styles.code}>app/page.tsx</code>
        </p>
        <div>
          <ul>
            <li>
              <Link href='file-uploader' className='underline'>
                File Uploader
              </Link>
            </li>
            <li>
              <Link href='qr-code-reader' className='underline'>
                QR Code Reader
              </Link>
            </li>
          </ul>
        </div>
        <div>
          <a
            href='https://vercel.com?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app'
            target='_blank'
            rel='noopener noreferrer'
          >
            By{' '}
            <Image
              src='/vercel.svg'
              alt='Vercel Logo'
              className={styles.vercelLogo}
              width={100}
              height={24}
              priority
            />
          </a>
        </div>
      </div>

      <div className={styles.center}>
        <Image
          className={styles.logo}
          src='/next.svg'
          alt='Next.js Logo'
          width={180}
          height={37}
          priority
        />
      </div>

      <div className={styles.grid}>
        <a
          href='https://nextjs.org/docs?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app'
          className={styles.card}
          target='_blank'
          rel='noopener noreferrer'
        >
          <h2>
            Docs <span>-&gt;</span>
          </h2>
          <p>Find in-depth information about Next.js features and API.</p>
        </a>

        <a
          href='https://nextjs.org/learn?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app'
          className={styles.card}
          target='_blank'
          rel='noopener noreferrer'
        >
          <h2>
            Learn <span>-&gt;</span>
          </h2>
          <p>Learn about Next.js in an interactive course with&nbsp;quizzes!</p>
        </a>

        <a
          href='https://vercel.com/templates?framework=next.js&utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app'
          className={styles.card}
          target='_blank'
          rel='noopener noreferrer'
        >
          <h2>
            Templates <span>-&gt;</span>
          </h2>
          <p>Explore the Next.js 13 playground.</p>
        </a>

        <a
          href='https://vercel.com/new?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app'
          className={styles.card}
          target='_blank'
          rel='noopener noreferrer'
        >
          <h2>
            Deploy <span>-&gt;</span>
          </h2>
          <p>Instantly deploy your Next.js site to a shareable URL with Vercel.</p>
        </a>
      </div>
    </main>
  );
}
```
