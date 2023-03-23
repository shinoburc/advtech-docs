---
sidebar_position: 4
---

# 総合演習解答例

### <a name="1">問題1</a>

```sql
 select name as 社員名, salary as 給料
  from syain_master 
 where salary not between 125000 and 243000
```

**(補足)**

```sql
where (salary < 125000 or salary > 243000)
```
でも可。

------------------

### <a name="2">問題2</a>

```sql
select name as 社員名
  from syain_master 
 where name like '_城%'
```

------------------

### <a name="3">問題3</a>

```sql
 select name as 社員名, age as 年齢, address as 住所, salary as 給料
  from syain_master 
 where (name like '%城%' or name like '%田%')
   and address like '%市%'
 order by age desc
```

------------------

### <a name="4">問題4</a>

```sql
select syouhinmei as 商品名, tanka as 単価, kazu as 商品数, rank as ランク
  from syouhin
 where tanka <= 500
   and kazu < 1500
order by rank
```

------------------

### <a name="5">問題5</a>

```sql
 select name as 社員名, salary as 給料, siten_code as 支店コード
  from syain_master 
 where salary between 180000 and 250000
   and (siten_code = 1 or siten_code = 2)
```

------------------

### <a name="6">問題6</a>

```sql
 select sum(salary) as 給料の合計額
  from syain_master 
 where salary > 150000
```

------------------

### <a name="7">問題7</a>

```sql
select syouhinmei as 商品名, tanka as 単価, kazu + (kazu * 12.5/100) as 商品数, kazu * 12.5/100 as 増加分
  from syouhin
order by 商品数 desc
```

------------------

### <a name="8">問題8</a>

**(解答例1)**
```sql
select code as 店舗コード, syouhin_cd as 商品コード, syouhinmei as 商品名, kazu as 商品数, tanka as 単価
  from syouhin
 where (code != 1 or syouhin_cd != 1)
order by code, syouhin_cd
```

**(解答例2)**
```sql
select code as 店舗コード, syouhin_cd as 商品コード, syouhinmei as 商品名, kazu as 商品数, tanka as 単価
  from syouhin
 where (code != 1 or syouhin_cd != 1)
   and kazu < 1500
   and tanka >= (select avg(tanka) from syouhin)
order by code, syouhin_cd
```

------------------

### <a name="9">問題9</a>

```sql
select syouhinmei as 商品名, maker as メーカー名, rank as ランク,
       case
         when rank = 'A' then '絶品'
         when rank = 'B' then '美味い'
         when rank = 'C' then '普通'
         else 'いまいち'
       end as 味
  from syouhin
order by rank
```

------------------

### <a name="10">問題10</a>

```sql
select maker as メーカー名, min(tanka) as 最低額, max(tanka) as 最高額, sum(tanka) as 合計額, count(maker) as 種類
  from syouhin
group by maker
```

------------------

### <a name="11">問題11</a>

```sql
select name as 社員名, maker as メーカー名
  from syain_master s1 inner join syouhin s2
    on s1.siten_code = s2.code
   and s1.syouhin_cd = s2.syouhin_cd
 where maker = 'くわっちー精肉店'
    or maker = 'まーさんミート'
```

------------------

### <a name="12">問題12</a>

```sql
select s1.code as 店舗コード
      ,s1.syouhin_cd as 商品コード
      ,syouhinmei as 商品名
      ,maker as メーカー名
      ,s2.name as 社員名
      ,arb.name as アルバイト名
  from syouhin s1 left outer join syain_master s2
                               on s1.code = s2.siten_code
                              and s1.syouhin_cd = s2.syouhin_cd
                  left outer join arbeit arb
                               on s1.code = arb.siten_code
                              and s1.syouhin_cd = arb.syouhin_cd
```

------------------

### <a name="13">問題13</a>

```sql
select *
  from (
	        select name as 名前, salary as 給料, '社員' as 雇用形態
	          from syain_master
	         where salary > (select avg(salary) from syain_master)
        	union
	        select name as 名前, salary as 給料, 'アルバイト' as 雇用形態
	          from arbeit
	         where salary > (select avg(salary) from arbeit)
       ) avg
order by  給料 desc
```

------------------

### <a name="14">問題14</a>

```sql
select name as 社員名, age as 年齢, maker as メーカー名
  from syain_master s1 inner join syouhin s2 on s1.siten_code = s2.code and s1.syouhin_cd = s2.syouhin_cd
 where s1.siten_code in (select siten_code from syain_master where name like '%城間%')
```

------------------

### <a name="15">問題15</a>

```sql
select syouhinmei as 商品名, maker as メーカー名
  from syouhin s1 left outer join syain_master s2 on s1.code = s2.siten_code and s1.syouhin_cd = s2.syouhin_cd
 where s2.no is null
```

**(補足)**

* どのカラムを`null`に指定するかは自由です。実行結果どおりになればOKです。

------------------

### <a name="16">問題16</a>

```sql
select s.maker as メーカー名, count(s.*) as 社員数
    from syouhin s inner join syain_master sm
      on s.code = sm.siten_code
     and s.syouhin_cd = sm.syouhin_cd
group by s.code, s.maker
  having count(*) = (select max(count)
                       from (    select count(*) as count
                                   from syouhin s inner join syain_master sm
                                     on s.code = sm.siten_code
                                    and s.syouhin_cd = sm.syouhin_cd
                               group by s.code, s.maker
                    ) max
                    )
order by s.code
```
