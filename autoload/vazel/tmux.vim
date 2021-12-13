""
" Sends a bazel command to the designated tmux window
function! vazel#tmux#SendBazelCommand(bazel_command) abort
    let l:build_pane_id = call s:FindBuildPaneId()
    if l:build_pane_id ==# ''
        throw vazel#errors#FormatErrorMessage("Could not find build tmux pane")
    endif
    call system("tmux send-keys -t {bottom-left} \"" . a:bazel_command . "\" Enter")
endfunction
