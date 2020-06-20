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

" Opens the BUILD/BUILD.bazel for the current file's package
command! VazelOpenBUILD :call vazel#OpenBUILD()
