# 初めてのJavaScript第3版 付録D
[全体目次へ戻る](index.md)

## 付録D ES2016とES2017の動向
### ES2016
- 累乗演算子`**`の追加
- `Array.prototype.includes`: 配列が指定した要素が含まれているかをチェック

### ES2017
- 関数定義・呼び出し時の引数リストの末尾カンマを許容
  + 配列やオブジェクトでは、すでに許容されている
- 文字列の`padStart(max, fill)`/`padEnd(max, fill)`メソッド: 文字列の長さが`max`に満たない場合、文字列`fill`を左/右に挿入して長さを合わせる
- `Object.entries(obj)`/`Object.values(obj)`: オブジェクトに含まれる全エントリ(キー・値の組)/値を配列として返す
- `Object.getOwnPropertyDescriptors(obj)`: オブジェクトの全プロパティのディスクリプタを一度に返す

- `async`/`await`: 非同期処理のための構文
  + `async`を`function`の前につけた関数は「async関数」となり、必ず`Promise`を返すようになる
    * `return`で`Promise`以外の値を返した場合、「その値で成功する`Promise`」が返る
  + async関数の内部では演算子`await`を利用できる。`await`で処理を一時中断し、対象の`Promise`が完了したら再開する
  + `await`式は、`Promise`が成功した場合に`resolve`に渡された値に評価される
  + `Promise`が失敗した場合は`reject`に渡されたエラーを`await`が再throwする(?)

```js
const fs = require('fs');

function readFile(filename) {
  return new Promise((resolve, reject) => {
    fs.readFile(filename, 'utf8', (err, data) => {
      err ? reject(err) : resolve(data);
    });
  });
}

function writeFile(filename, data) {
  return new Promise((resolve, reject) => {
    fs.writeFile(filename, data, err => {
      err ? reject(err) : resolve('OK');
    });
  });
}

// ファイル読み込みを逐次的に行う場合
async function readWriteFileSeq() {
  try {
    let data = await readFile('a.txt');
    data += await readFile('b.txt');
    data += await readFile('c.txt');
    await writeFile('d.txt', data);
  }
  catch (err) {
    console.err('error');
  }
}

// ファイル読み込みを並列に行う場合
// Promise.allも全体としてPromiseを返すので、awaitの対象になれる
async function readWriteFilePar() {
  try {
    const result = await Promise.all([
      readFile('a.txt'),
      readFile('b.txt'),
      readFile('c.txt')
    ]);
    await writeFile('d.txt', result.reduce((acc, e) => acc + e));
  }
  catch (err) {
    console.err('error');
  }
}
```

***

[前へ](c22.md) /
[全体目次へ戻る](index.md) /
