Htmlnano  = require \htmlnano
Posthtml  = require \posthtml
PostImgAS = require \posthtml-img-autosize
Dir       = require \./constants .dir
Flag      = require \./flag

module.exports = ->>
  plugins = [PostImgAS {processEmptySize:true, root:Dir.SRC_SITE}]
  plugins.push Htmlnano! if Flag.prod
  Posthtml(plugins).process it
