# 初めてのSQL 付録B
[全体目次へ戻る](index.md)

## 付録B MySQLによるSQL言語の拡張
### select文の拡張機能
+ **limit節** は、select文によって返される行の数を制限する。これをorder by節と組み合わせて使用することで、最もある行の値が大きい･小さいいくつかの行だけをテーブルから取り出すことができる。
  - パラメータを2つ指定する(`LIMIT m, n`のようにする)と、m番目(0オリジン)からn個のデータを取得する。
  - m番目から全ての行を取得したい場合は、`LIMIT m, n`のnを十分大きな値に設定するしかない。

```sql
/* 最も多く口座を開設した銀行員上位3人の行員IDと開設した口座の数をリストアップする。 */
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
ORDER BY how_many DESC
LIMIT 3;

/* 3番目に多く口座を開設した銀行員のIDと口座数を取得する。*/
/* LIMIT節は｢結果の2番目(行は0オリジンで数える)から1つを取ってくる｣という意味になっている。 */
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
ORDER BY how_many DESC
LIMIT 2, 1;
```

+ limit節はupdate文やdelete文の中でも利用できる。何かの値を基準に行をソートして、その上位･下位n行について更新･削除を行うといったことが可能。

+ **into outfile節** によってクエリの結果をファイルに出力することができる。デフォルトでは列の区切りはタブ('\\t')、行の区切りは改行('\\n')である。
  - 列の区切り文字を変更するには、`FIELDS TERMINATED BY '<区切り文字>'`というように指定する。
    * 列の区切りを変更した場合、文字列データの中に区切り文字と同じ文字が含まれるなら自動的にエスケープされる。
  - 行の区切り文字を変更するには、`LINES TERMINATED BY '<区切り文字>'`とする。

```sql
/* INTO OUTFILEの後に指定したパスにクエリの結果を出力する。 */
SELECT emp_id, fname, lname, start_date
INTO OUTFILE 'path'
FROM employee;
```

+ 通常、行を挿入する際にすでに主キーの列の値が一致するような行がある場合は制約により挿入は拒否される。MySQLでは、このような場合に、データを挿入するかわりに更新するような動きをするSQL文を利用できる。通常のinsert文の最後に`ON DUPLICATE KEY UPDATE <更新する列> = <値>`を追加すれば良い。
  - このような処理は｢upsert｣とも呼ばれる。

```sql
/* branch_usageは、ある顧客がある支店に最後の訪れた日付を記録する。 */
/* まだbranch_id = 1, cust_id = 5の組み合わせをもつ行がなければ、現在時刻とともに行を挿入する。 */
/* すでにその組み合わせを持つ行があれば、挿入するのではなく現在時刻だけを更新する。 */
INSERT INTO branch_usage (branch_id, cust_id, last_visited_on)
VALUES (1, 5, CURRENT_TIMESTAMP())
ON DUPLICATE KEY UPDATE last_visited_on = CURRENT_TIMESTAMP();
```

+ MySQLでは複数テーブルの関連するデータを1つのSQL文で更新･削除することができる。更新･削除対象を指定する方法はselect文で複数のテーブルからデータを取得する場合に近い。
  - 外部キー制約を設定している場合は複数テーブルのdelete/update文は利用できない可能性が高い。

```sql
/* account, customer, individualの3つのテーブルから、cust_idが1である顧客に関するデータを全て削除する。 */
DELETE account, customer, individual
FROM account INNER JOIN customer
ON account.cust_id = customer.cust_id
INNER JOIN individual
ON account.cust_id = individual.cust_id
WHERE individual.cust_id = 1;

/* individual, customer, accountの3つのテーブルのcust_idが3である行の全てのcust_idを更新する。 */
UPDATE individual INNER JOIN customer
ON individual.cust_id = customer.cust_id
INNER JOIN account
ON individual.cust_id = customer.cust_id
SET individual.cust_id = individual.cust_id + 10000,
customer.cust_id = customer.cust_id + 10000,
account.cust_id = account.cust_id + 10000
WHERE individual.cust_id = 3;
```

***

[前へ](c12-13.md) /
[全体目次へ戻る](index.md)
