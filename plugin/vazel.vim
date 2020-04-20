" Runs bazel build for the current file's package
command! VazelBuild :call vazel#Build()

" Runs ibazel build for the current file's package
command! VazelIBuild :call vazel#IBuild()

" Runs bazel test for the current file's package
command! VazelTest :call vazel#Test()

" Runs ibazel test for the current file's package
command! VazelITest :call vazel#ITest()

" Opens the BUILD/BUILD.bazel for the current file's package
command! VazelOpenBUILD :call vazel#OpenBUILD()
