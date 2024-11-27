Assert = require \assert
Path   = require \path
Sh     = require \shelljs

const DIRNAME =
  BUILD: \build
  SITE : \site
  SRC  : \src
  TASK : \task
  TEST : \test

Assert DIRNAME.BUILD, Path.basename cwd = process.cwd!
root = Path.resolve cwd, \..

dir =
  BUILD: cwd
  build:
    SITE: Path.resolve cwd, DIRNAME.SITE
  ROOT : root
  SRC  : Path.resolve root, DIRNAME.SRC

module.exports =
  APPNAME: \me2christ
  dirname: DIRNAME
  dir    : dir
  PORT   : 7777

Assert Sh.test \-e dir.BUILD
Assert Sh.test \-e dir.SRC
