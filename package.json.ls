name       : \me2christ
version    : \0.1.0
description: \me2christ.com
private    : true
homepage   : \https://github.com/dizzib/me2christ
bugs       : \https://github.com/dizzib/me2christ/issues
license:   : \MIT
author     : \dizzib
repository:
  type: \git
  url : \https://github.com/dizzib/me2christ
scripts:
  start: './task/bootstrap && node ./_build/task/repl'
engines:
  node: '>=0.10.x'
  npm : '>=1.0.x'
devDependencies:
  chalk        : \~0.4.0
  chokidar     : \~2.1.2
  cron         : \~1.0.3
  growly       : \~1.3.0
  pug          : \~2.0.3
  livescript   : \~1.6.0
  lodash       : \~4.6.1
  'node-static': \~0.7.11
  shelljs      : \~0.2.6
  stylus       : \~0.54.5
  'wait.for'   : \~0.6.3
