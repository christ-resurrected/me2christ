name       : \me2christ
version    : \1.4.0
description: 'me2christ.com source code'
private    : true
homepage   : \https://github.com/dizzib/me2christ
bugs       : \https://github.com/dizzib/me2christ/issues
license:   : \MIT
author     : \dizzib
repository:
  type: \git
  url : \https://github.com/dizzib/me2christ
scripts:
  build: '/src/task/bootstrap && node /build/task/npm/build'
  start: '/src/task/bootstrap && node /build/task/repl'
engines:
  node: '>=8.16.x'
  npm : '>=1.0.x'
devDependencies:
  chalk                       : \~0.4.0
  chokidar                    : \~3.2.2
  cron                        : \~1.0.3
  growly                      : \~1.3.0
  'jstransformer-livescript'  : \~1.2.0
  'jstransformer-markdown-it' : \~2.1.0
  'jstransformer-stylus'      : \~1.5.0
  livescript                  : \~1.6.0
  lodash                      : \~4.17.15
  'node-static'               : \~0.7.11
  pug                         : \~3.0.2
  'pug-cli'                   : \~1.0.0-alpha6
  shelljs                     : \~0.3.0
  'sitemap-generator'         : \~8.4.1
  stylus                      : \~0.54.5
