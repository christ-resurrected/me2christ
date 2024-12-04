Assert = require \assert
Fs     = require \fs
Path   = require \path

const DIRNAME =
  BUILD: \build
  SITE : \site
  SRC  : \src
  TASK : \task

Assert DIRNAME.BUILD, Path.basename cwd = process.cwd!
root = Path.resolve cwd, \..

dir =
  BUILD: cwd
  BUILD_SITE: Path.resolve cwd, DIRNAME.SITE
  ROOT: root
  SRC: Path.resolve root, DIRNAME.SRC
  SRC_SITE: Path.resolve root, DIRNAME.SRC, DIRNAME.SITE
  SRC_SITE_ASSET: Path.resolve root, DIRNAME.SRC, DIRNAME.SITE, \asset
  SRC_SITE_RESOURCE: Path.resolve root, DIRNAME.SRC, DIRNAME.SITE, \resource
  SRC_TASK: Path.resolve root, DIRNAME.SRC, DIRNAME.TASK

module.exports =
  APPNAME: \me2christ
  dirname: DIRNAME
  dir    : dir
  VERSES_PATH: Path.resolve dir.SRC_SITE_RESOURCE, \verses.json

Assert Fs.existsSync dir.BUILD
Assert Fs.existsSync dir.SRC
