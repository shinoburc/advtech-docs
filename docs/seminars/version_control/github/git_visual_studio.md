---
sidebar_position: 4
---

# Visual Studio から Git を操る

## Visual Studio から GitHubにリポジトリ作成

- [拡張機能] -> [拡張機能の管理] -> [オンライン] から [github]と検索 -> [GitHub Extension for Visual Studio] の Download をクリック
- Visual Studio を閉じる
- **このアプリがデバイスに変更を加えることを許可しますか？** と聞かれたら **はい** を選択
- **Modify** をクリック
- インストールが完了したら Visual Studio を起動して [チームエクスプローラー] にGitHubが表示されるようになるので「接続」をクリックして、「ブラウザーでサインインします」をクリック
- ユーザー名とパスワードを入力
- 新しいプロジェクトを立ち上げる
    - プロジェクト名は `try_github` とする
- [チームエクスプローラー] -> [GitHub] -> [GitHubに発行] -> [公開] をクリック

## コラボレータに追加
- レビューをお願いするために、隣の席の人を追加
  - リポジトリのページの右側の Settings をクリック
  - 左側の [Manage access] -> [Invite a collaborator] をクリック
  - フォームに隣の人の GitHub account 名を入力

## Branch を作成し commit , push する
- 右下の [master] -> [新しいブランチ]
  - ブランチ名は `try_collabo` とする
- 「ブランチの作成」をクリック
- 続いて以下のように変更する。

```cs
using System;

namespace ConsoleApp3
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Console.WriteLine("Hello GitHub!");
        }
    }
}
```

- [ファイル] -> [Program.csの保存]または[Ctrl + s] 
- [チームエクスプローラー] -> [変更]
- コミットしたいファイルを選んで、右クリックをして [ステージ] を選択
- Commit メッセージに Main クラスの編集、[ステージ済みをコミット] をクリック
- [チームエクスプローラー] -> [同期] -> [プッシュ(出力方向のコミット)]

## Pull Request を作成する

- 自身のGitHub上のリポジトリトップページにいく
- Compare & pull reqeust のボタンをクリックする
- Create pull request のボタンをクリックする
  - その際に、Comment : 「@<相手のアカウント名> レビューとマージお願いします」と言う事

## Pull Reqeust を merge する
- パートナーが差分をチェックして Pull Request を取り込む
  - commit 履歴/Files changed をクリックして、変更を内容を確認する。( スペルミス等はないか。あったらもう一度 commit してもらおう )
  - `Merge pull request` ボタンを押す
  - `Confirm merge` ボタンを押す
  - `Delete branch` を押す
