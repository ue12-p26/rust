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

# Initializing a project

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

Creating a new project from scratch is easily done with Cargo.
To initialize a new project inside a new directory named `foo`, we run:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo init --bin foo
```

This will create a project file `Cargo.toml` and a source file `src/main.rs`
that contains a default `main()` function:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

eza -T foo
```

The project file defines a *project name*, a *project version* and the
*edition year* of the `cargo` tool to use for managing this project:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat foo/Cargo.toml
```

If we look at the *hidden* files inside the project folder, we find that
two Git related files have also been created:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

ls -a foo
```

The `.git` folder means a Git database has been created.
The `.gitignore` file contains a single line that makes Git ignore the
`target` folder that is used by Cargo for its building outputs:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat foo/.gitignore
```

Note that, however, the created Git database is left empty. All
created files are list as *untracked*. This is up to us to include
them or not inside the Git repository:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

pushd foo
git status
```

:::{note} `new` sub-command
The `new` sub-command is also used for initializing a project, but only when
creating a new directories. If the directory already exists, the command will
fail.
:::

:::{note} Application or Library
The `--bin` argument we have been using with `cargo`, generates a project
for an application.
To generate a library project, we would use the `--lib` argument.
:::
