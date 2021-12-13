" Runs bazel build for the current file's package
command! -nargs=* VazelBuild :call vazel#Build(<f-args>)

" Runs ibazel build for the current file's package
command! -nargs=* VazelIBuild :call vazel#IBuild(<f-args>)

" Runs ibazel run for the given target
command! -nargs=* VazelRun :call vazel#Run(<f-args>)

" Runs ibazel run for the given target
command! -nargs=* VazelIRun :call vazel#IRun(<f-args>)

" Runs bazel test for the current file's package
command! VazelTest :call vazel#Test()

" Runs ibazel test for the current file's package
command! VazelITest :call vazel#ITest()

" Opens the BUILD (or BUILD.bazel) for the current file's package in a horizontal split
command! VazelSpBUILD :call vazel#OpenBUILDInHorizontalSplit()

" Opens the BUILD (or BUILD.bazel) for the current file's package in a vertical split
command! VazelVsBUILD :call vazel#OpenBUILDInVerticalSplit()

" Yanks the package label for the current source file's package
command -nargs=? VazelYankPackageLabel :call vazel#YankPackageLabel(<f-args>)

" Define which pane should be used for building. As an argument you can pass
" either the pane ID ($TMUX_PANE) or either of the tokens `{top-right}` or
" `{bottom-left}`
command! -nargs=1 VazelSetBuildPane :call vazel#tmux#SetBuildPane(<f-args>)
