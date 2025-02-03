addEventListener("DOMContentLoaded", () => {
  const d = document
  const elError = d.querySelector('#error')
  const elFieldset = d.querySelector('fieldset')
  const elSubmit = d.querySelector('#submit')

  document.forms[0].addEventListener('submit', (e) => {
    e.preventDefault()
    elError.innerHTML = ''
    req = { method: 'POST', body: new URLSearchParams(new FormData(e.target)) }
    elFieldset.disabled = true // must disable AFTER getting FormData
    elSubmit.classList.add('spinner')
    fetch(e.target.action, req).then(handleResponse).then(handleResponseText).then(showSuccess).catch(showError)
  });

  function handleResponse(res) { return res.text() }
  function handleResponseText(t) { if (t != 'OK') throw new Error(t) }

  function showError(err) {
    elError.innerHTML = err
    elFieldset.disabled = false
    elSubmit.classList.remove('spinner')
  }

  function showSuccess() {
    elFieldset.style.display = 'none'
    d.querySelector('#success').style.display = 'block'
  }
})
