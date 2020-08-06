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
