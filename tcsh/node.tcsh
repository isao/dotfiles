if(-X npm) then
  # for requiring globally installed libraries
  setenv NODE_PATH `npm root -g`

  # `npm bin -g |& head -1` -> /usr/local/share/npm/bin
  # n.b. the |& head supresses npm warning "(not in PATH env variable)"
  set path=($path node_modules/.bin `npm bin -g |& head -1`)
endif

if($?NODE_PATH) then
  alias npmls 'npm ls --loglevel error \!* | egrep ^.─ | colrm 1 4'
  alias npmr 'npm run-script \!*'
  complete node 'c/--/(debug debug-brk eval print v8-options)/'
endif
