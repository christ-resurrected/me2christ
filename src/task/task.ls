Chalk = require \chalk
Fs    = require \fs
P     = require \path
Perf  = require \perf_hooks .performance
Dir   = require \./constants .dir
Run   = require \./task.run

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
    await Promise.all p = [Run t, f for _, t of tasks for f in Fs.globSync t.glob].flat!flat!
    log Chalk.green "Processed #{p.length} files in #{(Perf.now! - t0).toFixed 0}ms"

  start-watching: (group, emitter, t) ->
    log "start watching #group #{t.tid}: #{t.srcdir}/#{t.pat}"
    t.running = [] # dedupe runs when multiple events are fired when neovim writes a file
    Fs.watch t.srcdir, recursive:true, (_, path) ->>
      return if t.running.includes path or path[*-1] is \~ or not P.matchesGlob path, t.pat
      clearTimeout t.timer if t.timer
      t.timer = setTimeout (-> t.running = []), 1000ms  # fix suspected issue where t.running is not clearing
      t.running.push path
      t.runid = runid = new Date!getTime!
      await new Promise -> setTimeout it, 1ms # allow async neovim file writes to be discarded before proceeding
      try
        ipath = P.resolve t.srcdir, path
        if (t.cmd or t.fun) and Fs.existsSync ipath then await Run t, ipath
        if t.ptask # process parent only, if found by filename e.g. contact-button.sss --> contact.pug
          ixt = P.extname t.ptask.pat
          pfiles = [f for f in Fs.globSync t.ptask.glob when ipath.startsWith f.replace ixt, '']
          await if pfiles.length is 1 then Run t.ptask, pfiles.0 else me.run-tasks [t.ptask]
        return unless runid is t.runid # debounce: do not emit events if another run has started
        emitter.emit if t.rsn then \restart else \built
      catch err then log "ERROR: #err" if err; emitter.emit \error
      finally then t.running = t.running.filter -> it isnt path
