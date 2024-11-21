// ensure iOS overlay scrollbar stays visible when bg color goes from black to white
addEventListener("DOMContentLoaded", () => {
  const UA = navigator.userAgent
  var isIOS = UA.includes('iPad') || UA.includes('iPhone') || UA.includes('iPod')
  if (!isIOS) return

  const B = document.body
  const D = document.documentElement
  const W = window

  var height_total

  function refresh_scrollbar_bg() {
    var scroll_pos = Math.round(D.scrollTop || B.scrollTop)
    var pos = scroll_pos / height_total
    B.style.backgroundColor = (pos < 0.5) ? '#000' : '#fff'
  }

  function refresh_height() {
    height_total = (D.scrollHeight || B.scrollHeight) - W.innerHeight
  }

  // event handlers
  window.addEventListener('orientationchange', refresh_height)
  window.addEventListener('resize', refresh_height)
  window.addEventListener('scroll', refresh_scrollbar_bg)

  // init
  refresh_height()
})
