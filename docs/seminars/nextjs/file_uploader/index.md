---
sidebar_position: 9
---

# ファイルのアップロード

Next.js アプリケーション内でファイルのアップロード機能を実装します。

## クライアントサイド

クライアントサイドは Next.js とは関係なく、HTML や React の機能でファイルのアップロードを実装します。

### ファイル(画像)アップロードを受け付ける画面の作成

HTML の `<input type="file"></input>` を使用してファイル選択を実装し、
選択されたファイル(画像)を HTML の `URL.createObjectURL()` を使用してサムネイル表示する機能を実装します。

`app/file_uploader/` ディレクトリを作成し、その中に `page.tsx` を以下のように作成して下さい。

```js title="app/file_uploader/page.tsx" showLineNumbers
'use client';

// reference
// Next.jsとFirebase storageで画像をuploadする方法
// https://masa-engineer-blog.com/next-js-firebase-file-upload/

import Image from 'next/image';
import Link from 'next/link';
import { useState } from 'react';

import styles from '../page.module.css';

import ImageIcon from '@mui/icons-material/Image';

export default function FileUploader() {
  const [image, setImage] = useState<File>();
  const [createObjectURL, setCreateObjectURL] = useState<string>('');

  const showImage = (event: { target: HTMLInputElement }) => {
    if (event.target.files && event.target.files[0]) {
      const file = event.target.files[0];

      setImage(file);
      setCreateObjectURL(URL.createObjectURL(file));

      /*******************************************/
      /* ここで file をストレージ等に送信すれば良い */
      /*******************************************/
    }
  };

  return (
    <main className={styles.main}>
      <div className={styles.description}>
        <p>File Uploader&nbsp;</p>
        <p>
          <Link href='/' className='underline'>
            Home
          </Link>
        </p>
        <div className=''>
          <div className=''>
            <label htmlFor='file-input' className=''>
              File Select
              <ImageIcon />
            </label>
            {/* HTML 標準のファイル選択UIを非表示にする */}
            <input
              id='file-input'
              style={{ visibility: 'hidden' }}
              type='file'
              accept='image/*'
              name='myImage'
              onChange={showImage}
            />
          </div>
          <div className=''>
            {createObjectURL != '' && (
              <Image
                className=''
                src={createObjectURL}
                alt='target image'
                width='100'
                height='100'
              />
            )}
          </div>
        </div>
      </div>
    </main>
  );
}
```

## サーバサイド

ほとんどの場合、外部ストレージを使用すると思われるため、本コンテンツ未作成。
