# barhop.el

Note: Highly experimental package, really rough edges etc.

This package is based on a pretty simple observation: no one ever needs a
shorthand for `jjjjjjjjj`, or `kkkkkkk`. But the keybindings are really
convenient (`C-9 j` and `C-7 k`).

Another observation is this: speedbars are a neat idea, but they just always
feel so goddamn heavyweight. They turn Emacs into Visual Studio.

So I combined these two observations and made a light-weight speedbar that
utilizes `C-<N> j` for something better than "insert `j` <N> times"! Barhop
lists your open project buffers in a sidebar and lets you jump to them super
easily.

Note: Don't expect a super polished package. I only published it to get some
feedback and possibly inspire someone else to do something useful and creative
with prefix arg + char. However, I actually use this package rather frequently,
especially on larger projects which require lots of file jumping (Android, Yocto
and similar projects come to mind).

Note: For now, `counsel-projectile` is a hard requirement due to lazy elisp.

Note: Evil users, stay far away! This probably won't combine nicely with your workflow. 

Usage: Just bind `barhop-mode` to something convenient and you're good to go.
`C-<num> j` jumps to buffer number `num`, `C-<num> K` kills it, `C-<num> J`
jumps to it in `other-window`.
