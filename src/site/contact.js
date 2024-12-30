addEventListener("DOMContentLoaded", () => {
  const elError = document.getElementById('error')
  const elFieldset = document.getElementsByTagName('fieldset')[0]
  const elSubmit = document.getElementById('submit')

  document.forms[0].addEventListener('submit', (e) => {
    e.preventDefault()
    elError.style.display = 'none'
    req = { method: 'POST', body: new URLSearchParams(new FormData(e.target)) }
    elFieldset.disabled = true // must disable AFTER getting FormData
    elSubmit.classList.add('spinner')
    fetch(e.target.action, req).then(handleResponse).then(handleResponseText).then(showSuccess).catch(showError)
  });

  function handleResponse(res) { return res.text() }
  function handleResponseText(t) { if (t != 'OK') throw new Error(t) }

  function showError(err) {
    elError.innerHTML = err
    elError.style.display = 'block'
    elFieldset.disabled = false
    elSubmit.classList.remove('spinner')
  }

  function showSuccess() {
    elFieldset.style.display = 'none'
    document.getElementById('success').style.display = 'block'
  }
})
