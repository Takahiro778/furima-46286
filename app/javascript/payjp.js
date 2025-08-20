// この関数が全体の処理をまとめる
const bootPayjp = () => {
  // 1. フォームと公開鍵の存在を確認
  const form = document.getElementById('charge-form');
  if (!form) {
    return; // フォームがなければ何もしない
  }
  // gonが未定義、または公開鍵がなければ処理を中断
  if (typeof gon === 'undefined' || !gon.public_key) {
    return;
  }

  // 2. Pay.jpの初期化
  const payjp = Payjp(gon.public_key);

  // 3. Pay.jp Elementsのインスタンスを作成
  const elements = payjp.elements();

  // 4. 各カード情報入力フォームを作成
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // 5. 作成したフォームをHTML上の対応するdiv要素にマウント
  numberElement.mount('#card-number');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  // 6. フォームの送信イベントを監視
  form.addEventListener('submit', (e) => {
    e.preventDefault(); // Railsのフォーム送信を一旦停止

    const submitBtn = document.getElementById('button');
    if (submitBtn) submitBtn.disabled = true;

    // 7. Pay.jpにカード情報を送信してトークンを生成
    payjp.createToken(numberElement).then((response) => {
      // response.error が存在すれば、トークン生成に失敗したことを意味する
      if (response.error) {
        // カリキュラムの仕様に基づき、ここではエラーを表示せず、
        // トークンが空のままフォームを送信し、サーバーサイドのバリデーションに任せる。
      } else {
        // トークン生成成功時
        const token = response.id;
        const hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'token');
        hiddenInput.setAttribute('value', token);
        form.appendChild(hiddenInput);
      }

      // セキュリティのため、カード情報をクリア
      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();

      // トークンの有無にかかわらず、フォームの送信を再開
      form.submit();
    });
  });
};

// 8. ページ読み込み時とTurboによる遷移時にbootPayjp関数を実行
document.addEventListener('turbo:load', bootPayjp);
document.addEventListener('DOMContentLoaded', bootPayjp);

