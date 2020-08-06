# Vazel: Bazel + Vim + tmux

Vazel is a plugin geared towards a Bazel-Vim-tmux setup, so it might not be for
everyone. In fact, I built it for my own particular workflow.

In tmux I normally have one window dedicated to development. This window has
two panes in a horizontal split. The top pane runs Vim and the bottom pane is a
terminal for running Bazel commands, among other miscellaneous shell commands.
(See diagram below.)


```
+--------------------------------+ 
|                                | 
|                                | 
|                                | 
|          <Vim pane>            | 
|                                | 
|                                | 
|                                | 
+--------------------------------+ 
|                                | 
|       <Terminal pane>          |
|                                | 
+--------------------------------+ 
```

The main feature of Vazel is sending `bazel build` and `bazel test` commands to the
terminal pane. For example, let's say I am editing the file
`~/myproject/src/main/scala/com/foo/bar/Bar.scala`. And lets say this file is
part of the `//myproject/src/main/scala/com/foo` package. Then if I run the
Vazel plugin command `VazelBuild`, then the command
`bazel build //myproject/src/main/scala/com/foo` will start running in the
terminal pane. 

## Commands

* `:VazelBuild [target_name] [-- [bazel_options]]` Constructs a Bazel command
  of the form below and sends it to the terminal window.  
  ``` 
  bazel build [bazel_options] //<files_current_package>[:<target_name>] 
  ``` 

* `:VazelRun [target_name] [-- [bazel_options]]` Constructs a Bazel command of
  the form below and sends it to the terminal window.  
  ``` 
  bazel run [bazel_options] //<files_current_package>[:<target_name>] 
  ```

* `:VazelTest [target_name] [-- [bazel_options]]` Constructs a Bazel command of
  the form below and sends it to the terminal window.  
  ``` 
  bazel test [bazel_options] //<files_current_package>[:<target_name>] 
  ```

* `:VazelSpBUILD` Opens the BUILD (or BUILD.bazel) for the current file's
  package in a horizontal split.

* `:VazelVsBUILD` Opens the BUILD (or BUILD.bazel) for the current file's
  package in a vertical split.
