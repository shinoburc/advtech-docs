---
sidebar_position: 8
---

# 関連の例

関連には一対一、一対多、多対一、多対多がある。

|関連|---|使用できるか|備考|  
|---|---|---|---|
|一対一|One-to-One|基本的にNG|設計自体は可能だが、テーブルを分ける意味がない|  
|一対多|One-to-Many|OK|正常・問題なし。|  
|多対一|Many-to-One|OK|正常・問題なし。|  
|多対多|Many-to-Many|NG|設計自体が不可能。データベースで表現できない|  

## 一対一

テーブルを分ける意味がない。  
キー項目が同じなら同じテーブルで管理したほうがよい。  

![example_one-to-one.jpg](./images/example_one-to-one.jpg)

## 一対多

正常・問題なし。

![example_one-to-many.jpg](./images/example_one-to-many.jpg)

## 多対一

正常・問題なし。

![example_many-to-one.jpg](./images/example_many-to-one.jpg)

## 多対多

DBでは表現できない。

![example_many-to-many.jpg](./images/example_many-to-many.jpg)

多対多の関連の中にテーブル(エンティティ)を一つ追加して 
一対多、多対一の関係にすることで関連を表すことができる。
つまり、多対多を間接的に設計することができる

![example_solve_many_to_many.jpg](./images/example_solve_many_to_many.jpg)

- 正規化して解決する方法もある

![example_solve_normalization_many_to_many.jpg](./images/example_solve_normalization_many_to_many.jpg)
