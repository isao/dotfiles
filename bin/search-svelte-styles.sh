#!/usr/bin/env bash

# Search for CSS selectors within <style> blocks in Svelte files
# Usage: search-svelte-styles.sh PATTERN [PATH]

set -euo pipefail

# Hyperlink URL format.
URL_FMT="x-bbedit://open?url=file://%s&line=%d&column=%d"

# Terminal hyperlink codes: \033]8;;URL\033\\TEXT\033]8;;\033\\
LINK_FMT='\033]8;;%s\033\\%s:%d\033]8;;\033\\:%s\n'

search_svelte_styles() {
  local pattern="$1"
  local search_path="${2:-.}"

  # Convert to absolute path for hyperlinking.
  search_path=$(realpath "$search_path")

  local awk_script="
    /<style[^>]*>/,/<\/style>/ {
      if (match(\$0, pat)) {
        # FNR is the line number in the current file
        # RSTART is the column
        url = sprintf(url_fmt, FILENAME, FNR, RSTART)
        printf link_fmt, url, FILENAME, FNR, \$0
      }
    }"

  rg --glob '*.svelte' -l "(^|\s+)$pattern\b\W*" "$search_path" \
    | xargs awk \
        -v pat="$pattern" \
        -v url_fmt="$URL_FMT" \
        -v link_fmt="$LINK_FMT" \
        "$awk_script"
}

# Check arguments
if [ $# -eq 0 ]; then
  echo "Usage: $0 PATTERN [PATH]"
  echo
  echo "Search for CSS selectors within <style> blocks in Svelte files"
  echo
  echo "Examples:"
  echo "  $0 section"
  echo "  $0 section /path/to/project"
  exit 1
fi

search_svelte_styles "$@"
