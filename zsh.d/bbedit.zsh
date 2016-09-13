compdef _gnu_generic bbedit bbdiff bbfind bbresults


# bbproj() {
#     open "~/Dropbox/Documents/bbproj/$1"
# }

_BB_DOC_PATH() {
    osascript <<-EOF

    tell application "BBEdit"
        if the first text document exists then
            file of first text document as alias
            POSIX path of result
        else
            beep
        end if
    end tell

EOF
}

# Get path to the first BBEdit text document's directory.
# cwdbbedit() {
#     osascript <<-EOF
#
#     tell application "BBEdit"
#         if the first text document exists then
#             file of first text document as alias
#             tell application "Finder" to folder of result as alias
#             POSIX path of result
#         else
#             beep
#         end if
#     end tell
#
# EOF
# }

cdbbedit() {
    cd -P "$(dirname "$(_BB_DOC_PATH)")" || exit 1
}
