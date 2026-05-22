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

# The `main` function

```{code-cell} bash
:tags: [remove-cell]
source bash-setup.sh
```

The `main()` function is the required entry point of a program in Rust.
There can be only one `main()` function in a program.

With the following command we create a new folder named `my_program`
initialized as a Cargo binary (i.e.: program, not library) project:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border
cargo init my_program
```

We enter the folder:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
cd my_program
```

And look at its content:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
exa -T
```

In the `src` folder is a single file named `main.rs` that contains a
function `main()` with a default implementation that prints a message:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat src/main.rs
```

We may build the program:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
cargo build
```

And run it through Cargo:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border
cargo run
```

:::{note} Build & run
We may have launched only the `run` sub-command since it automatically
executes the *build* step if needed.
:::

:::{exercise} First program
:label: first-program
:enumerated: true

Create a new Cargo project named `factorial` and write a program that
computes the factorial of 20, using a recursive function.
Print the result on the standard output stream (i.e.: using the
`println!()` macro).
:::

[see solution](#first-program-solution)
