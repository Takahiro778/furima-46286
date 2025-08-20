const bootPayjp = () => {
  const form = document.getElementById('charge-form');
  if (!form) return;

  if (typeof Payjp === 'undefined') {
    console.warn('[PAYJP] pay.js が読み込まれていません');
    return;
  }

  // gon から公開鍵取得
  const publicKey = (window.gon && (gon.payjp_public_key || gon.public_key)) || null;
  if (!publicKey) {
    console.warn('[PAYJP] 公開鍵が取得できません (gon.payjp_public_key / gon.public_key)');
    return;
  }

  // すでにマウント済みなら二重実行しない
  if (document.getElementById('card-number').dataset.mounted) return;

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  // mountメソッドにはCSSセレクタ文字列を渡す
  const numberElement = elements.create('cardNumber');
  numberElement.mount('#card-number');

  const expiryElement = elements.create('cardExpiry');
  expiryElement.mount('#expiry-form');

  const cvcElement = elements.create('cardCvc');
  cvcElement.mount('#cvc-form');

  // マウント済みの目印を付ける
  document.getElementById('card-number').dataset.mounted = 'true';

  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    // ボタンを無効化して二重送信を防ぐ
    const submitButton = form.querySelector('input[type="submit"]');
    submitButton.disabled = true;

    const { token, error } = await payjp.createToken(numberElement);
    if (error) {
      const err = document.getElementById('card-errors');
      if (err) err.textContent = error.message;
      console.warn('[PAYJP] token作成エラー', error);
      // エラー発生時はボタンを再度有効化
      submitButton.disabled = false;
      return;
    }

    // 既存のhiddenフィールドにトークンをセット
    const tokenInput = document.getElementById('card-token');
    if (!tokenInput) {
      console.error('Token input field #card-token not found.');
      submitButton.disabled = false;
      return;
    }
    tokenInput.value = token.id;

    form.submit();
  });
};

// Turboでの遷移に対応（両方拾う）
document.addEventListener('turbo:load',   bootPayjp);
document.addEventListener('turbo:render', bootPayjp);
