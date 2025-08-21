// app/javascript/price.js
// 販売価格の手数料・利益を表示（FURIMA仕様）
const price = () => {
  const priceInput = document.getElementById("item-price");
  const feeEl      = document.getElementById("add-tax-price");
  const profitEl   = document.getElementById("profit");
  if (!priceInput || !feeEl || !profitEl) return;

  const toHalfWidthNumber = (str) =>
    str.replace(/[０-９]/g, (s) => String.fromCharCode(s.charCodeAt(0) - 0xFEE0));

  const render = () => {
    const raw = toHalfWidthNumber(priceInput.value || "");
    const n = Number(raw.replace(/[^\d]/g, "")); // 数字以外除去
    if (!Number.isInteger(n) || n < 300 || n > 9_999_999) {
      feeEl.textContent = "";
      profitEl.textContent = "";
      return;
    }
    const fee = Math.floor(n * 0.1);
    feeEl.textContent = String(fee);
    profitEl.textContent = String(n - fee);
  };

  // Turbo再描画時の二重バインド防止（renderはこの位置より上で定義済み）
  if (priceInput.dataset.bound === "true") {
    render(); // 表示だけ更新
    return;
  }

  priceInput.addEventListener("input", render, { passive: true });
  priceInput.addEventListener("change", render, { passive: true });
  priceInput.dataset.bound = "true";
  render(); // 初期表示
};

// ページの初回読み込み、またはTurboでの画面遷移のいずれでもprice関数を実行する
window.addEventListener("turbo:load", price);
window.addEventListener("DOMContentLoaded", price);