#
# built-in completions
#

complete {cd,lsd,pushd,popd,rmdir} 'C/*/d/'

complete chgrp 'p/1/g/'

complete df 'c/--/(all human-readable kilobytes local megabytes)/'
complete du 'c/--/(all total dereference-args human-readable kilobytes count-links dereference megabytes separate-dirs summarize one-file-system exclude-from exclude max-depth/'

complete {find,findfile.sh} 'n/-{,i}name/f/' 'n/-newer/f/' 'n/-{,n}cpio/f/' 'n/-exec/c/' 'n/-ok/c/' 'n/-user/u/' 'n/-group/g/' 'n/-fstype/(nfs 4.2)/' 'n/-type/(b c d f l p s)/' 'c/-/(and atime cpio ctime depth empty exec fstype group iname inum iregex ls maxdepth mindepth mtime name ncpio newer nogroup not nouser ok or path perm print prune regex size type user xdev)/' 'n/*/d/'
complete {{,e,f}grep,codegrep.sh} 'c/--/(after-context before-context context count exclude file files-with-matches files-without-match fixed-strings include invert-match no-filename no-messages only-matching perl-regexp recursive with-filename)/'

complete kill 'c/%/j/' 'c/-/S/'
complete killall 'c/-/S/' 'p/1/(-)/'

#see http://hea-www.harvard.edu/~fine/Tech/tcsh.html
complete ln 'C/?/f/' 'p/1/(-s)/' 'n/-s/x:[first arg is path to original file]/' 'N/-s/x:[second arg is new link]/'
complete {man,whereis,which} 'p/*/c/'
complete su 'c/-/(f l m)/' 'p/*/u/'
complete sudo 'p/1/c/'
complete tcpdump 'n@-i@`ifconfig -l`@'
complete wget 'c/--/(background debug verbose non-verbose output-document timestamping no-host-directories recursive)/'
complete uncomplete 'p/*/X/'

# completion sets using personal lists
set _myhosts=(`cat -s $dotfiles/tcsh/hosts.txt| grep -v '^#'`)
#set _myhosts=(etherjar.com etherwerks raisegray-dl.corp.yahoo.com questaddressed.corp.gq1.yahoo.com neatsheet.corp.gq1.yahoo.com)

complete {host,nslookup,ping,route} 'p/*/$_myhosts/'

#complete chown 'c/--/(changes silent quiet verbose reference recursive help version)/' 'p/*/f/'
complete chown 'c/--/(changes help quiet recursive reference silent verbose version)/' 'c/*:/g//' 'p/1/u/:' 'p/*/f/'

#complete rsync 'c/--/(checksum copy-links cvs-exclude delete delete-excluded dry-run exclude-from= exclude= ignore-times include-from= include= modify-window= progress quiet recursive rsh=$RSYNC_RSH safe-links size-only times update verbose)/' 'p/*/f/'
complete rsync 'c/*@/$_myhosts//' 'c/--/(checksum copy-links cvs-exclude delete delete-excluded dry-run exclude-from= exclude= ignore-times include-from= include= modify-window= progress quiet recursive safe-links size-only times update verbose)/' 'p/*/f/'

# From Michael Schroeder <mlschroe@immd4.informatik.uni-erlangen.de>
# This one will ssh to fetch the list of files
complete scp 'c%*@*:%`set q=$:-0;set q="$q:s/@/ /";set q="$q:s/:/ /";set q=($q " ");$RSYNC_RSH $q[2] -l $q[1] ls -dp $q[3]\*`%' 'c%*:%`set q=$:-0;set q="$q:s/:/ /";set q=($q " ");$RSYNC_RSH $q[1] ls -dp $q[2]\*`%' 'c%*@%$_myhosts%:' 'C@[./$~]*@f@' 'n/*/$_myhosts/:'
complete ssh 'c/*@/$_myhosts//' 'p/*/u/@'


#
# app completions
#
if(-X bbedit) then
  complete bbedit 'c/--/(background clean create front-window maketags new-window print pipe-title scratchpad worksheet view-top resume wait)/'
  alias bbproj 'open ~/Dropbox/Documents/bbproj/\!*'
  complete bbproj 'p@*@D:/Users/isao/Dropbox/Documents/bbproj/@@'
endif

if(-X brew) complete brew 'c/--/(verbose prefix cache config)/' 'p/1/(install list info home rm remove create edit ln link unlink prune outdated deps uses doctor cat cleanup update upgrade log fetch search switch versions)/' 'n~{list,info,home,rm,remove,edit,ln,link,unlink,prune,outdated,deps,uses,doctor,cat,cleanup,upgrade,log,fetch,search,switch,versions}~`brew ls`~' 'n/info/(--github --all)/'

if(-X nano) complete nano 'c/--/(autoindent backup help nowrap)/'

if(-X svn) complete svn 'p/1/(add blame cat checkout cleanup commit copy delete diff export help import info list lock log merge mkdir move propdel propedit propget proplist propset resolved revert status switch unlock update)//' 'n/prop{del,edit,get,set}/(svn:executable svn:externals svn:ignore svn:keywords svn:mime-type)//' 'c/--/(quiet verbose username password)/'
