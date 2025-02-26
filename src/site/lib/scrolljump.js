function getH1s() {
  return Array.from(document.getElementsByTagName('h1'))
}

function getYs(h1s) {
  return h1s.map((h1) => h1.getBoundingClientRect().y)
}

function jumpTo(h1s, i) {
  if (i < 0) return
  h1s[i].scrollIntoView({ behavior: 'smooth' })
}

function jumpNext() {
  const h1s = getH1s()
  jumpTo(h1s, getYs(h1s).findIndex((y) => y > 0))
}

function jumpPrev() {
  const h1s = getH1s().reverse()
  jumpTo(h1s, getYs(h1s).findIndex((y) => y < 0))
}
