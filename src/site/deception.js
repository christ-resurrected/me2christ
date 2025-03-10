// https://stackoverflow.com/questions/7717527/smooth-scrolling-when-clicking-an-anchor-link
addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    if (anchor.attributes['href'].nodeValue.length > 1) {
      anchor.addEventListener('click', function(e) {
        e.preventDefault()
        document.querySelector(this.getAttribute('href')).scrollIntoView({
          behavior: 'smooth'
        })
      })
    }
  })
})
