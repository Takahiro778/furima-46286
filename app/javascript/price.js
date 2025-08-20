// 販売価格の手数料・利益を表示（FURIMA仕様）
// 10%手数料を切り捨て、利益 = 価格 - 手数料
const price = () => {
  const priceInput = document.getElementById("item-price");
  const feeEl      = document.getElementById("add-tax-price");
  const profitEl   = document.getElementById("profit");
  if (!priceInput || !feeEl || !profitEl) return;

  // Turbo再描画時の二重バインド防止
  if (priceInput.dataset.bound === "true") {
    render(); // 表示だけ更新
    return;
  }

  const toHalfWidthNumber = (str) =>
    str.replace(/[０-９]/g, (s) => String.fromCharCode(s.charCodeAt(0) - 0xfee0));

  const render = () => {
    const raw = toHalfWidthNumber(priceInput.value || "");
    const n = Number(raw.replace(/[^\d]/g, "")); // 数字以外除去
    if (!Number.isInteger(n) || n < 300 || n > 9999999) {
      feeEl.textContent = "";
      profitEl.textContent = "";
      return;
    }
    const fee = Math.floor(n * 0.1);
    feeEl.textContent = String(fee);
    profitEl.textContent = String(n - fee);
  };

  priceInput.addEventListener("input", render, { passive: true });
  priceInput.addEventListener("change", render, { passive: true });
  priceInput.dataset.bound = "true";
  render(); // 初期表示（バリデーション失敗で戻ってきた時も反映）
};

// Turbo / 非Turbo 両対応
window.addEventListener("turbo:load",   price);
window.addEventListener("turbo:render", price);
document.addEventListener("DOMContentLoaded", price);
