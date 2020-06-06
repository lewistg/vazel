""
" Build the current package with bazel
function! vazel#Build() abort
    let l:package_label = s:GetPackageLabel()
    let l:build_command = 'bazel build ' . l:package_label
    call s:SendBazelCommand(l:build_command)
endfunction

""
" Build the current package with ibazel
function! vazel#IBuild()
    let l:package_label = s:GetPackageLabel()
    let l:build_command = 'ibazel --run_output --run_output_interactive=false build ' . l:package_label
    call s:SendBazelCommand(l:build_command)
endfunction

""
" Build the current package with ibazel
function! vazel#Test()
    let l:package_label = s:GetPackageLabel()
    let l:build_command = 'bazel test ' . l:package_label
    call s:SendBazelCommand(l:build_command)
endfunction

""
" Build the current package with ibazel
function! vazel#ITest()
    let l:package_label = s:GetPackageLabel()
    let l:build_command = 'ibazel --run_output --run_output_interactive=false test ' . l:package_label
    call s:SendBazelCommand(l:build_command)
endfunction

""
" Build the current package with ibazel
function! vazel#IRun(...)
    let l:target = ""
    if !empty(a:000) && a:000[-1] !=# ""
        let l:target = ":" . a:000[-1]
    endif
    let l:package_label = s:GetPackageLabel()
    let l:build_command = 'ibazel run ' . l:package_label . l:target
    call s:SendBazelCommand(l:build_command)
endfunction

""
" Open the BUILD.bazel file for the current file's package
function! vazel#OpenBUILD() abort
    let l:build_file = s:FindBUILDFile()
    if l:build_file ==# ""
        throw "Could not find BUILD file"
    endif
    execute "vs " . l:build_file
endfunction

function! s:GetPackageLabel() abort
    let l:workspace_path = s:GetWorkspacePath()
    let l:package_path = s:GetPackagePath()
    return "/" . substitute(l:package_path, l:workspace_path, "", "g")
endfunction

""
" Sends a bazel command to the designated tmux window
function! s:SendBazelCommand(bazel_command) abort
    call system("tmux send-keys -t {bottom-left} \"" . a:bazel_command . "\" Enter")
endfunction

""
" Gets the absolute path to the bazel root of the current workspace
function! s:GetWorkspacePath() abort
    return s:FindDirectoryWithFile("WORKSPACE")
endfunction

""
" Gets the absolute path to the bazel root of the current workspace
function! s:GetPackagePath() abort
    let l:build_file = s:FindBUILDFile()
    return fnamemodify(l:build_file, ":p:h")
endfunction

function! s:FindBUILDFile() abort
    let l:prev_suffixesadd = &suffixesadd
    let &suffixesadd = ".bazel"
    let l:build_file = findfile("BUILD", ".;")
    let l:build_file = fnamemodify(l:build_file, ":p")
    let &suffixesadd = l:prev_suffixesadd
    return l:build_file
endfunction

""
" Gets the absolute file path of a file searching up the file tree
function! s:FindDirectoryWithFile(file_name) abort
    let l:workspace_path = findfile(a:file_name, ".;")
    if l:workspace_path ==# ""
        throw "Could not find file: " . a:file_name
    else 
        return fnamemodify(l:workspace_path, ":p:h")
    endif
endfunction
