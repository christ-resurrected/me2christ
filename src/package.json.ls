name       : \me2christ
version    : \3.1.0
description: 'me2christ.com source code'
private    : true
homepage   : \https://github.com/christ-resurrected/me2christ
bugs       : \https://github.com/christ-resurrected/me2christ/issues
license:   : \MIT
author     : \andrew
repository:
  type: \git
  url : \https://github.com/christ-resurrected/me2christ
scripts:
  build: 'node task/yarn/build.js'
  start: 'touch .restart-node && node --watch-path=.restart-node --watch-preserve-output task/repl.js'
engines:
  node: '22'
  yarn: '1.22'
devDependencies:
  chalk                       : \~0.4.0
  glob                        : \~11.0.0
  'jstransformer-markdown-it' : \~3.0.0
  'jstransformer-scss'        : \~2.0.0
  livescript                  : \~1.6.0
  lodash                      : \~4.17.21
  'node-static'               : \~0.7.11
  '@anduh/pug-cli'            : \~1.0.0-alpha8
  shelljs                     : \~0.8.5
  ws                          : \~8.18.0
  # lint
  'ls-lint'                   : \~0.1.2
  'postcss-scss'              : \~4.0.9
  'pug-lint'                  : \~2.6.0
  stylelint                   : \~14.12.1
  'stylelint-order'           : \~5.0.0
  'stylelint-scss'            : \~5.0.0
