addEventListener("DOMContentLoaded", () => {
  const elError = document.getElementById('error')
  const elSubmit = document.getElementById('submit')

  document.forms['contact'].addEventListener('submit', (event) => {
    hideError();
    event.preventDefault();
    elSubmit.disabled = true
    req = { method: 'POST', body: new URLSearchParams(new FormData(event.target)) }
    fetch(event.target.action, req).then(handleResponse).then(showSuccess).catch(showError);
  });

  function handleResponse(res) {
    elSubmit.disabled = false
    if (!res.ok) throw new Error(`${res.statusText} ${res.status}`);
    // return res.text();
  }

  function hideError() {
    elError.innerHTML = ''
    elError.style.display = 'none'
  }

  function showError(error) {
    console.error(error)
    elError.innerHTML = error
    elError.style.display = 'block'
  }

  function showSuccess() {
    document.getElementById('contact').style.display = 'none'
    document.getElementById('success').style.display = 'block'
  }
})
