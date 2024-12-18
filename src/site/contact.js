addEventListener("DOMContentLoaded", () => {
  const elError = document.getElementById('error')
  const elFieldset = document.getElementsByTagName('fieldset')[0]

  document.forms[0].addEventListener('submit', (event) => {
    event.preventDefault()
    elError.style.display = 'none'
    elFieldset.disabled = true
    req = { method: 'POST', body: new URLSearchParams(new FormData(event.target)) }
    fetch(event.target.action, req).then(handleResponse).then(handleResponseText).then(showSuccess).catch(showError);
  });

  function handleResponse(res) { return res.text() }
  function handleResponseText(t) { if (t != 'OK') throw new Error(t) }

  function showError(e) {
    elError.innerHTML = e
    elError.style.display = 'block'
    elFieldset.disabled = false
  }

  function showSuccess() {
    elFieldset.style.display = 'none'
    document.getElementById('success').style.display = 'block'
  }
})
