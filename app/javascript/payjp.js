const setupPayjp = () => {
  const form = document.getElementById("charge-form");
  if (!form) return;                     // 対象ページ以外は何もしない

  // ★ すでに初期化済みなら抜ける（ページ遷移でも安全）
  if (form.dataset.payjpMounted === "1") return;
  form.dataset.payjpMounted = "1";

  const meta = document.querySelector('meta[name="payjp-public-key"]');
  const publicKey = meta && meta.content;
  if (!publicKey) {
    console.warn("[PAYJP] public key が見つかりません（meta[name=payjp-public-key]）");
    return;
  }

  if (!window.Payjp) {
    console.error("[PAYJP] pay.js が読み込まれていません（CDNタグを確認）");
    return;
  }

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const numberElement = elements.create("cardNumber");
  const expiryElement = elements.create("cardExpiry");
  const cvcElement    = elements.create("cardCvc");

  numberElement.mount("#number-form");
  expiryElement.mount("#expiry-form");
  cvcElement.mount("#cvc-form");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const { token, error } = await payjp.createToken(numberElement);
    if (error) {
      console.error("[PAYJP] createToken error:", error);
      alert("カード情報が正しくありません。内容をご確認ください。");
      return;
    }
    const hidden = document.getElementById("card-token");
    if (hidden) hidden.value = token.id;

    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();
    form.submit();
  });
};

// ★ Turbo/非Turbo どちらでも一度だけ起動
document.addEventListener("turbo:load", setupPayjp);
document.addEventListener("DOMContentLoaded", setupPayjp);
