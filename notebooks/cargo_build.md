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

# Building the project

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

To compile a whole project, we use the `build` sub-command.

Let us create a new project:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo init --bin foo
cd foo
```

Here is the running of the `build` sub-command:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo build
```

To build in *release* (i.e.: no debug information) mode:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo build -r
```
