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

# Checking the project

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

The `check` sub-command checks for errors inside the local packages and its
dependencies. To do that, it runs a compiling up to, but excluding, the code
generation. This means that most of compiling errors will be detected, but not
all. However, it performs faster that the `build` sub-command, and thus is
interesting for quick error checking.

Let us create a new project:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo init --bin foo
cd foo
```

Here is the execution of the `check` sub-command:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo check
```
