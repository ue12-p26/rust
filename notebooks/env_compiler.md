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

# Rust compiler

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

The Rust compiler is used to compile and link Rust code files. Though we may
use it directly (and it is used this way in this book to run the various
examples), we mainly use it in practice through `cargo`.

## Compiling with `rustc`

```{code-cell} bash
:tags: [remove-cell]

cat >hello.rs <<EOF
fn main() {
  println!("Hello world!");
}
EOF
```

To compile the following rust file:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

bat hello.rs
```

We have to run the following command:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

rustc hello.rs
```

This command produces the binary `hello` that we can run:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

./hello
```

## Handling error messages

```{code-cell} bash
:tags: [remove-cell]

cat >hello.rs <<EOF
struct A {
  i: i8,
  i: i8,
}

fn main() {
  let a = A {i: 1, j: 2};
}
EOF
```

In the following code, we have introduced an error. The `i` variable is
defined twice in the same scope. Plus another error a bit below.

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat hello.rs
```

If we try to compile this code:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
:tags: [raises-exception]

rustc hello.rs
```

The compiler `rustc` fails and gives us multiple informations for each error:

1. The error number: `E0124` or `E0560`.
2. A short description of the error.
3. The exact place of the error.
4. Eventually some hints about the cause or the context of the error.

Finally `rustc` gives an error count (`error: aborting due to 2 previous
errors`) and explains us how to get more information about these errors.

Here is the output given by `rustc` when asking for informations about the
first error:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

rustc --explain E0124
```

:::{note} Resource page on all error codes
We may also find these explanations on internet:
[Error code E0124](https://doc.rust-lang.org/error_codes/E0124.html).
The page [Rust error codes index](https://doc.rust-lang.org/error_codes/)
gathers all error codes.
:::
