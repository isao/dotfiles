alias rg 'ssh -t raisegray-vm0.corp.yahoo.com "screen -dUR rg"'
alias killarrow 'pkill -fl arrow_ phantomjs selenium- firefox-bin webdriver'
alias selenium 'java -Dwebdriver.firefox.profile=default -jar `brew ls selenium-server-standalone | grep .jar`'
set arrow = "$HOME/Repos/mojito/myfork/node_modules/.bin/arrow --report"
set mojito = "$HOME/Repos/mojito/myfork/bin/mojito"
set mojlib = "$HOME/Repos/mojito/myfork"

set SVNY = 'svn+ssh://svn.corp.yahoo.com/yahoo'
set SVNYMIRROR = 'svn+ssh://svn-mirror.corp.yahoo.com/yahoo'

if(-d /home/y) then

  set path = (/home/y/bin{64,} $path)

  if(-X ynpm) alias npm 'ynpm --registry=https://registry.npmjs.org'

  if(-X yssh) then
      alias ssh yssh
      alias scp yscp
      setenv RSYNC_RSH yssh
      setenv GIT_SSH yssh
  endif

  #set yroot name if applicable
  if(-l /.yroot) then
    setenv YROOT_NAME `readlink /.yroot`
    setenv YROOT_NAME $YROOT_NAME:t
  endif

  complete yinst 'p/1/(activate changed check check-config clean clone collect create crontab cvsunzip deactivate diff env fetch help history install lock ls man packages platform range reload remove repair restart restore save self-install self-update set ssh start stop tag unlock unset version which-dist)/' 'n/ls/(-all -build -Buildtime -comment -config -custodian -dependencies -description -files -dirs -Flags -install_info -leaf -link -nocollection -noname -noversion -prefix -sys -time -yicf)/' 'n/install/(-branch -collection -downgrade -dryrun -force -live -noactivate -nocheck_data -noexecute -nonewer_build -noprerequisites -norepair_data -nostart -noupgrade -refresh -refresh_branch -refresh_collection -refresh_same_branch -replace -same -set -use_restart)/' 'n/-branch/(current stable test)/' 'p/*/f:*.tgz/'
  complete yinst_create 'c/--/(buildtype platform stage_dir target_dir clean dumpyicf keyed debug help)//' 'n/--buildtype/(release test link nightly)/' 'p/*/f:*.yicf/'
  complete yroot 'c/--/(create dryrun images list local-home mount ps remove rename restart set setup-amd start stop umount unset update verbose)/' 'n/--list/(--status)/' 'p@*@D:/home/y/var/yroots@@'

endif
