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

# Automatic propagation

:::{warning} To review
:class: readiness-toreview

:::

The *question mark* operator (`?`) is used to easily propagate some
enumerate values. The action of the operator is to:

- Either return the *contained value*.
- Or propagate the other case (i.e.: return the other value like `Err`,
  `None`, etc.).

It works with the following constructs:

- A [Result](#chp-result).
- A [Option](#chp-option).
- A [ControlFlow](#chp-control-flow).
- A [Poll](#chp-poll).

Let us redefine our custom error enum for a factorial function:

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

The factorial function is a bit simpler when dealing the case of the
actual computing:

```{code-cell} rust
:class: seq-cont badges border

fn fact(n: i64) -> Result<i64, MyError> {
  if n < 0 {
    Err(MyError::ForbiddenNumber)
  } else if n < 2 {
    Ok(1)
  } else {
    Ok(n * fact(n-1)?)
  }
}
```

The combination function is drastically simpler, with a one-liner
evaluation:

```{code-cell} rust
:class: seq-cont badges border

fn combination(n: i64, r: i64) -> Result<i64, MyError> {
  Ok(fact(n)? / fact(r)? / fact(n-r)?)
}
```

The result is exactly the same as the manual propagation:

```{code-cell} rust
:class: seq-stop badges border

combination(12, 15)
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
