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
  jumpTo(h1s, getYs(h1s).findIndex((y) => y > 10))
}

function jumpPrev() {
  const h1s = getH1s().reverse()
  jumpTo(h1s, getYs(h1s).findIndex((y) => y < -10))
}

addEventListener("DOMContentLoaded", () => {
  // show 'prev' if not at or above first h1
  const obsCallbackTop = ([entry]) => {
    document.body.classList.toggle('scrolljump-prev', !entry.isIntersecting)
  }
  new IntersectionObserver(obsCallbackTop).observe(getH1s()[0])

  // show 'next' if not at or below last h1
  const obsCallbackBottom = ([entry]) => {
    const isAtOrBelowLastH1 = entry.boundingClientRect.top <= 5 && !entry.isIntersecting
    document.body.classList.toggle('scrolljump-next', !isAtOrBelowLastH1)
  }
  const obsOpts = { rootMargin: '-5px', threshold: 1.0 }
  new IntersectionObserver(obsCallbackBottom, obsOpts).observe(getH1s().at(-1))
})
