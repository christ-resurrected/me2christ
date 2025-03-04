function getLastH1() { return document.querySelector('.cards:last-of-type h1') }
function getH1s() { return Array.from(document.getElementsByTagName('h1')) }
function getYs(h1s) { return h1s.map((h1) => h1.getBoundingClientRect().y) }
function jump(h1s, i) { if (i >= 0) h1s[i].scrollIntoView({ behavior: 'smooth' }) }
function jumpDown() { const h1s = getH1s(); jump(h1s, getYs(h1s).findIndex((y) => y > 10)) }
function jumpUp() { const h1s = getH1s().reverse(); jump(h1s, getYs(h1s).findIndex((y) => y < -10)) }
function toggleJump(sel, enable) { document.querySelector(sel).classList.toggle('jump-enabled', enable) }
function toggleJumpDown(enable) { toggleJump('.jump-down', enable) }

// dynamically enable/disable jump up/down buttons
addEventListener('DOMContentLoaded', () => {
  const obsCallbackTop = ([entry]) => { toggleJump('.jump-up', !entry.isIntersecting) }
  new IntersectionObserver(obsCallbackTop).observe(document.querySelector('h1'))

  const obsCallbackBottom = ([entry]) => { toggleJumpDown(entry.boundingClientRect.top > 5 || entry.isIntersecting) }
  new IntersectionObserver(obsCallbackBottom, { rootMargin: '-5px', threshold: 1.0 }).observe(getLastH1())

  // FIX/HACK: make :active pseudoclass work in iOS safari
  // see https://stackoverflow.com/questions/6063308/touch-css-pseudo-class-or-something-similar
  // Adding 'ontouchstart' attribute to body doesn't work because it gets removed by PostHtml optimisations
  document.addEventListener('touchstart', function() { }, false);
})

// ensure jump-down button remains disabled if page is refreshed at bottom of page
addEventListener('load', () => {
  function onScroll() {
    window.removeEventListener('scroll', onScroll)
    toggleJumpDown(getLastH1().getBoundingClientRect().top > 5)
  }

  window.addEventListener('scroll', onScroll)
})
