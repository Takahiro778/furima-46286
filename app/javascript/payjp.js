const bootPayjp = () => {
  const form = document.getElementById('charge-form');
  // フォームが存在しないページでは処理を終了
  if (!form) return;

  // Pay.jpライブラリが読み込まれていない場合は処理を終了
  if (typeof Payjp === 'undefined') {
    console.warn('[PAYJP] pay.js が読み込まれていません');
    return;
  }

  // gonから公開鍵を取得
  const publicKey = window.gon && gon.payjp_public_key;
  if (!publicKey) {
    console.warn('[PAYJP] 公開鍵が取得できません (gon.payjp_public_key)');
    return;
  }

  // イベントリスナーの二重登録を防止
  if (form.dataset.listenerAttached) return;
  form.dataset.listenerAttached = 'true';

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  numberElement.mount('#card-number');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const submitButton = form.querySelector('input[type="submit"]');
    submitButton.disabled = true;

    payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        const err = document.getElementById('card-errors');
        if (err) err.textContent = response.error.message;
        submitButton.disabled = false;
      } else {
        const tokenInput = document.getElementById('card-token');
        if (tokenInput) tokenInput.value = response.id;
        form.submit();
      }
    });
  });
};

document.addEventListener('turbo:load', bootPayjp);
