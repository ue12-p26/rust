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

# Resources

Various sources are available to learn the Rust language.

The first places where to start are:

- The official book
  [The Rust Programming Language](https://doc.rust-lang.org/stable/book/).
- Its companion
  [Rust By Example](https://doc.rust-lang.org/rust-by-example/index.html)
  that illustrates each point of the language with examples.
- [The Rust Reference](https://doc.rust-lang.org/reference/introduction.html).
- The reference of
  [The Rust Standard Library](https://doc.rust-lang.org/std/index.html).

An interesting resource to explore while reading the books is the
`rustlings` package. It is a Rust program that helps learning the Rust
language through exercises.
To install it, run the following commands that will create a `rustlings`
folder in which exercises will be written:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo install rustlings
rustlings init
cd rustlings
rustlings
```

The `rustlings` program presents one exercise at a time that we have to
solve inside our preferred editor, checks our solution, and if successful
passes to the next exercise. It tracks and stores our progress, so we can
pause and continue later. There are almost 100 exercises to solve.

:::{note} Cargo binary install folder
The `cargo install` command installs a binary Rust program into the
default folder `$HOME/.cargo/bin` under \*nix platforms. The folder needs
to be added to the `PATH` environment variable to give access to all Rust
binaries installed.
:::

A complete list of all official resources can be found in
[The Little Book of Rust Books](https://lborb.github.io/book/official.html).

The web site [https://lib.rs/](https://lib.rs/) is a good place to search
for Rust packages.

Finally, if interested in games, the website
[Are we game yet?](https://arewegameyet.rs/) is an essential place where to
find pointers to game related libraries, and also to games made in Rust.
