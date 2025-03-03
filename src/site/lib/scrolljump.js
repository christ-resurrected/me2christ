function getH1s() {
  return Array.from(document.getElementsByTagName('h1'))
}

function getYs(h1s) {
  return h1s.map((h1) => h1.getBoundingClientRect().y)
}

function jump(h1s, i) {
  if (i < 0) return
  h1s[i].scrollIntoView({ behavior: 'smooth' })
}

function jumpDown() {
  const h1s = getH1s()
  jump(h1s, getYs(h1s).findIndex((y) => y > 10))
}

function jumpUp() {
  const h1s = getH1s().reverse()
  jump(h1s, getYs(h1s).findIndex((y) => y < -10))
}

// dynamically enable/disable prev/next buttons
addEventListener("DOMContentLoaded", () => {
  const jumpDown = document.getElementsByClassName('jump-down')[0]
  const jumpUp = document.getElementsByClassName('jump-up')[0]

  const obsCallbackTop = ([entry]) => {
    jumpUp.classList.toggle('jump-active', !entry.isIntersecting)
  }
  new IntersectionObserver(obsCallbackTop).observe(getH1s()[0])

  const obsCallbackBottom = ([entry]) => {
    const isAtOrBelowLastH1 = entry.boundingClientRect.top <= 5 && !entry.isIntersecting
    jumpDown.classList.toggle('jump-active', !isAtOrBelowLastH1)
  }
  const obsOpts = { rootMargin: '-5px', threshold: 1.0 }
  new IntersectionObserver(obsCallbackBottom, obsOpts).observe(getH1s().at(-1))
})
