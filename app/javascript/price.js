document.addEventListener('turbo:load', () => {
  const input  = document.getElementById('item-price');
  const feeEl  = document.getElementById('add-tax-price');
  const profEl = document.getElementById('profit');
  if (!input || !feeEl || !profEl) return;

  input.addEventListener('input', () => {
    const v = Number(input.value);
    if (!Number.isInteger(v) || v < 300 || v > 9999999) {
      feeEl.textContent  = '';
      profEl.textContent = '';
      return;
    }
    const fee = Math.floor(v * 0.1); // 販売手数料10%（切り捨て）
    feeEl.textContent  = fee;
    profEl.textContent = v - fee;
  });
});
