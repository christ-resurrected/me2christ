module.exports = me =
  prod: process.env.NODE_ENV is \production
  toggle-prod: -> me.prod = not me.prod
