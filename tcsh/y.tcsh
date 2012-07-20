if(-d /home/y) then

  set path = (/home/y/bin ~/bin $path)

  alias npmjsorg 'ynpm --registry=https://registry.npmjs.org'

  alias ssh /usr/local/bin/yssh
  alias scp /usr/local/bin/yscp

  setenv GIT_SSH /usr/local/bin/yssh
  set SVNROOT = 'svn+ssh://svn.corp.yahoo.com/yahoo'

  #set yroot name if applicable
  if(-l /.yroot) then
    setenv YROOT_NAME `readlink /.yroot`
    setenv YROOT_NAME $YROOT_NAME:t
    set histfile = ~/.history-$HOST-$YROOT_NAME
  endif

  complete yinst 'p/1/(activate changed check check-config clean clone collect create crontab cvsunzip deactivate diff env fetch help history install lock ls man packages platform range reload remove repair restart restore save self-install self-update set ssh start stop tag unlock unset version which-dist)/' 'n/ls/(-all -build -Buildtime -comment -config -custodian -dependencies -description -files -dirs -Flags -install_info -leaf -link -nocollection -noname -noversion -prefix -sys -time -yicf)/' 'n/install/(-branch -collection -downgrade -dryrun -force -live -noactivate -nocheck_data -noexecute -nonewer_build -noprerequisites -norepair_data -nostart -noupgrade -refresh -refresh_branch -refresh_collection -refresh_same_branch -replace -same -set -use_restart)/' 'n/-branch/(current stable test)/' 'p/*/f:*.tgz/'
  complete yinst_create 'c/--/(buildtype platform stage_dir target_dir clean dumpyicf keyed debug help)//' 'n/--buildtype/(release test link nightly)/' 'p/*/f:*.yicf/'
  complete yroot 'c/--/(create dryrun images list local-home mount ps remove rename restart set setup-amd start stop umount unset update verbose)/' 'n/--list/(--status)/' 'p@*@D:/home/y/var/yroots@@'
  complete yvm 'c/--/(config console create list pmadd pmlist pmremove remove rename restart start stop suspend)/' 'n/--list/(--status)/' 'p@2@D:/home/y/var/yvm@@'

endif
