Chalk   = require \chalk
Emitter = require \events .EventEmitter
Fs      = require \fs
Glob    = require \glob .globSync
Match   = require \minimatch
P       = require \child_process
Path    = require \path
Dirname = require \./constants .dirname
Dir     = require \./constants .dir

const CFG = "#{Dir.SRC}/task/lint"

tasks =
  task_ls:
    cmd : \ls-lint
    cfg : \ls-lint.lson
    ixt : \ls

for , t of tasks then
  t.pat = "**/*.#{t.ixt}"
  t.glob = Path.resolve Dir.SRC, t.pat

module.exports = me = (new Emitter!) with
  all: ->>
    try
      await Promise.all p = [lint t, f for , t of tasks for f in Glob(t.glob)].flat!flat!
      log Chalk.green "...done #{p.length} files!"
      me.emit \done
    catch err then log err
  start: -> for tid of tasks then start-watching tid

function lint t, ipath then new Promise (resolve, reject) ->
  log cmd = "yarn #{t.cmd} --config #CFG/#{t.cfg} #{t.opts || ''} #ipath"
  P.exec cmd, (err, stdout, stderr) -> if err then log stderr; reject! else log stdout; resolve!

function start-watching tid
  t = tasks[tid]
  log "start watching lint #tid: #{t.pat}"
  watch-once!
  function watch-once then w = t.watcher = Fs.watch Dir.SRC, {recursive:true}, (, path) ->>
    return unless Match path, t.pat
    w.close! # shutdown flood of events
    await new Promise -> setTimeout it, 20ms # allow background file updates to settle
    if Fs.existsSync ipath = Path.resolve Dir.SRC, path then await lint t, ipath
    me.emit \done
    watch-once!
