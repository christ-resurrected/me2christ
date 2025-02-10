function countText(id) {
  const el = document.getElementById(id)
  const len = el.value.length
  const maxlen = el.getAttribute('maxlength')
  const elCount = document.getElementById(`${id}-count`)
  elCount.innerText = `${len}/${maxlen}`
  elCount.classList.toggle('warn', len / maxlen > 0.8)
}
