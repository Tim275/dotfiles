#!/usr/bin/env bash
# Cyberdream tmux - Git Status Widget
# Shows: branch, staged (+), modified (~), untracked (?)

get_git_info() {
    cd "$1" 2>/dev/null || return

    # Check if in git repo
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi

    # Get branch name
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [ -z "$branch" ] && return

    # Get status counts
    local staged=0 modified=0 untracked=0

    while IFS= read -r line; do
        case "${line:0:2}" in
            "A "|"M "|"D "|"R "|"C ") ((staged++)) ;;
            " M"|" D") ((modified++)) ;;
            "??") ((untracked++)) ;;
            "AM"|"MM") ((staged++)); ((modified++)) ;;
        esac
    done < <(git status --porcelain 2>/dev/null)

    # Build output
    local output=" $branch"

    [ $staged -gt 0 ] && output="$output +$staged"
    [ $modified -gt 0 ] && output="$output ~$modified"
    [ $untracked -gt 0 ] && output="$output ?$untracked"

    echo "$output"
}

# Get pane's current path
PANE_PATH="$1"
[ -z "$PANE_PATH" ] && PANE_PATH="$PWD"

get_git_info "$PANE_PATH"
