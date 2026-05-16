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

# Folder module

:::{danger} Draft
This section is still being written.
:::

```{code-cell} bash
:tags: [remove-cell]
source bash-setup.sh
```

Let us create a project with a binary crate:

```{code-cell} bash
:class: dark-background full-color-output
cargo new --bin foo
```

```{code-cell} bash
:tags: [remove-cell]
pushd foo
cat >src/math.rs <<EOF
pub fn add(a: i16, b: i16) -> i16 {
  a + b
}
EOF
```

A module can also be written as a folder, in which case a file `mod.rs`
must be created inside the folder.
For instance if we want to define our `math` module as a folder, we need
to create a file `src/math/mod.rs`.

Here is the content of our file:

```{code-cell} bash
:tags: [remove-cell]
rm src/math.rs
mkdir src/math
cat >src/math/mod.rs <<EOF
pub fn add(a: i16, b: i16) -> i16 {
  a + b
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output
bat src/math/mod.rs
```

The main code file is written to use the `math` module:

```{code-cell} bash
:tags: [remove-cell]
cat >src/main.rs <<EOF
mod math;

fn main () {
  println!("{}", math::add(2, 6));
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output
bat src/main.rs
```

The program still compiles:

```{code-cell} bash
:class: dark-background full-color-output
cargo build
```

And we can run it:

```{code-cell} bash
:class: dark-background full-color-output
cargo run
```

The advantage of using a *folder* module is that we can define file
*sub-modules*.

```{code-cell} bash
:tags: [remove-cell]
popd
```
