Chalk     = require \chalk
Htmlnano  = require \htmlnano
Posthtml  = require \posthtml
PostBool  = require \posthtml-boolean-attributes # e.g. <input required>
PostImgAS = require \posthtml-img-autosize # add img width and height, to pass lighthouse tests
Dir       = require \./constants .DIR
Flag      = require \./flag

module.exports = (html) ->>
  plugins =
    * PostBool!
    * PostImgAS {processEmptySize:true, root:Dir.SRC_SITE}
  plugins.push Htmlnano! if Flag.prod

  new Promise (resolve, reject) ->>
    #
    # Posthtml seems to clean up the following pug issues...
    #
    # - invalid </input> end tag
    # - invalid <img/> self-closing tag (perhaps)
    #
    Posthtml(plugins).process(html).then(ok).catch(reject)

    function ok
      if Flag.prod
        delta = html.length - it.html.length
        percent = (100 * delta / html.length).toFixed 2
        log Chalk.yellow "Reduced html by #{delta.toLocaleString!} bytes (#percent%)"
      resolve it.html
