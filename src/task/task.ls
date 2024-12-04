Path = require \path
Dir  = require \./constants .dir

module.exports =
  prepare: (tasks) ->
    for tid, t of tasks then
      t.tid = tid
      t.pat = "#{t.pat || ''}*.#{t.ixt}"
      t.srcdir = Path.resolve Dir.SRC, t.dir
      t.glob = Path.resolve t.srcdir, t.pat
    tasks
