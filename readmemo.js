const fs = require('fs');
const path = require('path');
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
  let projectDir = rs.question('プロジェクト名を入力:');
  if (exists(path.join(__dirname, projectDir))) {
    console.log('同じ名前のプロジェクトが存在します。別の名前を指定してください: ');
    loop();
  }
  return projectDir;
}

const printAll = (path, contents) => {
  if(typeof contents === 'string') {
    contents = [contents];
  }
  const joined = contents.join('\n') + '\n';
  if(!exists(path)) {
    fs.writeFileSync(path, joined);
  }
  else {
    fs.appendFileSync(path, joined);
  }
}

process.chdir(__dirname);

console.log('新規読書メモプロジェクトを構成します');
let projectDir = loop();
let book = rs.question('本のタイトルを入力:');
let chapters = rs.question('章の系列をコンマ区切りで入力(例: 1,2-3,4-6):');

const index = path.join(projectDir, 'index.md');

try {
  fs.mkdir(projectDir);
  printAll('readme.md', `+ [${book}](${projectDir}/index.md)`);
  printAll(index, [
    `# ${book} メモ`,
    `[戻る](../../../tree/master)`,
    ``,
    `## 目次`
  ]);

  let chapSplit = chapters.split(',');
  chapSplit.forEach((chap, idx) => {
    let mdchap = path.join(projectDir, `c${chap}.md`);
    let title = chap.replace('-', '～');

    printAll(index, `+ [${title}章](c${chap}.md)`);
    printAll(mdchap, [
      `# ${book} 第${title}章`,
      `[全体目次へ戻る](index.md)`,
      ``,
    ]);

    if(chap.indexOf('-') < 0) {
      printAll(mdchap, `## ${chap}章`);
    }
    else {
      let [start, end] = chap.split('-').map((v) => parseInt(v));
      for(let i = start; i <= end; i++) {
        printAll(mdchap, `## ${i}章`);
      }
    }
    printAll(mdchap, [
      ``,
      `***`,
      ``
    ]);
    if(idx > 0) {
      printAll(mdchap, `[前へ](c${chapSplit[idx - 1]}.md) /`);
    }
    printAll(mdchap, `[全体目次へ戻る](index.md) /`);
    if(idx < chapSplit.length - 1) {
      printAll(mdchap, `[次へ](c${chapSplit[idx + 1]}.md)`);
    }
  });

  printAll(index, [
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
