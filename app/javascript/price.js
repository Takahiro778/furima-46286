// 販売価格の手数料・利益を表示
const setupPriceCalc = () => {
  const priceInput = document.getElementById("item-price");
  const feeEl = document.getElementById("add-tax-price");
  const profitEl = document.getElementById("profit");
  if (!priceInput || !feeEl || !profitEl) return;

  const render = () => {
    const v = Number(priceInput.value);
    if (!Number.isInteger(v) || v < 300 || v > 9999999) {
      feeEl.textContent = "";
      profitEl.textContent = "";
      return;
    }
    const fee = Math.floor(v * 0.1);
    feeEl.textContent = fee;
    profitEl.textContent = v - fee;
  };

  priceInput.addEventListener("input", render);
  render(); // ← 初期表示（エラー戻り時も反映）
};

// Turbo / 非Turbo 両対応
document.addEventListener("turbo:load", setupPriceCalc);
document.addEventListener("DOMContentLoaded", setupPriceCalc);
