Chalk = require \chalk
Cp    = require \child_process
Fs    = require \fs
P     = require \path
Dir   = require \./constants .DIR

module.exports = (t, ipath) ->
  new Promise (resolve, reject) ->>
    odir = P.dirname P.resolve (t.out || Dir.BUILD), P.relative Dir.SRC, ipath
    if !Fs.existsSync odir then Fs.mkdirSync odir, recursive:true

    run-cmd = ->>
      log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$ODIR odir)
      cmd = (args = cmd.split ' ').splice 0 1 # splice alters args and returns the removed item
      cp = Cp.spawn cmd.0, args, stdio:\inherit # use spawn rather than exec to preserve colors
      cp.on \close (code) -> if code is 0 then resolve! else reject!

    run-fn = ->>
      try
        opath = P.resolve odir, P.basename ipath.replace /\.pug$/ ".#{t.oxt}"
        await t.fun ipath, opath
        resolve!
      catch err then reject err

    if t.fun then run-fn! else run-cmd!
