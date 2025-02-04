addEventListener("DOMContentLoaded", () => {
  function el(sel) { return document.querySelector(sel) }

  document.forms[0].addEventListener('submit', (e) => {
    e.preventDefault()
    el('#error').innerHTML = ''
    req = { method: 'POST', body: new URLSearchParams(new FormData(e.target)) }
    disableUI(true) // must happen AFTER reading form!
    fetch(e.target.action, req).then(handleResponse)
  });

  function disableUI(disabled) {
    el('fieldset').disabled = disabled
    el('button').classList.toggle('spinner', disabled)
  }

  function handleResponse(res) {
    disableUI(false)
    res.text().then((text) => (res.status == 200 ? el('#success') : el('#error')).innerHTML = text)
  }
})
