// app/javascript/payjp.js
const setupPayjp = () => {
  const form = document.getElementById('charge-form');
  if (!form) return;

  // ビューから公開鍵を取得（data-public-key）
  const publicKey = form.dataset.publicKey;
  if (!publicKey) {
    console.error('[PAYJP] 公開鍵が見つかりません');
    return;
  }

  // PAY.JP 初期化
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  // Elements を作成して指定のDIVにマウント
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement    = elements.create('cardCvc');

  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  // 送信時の処理
  form.addEventListener('submit', async (e) => {
    // Turbo対策で二重送信されやすいのでまず止める
    e.preventDefault();

    // トークン生成
    const { error, id: token } = await payjp.createToken(numberElement);

    if (error) {
      console.error('[PAYJP] token error:', error);
      alert('カード情報に不備があります。再入力してください。');
      return;
    }

    // hidden input を差し込む（Formオブジェクトの名前に合わせる）
    const tokenInput = document.createElement('input');
    tokenInput.setAttribute('type', 'hidden');
    tokenInput.setAttribute('name', 'order_shipping_address[token]');
    tokenInput.setAttribute('value', token);
    form.appendChild(tokenInput);

    // カード入力欄は空に
    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();

    // ここで初めて送信
    form.submit();
  });
};

// Turbo環境下でも発火するように
window.addEventListener('turbo:load', setupPayjp);
window.addEventListener('DOMContentLoaded', setupPayjp);
