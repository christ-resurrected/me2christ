Chalk = require \chalk
Fs    = require \fs
Glob  = require \glob .globSync
Match = require \minimatch .minimatch
Path  = require \path
P     = require \child_process
Sh    = require \shelljs
Dir   = require \./constants .dir

module.exports = me =
  prepare: (tasks) ->
    for tid, t of tasks then
      t.tid = tid
      t.pat = "#{t.pat || ''}*.#{t.ixt}"
      t.srcdir = Path.resolve Dir.SRC, t.dir
      t.glob = Path.resolve t.srcdir, t.pat
    tasks

  run-task: (t, ipath) -> new Promise (resolve, reject) ->
    function get-opath then Path.resolve Dir.BUILD, Path.relative Dir.SRC, ipath.replace t.ixt, t.oxt || t.ixt
    Sh.mkdir \-p odir = Path.dirname opath = get-opath!
    log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
    P.exec cmd, (err, stdout, stderr) -> if err then log stderr; reject! else log stdout if stdout.length; resolve!

  run-tasks: (tasks) ->>
    await Promise.all p = [me.run-task t, f for , t of tasks when t.cmd for f in Glob t.glob].flat!flat!
    log Chalk.green "...done #{p.length} files!"

  start-watching: (emitter, group, t) ->
    log "start watching #group #{t.tid}: #{t.srcdir}/#{t.pat}"
    watch-once!
    function watch-once then w = Fs.watch t.srcdir, {recursive:true}, (, path) ->>
      return unless Match path, t.pat
      w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
      try
        if t.pid then await me.run-tasks [TASKS[t.pid]]
        else if Fs.existsSync ipath = Path.resolve t.srcdir, path then await me.run-task t, ipath
        emitter.emit if t.rsn then \restart else \built
      catch err then emitter.emit \error
      watch-once!
