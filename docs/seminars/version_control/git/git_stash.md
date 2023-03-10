# Stash について学ぶ

## 変更を commit せずにブランチを移動したらどうなる？

変更を現在のブランチで commit せずに別のブランチに移動した場合、
変更は移動先のブランチに適応される。つまり変更が持ち越される。

その際に、持ち越した変更が移動先のブランチの変更と `conflict` してしまう時がある。

### ミニ演習

変更が持ち越されるか確認する演習

1. `try-changes` というブランチを `master` ブランチから作成せよ。
- `try-changes` ブランチに移動せよ。
- `fuga.txt` を新たに作成せよ ( touch コマンド )
- `commit` せずに `master` ブランチへ移動し、`fuga.txt` が `master` ブランチの変更となっていることを確かめよ

`$ git status` で以下のような結果が出力されれば成功

```
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	fuga.txt

nothing added to commit but untracked files present (use "git add" to track)
```

- そのまま `git reset` コマンドで最新の commit に戻り変更をなかったことにせよ。
- その後、`try-changes` ブランチを削除せよ。


## 変更が持ち越されて Conflict する

branch を移動する際に、**変更**を持ち越してしまう場合がある。その場合に一時的に変更を隠す(stash)ことができる。
まずは、stash を試すためのブランチを `master` から**２つ**作成せよ。  
以下のような結果になると成功

`$ git branch`

```
  master
  try-move
  try-remove
* try-stash1
  try-stash2
```
---

## ミニ演習1

1. `hoge.txt` を以下の結果になるように変更せよ
- 以下の結果と同様にできれば、commit せよ。

```
$ git status
```

```
On branch try-stash1
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

  modified:   hoge.txt

no changes added to commit (use "git add" and/or "git commit -a")

```

`$ git diff`
> `git diff` は現在の working tree の状態と前回の commit の状態を比較するもの。`+`, が追加された行を表し、`-`が削除された行を表す。

```diff
diff --git a/hoge.txt b/hoge.txt
index a32d114..51bff84 100644
--- a/hoge.txt
+++ b/hoge.txt
@@ -1,3 +1,4 @@
 File is changed.
 File is changed by master
 File is changed by try-conflict
+File is changed by try-stash1
```

## ミニ演習2

`try-stash2` ブランチに移動し、以下の結果になるよう、hoge.txt を変更せよ。
:warning: 注意 : commit はしないこと。

`$ git branch`

```
  master
  try-move
  try-remove
  try-stash1
* try-stash2
```

`$ git diff`

```
diff --git a/hoge.txt b/hoge.txt
index a32d114..67e3dee 100644
--- a/hoge.txt
+++ b/hoge.txt
@@ -1,3 +1,4 @@
 File is changed.
 File is changed by master
 File is changed by try-conflict
+File is changed by try-stash2
```

# 変更の持ち越しを stash(隠す) する

- `try-stash1` で変更を commit する。
- `try-stash2` では変更を加え、commit せずに `try-stash1` に移動しようとする。

`$ git checkout try-stash1`

```
error: Your local changes to the following files would be overwritten by checkout:
       hoge.txt
Please, commit your changes or stash them before you can switch branches.
Aborting
```

> Please, commit your changes or stash them before you can switch branches.  
> ブランチを移動する前に変更を commit するか、stash してください。

commit せずにブランチ越しに変更を持ち歩くことはできる。しかし、変更内容が conflict する場合には上記のようなエラーが出て持ち歩くことができない。  
現在持っている変更を隠すコマンドが以下になる

`$ git stash save`
または
`$ git stash`

```
Saved working directory and index state WIP on try-stash2: 1d57efd add for_commit.txt
HEAD is now at 1d57efd add for_commit.txt
```

`$ cat hoge.txt`

```
File is changed.
File is changed by master
File is changed by try-conflict
```

変更が stash されたので、加えた行がなくなっているのが確認できる。この状態ではブランチが移動できる。

`$ git checkout try-stash1`

```
Switched to branch 'try-stash1'
```

元のブランチに戻って stash をした変更を復元する。復元するには `git stash pop` コマンドを使用する

```
$ git checkout try-stash2
$ git stash pop
```

```
On branch try-stash2
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   hoge.txt

no changes added to commit (use "git add" and/or "git commit -a")
Dropped refs/stash@{0} (ec9ebab1ef3353ea7a3f8e2b5334e2bf47df6e9a)

```

> Tips : pop には「ポンとでる、飛び出す。」という意味がある。隠されていた領域から、変更が出されてくるイメージを持つとよい。

# まとめ

- `git stash` コミットされていない変更を隠す
- `git stash pop` 隠していた変更を現在のブランチへ適応する

# 演習1

`try-stash2` で `try-stash1` の変更を `pop` すると `conflict` することを確認する演習

1. もう一度、`try-stash2` の変更を stash せよ
- `git stash pop` を `try-stash1` で実行し、内容が `conflict` することを確認せよ。
- `git reset --hard <コミットハッシュ値>` を用いて `conflict` 状態の前に戻せ。


confilct している際に `git status` コマンドを試すと `both modified` と表示される。

```
On branch try-stash1
Unmerged paths:
  (use "git reset HEAD <file>..." to unstage)
  (use "git add <file>..." to mark resolution)

	both modified:   hoge.txt

no changes added to commit (use "git add" and/or "git commit -a")

```

# 演習2

1. `man git stash` を使用し、現在の stash を破棄するコマンド調べ実行せよ

# 演習3

`git stash pop` は必ず `conflict` するわけではないことを試す演習

1. 続いて `try-stash1` branch の変更を `try-stash2` branch に merge せよ (`git merge` コマンドの復習)
- `try-stash2` ブランチで `hoge.txt` に適当な変更を加えよ。( commit はしない )
- 加えた変更を commit せずに `try-stash1` に持ち越せることを確認せよ。( 内容が conflict しないから )

