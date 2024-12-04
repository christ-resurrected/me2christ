Chalk   = require \chalk
Emitter = require \events .EventEmitter
Fs      = require \fs
Glob    = require \glob .globSync
Match   = require \minimatch .minimatch
P       = require \child_process
Path    = require \path
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const CFG = "#{Dir.SRC}/task/lint"

const TASKS = T.prepare RAW_TASKS =
  task_ls:
    cmd: \ls-lint
    dir: Dirname.TASK
    cfg: \ls-lint.lson
    ixt: \ls
    pat: '**/'

module.exports = me = (new Emitter!) with
  all: ->>
    try
      await Promise.all p = [lint t, f for , t of TASKS for f in Glob(t.glob)].flat!flat!
      log Chalk.green "...done #{p.length} files!"
      me.emit \done
    catch err then log err
  start: -> for , t of TASKS then start-watching t

function lint t, ipath then new Promise (resolve, reject) ->
  log Chalk.blue cmd = "yarn --silent #{t.cmd} --config #CFG/#{t.cfg} #{t.opts || ''} #ipath"
  P.exec cmd, (err, stdout, stderr) -> if err then log stderr; reject! else log stdout; resolve!

function start-watching t
  log "start watching lint #{t.tid}: #{t.pat}"
  watch-once!
  function watch-once then w = Fs.watch Dir.SRC, {recursive:true}, (, path) ->>
    return unless Match path, t.pat
    w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
    if Fs.existsSync ipath = Path.resolve Dir.SRC, path then await lint t, ipath
    me.emit \done
    watch-once!
