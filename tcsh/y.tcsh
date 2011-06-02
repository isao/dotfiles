if(-d /home/y/bin) set path=(/home/y/bin $path)

if(-X yssh) alias ssh yssh
if(-X yscp) alias scp yscp

if(-X yinst) complete yinst 'p/1/(activate changed check check-config clean clone collect create crontab cvsunzip deactivate diff env fetch help history install lock ls man packages platform range reload remove repair restart restore save self-install self-update set ssh start stop tag unlock unset version which-dist)/' 'n/ls/(-all -build -Buildtime -comment -config -custodian -dependencies -description -files -dirs -Flags -install_info -leaf -link -nocollection -noname -noversion -prefix -sys -time -yicf)/' 'n/install/(-branch -collection -downgrade -dryrun -force -live -noactivate -nocheck_data -noexecute -nonewer_build -noprerequisites -norepair_data -nostart -noupgrade -refresh -refresh_branch -refresh_collection -refresh_same_branch -replace -same -set -use_restart)/' 'n/-branch/(current stable test)/' 'p/*/f:*.tgz/'
if(-X yinst_create) complete yinst_create 'c/--/(buildtype platform stage_dir target_dir clean dumpyicf keyed debug help)//' 'n/--buildtype/(release test link nightly)/' 'p/*/f:*.yicf/'
if(-X yroot) complete yroot 'c/--/(create dryrun images list local-home mount ps remove rename restart set setup-amd start stop umount unset update verbose)/' 'n/--list/(--status)/' 'p@*@D:/home/y/var/yroots@@'
if(-X yvm) complete yvm 'c/--/(config console create list pmadd pmlist pmremove remove rename restart start stop suspend)/' 'n/--list/(--status)/' 'p@2@D:/home/y/var/yvm@@'


##Y!
#set yroot name if applicable
if(! $?YROOT_NAME && -l /.yroot) then
	set YROOT_NAME=`readlink /.yroot`
	set YROOT_NAME=`basename $YROOT_NAME`
endif

##Y!
#keep separate histories for my *nix boxes & yroots
#because they share a single home dir nfs mounted
if($?YROOT_NAME) then
  set histfile = ~/.history-$HOST-$YROOT_NAME
  set prompt = "%{\033]0;%n@%m,${YROOT_NAME}:%c03\007%}%T%n@%B${YROOT_NAME}%b%# %L"
  sched +0:00 alias postcmd 'printf "\033]0;%s %s\007" $YROOT_NAME "\!#"'
endif
