# Vazel: bazel + vim + tmux

Vazel is a plugin geared towards a bazel-vim-tmux setup, so it might not be for
everyone. In fact, I built it for my own particular workflow.

In tmux I normally have one window dedicated to development. This window has
two panes in a horizontal split. The top pane runs vim and the bottom pane is
for running bazel commands, among other miscellaneous shell commands.
(See diagram below.)


```
+--------------------------------+ 
|                                | 
|                                | 
|                                | 
|          <vim pane>            | 
|                                | 
|                                | 
|                                | 
+--------------------------------+ 
|                                | 
|       <terminal pane>          |
|                                | 
+--------------------------------+ 
```

The main feature of vazel is sending `bazel build` and `bazel test` commands to the
terminal pane. For example, let's say I am editing the file
`~/myproject/src/main/scala/com/foo/bar/Bar.scala`. And lets say this file is
part of the `//myproject/src/main/scala/com/foo` package. Then if I run the
vazel plugin command `VazelBuild`, then the command
`bazel build //myproject/src/main/scala/com/foo` will start running in the
terminal pane. 
