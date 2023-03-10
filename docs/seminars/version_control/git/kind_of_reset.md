# `git reset` の種類

`$ git reset --hard <コミットハッシュ値>`

コマンド使って以前の commit 状態に戻る操作を今まで行った。ここでは、さらに細かい `git reset` の操作について見ていく。

`git reset` について、以下の３つのオプションを理解する。

- `--soft`
- `--mixed`
- `--hard`

同時に**変更**が扱われる３つの領域についても理解を深める。

- Working tree
- Index (or Staging area)
- Repository

`Wroking tree -- add --> Index (or Staging area) -- commit --> Repository`

# 事前準備

`master` branch から `try-reset` branch を作成し、移動しておく。

ファイルの内容を変更する

```
$ vi hoge.txt
$ cat hoge.txt
```

```
File is changed.
File is changed by master
File is changed by try-conflict
File is changed by try-reset
```

```
$ git add hoge.txt
$ git commit -m "modify hoge.txt"
$ git log
```

```
commit 1f795bfe60f549b594cd17967865c7da41c602c6
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 14:52:35 2015 +0000

    modity hoge.txt

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

# `--soft` について

`$ git reset --soft` コマンドを実行すると、commit が取り消される。

```
Wroking tree -- add --> Index (or Staging area) -- commit --> Repository
                                                <------------ soft
```

最新の commit の**一つ前**のハッシュ値を指定して、`git reset --soft` を実行せよ

`$ git reset --soft 1d57efd3de77ed03e525c0792c98c75ca6287be4`

コミット履歴を確かめる。`--soft` オプションは commit を取り消す。がインデックスには残っている。

`$ git log`

```
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

`$ git status`

```
On branch try-reset
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

  modified:   hoge.txt

```

`add` はされているが、`commit` はされていない状況になった。
つまりインデックスに戻った。

# `--mixed` について

```
Wroking tree -- add --> Index (or Staging area) -- commit --> Repository
             <----------------------------------------------- mixed
```

`git reset --soft` はコミットまでを取り消し、インデックスに値は残っていた。  
`git reset --mixed` コマンドは、commit と add が取り消される。つまり、リポジトリとインデックスからは変更が削除され、Working tree には残ることになる。
それを確かめるためにもう一度 commit する。

```
$ git commit -m "modify hoge.txt"
$ git log
```


```
ccommit 3ba89a0bd9f90246e138c92e7a1910e510f060ee
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 15:00:38 2015 +0000

    modifty hoge.txt

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

> そろそろ、コミットのハッシュ値をコピペするのに飽きてきたころでは。

それぞれ、最新のコミットから順に 以下のように `HEAD` という文字列に対応している。

```
commit 3ba89a0bd9f90246e138c92e7a1910e510f060ee <-- HEAD
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 15:00:38 2015 +0000

    modifty hoge.txt

commit 6f988bd77b79f535c797e4806f9aaa3740e11d9d <-- HEAD^
Merge: 9e7f11c dc19662
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 12:58:34 2015 +0000

    merge

commit 9e7f11c02dced6a86c3c7de22380f82e807371fe <-- HEAD^^
Author: yutakakinjyo <yutakakinjyo@gmail.com>
Date:   Thu Apr 30 11:57:55 2015 +0000

    update hoge.txt

commit dc19662c35c1f3d42495ef29c881b2ff7deb45de <-- HEAD^^^
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

`--mixed` オプションを試して、add, commit が取り消されることを確認する。  

`$ git reset --mixed HEAD^`

```
Unstaged changes after reset:
M	 hoge.txt
```

`$ git log`

```
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

`$ git status`

```
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

  modified:   hoge.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

> Changes not staged for commit:  
> 変更は、ステージ領域(Index)にない

よって `git reset --mixed <コミットハッシュ値>` コマンドを実行すると、commit と add が取り消される。

# `--hard` について

`--hard` オプションは `commit` と `add` を取り消し、Working tree の状態を前の commit の状態にまで戻す。

```
Wroking tree -- add --> Index (or Staging area) -- commit --> Repository
<------------------------------------------------------------ hard
```

`$ cat hoge.txt`

```
File is changed.
File is changed by master
File is changed by try-conflict
File is changed by try-reset
```

`add` と `commit` を行う。

```
$ git add hoge.txt
$ git commit -m "modify hoge.txt"
$ git reset --hard HEAD^
```

`$ cat hoge.txt`

```
File is changed.
```

`$ git log`

```
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

`$ git status`

```
On branch try-reset
nothing to commit, working directory clean
```

Working tree が一つ前の commit 時の状態に戻った。

> Tips : reset をやり直したい場合には
> `$ git reset --hard ORIG_HEAD` コマンドを使用する

# まとめ

- `git reset --soft <コミットハッシュ値>` commit を取り消す
- `git reset --mixed <コミットハッシュ値>` add と commit を取り消す
- `git reset --hard <コミットハッシュ値>` working tree の変更と add, commit を取り消す

```
Wroking tree -- add --> Index (or Staging area) -- commit --> Repository
                                                <------------ soft
             <----------------------------------------------- mixed
<------------------------------------------------------------ hard
```



