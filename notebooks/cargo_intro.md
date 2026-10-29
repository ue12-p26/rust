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

# Introduction

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

`cargo` is the Rust package manager, and is as well used to manage a Rust
project as to install applications (crates) from the official repository.

The different actions provided by `cargo` are accessed through a set of
sub-commands. See {numref}`tab-cargo-subcmds` for a list of the main
sub-commands.
To get the full list of sub-commands, run the following command:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo --list
```

:::{list-table} Main sub-commands of `cargo`
:name: tab-cargo-subcmds
:header-rows: 1
:align: center

* - Sub-command
  - Shortcut
  - Description
* - `add`
  -
  - Add dependencies to a Cargo.toml manifest file.
* - `build`
  -
  - Compile a local package and all of its dependencies.
* - `check`
  -
  - Check a local package and all of its dependencies for errors.
* - `clean`
  -
  - Remove artifacts that cargo has generated in the past.
* - `clippy`
  -
  - Check a package to catch common mistakes and improve your Rust code.
* - `config`
  -
  - Inspect configuration values.
* - `doc`
  - `d`
  - Build a package's documentation.
* - `fix`
  -
  - Automatically fix lint warnings reported by rustc.
* - `init`
  -
  - Create a new cargo package in a new or existing directory.
* - `install`
  -
  - Install a Rust binary.
* - `new`
  -
  - Create a new cargo package in a new directory.
* - `remove`
  - `rm`
  - Remove dependencies from a Cargo.toml manifest file.
* - `run`
  - `r`
  - Run a binary or example of the local package.
* - `search`
  -
  - Search packages in the registry. Default registry is *crates.io*.
* - `test`
  - `t`
  - Execute all unit and integration tests and build examples of a local
    package.
* - `tree`
  -
  - Display a tree visualization of a dependency graph.
* - `uninstall`
  -
  - Remove a Rust binary.
* - `version`
  -
  - Show version information.
:::
