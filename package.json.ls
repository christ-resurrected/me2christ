name       : \gospelvis
version    : \0.1.0
description: "Visualising a harmony of the Gospels"
private    : true
homepage   : \https://github.com/dizzib/gospelvis
bugs       : \https://github.com/dizzib/gospelvis/issues
license:   : \MIT
author     : \dizzib
repository:
  type: \git
  url : \https://github.com/dizzib/gospelvis
scripts:
  start: './task/bootstrap && node ./_build/task/repl'
engines:
  node: '>=0.10.x'
  npm : '>=1.0.x'
devDependencies:
  chalk        : \~0.4.0
  chokidar     : \~1.6.1
  cron         : \~1.0.3
  growly       : \~1.3.0
  pug          : \~2.0.0-beta11
  livescript   : \~1.5.0
  lodash       : \~4.6.1
  'node-static': \~0.7.7
  shelljs      : \~0.2.6
  stylus       : \~0.51.0
  'wait.for'   : \~0.6.3
