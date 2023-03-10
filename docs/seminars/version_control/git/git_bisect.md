# Git によるデバック方法 〜バイナリサーチでバグを探す〜
 
 Git とバイナリサーチという手法を組み合わせることで、デバックに利用することができる。
 
 - 探索アルゴリズム : バイナリサーチ
 - Git のデバックコマンド bisect
 
---

###バイナリサーチとは？ 

ソート済みの配列において、検索をする範囲を半分に絞りながら、目的のデータを探しだすアルゴリズム。
検索範囲の分割はデータの大小関係もとに行われるので、探索対象がソートされている事が条件になる。**二分探索**とも言う
 
 `1 2 4 5 6 7 10 24 100`
 
 というソートされた値の列から、`5` という値を探すとする。
 
1. 中央の値を `6` とみる
- `6` は探したい `5` という値よりも大きい値なので、中央値よりも前半の値を次の探索対象とする (`1 2 4 5`の範囲)
- 中央の値を `2` とみる (`4` でもいい)
- `2` は探したい `5` という値よりも小さい値なので、中央値よりも後半の値を次の探索対象とする(`4 5`の範囲)
- 中央の値を `4` とみる (`5` でもいい)
- `4` は探したい `5` という値よりも大きいなので、中央値よりも後半の値を次の探索対象とする(`5` の範囲)
- 中央の値を `5` とみる
- `5` は探したい `5` という値と一致するため探索が終了する
 
## アルゴリズム分析

1. 配列をソートする
2. 配列の中央の要素を調べる
3. 探索する
 - 中央の要素が目的の値ではなく、目的のデータが中央の値より大きい場合は、中央より後半の範囲を探索対象として、手順2 に戻る
 - 中央の要素が目的の値ではなく、目的のデータが中央の値より小さい場合は、中央より前半の範囲を探索対象として、手順2 に戻る
 - 中央の要素が目的の値であれば、探索終了
 
バイナリサーチの手法は、数値が中央地よりも大きいか、小さいかを判断するものである。   
この手法をバグが「ある」か「ない」に応用したデバック方法がある。  
それをサポートする Git コマンドが**`git bisect`**コマンドである。  

## git bisect - バイナリサーチ  

以前は動いていたシステムが最新版ではいつもまにか動かなくなっていて、  どのコミットでバグを混入させたかを調べたい。  
その様な場合には、`git bisect`コマンドを使用する。  
 
`git bisect`を使う際に大事なことは  
**「問題がない(good)状態と問題がある(bad)状態を、確実に判定できるようにする」**  
ということ  
ここが曖昧だとバイナリサーチをしても問題箇所をうまく特定することはできない。  

**good と bad の指定**

問題がない(good)時点と問題のある(bad)時点を指定する。

```
git bisect start <bad-commit> <good-commit>
```
これで、bad とgood の間にある適当な中間バージョンがチェックアウトされる。
 
**テストをする**

このチェックアウトされたバージョンに対してテストを行う。  
テストの結果、問題がない(good)なら以下のコマンドを実行。  

```
git bisect good
```
 
テストの結果、問題がある(bad)なら以下のコマンドを実行。
 
```
git bisect bad
```
 
このどちらかのコマンドを実行すると、gitが自動的にbad と good の間にある、中間バージョンをチェックアウトする。  
それに対して、再びテストを行い、問題が混入した時点を特定する。  
コミット内容を調べて、問題を解決する。
 
**その他便利コマンド**  

現在チェックアウトしているコミットを確認する。
 
```
git bisect view
```
 
オプション`-p`をつけると、変更の `diff` が確認できる。
 
バイナリサーチのログを表示する
 
```
git bisect log
```
 
`git bisect`を実行する前の状態に戻す
 
```
git bisect reset
```

## git blame - 誰が犯人？

blame : 非難する

例えば、バグがあるファイルを発見したとする。
しかし、この修正をいつ誰が行ったのかが分からない。
その場合は`git blame`コマンドを使用すると、ファイルの変更履歴を行単位(コミット単位)で調べることができる。  
 
