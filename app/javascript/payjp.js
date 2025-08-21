// app/javascript/payjp.js

// 画面ごとに初期化（Turbo再描画にも対応）
const bootPayjp = () => {
  // 対象フォームが無ければ何もしない
  const form = document.getElementById('charge-form');
  if (!form) return;

  // 入力パーツのコンテナが無ければ何もしない（他ページ安全）
  if (!document.getElementById('card-number')) return;
  if (!document.getElementById('expiry-form')) return;
  if (!document.getElementById('cvc-form')) return;

  // 二重初期化の防止（Turbo再描画でもOK）
  if (form.dataset.payjpInitialized === 'true') return;
  form.dataset.payjpInitialized = 'true';

  // 公開鍵チェック（gon使用）
  if (typeof gon === 'undefined' || !gon.public_key) return;

  // Pay.jp初期化
  const payjp = Payjp(gon.public_key);
  const elements = payjp.elements();

  // 分割入力のElementsを作成
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement    = elements.create('cardCvc');

  // マウント
  numberElement.mount('#card-number');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  // 送信時にトークン化
  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const submitBtn = document.getElementById('button');
    if (submitBtn) submitBtn.disabled = true;

    payjp.createToken(numberElement).then((response) => {
      if (!response.error) {
        // トークンをhiddenで埋め込む
        const tokenInput = document.createElement('input');
        tokenInput.type  = 'hidden';
        tokenInput.name  = 'token';
        tokenInput.value = response.id;
        form.appendChild(tokenInput);
      }
      // セキュリティのため必ず消去
      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();

      // トークン有無に関わらずサーバー側で検証
      form.submit();
    });
  }, { once: true }); // 念のため多重バインド防止
};

// 初期化フック（Turbo完全対応）
document.addEventListener('turbo:load',   bootPayjp);
document.addEventListener('turbo:render', bootPayjp);
// フォールバック（非Turbo遷移用）
document.addEventListener('DOMContentLoaded', bootPayjp);
