// 販売価格の手数料・利益を表示（FURIMA仕様）
const setupPriceCalc = () => {
  const priceInput = document.getElementById('item-price');
  const feeEl = document.getElementById('add-tax-price');
  const profitEl = document.getElementById('profit');
  if (!priceInput || !feeEl || !profitEl) return;

  // Turbo再描画時の二重バインド防止
  if (priceInput.dataset.bound === 'true') {
    // 表示だけ再計算しておく
    render();
    return;
  }

  function toHalfWidthNumber(str) {
    return str.replace(/[０-９]/g, (s) =>
      String.fromCharCode(s.charCodeAt(0) - 0xFEE0)
    );
  }

  function render() {
  const raw = toHalfWidthNumber(priceInput.value || '');
  const n = Number(raw.replace(/[^\d]/g, ''));

  if (!Number.isFinite(n)) {
    feeEl.textContent = '';
    profitEl.textContent = '';
    priceInput.classList.remove('is-invalid');
    return;
  }

  const fee = Math.floor(n * 0.1);
  feeEl.textContent = fee.toLocaleString();
  profitEl.textContent = (n - fee).toLocaleString();

  // 範囲外は見た目で無効を示す
  if (n < 300 || n > 9_999_999) {
    priceInput.classList.add('is-invalid');
  } else {
    priceInput.classList.remove('is-invalid');
  }
}

  priceInput.addEventListener('input', render, { passive: true });
  priceInput.addEventListener('change', render, { passive: true });
  priceInput.dataset.bound = 'true';

  // 初期表示
  render();
};

// 初回読み込み & Turboの再描画どちらでも有効化
document.addEventListener('DOMContentLoaded', setupPriceCalc);
document.addEventListener('turbo:load', setupPriceCalc);
document.addEventListener('turbo:render', setupPriceCalc);
