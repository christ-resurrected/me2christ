name       : \me2christ
version    : \1.5.0
description: 'me2christ.com source code'
private    : true
homepage   : \https://github.com/dizzib/me2christ
bugs       : \https://github.com/dizzib/me2christ/issues
license:   : \MIT
author     : \andrew
repository:
  type: \git
  url : \https://github.com/dizzib/me2christ
scripts:
  build: 'cd .. && ./bootstrap && node build/task/npm/build'
  start: 'cd .. && ./bootstrap && node build/task/repl'
engines:
  node: '>=10.0.x'
  npm : '>=7.0.x'
devDependencies:
  chalk                       : \~0.4.0
  chokidar                    : \~3.2.2
  cron                        : \~1.0.3
  growly                      : \~1.3.0
  'jstransformer-livescript'  : \~1.2.0
  'jstransformer-markdown-it' : \~2.1.0
  'jstransformer-stylus'      : \~1.5.0
  livereload                  : \~0.9.3
  livescript                  : \~1.6.0
  lodash                      : \~4.17.21
  'node-static'               : \~0.7.11
  'postcss-syntax'            : \~0.36.2  # required for stylelint-plugin-stylus
  pug                         : \~3.0.2
  'pug-cli'                   : \~1.0.0-alpha6
  shelljs                     : \~0.8.4
  stylelint                   : \~14.8.2
  'stylelint-order'           : \~5.0.0
  'stylelint-plugin-stylus'   : \~0.13.1
  stylus                      : \~0.55.0
