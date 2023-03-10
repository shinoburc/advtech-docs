# Git をはじめよう

バージョン管理システムとして、`Git` というものがある。変更の履歴を管理する柔軟なシステム。
基本的にコマンドラインからの操作になるが、GUI からも操作できるクライアントが存在する。

- GUI クライアント
  - GitHub for Windows
  - Eclipse plugin

# Git の install

## Windows の場合

[git for windows](https://gitforwindows.org/) をインストール

## CentOS の場合
```
$ sudo yum install -y git
$ git --version
```

git の version が表示されれば install 成功

## Ubuntu の場合

```
$ sudo add-apt-repository ppa:git-core/ppa
$ sudo apt-get update
$ sudo apt-get install git
$ git --version
```

git の version が表示されれば install 成功

# Git の config

Git の設定情報を登録する

```
$ git config --global user.name <あなたのユーザ名>
$ git config --global user.email <あなたのEmailアドレス>
```

下記のコマンドで設定した内容を確認できる

`$ git config --list`

誤った情報を設定した場合は、もう一度、上記のコマンドを実行すると、情報が上書きされる

> ユーザー名とEmail アドレスは **GitHub** :octocat: に設定したアドレス  

# Git リポジトリの作成

## リポジトリとは

リポジトリとはファイルセット。 ( 飲食店のセットメニュー のようなもの)

複数のファイルを作成しながらプログラミングは進むので、ディレクトリを一つのセットとして扱うことが多い。リポジトリを中心に開発は進む。リポジトリの中に変更の履歴を持つ。

## リポジトリ作成手順

次に Git のリポジトリを作成する。Git はディレクトリを一つのリポジトリとみる。ホームディレクトリに `first_repo` というディレクトリを作成し、それをリポジトリ化する。

 ホームディレクトリに移動

 ` $ cd ~`


ディレクトリの作成
```
$ mkdir first_repo
$ cd first_repo
```

ディレクトリの中身の確認。この時点ではファイルは存在しない。
`$ ls -a`
```
.	..
```

リポジトリの作成  
`$ git init`
```
Initialized empty Git repository in <それぞれのファイルパス>/first_repo/.git/
```

上記の結果が出力されると、リポジトリの作成が成功  

ディレクトリの中身の確認  
`$ ls -a`
```
.	..	.git
```

`.git` というディレクトリが作成された。
`.git` の中身の確認
`$ ls .git`
```
config  description  HEAD  hooks/  info/  objects/  refs/
```

`.git` ディレクトリにはリポジトリの情報が格納されている。詳しい内容は別の資料で一部紹介する。  

## ミニ演習

`.git`がある**ディレクトリ以下**がその Git のリポジトリとなる。以下の場合にはどのディレクトリが Git のリポジトリになるか考えよ。

![](images/dotgit.png)

## まとめ

- リポジトリはディレクトリ単位で作成される
- `git init` Git リポジトリの作成
  - 新しくリポジトリを作成
