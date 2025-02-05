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
    function watch-once
      w = Fs.watch t.dir, recursive:true, (_, path) ->>
        return unless P.matchesGlob path, t.pat
        try
          w.close!
          await Sleep 0 # allow multi async file ops to be discarded before proceeding
          ipath = P.resolve t.dir, path
          if t.ptask # process parent only, if found by filename e.g. contact-button.sss --> contact.pug
            ixt = P.extname t.ptask.pat
            pfiles = [f for f in Fs.globSync t.ptask.glob when ipath.startsWith f.replace ixt, '']
            await if pfiles.length is 1 then Run t.ptask, pfiles.0 else me.run-tasks [t.ptask]
          else await Run t, ipath
          emitter.emit if t.rsn then \restart else \built
        catch err then log "ERROR: #err" if err; emitter.emit \error
        finally then watch-once! # git operations break existing watch, so start a new watch
    watch-once!
