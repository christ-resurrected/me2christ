Assert = require \assert
Fs     = require \fs
P      = require \path

const DIRNAME =
  BUILD: \build
  SITE : \site
  TASK : \task

Assert.equal P.basename(cwd = process.cwd!), DIRNAME.BUILD

const DIR =
  BUILD: cwd
  BUILD_SITE: P.resolve cwd, DIRNAME.SITE
  BUILD_TASK: P.resolve cwd, DIRNAME.TASK
  ROOT: P.resolve cwd, \..

DIR.SRC = P.resolve DIR.ROOT, \src
DIR.SRC_SITE = P.resolve DIR.SRC, DIRNAME.SITE
DIR.SRC_SITE_ASSET = P.resolve DIR.SRC_SITE, \asset
DIR.SRC_SITE_ASSET_FAVICON = P.resolve DIR.SRC_SITE_ASSET, \favicon
DIR.SRC_SITE_RESOURCE = P.resolve DIR.SRC_SITE, \resource
DIR.SRC_TASK = P.resolve DIR.SRC, DIRNAME.TASK

module.exports =
  APPNAME: \me2christ
  dir    : DIR
  KJVPATH: P.resolve DIR.SRC_SITE_RESOURCE, \verses-1769.json

Assert Fs.existsSync DIR.BUILD
Assert Fs.existsSync DIR.SRC
