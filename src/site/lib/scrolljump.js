function getH1s() {
  return Array.from(document.getElementsByTagName('h1'))
}

function getYs(h1s) {
  return h1s.map((h1) => h1.getBoundingClientRect().y)
}

function jumpNext() {
  const h1s = getH1s()
  const ys = getYs(h1s)
  let i = ys.findIndex((y) => y > 0)
  if (i < 0) return
  h1s[i].scrollIntoView({
    behavior: 'smooth'
  })
}

function jumpPrev() {
  const h1s = getH1s().reverse()
  const ys = getYs(h1s)
  let i = ys.findIndex((y) => y < 0)
  if (i < 0) return
  h1s[i].scrollIntoView({
    behavior: 'smooth'
  })
}
