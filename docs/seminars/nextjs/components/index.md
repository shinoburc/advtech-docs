---
sidebar_position: 7
---

# components(コンポーネント)

汎用的に使用するUIの部品を React のコンポーネントして実装します。

ここでは例として感謝カード(thanks_cardモデル)の一覧を表示するコンポーネントを実装し、
システムのトップ画面(`app/page.tsx`) に表示します。

### 感謝カード一覧表示コンポーネントの実装

```tsx title="app/_components/thanks_card/list.tsx"
'use client';

import React from 'react';
import { Prisma, Department } from '@prisma/client';

/* ライブラリ Material-UI が提供するコンポーネントの import */
import TableContainer from '@mui/material/TableContainer';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';

import type { ThanksCardWithFromToList } from '@/app/_repositories/ThanksCard';

// reference:
// https://www.prisma.io/docs/concepts/components/prisma-client/advanced-type-safety/operating-against-partial-structures-of-model-types#problem-using-variations-of-the-generated-model-type
/*
const thanksCardWithFromTo = Prisma.validator<Prisma.ThanksCardArgs>()({
    include: {
        from: true,
        to: true,
    }
});
type ThanksCardWithFromTo = Prisma.ThanksCardGetPayload<typeof thanksCardWithFromTo>
*/

/*
type ThanksCardWithFromTo = Prisma.ThanksCardGetPayload<{
    include: {
        from: true;
        to: true;
    }
}>
*/

type Props = {
  thanks_cards: ThanksCardWithFromToList;
};

function ThanksCardList(props: Props) {
  const thanks_cards = props.thanks_cards;

  return (
    <TableContainer component={Paper}>
      <Table sx={{ minWidth: 650 }} aria-label='simple table'>
        <TableHead>
          <TableRow>
            <TableCell>id</TableCell>
            <TableCell>title</TableCell>
            <TableCell>body</TableCell>
            <TableCell>from</TableCell>
            <TableCell>to</TableCell>
            <TableCell>createdAt</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {/* thanks_cards 全件をテーブル出力する */}
          {thanks_cards?.map((thanks_card) => {
            return (
              /* 一覧系の更新箇所を特定するために一意となる key を設定する必要がある */
              <TableRow key={thanks_card.id}>
                <TableCell>{thanks_card.id}</TableCell>
                <TableCell>{thanks_card.title}</TableCell>
                <TableCell>{thanks_card.body}</TableCell>
                <TableCell>{thanks_card.from.name}</TableCell>
                <TableCell>{thanks_card.to.name}</TableCell>
                <TableCell>{thanks_card.createdAt?.toString()}</TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </TableContainer>
  );
}

export default ThanksCardList;
```

### コンポーネントの使用

`app/page.tsx` を以下のように変更し、感謝カード一覧コンポーネントを表示するようにしてください。

サーバコンポーネントとして動作するように変更(signOutの削除)していますので、
`'use client'`も削除しています。

```tsx title="app/page.tsx"
import Image from 'next/image';
import styles from './page.module.css';
import Link from 'next/link';

import { ThanksCardRepository } from '@/app/_repositories/ThanksCard';
import ThanksCardList from '@/app/_components/thanks_card/list';

export default async function Home() {
  const thanks_cards = await ThanksCardRepository.findMany();

  return (
    <main className={styles.main}>
      <div className={styles.description}>
        <ThanksCardList thanks_cards={thanks_cards} />
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
