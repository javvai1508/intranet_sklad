const vm = require('node:vm');
const fs = require('node:fs');
const assert = require('node:assert/strict');
let listener, submitted, navigated, confirmation = true;
const document = {
  addEventListener(name, fn) { if (name === 'click') listener = fn; },
  createElement(tag) {
    return { tag, children: [], appendChild(el) { this.children.push(el); }, submit() { submitted = this; } };
  },
  querySelector() { return { content: 'test-session-token' }; },
  body: { appendChild() {} },
};
const location = new URL('https://warehouse.example/Material/showDispatch');
location.assign = href => { navigated = href; };
vm.runInNewContext(fs.readFileSync(__dirname + '/../www/js/main.js', 'utf8'), {
  document, window: { location, confirm() { return confirmation; } }, location, URL, setTimeout,
});
function click({ href, dataset = {}, row, interactive = false, ...keys } = {}) {
  submitted = navigated = null;
  const event = {
    target: { closest(selector) {
      if (selector === 'a[href]') return href ? { href, dataset } : null;
      if (selector === 'tr[data-href]') return row ? { dataset: { href: row } } : null;
      return interactive ? {} : null;
    } },
    button: 0, ...keys,
    preventDefault() { this.prevented = true; }, stopImmediatePropagation() {},
  };
  listener(event);
  return event;
}
assert.equal(click({href: 'https://warehouse.example/Material/showDispatch?do=closeDispatch'}).prevented, true);
assert.equal(submitted.method, 'post');
assert.equal(submitted.children[0].name, '_requestToken');
assert.equal(submitted.children[0].value, 'test-session-token');
assert.equal(click({href: 'https://warehouse.example/Material/default'}).prevented, undefined);
assert.equal(submitted, null);
click({href: 'https://other.example/?do=delete'});
assert.equal(submitted, null);
confirmation = false;
click({href: 'https://warehouse.example/?do=delete', dataset: { netteConfirmText: 'Opravdu?' }});
assert.equal(submitted, null);
click({row: '/DeliveryNote/itemDetail?itemId=5'});
assert.equal(navigated, 'https://warehouse.example/DeliveryNote/itemDetail?itemId=5');
click({row: 'https://other.example/'});
assert.equal(navigated, null);
click({row: '/DeliveryNote/itemDetail?itemId=5', interactive: true});
assert.equal(navigated, null);
click({row: '/DeliveryNote/itemDetail?itemId=5', ctrlKey: true});
assert.equal(navigated, null);
click({href: 'https://warehouse.example/DeliveryNote/default', row: '/DeliveryNote/itemDetail?itemId=5'});
assert.equal(navigated, null);
console.log('PASS: POST signal and CSRF, cancelled deletion, row navigation, interactive elements and modified clicks');
