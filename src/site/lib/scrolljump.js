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

function setActiveJump(sel, active) {
  document.querySelector(sel).classList.toggle('jump-active', active)
}

function setActiveJumpDown(active) {
  setActiveJump('.jump-down', active)
}

function setActiveJumpUp(active) {
  setActiveJump('.jump-up', active)
}

// dynamically enable/disable prev/next buttons
addEventListener("DOMContentLoaded", () => {
  const obsCallbackTop = ([entry]) => {
    setActiveJumpUp(!entry.isIntersecting)
  }
  new IntersectionObserver(obsCallbackTop).observe(getH1s()[0])

  const obsCallbackBottom = ([entry]) => {
    const isAtOrBelowLastH1 = entry.boundingClientRect.top <= 5 && !entry.isIntersecting
    setActiveJumpDown(!isAtOrBelowLastH1)
  }
  const obsOpts = { rootMargin: '-5px', threshold: 1.0 }
  new IntersectionObserver(obsCallbackBottom, obsOpts).observe(getH1s().at(-1))

  // FIX/HACK: make :active pseudoclass work in iOS safari
  // see https://stackoverflow.com/questions/6063308/touch-css-pseudo-class-or-something-similar
  // Adding 'ontouchstart' attribute to body doesn't work because it gets removed by PostHtml optimisations
  document.addEventListener('touchstart', function() { }, false);
})

// ensure jump-down button remains disabled if page is refreshed at bottom of page
addEventListener('load', () => {
  const lastH1 = getH1s().at(-1)
  function onScroll() {
    window.removeEventListener('scroll', onScroll)
    isAtOrBelowLastH1 = lastH1.getBoundingClientRect().top <= 5
    setActiveJumpDown(!isAtOrBelowLastH1)
  }

  window.addEventListener('scroll', onScroll)
})
