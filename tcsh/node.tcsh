if(-X node) then

  set path=($path node_modules/.bin /usr/local/share/npm/bin)

  alias npmls 'npm ls --loglevel error \!* | egrep ^.─ | colrm 1 4'
  alias npmy 'npm --registry=http://ynpm-registry.corp.yahoo.com:4080'
  alias npmp 'npm --registry=http://localhost:4080'

  complete mojito 'p/1/(build compile create docs gv help info jslint start test version)/' 'n/(create jslint test)/(app mojit)/' 'n/build/html5app/' 'n/compile/(all inlinecss json views rollups)/'
  complete node 'c/--/(debug debug-brk eval print v8-options)/'

endif