Chalk = require \chalk
CP    = require \child_process
Fs    = require \fs
Glob  = require \glob .globSync
Match = require \minimatch .minimatch
P     = require \path
Dir   = require \./constants .dir

module.exports = me =
  init: (tasks) ->
    for tid, t of tasks then
      t.pat = "#{t.pat || ''}*.#{t.ixt}"
      t.ptask = tasks[t.pid] if t.pid
      t.srcdir = P.resolve Dir.SRC, t.dir
      t.tid = tid
      t.glob = P.resolve t.srcdir, t.pat
    tasks

  run-tasks: (tasks) ->>
    await Promise.all p = [run-task t, f for _, t of tasks for f in Glob t.glob].flat!flat!
    log Chalk.green "...done #{p.length} files!"

  start-watching: (group, emitter, t) ->
    log "start watching #group #{t.tid}: #{t.srcdir}/#{t.pat}"
    watch-once!
    function watch-once then w = Fs.watch t.srcdir, recursive:true, (, path) ->>
      return if path[*-1] is \~ or not Match path, t.pat
      t.runid = runid = new Date!getTime!
      w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
      watch-once!
      try
        console.time time-id = "run-tasks-#{runid}"
        if t.ptask then await me.run-tasks [t.ptask]
        else if Fs.existsSync ipath = P.resolve t.srcdir, path then await run-task t, ipath
        console.timeEnd time-id
        return unless runid is t.runid # debounce: do not emit events if another run has started
        emitter.emit if t.rsn then \restart else \built
      catch err then emitter.emit \error

function run-task t, ipath then new Promise (resolve, reject) ->
  function get-opath then P.resolve Dir.BUILD, P.relative Dir.SRC, ipath
  if !Fs.existsSync(odir = P.dirname opath = get-opath!) then Fs.mkdirSync odir, recursive:true
  log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir)
  CP.exec cmd, (err, stdout, stderr) -> if err then log stderr; reject! else log stdout if stdout.length; resolve!
