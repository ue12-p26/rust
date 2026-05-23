---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  name: bash
  display_name: Bash
  language: bash
---

# Bash examples

:::{warning} To review
:::

To run a bash example by yourself, open a bash session using your
favourite terminal emulator (macOS Terminal, iTerm, Kitty, Git Bash,
MobaXterm, ...), and just copy & paste the commands.

The bash version used to run the examples for this book was:

```{code-cell} bash
:class: dark-background full-color-output

echo $BASH_VERSION
```

## Multi-cells example

Most bash examples run on multiple snippets (a.k.a.: *multi-cells*). In
such an example, one *single* session must be opened, and all the
commands must be run in the this session, without quitting it.
In the book, *multi-cells* examples are tagged on their right with
**start** for the first cell, **stop** for the last cell, and **cont**
for the cells in between.

Example:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

mkdir foo
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

pushd foo
touch a.txt
ls
```

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

popd
```

:::{warning} Pay attention to folder changes
Pay particular attention to commands that:

- Create directories.
- Change to a directory (i.e.: `cd some/folder` or `pushd
  some/folder`).
- Leave a directory (i.e.: `cd ..` or `popd`).

If you miss one of them, you will end running following commands
inside the wrong path and obtain the wrong results.
:::

## Availability of commands

Some commands are *native* bash commands (e.g.: `pushd`, `popd`,
`cd`, `echo`, ...), others must be installed on your system to run
them.

Standard Unix commands, like `mkdir`, `ls`, `find`, `cat`, etc, should
already be available on your system. Some others (e.g.: `which`,
`tree`) are not always installed by default, see
[Missing tools](#chp-howto-missing-tools).

Sometimes, you will find some *more modern* version of the Unix
commands (e.g.: `bat`, `eza`) that we use in the course for their
*better looking* and *clearer* outputs. See also
[Missing tools](#chp-howto-missing-tools) to know how to install
them.

## Running in another shell

All the examples have been tested with bash, not other shells.

However most of commands should work with other shells. So, for
instance, for macOS users, there is no need to run bash, they may
stay with zsh.
Unless it is explicitly stated in the course that you must use bash.