**`git blame`の実行方法**
 
```
git blame <ファイル名>
```
 
このコマンドを打つと
 
```
コミットのハッシュ値(名前 日時 行数) ファイルの中身
```
 
という様に表示されるので、  
その行を誰がいつ記入したのかを確認することができる。

### 演習準備

git bisect を使って Java のコードのデバックを行う。そのためにまずは Java の開発環境を構築する

(CentOS の場合)

```
$ sudo yum install -y java-1.8.0-openjdk-devel
```

`$ javac -version` でバージョンが表示されれば成功

(Ubuntu の場合)

```
$ sudo apt-get update
$ sudo apt-get install default-jdk
```

`$ javac -version` でバージョンが表示されれば成功

ディレクトリを作成する

```
$ mkdir ~/java_debug
$ cd ~/java_degug
$ git clone https://github.com/yutakakinjyo/binary-search.git
$ cd binary-search
```

これは与えられた整数の配列から、探索対象の値を二分探索で調べるプログラム。
配列の値と探索する値は決まっている。

```
$ javac Main.java
$ java Main
```

とするとプログラムが実行され、以下のような結果がでる。

```
[3, 4, 5, 10, 12, 14, 25, 30, 49, 100]
12はありませんでした。
```

一行目 : 探索対象の整数配列  
二行目 : `12` が配列の中にあったかどうかの結果

本来は、`12` はあるはずなので、最新のコミットにはバグが存在している。以下のように表示されると、バグがなく正常に動いている状態。

```
[3, 4, 5, 10, 12, 14, 25, 30, 49, 100]
12はありました。
```

## 演習1


開発しているうちにいつのまにかバグが混入してしまったようだ。これを `git bisect` コマンドを使って、コミットログの全体からバグが混入されたコミットを特定せよ。

- bad commit は一番新しいコミットのハッシュ値を指定せよ
- good commit は一番古いコミットのハッシュ値を指定せよ ( 最も古いコミットは正常に動く )

`git bisect start <bad-commit> <good-commit>` を実行し、特定せよ。

> Hint : 以下のような手順で特定する。

1. `$ git bisect start <bad-commit> <good-commit>`
- `$ javac Main.java`
- `$ java Main`
- `$ git bisect bad` (プログラムで正常に動いていなった)
- `$ javac Main.java`
- `$ java Main`
- `$ git bisect bad` (プログラムで正常に動いていなった)
- `$ javac Main.java`
- `$ java Main`
- `$ git bisect good` (プログラムで正常に動いていた)
- `$ javac Main.java`
- `$ java Main`
- `$ git bisect bad` (プログラムで正常に動いていなった)

コミットが特定されると

```
<コミットハッシュ値> is the first bad commit
```

というメッセージが現れる。

## 演習2

バグが混入されたコミットを特定できたら、続いて

```
$ git bisect view -p
```

コマンドを打って、変更の diff を確認し、どの行の変更がバグなのか特定せよ。必ず特定したコミットの中にバグがある。

## 演習3

どの行の変更がバグなのか、特定したら

`$ git blame`  コマンドを使って、誰がその変更をコミットしたか確認せよ

## 演習4

1. バグの特定が済んだら`git bisect start`を実行する前に状態に戻せ(戻すコマンドは上記で説明した) 
- `fix-bug` というブランチを `master` から作成せよ
- `fix-bug`ブランチ上で バグの箇所を修正し、正常に動作することを確かめろ

## 演習5

- `fix-bug`ブランチ上に、バグ修正の変更をコミットせよ。commit message はなんでもよい。
 - この時、`.class` ファイルをコミットしないように気をつけよ
- `fix-bug`ブランチを`master`ブランチに merge せよ

## アドバンス演習1

- `git tag`  コマンドについて調べ、バグを修正したコミットに `v1.0` というタグをつけよ

## アドバンス演習2

- `git tag`で作成した `v1.0` のtag の実態はハッシュ値である。どのファイルにハッシュ値が記録されてるか特定せよ

> Hint : HEAD のハッシュ値が記録されている場所から推測せよ