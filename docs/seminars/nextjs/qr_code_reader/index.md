---
sidebar_position: 10
---

# QRコードリーダーの実装

Next.js アプリケーション内で QR コードを読み込む機能を実装します。

## クライアントサイド

React で RQ コードを読み込むためのライブラリには [react-qr-reader](https://www.npmjs.com/package/react-qr-reader), [zxing-js/browser](https://github.com/zxing-js/browser) などがありますが、
ここでは `react-qr-reader` を使った実装を行います。

### react-qr-reader のインストール

2023年6月21日現在、最新の Next.js で react-qr-reader をインストールしようとすると React のバージョンにおける依存性不一致で react-qr-reader のインストールに失敗してしまいます。

`package.json` に以下を設定し、依存関係のチェックを上書きすることで、インストールすることができます。

`package.json` に以下 `overrides` の設定を追記してください。

```json title="package.json" showLineNumbers
  ...
  "private": true,
  // highlight-start
  "overrides": {
    "react-qr-reader": {
      "react": "$react",
      "react-dom": "$react-dom"
    }
  },
  // highlight-end
  "scripts": {
  ...
```

これで `react-qr-reader` がインストールできます。
以下のコマンドでインストールしてください。

```shell
npm install --save react-qr-reader
```

### QRコードを読み込み内容を表示する画面の作成

`app/qr-code-reader/` ディレクトリを作成し、その中に `page.tsx` を以下のように作成して下さい。

```js title="app/qr-code-reader/page.tsx" showLineNumbers
'use client';

// reference
// react-qr-reader
// https://github.com/JodusNodus/react-qr-reader

import Link from 'next/link';
import { useState } from 'react';
import { QrReader } from 'react-qr-reader';

import styles from '../page.module.css';

export default function QRCodeReader() {
  const [data, setData] = useState('No result');

  return (
    <main className={styles.main}>
      <div className={styles.description}>
        <p>QR Code Reader&nbsp;</p>
        <p>
          <Link href='/' className=''>
            Home
          </Link>
        </p>
        <div className=''>
          <div className=''>
            <QrReader
              onResult={(result, error) => {
                if (result) {
                  setData(result.getText());
                }
                if (error) {
                  console.info(error);
                }
              }}
              constraints={{ facingMode: 'environment' }}
            />
            <p>{data}</p>
          </div>
        </div>
      </div>
    </main>
  );
}
```

## サーバサイド

サーバサイドに必要な機能はありません。
