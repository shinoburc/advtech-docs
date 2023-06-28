---
sidebar_position: 1
---

# プロジェクトの作成

以下のコマンドを実行することで「thanks-card」という名前のプロジェクトを作成することができます。 `--typescript` オプションを指定することで、雛形のソースコードが JavaScript ではなく TypeScript で生成されます。

```shell
npx create-next-app thanks-card --typescript
```

各オプションは以下を基準に選択してください。

- `√ Would you like to use ESLint with this project? ... No / Yes`
  - ESLint は JavaScript(EcmaScript) 静的解析ツールのデファクトスタンダードであるため通常「Yes」
- `√ Would you like to use Tailwind CSS with this project? ... No / Yes`     
  - Tailwind は CSS フレームワークのデファクトスタンダードになりつつあるため通常「Yes」
  - material-ui を使用する場合は「No」(Tailwind と material-ui は共存できるが、共存するメリットはないと考える)
- `√ Would you like to use `src/` directory with this project? ... No / Yes`
  - Next.js の推奨に合わせて「No」
- `√ Use App Router (recommended)? ... No / Yes`
  - Next.js の推奨に合わせて「Yes」
- `√ Would you like to customize the default import alias? ... No / Yes`
  - 「No」

## 動作確認

```shell
cd thanks-card
npm run dev
```

ブラウザで「http://localhost:3000」を開き「Welcome to Next.js!」と書かれたページが表示されればインストール成功です。

## tsconfig.json の設定

** !!!!! Next.js のあるバージョンから以下の設定は不要になりましたので飛ばして構いません。!!!!! **

本設定は不要ではありますが、後々、TypeScript の `import` を使用する際に、ファイルを探しやすくするための設定をしておきます。

この設定により例えば `import { prisma } from "../../../utils/prismaSingleton";` のような記述を `import { prisma } from "@/utils/prismaSingleton";` のように簡潔に記述することができるようになります。

`tsconfig.json` を以下のように書き換えてください。

```json title="tsconfig.json" showLineNumbers
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    // highlight-start
    "incremental": true,
    "baseUrl": "./",
    "paths": {
      "@/*": ["./*"]
    }
    // highlight-end
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
```
