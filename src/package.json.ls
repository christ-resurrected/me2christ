name       : \me2christ
version    : \3.3.0
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
  chalk      : \~0.4.0
  cssnano    : \~7.0.6
  glob       : \~11.0.0
  livescript : \~1.6.0
  pug        : \~3.0.3
  postcss    : \~8.4.49
  'uglify-js': \~3.19.3
devDependencies:
  'ls-lint': \~0.1.2
  ws       : \~8.18.0
