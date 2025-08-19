document.addEventListener("turbo:load", () => {
  const form = document.getElementById("charge-form");
  if (!form) return;

  const publicKey = document
    .querySelector('meta[name="payjp-public-key"]')
    ?.getAttribute("content");

  if (!publicKey || !window.Payjp) return;

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const numberElement = elements.create("cardNumber");
  numberElement.mount("#number-form");

  const expiryElement = elements.create("cardExpiry");
  expiryElement.mount("#expiry-form");

  const cvcElement = elements.create("cardCvc");
  cvcElement.mount("#cvc-form");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const { id, error } = await payjp.createToken(numberElement);
    if (error) {
      alert(error.message);
      return;
    }
    document.getElementById("card-token").value = id;
    form.submit();
  });
});
