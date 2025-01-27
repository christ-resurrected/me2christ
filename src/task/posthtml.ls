Posthtml  = require \posthtml
PostImgAS = require \posthtml-img-autosize
Dir       = require \./constants .dir

module.exports = ->> Posthtml!use(PostImgAS {processEmptySize:true, root:Dir.SRC_SITE}).process it
