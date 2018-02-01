const fs = require('fs');
const rs = require('readline-sync');

const exists = (path) => {
  try {
    fs.accessSync(path);
    return true;
  }
  catch (e) {
    return false;
  }
}

const loop = () => {
  let dirname = rs.question('プロジェクト名を入力:');
  if (exists(`./${dirname}`)) {
    console.log('同じ名前のプロジェクトが存在します。別の名前を指定してください: ');
    loop();
  }
  return dirname;
}

console.log('新規読書メモプロジェクトを構成します');
let dirname = loop();
let book = rs.question('本のタイトルを入力:');
let chapters = rs.question('章の系列をコンマ区切りで入力(例: 1,2-3,4-6):');

const index = `./${dirname}/index.md`;
const md = (chap) => {
  `./${dirname}/$c{chap}.md`;
}
const println = (path, contents) => {
  if(typeof contents !== 'object') {
    contents = [contents];
  }

  if(!exists(path)) {
    let c = contents.shift();
    fs.writeFileSync(path, `${c}\n`);
  }
  contents.forEach((c) => {
    fs.appendFileSync(path, `${c}\n`);
  });
}

try {
  fs.mkdir(`./${dirname}`);
  println('./readme.md', `+ [${book}](${dirname}/index.md)`);
  println(index, [
    `# ${book} メモ`,
    `[戻る](../../../tree/master)`,
    ``,
    `## 目次`
  ]);

  let chapSplit = chapters.split(',');
  chapSplit.forEach((chap, idx) => {
    let mdchap = `./${dirname}/${chap}.md`;
    let title = chap.replace('-', '～');

    println(index, `+ [${title}章](${chap}.md)`);
    println(mdchap, [
      `# ${book} 第${title}章`,
      `[全体目次へ戻る](index.md)`,
      ``,
    ]);

    if(chap.indexOf('-') < 0) {
      println(mdchap, `## ${chap}章`);
    }
    else {
      let [start, end] = chap.split('-').map((v) => parseInt(v));
      for(let i = start; i <= end; i++) {
        println(mdchap, `## ${i}章`);
      }
    }
    println(mdchap, [
      ``,
      `***`,
      ``
    ]);
    if(idx > 0) {
      println(mdchap, `[前へ](c${chapSplit[idx - 1]}.md) /`);
    }
    println(mdchap, `[全体目次へ戻る](index.md) /`);
    if(idx < chapSplit.length - 1) {
      println(mdchap, `[次へ](c${chapSplit[idx + 1]}.md)`);
    }
  });

  println(index, [
    ``,
    `## 情報`,
    ``,
    `## 備考`
  ]);
}
catch(e) {
  console.log('エラー発生:');
  console.log(e);
}
