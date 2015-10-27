if(-X git) then

    # fetch boilerplate from http://gitignore.io; i.e. gitignore node > .gitignore
    alias gitignore 'curl -q http://gitignore.io/api/\!:1'

    # https://github.com/blog/985-git-io-github-url-shortener
    alias gitio 'curl -i http://git.io -F "url=\!:1"'

    if(-x /Applications/Gitbox.app) alias gitbox 'open -a Gitbox \!*'

    # git statuses
    alias g 'git status --short \!*'
    alias gg 'git status --branch --short \!* && git stash list'
    alias ggg 'git status --branch --short --ignored \!* && git stash list'

    alias gb 'git branch | grep -v old/'
    alias gd 'git difftool'
    alias gu 'git gui browser'
    alias gs 'git stash list'
    alias gr 'git remote'

    # custom aliases defined in ~/.gitconfig (../dot-gitconfig)
    set gitaliases='bbdiff fetchcrazy fu heads lf lg open pr pub pullreq reup statuscrazy'

    set gitcmd="$gitaliases add am annotate apply archive bisect blame branch bundle cat-file checkout cherry cherry-pick citool clean clone commit commit-tree config describe diff diff-files diff-index diff-tree difftool fetch filter-branch format-patch fsck gc grep gui help init log ls-files ls-remote merge merge-base merge-file merge-one-file merge-ours merge-recursive merge-resolve merge-subtree merge-tree mergetool mktag mv name-rev notes patch-id prune prune-packed pull pull-rebase-no-ff push rebase reflog relink remote repack replace repo-config request-pull rerere reset rev-list rev-parse revert rm send-email shortlog show show-branch show-index show-ref stash status stripspace submodule symbolic-ref tag tar-tree update-index update-ref update-server-info var verify-tag whatchanged write-tree"

    #alias gitbranch 'git branch |& grep ^\* | cut -c3-33'
    alias gitbranch 'git rev-parse --abbrev-ref HEAD'
    alias gitbranches 'git for-each-ref --format="%(refname:short)" refs/heads/'
    alias gitremotes 'git remote'

    # ln -s "`brew --prefix git`/share/git-core/contrib/completion/git-completion.tcsh" ~/.git-completion.tcsh
    # ln -s "`brew --prefix`/etc/bash_completion.d/git-completion.bash" ~/.git-completion.bash
    #source ~/.git-completion.tcsh

    # My hand rolled completion:
    complete git "p/1/($gitcmd tf)/" "n/help/($gitcmd)/" 'n%checkout%`gitbranches`%' 'n/remote/(show add rm prune update)/' 'n/remote/(add rename rn set-url show prune update -v)/' 'N/remote/`gitremotes`/' 'n/stash/(branch clear drop list show pop)/' 'n/reset/(--soft --hard)/' 'n/push/`gitremotes`/' 'N/push/`gitbranch`/' 'n/tf/(clone configure checkin fetch pull shelve shelvesets)/'

endif
