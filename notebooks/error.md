---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# Error trait

:::{warning} To review
:class: readiness-toreview

:::

The [Error](https://doc.rust-lang.org/std/error/trait.Error.html) trait
is used by the *standard library* and most crates for their error types.

To implement the `Error` trait for a custom error we need to implement
the `Debug` and `Display` traits:

1. The `Debug` implementation can be done using the `derive()` macro.
2. The `Display` implementation must be done manually.
3. The `Error` implementation must just be declared, there is *no method*
   to implement.

First, we import the `Error` trait and the `fmt` (i.e.: format) module:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::error::Error;
use std::fmt;
```

We declare a custom error, using here a `struct` with a single message
field, but an `enum` would do also. Note the implementation of the
`Debug` trait through the `derive` attribute:

```{code-cell} rust
:class: seq-cont badges border

#[derive(Debug)]
struct MyError {
  msg: &'static str,
}
```

We then implement the `Display` formatter trait that will allow to print
our error through the `print!()` and `format!()` macros:

```{code-cell} rust
:class: seq-cont badges border

impl fmt::Display for MyError {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "{}", self.msg)
  }
}
```

Finally, we implement the `Error` trait, which requires no method
definition:

```{code-cell} rust
:class: seq-cont badges border

impl Error for MyError {}
```

Now we can define an example function that returns a `Result` that uses
our *custom error*:

```{code-cell} rust
:class: seq-cont badges border

fn foo(x: f32) -> Result<f32, MyError> {
  if x > 1.0 {
    Ok(2.0 * x)
  } else {
    Err(MyError { msg: "My error message." })
  }
}
```

Here is a usage of the `foo()` function with two different values:

```{code-cell} rust
:class: seq-stop badges border

for x in [0.2, 1.1] {
  match foo(x) {
    Ok(y) => println!("{y}"),
    Err(e) => println!("{e}"),
  }
}
```
