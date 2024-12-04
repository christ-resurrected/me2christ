Emitter = require \events .EventEmitter
Fs      = require \fs
Match   = require \minimatch .minimatch
Path    = require \path
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
T       = require \./task

const TASKS = T.prepare RAW_TASKS =
  task_ls:
    cmd: "yarn --silent ls-lint --config #{Dir.SRC}/task/lint/ls-lint.lson $IN"
    dir: Dirname.TASK
    ixt: \ls
    pat: '**/'

module.exports = me = (new Emitter!) with
  all: ->> try T.run-tasks TASKS; me.emit \done catch err then log err
  start: -> for , t of TASKS then start-watching t

function start-watching t
  log "start watching lint #{t.tid}: #{t.pat}"
  watch-once!
  function watch-once then w = Fs.watch t.srcdir, {recursive:true}, (, path) ->>
    return unless Match path, t.pat
    w.close!; await new Promise -> setTimeout it, 20ms # stop event flood and wait for file updates to settle
    if Fs.existsSync ipath = Path.resolve t.srcdir, path then await T.run-task t, ipath
    me.emit \done
    watch-once!
