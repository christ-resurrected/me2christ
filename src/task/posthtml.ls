Chalk     = require \chalk
Htmlnano  = require \htmlnano
Posthtml  = require \posthtml
PostImgAS = require \posthtml-img-autosize
Dir       = require \./constants .dir
Flag      = require \./flag

module.exports = (html) ->>
  plugins = [PostImgAS {processEmptySize:true, root:Dir.SRC_SITE}]
  plugins.push Htmlnano! if Flag.prod

  new Promise (resolve, reject) ->>
    Posthtml(plugins).process(html).then(ok).catch(reject)

    function ok
      if Flag.prod
        delta = html.length - it.html.length
        percent = (100 * delta / html.length).toFixed 2
        log Chalk.yellow "Reduced html by #{delta.toLocaleString!} bytes (#percent%)"
      resolve it.html
