addEventListener("DOMContentLoaded", () => {
  function el(sel) { return document.querySelector(sel) }

  function disableUI(disabled) {
    el('fieldset').disabled = disabled
    el('button').classList.toggle('spinner', disabled)
  }

  document.forms[0].addEventListener('submit', async (e) => {
    try {
      e.preventDefault()
      el('#error').innerHTML = ''
      req = { method: 'POST', body: new FormData(e.target), signal: AbortSignal.timeout(10000) }
      disableUI(true) // must happen AFTER reading form!
      res = await fetch(e.target.action, req)
      disableUI(false)
      text = await res.text();
      (res.status == 200 ? el('#success') : el('#error')).innerHTML = text
    }
    catch (err) {
      disableUI(false)
      el('#error').innerHTML = err
    }
  });
})
