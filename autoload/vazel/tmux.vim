let g:vazel_default_build_pane = get(g:, 'vazel_default_build_pane', ['{top-right}', '{bottom-left}'])

let s:pane_tokens = {
    \ '{top-right}': 1,
    \ '{bottom-left}': 2,
    \ '{bottom-right}': 3,
\}

""
" Sends a bazel command to the designated tmux window
function! vazel#tmux#SendBazelCommand(bazel_command) abort
    let l:build_pane_target = s:GetBuildPaneTarget()
    if l:build_pane_target ==# ''
        throw vazel#errors#FormatErrorMessage("Could not find tmux build pane")
    endif
    let l:tmux_command = join([
        \ "tmux",
        \ "send-keys",
        \ "-t",
        \ l:build_pane_target,
        \ '"' . a:bazel_command . '"',
        \ "Enter"
    \], " ")
    echom l:tmux_command
    " call system("tmux send-keys -t {bottom-left} \"" . a:bazel_command . "\" Enter")
    call system(l:tmux_command)
endfunction

""
" Sets which pane is used for the build
function vazel#tmux#SetBuildPane(pane_id_or_token) abort 
    let s:build_pane_id_or_token = a:pane_id_or_token
endfunction

function! s:GetBuildPaneTarget() abort
    if exists('s:build_pane_id_or_token')
        return s:build_pane_id_or_token
    endif
    function! ParsePaneString(index, line) abort
        let l:match = matchlist(a:line, '\(%\d\+\) \(\d\) \(\d\) \(\d\) \(\d\) \(\d\)')
        if l:match[5] ==# '1'
            " Is the active pane 
            return {}
        end
        return { 
            \ 'pane_id': l:match[1],
            \ 'pane_at_top': str2nr(l:match[2]),
            \ 'pane_at_right': str2nr(l:match[3]),
            \ 'pane_at_bottom': str2nr(l:match[4]),
            \ 'pane_at_left': str2nr(l:match[5]),
        \}
    endfunction

    let l:pane_strings = systemlist("tmux list-panes -F '#{pane_id} #{pane_at_top} #{pane_at_right} #{pane_at_bottom} #{pane_at_left} #{pane_active}'")
    let l:panes = map(l:pane_strings, funcref('ParsePaneString'))
    call filter(l:panes, { index, pane_dict -> len(pane_dict) })

    let l:panes_by_token = {}
    for pane in l:panes
        if pane['pane_at_top'] ==# 1 && pane['pane_at_right'] ==# 1
            let l:panes_by_token['{top-right}'] = pane['pane_id']
        elseif pane['pane_at_bottom'] ==# 1 && pane['pane_at_left'] ==# 1
            let l:panes_by_token['{bottom_left}'] = pane['pane_id']
        endif
    endfor

    for pane_token in g:vazel_default_build_pane
        if has_key(l:panes_by_token, pane_token)
            return l:panes_by_token[pane_token]
        endif
    endfor

    return ''
endfunction
