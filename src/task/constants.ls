Assert = require \assert
Fs     = require \fs
P      = require \path

const DIRNAME =
  BUILD: \build
  SITE : \site
  SRC  : \src
  TASK : \task

Assert DIRNAME.BUILD, P.basename cwd = process.cwd!
root = P.resolve cwd, \..

const DIR =
  BUILD: cwd
  BUILD_SITE: P.resolve cwd, DIRNAME.SITE
  BUILD_TASK: P.resolve cwd, DIRNAME.TASK
  ROOT: root
  SRC: P.resolve root, DIRNAME.SRC
  SRC_SITE: P.resolve root, DIRNAME.SRC, DIRNAME.SITE
  SRC_SITE_ASSET: P.resolve root, DIRNAME.SRC, DIRNAME.SITE, \asset
  SRC_SITE_RESOURCE: P.resolve root, DIRNAME.SRC, DIRNAME.SITE, \resource
  SRC_TASK: P.resolve root, DIRNAME.SRC, DIRNAME.TASK

module.exports =
  APPNAME: \me2christ
  dirname: DIRNAME
  dir    : DIR
  KJVPATH: P.resolve DIR.SRC_SITE_RESOURCE, \verses-1769.json

Assert Fs.existsSync DIR.BUILD
Assert Fs.existsSync DIR.SRC
