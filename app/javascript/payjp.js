// app/javascript/payjp.js
// Pay.jp v2 Elements を #number-form / #expiry-form / #cvc-form にマウントし、
// トークンを hidden に入れて submit する

const setupPayjp = () => {
  const form = document.getElementById("charge-form");
  if (!form) return; // このページ以外では何もしない

  // 1) 公開鍵を meta から取得
  const meta = document.querySelector('meta[name="payjp-public-key"]');
  const publicKey = meta && meta.content;
  if (!publicKey) {
    console.warn("[PAYJP] public keyが見つかりません（meta[name=payjp-public-key]）");
    return;
  }

  // 2) Payjp & Elements 初期化
  if (!window.Payjp) {
    console.error("[PAYJP] pay.js が読み込まれていません（CDNタグを確認）");
    return;
  }
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const numberElement = elements.create("cardNumber");
  const expiryElement = elements.create("cardExpiry");
  const cvcElement    = elements.create("cardCvc");

  // 3) 指定のIDにマウント（IDが違うと何も表示されません）
  numberElement.mount("#number-form");
  expiryElement.mount("#expiry-form");
  cvcElement.mount("#cvc-form");

  // 4) 送信時にトークン化して hidden に詰めて submit
  form.addEventListener("submit", async (e) => {
    // Elementsの値が未検証なので、とりあえず生成を試みる
    e.preventDefault();

    const { token, error } = await payjp.createToken(numberElement);
    if (error) {
      console.error("[PAYJP] createToken error:", error);
      alert("カード情報が正しくありません。内容をご確認ください。");
      return;
    }

    // hidden にトークンをセット
    const hidden = document.getElementById("card-token");
    if (hidden) hidden.value = token.id;

    // カード入力欄はクリアしてから submit
    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();

    form.submit();
  });
};

// Turbo環境でも動くように
window.addEventListener("turbo:load", setupPayjp);
window.addEventListener("DOMContentLoaded", setupPayjp);
