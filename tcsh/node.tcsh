if(-X npm) then

  #so require'ing node packages/modules installed globally works
  setenv NODE_PATH `npm root -g`

  #set path=($path node_modules/.bin `npm bin -g |& head -1`)
  set path=($path `npm bin -g |& head -1` node_modules/.bin)

  alias npmls 'npm ls --loglevel error \!* | egrep ^.─ | colrm 1 4'
  alias npmy 'npm --registry=http://ynpm-registry.corp.yahoo.com:4080'
  alias npmp 'npm --registry=http://localhost:4080'
  alias npmr 'npm run-script \!*'

  complete mojito 'p/1/(build compile create docs gv help info jslint start test version)/' 'n/(create jslint test)/(app mojit)/' 'n/build/html5app/' 'n/compile/(all inlinecss json views rollups)/'
  complete node 'c/--/(debug debug-brk eval print v8-options)/'

endif
