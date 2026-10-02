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

# Manual propagation

:::{warning} To review
:class: readiness-toreview

:::

Errors may be propagated from one function to another using the returned
value explicitly.

Let us define a custom error enum for a factorial function:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
enum MyError {
  ForbiddenNumber,
}
```

Here is the factorial function that returns an error when the input
number is negative:

```{code-cell} rust
:class: seq-cont badges border

fn fact(n: i64) -> Result<i64, MyError> {
  if n < 0 {
    Err(MyError::ForbiddenNumber)
  } else if n < 2 {
    Ok(1)
  } else {
    match fact(n-1) {
      Ok(m) => Ok(n * m),
      Err(e) => Err(e),
    }
  }
}
```

The following combination function *propagates* the error of any call to
the factorial function:

```{code-cell} rust
:class: seq-cont badges border

fn combination(n: i64, r: i64) -> Result<i64, MyError> {

  let a = match fact(n) {
    Ok(m) => m,
    Err(e) => return Err(e),
  };

  let b = match fact(r) {
    Ok(m) => m,
    Err(e) => return Err(e),
  };

  let c = match fact(n-r) {
    Ok(m) => m,
    Err(e) => return Err(e),
  };

  Ok(a / b / c)
}
```

Here is an example that triggers an error:

```{code-cell} rust
:class: seq-stop badges border

combination(12, 15)
```
