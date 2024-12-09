name       : \me2christ
version    : \3.2.0
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
  build: 'node -e "global.log = console.log; require(\'./task/build\').all()"'
  start: 'touch .restart-node && node --watch-path=.restart-node --watch-preserve-output task/repl.js'
engines:
  node: '22'
  yarn: '1.22'
dependencies:
  chalk                       : \~0.4.0
  glob                        : \~11.0.0
  'jstransformer-markdown-it' : \~3.0.0
  livescript                  : \~1.6.0
  '@anduh/pug-cli'            : \~1.0.0-alpha8
  ws                          : \~8.18.0
devDependencies:
  'ls-lint'                   : \~0.1.2
