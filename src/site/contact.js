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

  function handleResponse(res) {
    disableUI(false)
    if (res.status == 200) { elFieldset.style.display = 'none'; elSuccess.style.display = 'block' }
    else res.text().then((text) => elError.innerHTML = text)
  }

  function disableUI(disabled) {
    elFieldset.disabled = disabled
    elSubmit.classList.toggle('spinner', disabled)
  }
})
