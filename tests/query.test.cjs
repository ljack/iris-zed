const fs = require('fs');
const path = require('path');
const test = require('node:test');
const assert = require('assert/strict');
const { execSync } = require('child_process');
const Parser = require('web-tree-sitter');

const fixturePath = path.join(__dirname, 'fixtures', 'sample.iris');
const source = fs.readFileSync(fixturePath, 'utf8');

const wasmPath = path.join(__dirname, 'fixtures', 'tree-sitter-iris.wasm');
const grammarDir = path.join(__dirname, '..', 'tree-sitter-iris');

function ensureWasm() {
  if (fs.existsSync(wasmPath)) return;
  execSync(`npx tree-sitter build --wasm -o \"${wasmPath}\"`, {
    cwd: grammarDir,
    stdio: 'inherit',
  });
}

async function parseSource() {
  ensureWasm();
  await Parser.init();
  const language = await Parser.Language.load(wasmPath);
  const parser = new Parser();
  parser.setLanguage(language);
  return { tree: parser.parse(source), language };
}

function runQuery(queryPath, tree, language) {
  const querySource = fs.readFileSync(queryPath, 'utf8');
  const query = language.query(querySource);
  return query.captures(tree.rootNode);
}

function captureTexts(captures) {
  return captures.map((capture) => ({
    name: capture.name,
    text: source.slice(capture.node.startIndex, capture.node.endIndex),
  }));
}

test('highlights capture keywords, types, functions, and constructors', async () => {
  const { tree, language } = await parseSource();
  const captures = captureTexts(
    runQuery(path.join(__dirname, '..', 'languages', 'iris', 'highlights.scm'), tree, language),
  );

  const byName = (name) => captures.filter((c) => c.name === name).map((c) => c.text);

  assert.ok(byName('keyword').includes('deffn'));
  assert.ok(byName('function').includes('main'));
  assert.ok(byName('type').includes('User'));
  assert.ok(byName('type').includes('I64'));
  assert.ok(byName('constructor').includes('"Ok"') || byName('constructor.special').includes('"Ok"'));
});

test('outline captures module, defs, and type items', async () => {
  const { tree, language } = await parseSource();
  const captures = captureTexts(
    runQuery(path.join(__dirname, '..', 'languages', 'iris', 'outline.scm'), tree, language),
  );
  const names = captures.filter((c) => c.name === 'name').map((c) => c.text);
  assert.ok(names.includes('main'));
  assert.ok(names.includes('User'));
  assert.ok(names.includes('"sample"'));
});

test('folds and indents produce captures', async () => {
  const { tree, language } = await parseSource();
  const foldCaptures = runQuery(
    path.join(__dirname, '..', 'languages', 'iris', 'folds.scm'),
    tree,
    language,
  );
  const indentCaptures = runQuery(
    path.join(__dirname, '..', 'languages', 'iris', 'indents.scm'),
    tree,
    language,
  );

  assert.ok(foldCaptures.length > 0);
  assert.ok(indentCaptures.length > 0);
});
