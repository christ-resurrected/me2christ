function countText(id) {
  const el = document.getElementById(id)
  const len = el.value.length
  const maxlen = el.getAttribute('maxlength')
  const elCount = document.getElementById(`${id}-count`)
  elCount.innerText = `${len}/${maxlen}`
  elCount.classList.remove('error', 'warn')
  if (len / maxlen > 0.8) elCount.classList.add('warn')
  if (len == maxlen) elCount.classList.add('error')
}
