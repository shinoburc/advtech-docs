---
sidebar_position: 7
---

# GitHub Flavored Markdown

## Markdown とは

文章を綺麗に整えて表示するフォーマットの一つ。

### リスト

```
- リスト1
- リスト2
```

というように書くと

- リスト1
- リスト2

と表示される。他にも様々なフォ−マットが存在する。

### 番号付きリスト

```
1. 一番目
- 二番目
- 三番目
```

1. 一番目
- 二番目
- 三番目

リストの最初が `1.` であれば、続いて何を書いても番号付きのリストになる


### 強調

```
**強調**
```

**強調**

`**` で囲まれた部分は太文字になる



### イタリック体

```
_イタリック_
```

_イタリック_

`__` or `*` で囲まれた部分は太文字になる


--

### 引用

```
> 引用文章
```

> 引用文章

`> が書かれた行は引用になる`

--

### Block

```
　```
　Block
　```
```

```
Block
```

```
 `一行`
```

`一行`

--

### リンク

```
[株式会社オーシーシー](http://www.occ.co.jp/)
```

`[]`でリンク名を書き、`()` に URL を記載する. : `[リンク名](URL)`


[株式会社オーシーシー](http://www.occ.co.jp/)

--

### 改行と段落

注意しなければならないのは段落である。Markdown 上では見た目の改行通りに、改行されない。例えば以下のように文章を書くと


```
一行目
二行目
```

一行目
二行目


のように出力される。改行したい場合には、スペースを２つ付け加えることで改行になる。

```
一行目  <-- ここにスペースが２つ
二行目
```

一行目  
二行目

また段落を分けたい場合には、行の間を開けることで実現できる。

```
一行目

二行目
```

一行目

二行目


## GitHub Flavored Markdown (GFM)

Markdown をさらにGitHub 上で使いやすくカスタマイズしたものが GitHub Flavored Markdown(GFM) だ。  
GitHub 上でのコメント全ては GFM に対応している。GFM を理解し活用することで、素早く表現力の高い構成で文章を作成することができる。  

### 見出し

```
# 一番大きな見出し
## 二番目に大きな見出し
#### 三番目に大きな見出し
```

--

### タスクリスト

```
- [x] タスク1
- [x] タスク2
- [ ] タスク3
  - [ ] タスク3-1
```

- [x] タスク1
- [x] タスク2
- [ ] タスク3
  - [ ] タスク3-1

--

### 取り消し線

```
~~取り消し線~~
```

~~取り消し線~~

`~~` で囲むと取り消し線が引かれる。

---

### コードハイライト

```
　```java
　public class Main {

    public static void main(String[] args) {
        System.out.println("Hello GFM");
    }
  }
　```
```

```java
  public class Main {

    public static void main(String[] args) {
        System.out.println("Hello GFM");
    }
  }
```

他にも、`ruby`, `C#`, `diff` などある  
see also : [the languages YAML file](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml)

### テーブル

```
見出し1 | 見出し2
--------|---------
要素1   | 要素2
要素3   | 要素4

```

とすると、テーブルを表現できる

見出し1 | 見出し2
--------|---------
要素1   | 要素2
要素3   | 要素4



## README.md

また、GitHub 上に `.markdown` や `.md` という markdown の拡張子でアップロードすることで、そのファイルを GitHub 上で見ると整った形で表示される。このページもそうである。  
とくに代表的な例として、`README.md` というファイルがある。`README` ファイルは慣習として、ソフトのパッケージなどに付随しており、最初に読むべきドキュメントである。その慣習を踏まえて、GitHub 上では README.md というファイル名であれば、自動でリポジトリのページに表示されるようになっている。


## Emoji :pizza: :beer: :+1:

GFM では Emoji が使える :smile:  
[EMOJI CHEAT SHEET](http://www.emoji-cheat-sheet.com/) - created by Arvid Andersson / @arvid_a at Oktavilla.  

**Emoji が探しやすいプラグイン**

[Emoji Cheatsheet for GitHub, Basecamp etc.](https://chrome.google.com/webstore/detail/emoji-cheatsheet-for-gith/nojknakoailnpbjlmfkpbbhoodlolfbh)

## 演習

自分のリポジトリの issue で GFM の練習をしよう

- 上記で紹介してきたフォーマットを試せ
