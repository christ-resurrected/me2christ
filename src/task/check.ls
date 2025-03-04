Chalk = require \chalk
Https = require \https
Tpug  = require \./task-pug

module.exports =
  check-external-links: ->>
    n = (xlinks = [...Tpug.external-links]).length
    return log "Run build first" if n is 0
    log Chalk.yellow "Check #n external links..."
    await res = Promise.allSettled [check-url url for url in xlinks]
    log \done!

function check-url url then new Promise (resolve, reject) ->
  Https.get url, ->
    code = it.statusCode
    color = switch
    | code >= 200 && code < 300 then Chalk.green
    | code >= 400 && code < 500 then Chalk.red
    | otherwise Chalk.yellow
    log color "#{code = it.statusCode} from #url"
    if color is Chalk.red then reject! else resolve!
