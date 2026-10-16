document.addEventListener('click', function (event) {
    const link = event.target.closest('a[href]');
    if (!link) {
        if (event.defaultPrevented || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || event.button > 0) return;
        if (event.target.closest('button, input, select, textarea, label')) return;
        const row = event.target.closest('tr[data-href]');
        if (row) {
            const destination = new URL(row.dataset.href, window.location.href);
            if (destination.origin === location.origin) window.location.assign(destination.href);
        }
        return;
    }
    const url = new URL(link.href, window.location.href);
    if (url.origin !== location.origin || !url.searchParams.has('do')) return;
    event.preventDefault();
    event.stopImmediatePropagation();
    const question = link.dataset.netteConfirmText;
    if (question && !window.confirm(question)) return;
    const form = document.createElement('form');
    form.method = 'post';
    form.action = url.href;
    const token = document.createElement('input');
    token.type = 'hidden';
    token.name = '_requestToken';
    token.value = document.querySelector('meta[name="request-token"]').content;
    form.appendChild(token);
    document.body.appendChild(form);
    form.submit();
}, true);

document.addEventListener('DOMContentLoaded', function() {

    naja.initialize();

    const barcodeInput = document.querySelector('input[id$="-BarCode"]');

    function focusBarcodeInput() {
        if (!barcodeInput) {
            return;
        }

        setTimeout(function () {
            barcodeInput.focus();
        }, 100);
    }

    // Fokus po načtení stránky
    focusBarcodeInput();

    // Fokus po zavření Bootstrap alertu
    document.querySelectorAll('.flash-modal').forEach(function (modalEl) {
        modalEl.addEventListener('hide.bs.modal', function () {
            if (document.activeElement && modalEl.contains(document.activeElement)) {
                document.activeElement.blur();
            }
        });

        modalEl.addEventListener('hidden.bs.modal', function () {
            focusBarcodeInput();
        });

        const modal = new bootstrap.Modal(modalEl);
        modal.show();
    });

}, false);
