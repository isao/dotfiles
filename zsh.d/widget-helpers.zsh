#
#   WIDGET HELPERS
#

# Helper: Extract word under cursor from LBUFFER/RBUFFER.
# Sets: _imy_query, _imy_prefix, _imy_suffix
#
# Examples (| = cursor):
#   command line         LBUFFER            RBUFFER        _imy_query
#   ──────────────────   ────────────────   ────────────   ─────────────
#   "cd proj|"           "cd proj"          ""             "proj"
#   "cd foo/bar/baz|"    "cd foo/bar/baz"   ""             "foo/bar/baz"
#   "cmd --foo=bar|"     "cmd --foo=bar"    ""             "bar"
#   "cd proj|ects"       "cd proj"          "ects"         "projects"
#   "vim |main.ts"       "vim "             "main.ts"      "main.ts"
#
_imy_word_under_cursor() {
    local left="${LBUFFER##*[ =]}"   # partial word before cursor (after last space or =)
    local right="${RBUFFER%% *}"     # partial word after cursor (up to first space)
    _imy_query="${left}${right}"     # complete word at/under cursor
    _imy_prefix="${LBUFFER%$left}"   # everything before the word
    _imy_suffix="${RBUFFER#$right}"  # everything after the word
}

# Helper: Replace word under cursor with selection (requires _imy_word_under_cursor first).
_imy_replace_word() {
    if [[ -n "$1" ]]; then
        LBUFFER="${_imy_prefix}$1"
        RBUFFER="${_imy_suffix}"
    fi
}
