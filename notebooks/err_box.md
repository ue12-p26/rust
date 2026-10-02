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

# Error polymorphism

:::{warning} To review
:class: readiness-toreview

:::

By the mean of *polymorphism* we can make error handling quite easy to
use. The key features we will use to achieve this, are:

- The implementation of the `Error` trait by all error types.
- The use of the [Box](https://doc.rust-lang.org/std/boxed/struct.Box.html)
  pointer structure.
- Error propagation using the *question mark* operator `?`.

First, we import the `Error` trait:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::error::Error;
```

Then we implement a function that reads float numbers from strings, and
use two functions that return `Result` objects that both use different
error objects. These both error types
(`std::collections::TryReserveError` and `std::FromStr::Err`) implement
the `Error` trait. Instead of naming them explictly inside the returned
`Result` object of the structure, we use the `Error` trait inside a
`Box`. The error objects will thus be moved to the *heap* inside a `Box`.
For both functions, we use the `?` operator to retrieve the value or
return with the error:

```{code-cell} rust
:class: seq-cont badges border

fn read_floats(strings: &[&str]) -> Result<Vec<f32>, Box<dyn Error>> {
  let mut v = Vec::new();
  v.try_reserve(2_000_000)?; // std::collections::TryReserveError
  for s in strings {
    let x = s.parse::<f32>()?; // std::FromStr::Err
    v.push(x);
  }
  Ok(v)
}
```

The following intermediate function will blindly pass any error object
that is returned by the `read_floats()` function:

```{code-cell} rust
:class: seq-cont badges border

fn do_stuff() -> Result<(), Box<dyn Error>> {
  let s = vec!["2.13", "5.1", "-10.4", "5O"];
  let v = read_floats(&s)?; // any Error
  println!("{v:?}");
  Ok(())
}
```

When calling the `do_stuff()` function, we apply a match to take actions
depending on the success or not:

```{code-cell} rust
:class: seq-stop badges border

match do_stuff() {
  Ok(()) => (),
  Err(e) => println!("An error occured: {e}"),
}
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
