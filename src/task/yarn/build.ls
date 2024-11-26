global.log = console.log

Build = require \../build
Dir   = require \../constants .dir

cd Dir.BUILD
Build.all!
