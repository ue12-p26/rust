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

# Running the application

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

Let us initialize a new project:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo init --bin foo
cd foo
```

To run the application, we use the `run` sub-command:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo run
```

If there are multiple binaries in the project, we use the `--bin` option to
set the binary to run:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo run --bin foo
```

To pass, argument to our binary, we would set them after a double dash `--`:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo run --bin foo -- arg1 arg2 arg3 ...
```
