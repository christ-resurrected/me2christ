Chalk = require \chalk
Fs    = require \fs
P     = require \path
Perf  = require \perf_hooks .performance
Sleep = require \node:timers/promises .setTimeout
Dir   = require \./constants .DIR
Run   = require \./task.run

module.exports = me =
  init: (tasks) ->
    for tid, t of tasks
      t.glob = P.resolve t.dir, t.pat
      t.ptask = tasks[t.pid] if t.pid
      t.tid = tid
    tasks

  run-tasks: (tasks) ->>
    t0 = Perf.now!
    await Promise.all p = [Run t, f for _, t of tasks for f in Fs.globSync t.glob].flat!flat!
    log Chalk.green "Processed #{p.length} files in #{(Perf.now! - t0).toFixed 0}ms"

  start-watching: (group, emitter, t) ->
    log "start watching #group #{t.tid}: #{t.dir}/#{t.pat}"
    t.guard = [] # guard against concurrent async runs on same file e.g. when neovim writes a file
    Fs.watch t.dir, recursive:true, (_, path) ->>
      return if t.guard.includes path or path[*-1] is \~ or not P.matchesGlob path, t.pat
      try
        t.guard.push path
        await Sleep 0 # allow async neovim file writes to be discarded before proceeding
        # clearTimeout t.timer
        # t.timer = setTimeout (-> t.guard = []), 1000ms  # fix suspected issue where t.guard is not clearing
        ipath = P.resolve t.dir, path
        if t.ptask # process parent only, if found by filename e.g. contact-button.sss --> contact.pug
          ixt = P.extname t.ptask.pat
          pfiles = [f for f in Fs.globSync t.ptask.glob when ipath.startsWith f.replace ixt, '']
          await if pfiles.length is 1 then Run t.ptask, pfiles.0 else me.run-tasks [t.ptask]
        else await Run t, ipath
        emitter.emit if t.rsn then \restart else \built
      catch err then log "ERROR: #err" if err; emitter.emit \error
      finally then t.guard = t.guard.filter -> it isnt path
