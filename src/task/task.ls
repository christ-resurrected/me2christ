Chalk = require \chalk
Fs    = require \fs
Glob  = require \glob .globSync
Match = require \minimatch .minimatch
Path  = require \path
P     = require \child_process
Dir   = require \./constants .dir

module.exports = me =
  init: (tasks) ->
    for tid, t of tasks then
      t.pat = "#{t.pat || ''}*.#{t.ixt}"
      t.ptask = tasks[t.pid] if t.pid
      t.srcdir = Path.resolve Dir.SRC, t.dir
      t.tid = tid
      t.glob = Path.resolve t.srcdir, t.pat
    tasks

  run-tasks: (tasks) ->>
    await Promise.all p = [run-task t, f for , t of tasks when t.cmd for f in Glob t.glob].flat!flat!
    log Chalk.green "...done #{p.length} files!"

  start-watching: (emitter, group, t) ->
    log "start watching #group #{t.tid}: #{t.srcdir}/#{t.pat}"
    watch-once!
    function watch-once then w = Fs.watch t.srcdir, recursive:true, (, path) ->>
      return unless Match path, t.pat
      w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
      try
        if t.ptask then await me.run-tasks [t.ptask]
        else if Fs.existsSync ipath = Path.resolve t.srcdir, path then await run-task t, ipath
        emitter.emit if t.rsn then \restart else \built
      catch err then emitter.emit \error
      watch-once!

function run-task t, ipath then new Promise (resolve, reject) ->
  function get-opath then Path.resolve Dir.BUILD, Path.relative Dir.SRC, ipath.replace t.ixt, t.oxt || t.ixt
  if !Fs.existsSync(odir = Path.dirname opath = get-opath!) then Fs.mkdirSync odir, recursive:true
  log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
  P.exec cmd, (err, stdout, stderr) -> if err then log stderr; reject! else log stdout if stdout.length; resolve!
