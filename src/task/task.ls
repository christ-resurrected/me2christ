Chalk = require \chalk
CP    = require \child_process
Fs    = require \fs
P     = require \path
Perf  = require \perf_hooks .performance
Dir   = require \./constants .dir

module.exports = me =
  init: (tasks) ->
    for tid, t of tasks
      t.ptask = tasks[t.pid] if t.pid
      t.srcdir = P.resolve Dir.SRC, t.dir
      t.tid = tid
      t.glob = P.resolve t.srcdir, t.pat
    tasks

  run-tasks: (tasks) ->>
    t0 = Perf.now!
    await Promise.all p = [run-task t, f for _, t of tasks for f in Fs.globSync t.glob].flat!flat!
    log Chalk.green "Processed #{p.length} files in #{(Perf.now! - t0).toFixed 0}ms"

  start-watching: (group, emitter, t) ->
    log "start watching #group #{t.tid}: #{t.srcdir}/#{t.pat}"
    t.processing = []
    Fs.watch t.srcdir, recursive:true, (_, path) ->>
      return if t.processing.includes path or path[*-1] is \~ or not P.matchesGlob path, t.pat
      t.processing.push path
      t.runid = runid = new Date!getTime!
      await new Promise -> setTimeout it, 1ms # wait for neovim to finish intermittent file writes
      try
        ipath = P.resolve t.srcdir, path
        if (t.cmd or t.fun) and Fs.existsSync ipath then await run-task t, ipath
        if t.ptask  # process parent only, if found by filename e.g. contact-button.sss --> contact.pug
          ixt = P.extname t.ptask.pat
          pfiles = [f for f in Fs.globSync t.ptask.glob when ipath.startsWith f.replace ixt, '']
          await if pfiles.length is 1 then run-task t.ptask, pfiles.0 else me.run-tasks [t.ptask]
        return unless runid is t.runid # debounce: do not emit events if another run has started
        emitter.emit if t.rsn then \restart else \built
      catch err then log "ERROR: #err" if err; emitter.emit \error
      finally then t.processing = t.processing.filter -> it isnt path

function run-task t, ipath then new Promise (resolve, reject) ->>
  odir = P.dirname P.resolve Dir.BUILD, P.relative Dir.SRC, ipath
  if !Fs.existsSync odir then Fs.mkdirSync odir, recursive:true
  if t.fun then try await t.fun ipath, odir; resolve! catch err then reject err finally return
  log Chalk.blue cmd = t.cmd.replace(\$IN ipath).replace(\$ODIR odir)
  cmd = (args = cmd.split ' ').splice 0 1  # splice alters args and returns the removed item
  # use spawn rather than exec to preserve colors
  cp = CP.spawn cmd.0, args, stdio:\inherit
  cp.on \close (code) -> if code is 0 then resolve! else reject!
