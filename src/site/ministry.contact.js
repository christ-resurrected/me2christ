addEventListener("DOMContentLoaded", () => {
  function el(sel) { return document.querySelector(sel) }

  document.forms[0].addEventListener('submit', (e) => {
    e.preventDefault()
    el('#error').innerHTML = ''
    req = { method: 'POST', body: new FormData(e.target), signal: AbortSignal.timeout(10000) }
    disableUI(true) // must happen AFTER reading form!
    fetch(e.target.action, req).then(handleResponse).catch(handleError)
  });

  function disableUI(disabled) {
    el('fieldset').disabled = disabled
    el('button').classList.toggle('spinner', disabled)
  }

  function handleError(res) {
    disableUI(false)
    el('#error').innerHTML = res
  }

  function handleResponse(res) {
    disableUI(false)
    res.text().then((text) => (res.status == 200 ? el('#success') : el('#error')).innerHTML = text)
  }
})
