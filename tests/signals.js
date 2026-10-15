const vm = require('node:vm');
const fs = require('node:fs');
const assert = require('node:assert/strict');
let listener, submitted, confirmation = true;
const document = {
  addEventListener(name, fn) { if (name === 'click') listener = fn; },
  createElement(tag) {
    return { tag, children: [], appendChild(el) { this.children.push(el); }, submit() { submitted = this; } };
  },
  querySelector() { return { content: 'test-session-token' }; },
  body: { appendChild() {} },
};
const location = new URL('https://warehouse.example/Material/showDispatch');
vm.runInNewContext(fs.readFileSync(__dirname + '/../www/js/main.js', 'utf8'), {
  document, window: { location, confirm() { return confirmation; } }, location, URL, setTimeout,
});
function click(href, dataset = {}) {
  submitted = null;
  const event = {
    target: { closest() { return { href, dataset }; } },
    preventDefault() { this.prevented = true; }, stopImmediatePropagation() {},
  };
  listener(event);
  return event;
}
assert.equal(click('https://warehouse.example/Material/showDispatch?do=closeDispatch').prevented, true);
assert.equal(submitted.method, 'post');
assert.equal(submitted.children[0].name, '_requestToken');
assert.equal(submitted.children[0].value, 'test-session-token');
assert.equal(click('https://warehouse.example/Material/default').prevented, undefined);
assert.equal(submitted, null);
click('https://other.example/?do=delete');
assert.equal(submitted, null);
confirmation = false;
click('https://warehouse.example/?do=delete', { netteConfirmText: 'Opravdu?' });
assert.equal(submitted, null);
console.log('PASS: POST signal, CSRF token, ordinary navigation, external URL, cancelled deletion');
