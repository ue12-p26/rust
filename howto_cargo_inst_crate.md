---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: bash
  display_name: Bash
  language: bash
---

(chp-howto-cargo-inst-crate)=
# Install a crate with `cargo`

:::{warning} To review
:::

`cargo` is the Rust package manager. It is thus used to installed
applications written in the Rust language.
Many useful system applications have been written in Rust, hence
`cargo` may be a solution to install a tool that your operating
system does not provide.

To install `cargo` on your system search for the `rustup` package
and install it. Then execute `rustup` and follow the instructions.
You may also use the command provided on
[https://rustup.rs/](https://rustup.rs/) to install rustup.

Once installed you should have access to the `cargo` command.
To search for a crate (`bat` in the following example), use the
`search` sub-command:

```{code-cell} bash
:class: dark-background full-color-output
cargo search bat
```

To install a crate, use the `install` sub-command:

```bash
cargo install bat
```

The `bat` binary will be installed by default in `$HOME/.cargo/bin`,
which is the default destination of *all binaries* installed from
crates:

```{code-cell} bash
:class: dark-background full-color-output
which bat
```

Thus we need to make sure that this path is defined inside our
`PATH` environment variable. See [PATH env var](#chp-howto-path) to
learn what is the `PATH` environment variable and how to add a
folder path to it.
