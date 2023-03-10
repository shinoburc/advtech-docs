## コミットを続ける

リポジトリを作成し、リポジトリに対して、ファイルの新規作成という変更を commit した。
続いて、ファイルの内容を変更し、その**変更**をリポジトリに commit する

`$ cd ~/first_repo`

まずはファイルを以下のように編集する。

```
$ vi hoge.txt
$ cat hoge.txt
```

```
File is changed.
```

`$ git diff`

```diff
diff --git a/hoge.txt b/hoge.txt
index e69de29..510f702 100644
--- a/hoge.txt
+++ b/hoge.txt
@@ -0,0 +1 @@
+File is changed.
```

`git diff` はオプションなしで実行すると、現在のインデックスと Working tree の差を表示する。  
`+` が比較して、追加された行を表す  
`-` が比較して、削除された行を表す

上記の場合には、あらたに、`hoge.txt` に `File is changed.` という変更が加えられたことを表す。

> Tips : git diff コマンドも現状を確認するための大切なコマンドなので、覚えておこう。

`$ git status`

```
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

  modified:   hoge.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

> modified:   hoge.txt

ファイル内容が変更されたことがわかる。次に「変更」をインデックスに追加する。

`$ git add hoge.txt`

`$ git status`

```
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

  modified:   hoge.txt
```

最後にコミットメッセージを付けて、リポジトリに commit する。

`$ git commit -m "write contents"`

```
[master 04be81c] write contents
 1 file changed, 1 insertion(+)
```

`git log` コマンドできちんとコミットされたか確認する。

`$ git log`

```
commit 04be81c97b34d6dc10ab9886fd9cc96075afc733
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Sun Mar 29 01:49:42 2015 +0900

    write contents

commit cf8aea8d002b615783f78fd2f884e1f05796ab9f
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Sun Mar 29 01:29:29 2015 +0900

    my first commit
```

### 前のバージョンに戻る

Git はバージョン管理システムであるので、各 commit 時点に戻ることができる。
現在、commit したタイミングは二つ

- ファイルの新規作成時
- ファイルの内容を書き込んだ時

最新はファイルのに内容を書き込んだ時になっている。ここで、`hoge.txt`ファイルの新規作成時の状態に戻してみる。

現在の状態を確認

`$ cat hoge.txt`
```
File is changed.
```

指定した commit の時点に戻るコマンドが以下になる。オプションについては後述する。

`$ git reset --hard <コミットハッシュ値>`

コミットハッシュ値は `git log` コマンドの際に表示される。コミットハッシュ値は リポジトリ内で **commit を一意に特定する値** であり、Git が自動で計算して commit に対して付与する。コミットハッシュ値を指定することで、コミットを指定することになる。例えば以下のようになる。

`$ git reset --hard cf8aea8d002b615783f78fd2f884e1f05796ab9f`

> :warning: 注意 `git checkout` に指定しているハッシュ値は `git log` から見て取れる値を指定している。これは各人で変わる値なので、自分で `$ git log` コマンドでハッシュ値を確認せよ

なにも表示されないことを確認する。

`$ cat hoge.txt`
```

```

コミットの履歴もなかったことになっている。

`$ git log`
```
commit cf8aea8d002b615783f78fd2f884e1f05796ab9f
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Sun Mar 29 01:29:29 2015 +0900

    my first commit
```

ファイルの内容を書き commit した履歴を削除した

- ファイルの新規作成時
- ~~ファイルの内容を書き込んだ時~~

これで、不必要なコミットを削除することができるようなった。

前回の変更を確認したいだけの場合は、

`$ git reset --hard cf8aea8d002b615783f78fd2f884e1f05796ab9f`

の代わりに

`$ git checkout` 

を使うことで、変更の履歴は削除せずに、バージョンを戻すことができる。
もういちど、ファイル変更のコミットを行う。

`$ vi hoge.txt`
```
File is changed.
```

`$ git add hoge.txt`  
`$ git commit -m "write contents"`  
`$ git log`  
`$ git checkout cf8aea8d002b615783f78fd2f884e1f05796ab9f`  

この時点で、`hoge.txt` の中身は空であることを確かめよ。
最新のコミットに戻るには以下のコマンドを使用する。

`$ git checkout master` 

master については後述する

## まとめ

- `git diff` 変更の差分を表示する
- `git reset --hard <コミットハッシュ値>` 指定したコミットの時点に戻る。後戻りはできない ( 厳密にはできる )
- `git checkout <コミットハッシュ値>` 指定したコミットの時点に戻るが、最新のコミットにも戻れる。

## 演習

1. `hoge.txt` を `rm` コマンドで削除せよ
- `git reset` コマンドを使って、`rm` コマンドを実行する前に戻せ
