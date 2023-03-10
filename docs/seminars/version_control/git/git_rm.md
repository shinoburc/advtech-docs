# ファイルの削除

## ミニ演習 下準備

`try-remove` というブランチを作成し、そのブランチに移動せよ (コマンドを思い出してみましょう)。

> ファイルの削除を練習するために、練習用のブランチを作成する。練習用のブランチで作業すると、誤った操作をしても、他のブランチには影響がでないので、安全に練習ができる。失敗しても最悪ブランチを削除し、対応できる。もしくは `git reset` 等で元に戻しても良い。


`$ git branch`

上記のコマンドを打って以下の結果が出力されれば成功

```
master
* try-remove
```

## rm でファイルを削除

まず、Linux コマンドを使用してファイルの削除を行ってみる。

`$ rm hoge.txt`

`$ git status`

```
On branch try-remove
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    hoge.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

`$ git add hoge.txt`

`$ git status`

```
On branch try-remove
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	deleted:    hoge.txt

```

`$ git commit -m "delete hoge.txt" hoge.txt`

```
[try-remove 1666159] delete hoge.txt
 1 file changed, 3 deletions(-)
 delete mode 100644 hoge.txt
```

`$ git log`

```
commit 16661590d52118dc8b88cbc89378c0fb569942ad
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 13:00:43 2015 +0000

    delete hoge.txt

commit 6f988bd77b79f535c797e4806f9aaa3740e11d9d
Merge: 9e7f11c dc19662
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 12:58:34 2015 +0000

    merge

commit 9e7f11c02dced6a86c3c7de22380f82e807371fe
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:57:55 2015 +0000

    update hoge.txt

commit dc19662c35c1f3d42495ef29c881b2ff7deb45de
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:57:22 2015 +0000

    update hoge.txt

commit e7c58dcca599037ee69f09d4764212e4653d061e
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:37:18 2015 +0000

    add for_commit.txt

commit f33895c1dd26365531bfc987dc72ef34664ddf5a
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:21:49 2015 +0000

    write contents

commit df4c8dcef4a98398b6ca32c5ecc0e7ec363df812
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:17:27 2015 +0000

    my first commit

```

## これまでの流れ

1. `$ rm <ファイル名>`
- `$ git add <ファイル名>`
- `$ git commit -m "<コミットメッセージ>"`

# `git rm` を試す

rm コマンドでファイルを削除し、その変更を commit した。
次に `git rm` コマンドを実行して、動作を試す。

```
$ git rm for_commit.txt
$ git status
```

```
On branch try-remove
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	deleted:    for_commit.txt
```

`$ git commit -m "delete for_commit.txt"`

`$ rm for_commit.txt` と `git add for_commit.txt` を一度に行ったことになる。

`$ git log`

```
commit 1c9b2c459017d3cb605d5f206b08dd81f705901d
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 13:05:16 2015 +0000

    delete for_commit.txt

commit 16661590d52118dc8b88cbc89378c0fb569942ad
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 13:00:43 2015 +0000

    delete hoge.txt

commit 6f988bd77b79f535c797e4806f9aaa3740e11d9d
Merge: 9e7f11c dc19662
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 12:58:34 2015 +0000

    merge

commit 9e7f11c02dced6a86c3c7de22380f82e807371fe
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:57:55 2015 +0000

    update hoge.txt

commit dc19662c35c1f3d42495ef29c881b2ff7deb45de
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:57:22 2015 +0000

    update hoge.txt

commit e7c58dcca599037ee69f09d4764212e4653d061e
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:37:18 2015 +0000

    add for_commit.txt

commit f33895c1dd26365531bfc987dc72ef34664ddf5a
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:21:49 2015 +0000

    write contents

commit df4c8dcef4a98398b6ca32c5ecc0e7ec363df812
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:17:27 2015 +0000

    my first commit

```

`$ ls`

なにも表示されなければ、成功。

# まとめ

ファイルの削除方法には二種類ある。

1. `$ rm <ファイル名>`
- `$ git add <ファイル名>`
- `$ git commit -m "<コミットメッセージ>"`

---

1. `$ git rm <ファイル名>` ファイルの削除
- `$ git commit -m "<コミットメッセージ>"`

`git rm` は `rm` コマンドと `git add` コマンドを同時に行うコマンド
