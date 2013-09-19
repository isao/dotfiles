if(-X npm) then
  # for requiring globally installed libraries
  setenv NODE_PATH `npm root -g`

  # `npm bin -g |& head -1` -> /usr/local/share/npm/bin
  # n.b. the |& head supresses npm warning "(not in PATH env variable)"
  set path=($path node_modules/.bin `npm bin -g |& head -1`)

  alias npmy 'npm --registry=http://ynpm-registry.corp.yahoo.com:4080'
  alias npmp 'npm --registry=http://localhost:4080'
endif

if(-x /home/y/bin/ynpm) then
  setenv NODE_PATH /home/y/lib/node_modules
  set path=($path node_modules/.bin)
endif

if($?NODE_PATH) then
  alias npmls 'npm ls --loglevel error \!* | egrep ^.─ | colrm 1 4'
  alias npmr 'npm run-script \!*'
  complete mojito 'p/1/(build compile create docs gv help info jslint start test version)/' 'n/(create jslint test)/(app mojit)/' 'n/build/html5app/' 'n/compile/(all inlinecss json views rollups)/'
  complete node 'c/--/(debug debug-brk eval print v8-options)/'
endif
