Chalk = require \chalk
CP    = require \child_process
Fs    = require \fs
Glob  = require \glob .globSync
Match = require \minimatch .minimatch
P     = require \path
Perf  = require \perf_hooks .performance
Dir   = require \./constants .dir

module.exports = me =
  init: (tasks) ->
    for tid, t of tasks
      t.pat = "#{t.pat || ''}*.#{t.ixt}"
      t.ptask = tasks[t.pid] if t.pid
      t.srcdir = P.resolve Dir.SRC, t.dir
      t.tid = tid
      t.glob = P.resolve t.srcdir, t.pat
    tasks

  run-tasks: (tasks) ->>
    t1 = Perf.now!
    await Promise.all p = [run-task t, f for _, t of tasks for f in Glob t.glob].flat!flat!
    log Chalk.green "Processed #{p.length} files in #{(Perf.now! - t1).toFixed(0)}ms"

  start-watching: (group, emitter, t) ->
    log "start watching #group #{t.tid}: #{t.srcdir}/#{t.pat}"
    watch-once!
    function watch-once then w = Fs.watch t.srcdir, recursive:true, (, path) ->>
      return if path[*-1] is \~ or not Match path, t.pat
      t.runid = runid = new Date!getTime!
      w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
      watch-once!
      try
        if t.ptask then await me.run-tasks [t.ptask]
        else if Fs.existsSync ipath = P.resolve t.srcdir, path then await run-task t, ipath
        return unless runid is t.runid # debounce: do not emit events if another run has started
        emitter.emit if t.rsn then \restart else \built
      catch err then log "ERROR: #err"; emitter.emit \error

function run-task t, ipath then new Promise (resolve, reject) ->>
  odir = P.dirname P.resolve Dir.BUILD, P.relative Dir.SRC, ipath
  if !Fs.existsSync odir then Fs.mkdirSync odir, recursive:true
  if t.fun then try await t.fun ipath, odir; resolve! catch err then reject err finally return
  log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$ODIR odir)
  CP.exec cmd, (err, stdout, stderr) -> if err then reject stderr else log stdout if stdout.length; resolve!
