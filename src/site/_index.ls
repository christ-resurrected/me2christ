<- document.addEventListener \DOMContentLoaded

b = document.body
h = document.documentElement
l = b.querySelector \.light
m = b.querySelector \.main
o = b.querySelector \.outro

var total-height # for efficiency, only calculated on window resize
var MAP_ALL # array of lightburst intensity at each scroll position, 0=dark, 1=light

function burst
  const SCALE_MAX = 5 # max lightburst scale
  scrollpos = Math.round (h.scrollTop||b.scrollTop)
  scale = MAP_ALL[scrollpos] * SCALE_MAX
  l.style.transform = "scale(#scale, #scale)"
  m.style.opacity = scale

function refresh-height
  total-height := (h.scrollHeight||b.scrollHeight) - h.clientHeight

  const LEN_MAP   = total-height # divide full height into this many units
  const LEN_INTRO = 100
  const LEN_RAMP  = 800 # controls light to/from dark transition speed
  const LEN_OUTRO = 600
  const LEN_MAIN  = LEN_MAP - LEN_INTRO - LEN_OUTRO - (LEN_RAMP * 2)
  const MAP_INTRO = [0] * LEN_INTRO
  const MAP_UP    = [x / LEN_RAMP for x to LEN_RAMP]
  const MAP_MAIN  = [1] * LEN_MAIN
  const MAP_DOWN  = MAP_UP.slice!reverse!
  const MAP_OUTRO = [0] * LEN_OUTRO

  MAP_ALL := MAP_INTRO ++ MAP_UP ++ MAP_MAIN ++ MAP_DOWN ++ MAP_OUTRO

# event handlers
window.onresize = refresh-height
window.onscroll = burst
for el in b.getElementsByTagName \details then el.ontoggle = refresh-height

# init
refresh-height!
