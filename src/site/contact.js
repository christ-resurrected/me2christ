addEventListener("DOMContentLoaded", () => {
  const d = document
  const elError = d.querySelector('#error')
  const elFieldset = d.querySelector('fieldset')
  const elSubmit = d.querySelector('#submit')
  const elSuccess = d.querySelector('#success')

  document.forms[0].addEventListener('submit', (e) => {
    e.preventDefault()
    elError.innerHTML = ''
    req = { method: 'POST', body: new URLSearchParams(new FormData(e.target)) }
    disableUI(true) // must happen AFTER reading form!
    fetch(e.target.action, req).then(handleResponse)
  });

  function disableUI(disabled) {
    elFieldset.disabled = disabled
    elSubmit.classList.toggle('spinner', disabled)
  }

  function handleResponse(res) {
    disableUI(false)
    res.text().then((text) => (res.status == 200 ? elSuccess : elError).innerHTML = text)
  }
})
