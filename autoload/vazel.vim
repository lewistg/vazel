let s:BAZEL = 'bazel'
let s:IBAZEL = 'ibazel'

let s:BUILD = 'build'
let s:RUN = 'run'
let s:TEST = 'test'

""
" Build the current package with bazel
function! vazel#Build(...) abort
    let l:args = s:ParseCommandArguments(a:000)
    let l:target_label = s:GetTargetLabel(l:args.target_name)
    let l:command = s:FormatBazelCommand(s:BAZEL, s:BUILD, l:args.native_bazel_options, l:target_label)
    call s:SendBazelCommand(l:command)
endfunction

""
" Build the current package with ibazel
function! vazel#IBuild(...) abort
    let l:args = s:ParseCommandArguments(a:000)
    let l:options = '--run_output --run_output_interactive=false ' . l:args.native_bazel_options
    let l:target_label = s:GetTargetLabel(l:args.target_name)
    let l:command = s:FormatBazelCommand(s:IBAZEL, s:BUILD, l:options, l:target_label)
    call s:SendBazelCommand(l:command)
endfunction

""
" Build the current package with ibazel
function! vazel#Test() abort
    let l:package_label = s:GetPackageLabel()
    let l:build_command = 'bazel test ' . l:package_label
    call s:SendBazelCommand(l:build_command)
endfunction

""
" Build the current package with ibazel
function! vazel#ITest()
    let l:args = s:ParseCommandArguments(a:000)
    let l:options = '--run_output --run_output_interactive=false ' + l:args.native_bazel_options
    let l:target_label = s:GetTargetLabel(l:args.target_name)
    let l:command = s:FormatBazelCommand(s:IBAZEL, s:TEST, l:options, l:target_label)
    call s:SendBazelCommand(l:build_command)
endfunction

""
" Run an executable target
function! vazel#Run(...) abort
    let l:args = s:ParseCommandArguments(a:000)
    let l:target_label = s:GetTargetLabel(l:args.target_name)
    let l:command = s:FormatBazelCommand(s:BAZEL, s:RUN, l:args.native_bazel_options, l:target_label)
    call s:SendBazelCommand(l:command)
endfunction

""
" Run an executable target with ibazel
function! vazel#IRun(...) abort
    let l:args = s:ParseCommandArguments(a:000)
    let l:target_label = s:GetTargetLabel(l:args.target_name)
    let l:command = s:FormatBazelCommand(s:IBAZEL, s:RUN, l:args.native_bazel_options, l:target_label)
    call s:SendBazelCommand(l:command)
endfunction

function! s:FormatBazelCommand(command, sub_command, options, target) abort
    let l:command_string = a:command
    if a:options !=# ""
        let l:command_string = l:command_string . " " . a:options
    endif
    let l:command_string = l:command_string . " " . a:sub_command . " " . a:target
    return l:command_string
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

function! s:ParseCommandArguments(command_args) abort
    let l:args = {}

    " Set defaults
    let l:args.target_name = ''
    let l:args.native_bazel_options = ''

    if empty(a:command_args)
        return l:args
    endif

    let l:native_bazel_options_start_index = index(a:command_args, "--")
    if l:native_bazel_options_start_index == -1
        let l:native_bazel_options_start_index = len(a:command_args)
    else
        let l:native_bazel_options_start_index += 1
    endif
    
    let l:vazel_options = a:command_args[0:l:native_bazel_options_start_index - 2]
    let l:args.target_name = get(l:vazel_options, -1, '')

    let l:args.native_bazel_options = join(a:command_args[l:native_bazel_options_start_index:])

    return l:args 
endfunction

function! s:GetTargetLabel(target_name) abort
    let l:target_suffix = ""
    if a:target_name !=# ""
        let l:target_suffix = ":" . a:target_name
    endif
    let l:package_label = s:GetPackageLabel()
    return l:package_label . l:target_suffix
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
