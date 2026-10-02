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

(chp-result)=
# Result

:::{warning} To review
:class: readiness-toreview

:::

The generic [Result<T, E>](https://doc.rust-lang.org/std/result/enum.Result.html)
enum serves to transmit a *recoverable* error. It is used to return a
value from a function when an error is possible. The enum is made to
transport either the *value* through its `Ok(T)` variant or the *error*
through its `Err(E)` variant.

The definition of the `Result<T, E>` enum is as following:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

enum Result<T, E> {
  Ok(T),
  Err(E),
}
```

Some of the methods of `Result<T, E>` are presented in
{numref}`tab-result-methods`. See
[Result<T, E>](https://doc.rust-lang.org/std/result/enum.Result.html) for
a full list.

:::{list-table} Some methods of `Result<T, E>`
:name: tab-result-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `and(other)`
  - Returns `Err` if this `Result` is `Err` otherwise returns `other`.
* - `and_then(f)`
  - Returns `Err` if this `Result` is `Err` otherwise calls `f()` with
    the wrapped value.
* - `cloned()`
  - Convert a `Result<&T, E>` into a `Result<T, E>` by cloning.
* - `copied()`
  - Convert a `Result<&T, E>` into a `Result<T, E>` by copying.
* - `err()`
  - Converts `Result<T, E>` into `Option<E>`.
* - `expect(m)`
  - Returns `T` if `Ok(T)`, or *panic* with the custom message `m`.
* - `flatten()`
  - Returns a `Result<T, E>` if this object is a `Result<Result<T, E>,
    E>`.
* - `inspect(f)`
  - Calls function `f()` on the contained value, then returns this
    `Result<T, E>` instance.
* - `is_err()`
  - Returns `true` if `Err(e)`.
* - `is_ok()`
  - Returns `true` if `Ok(v)`.
* - `iter()`
  - Returns an iterator on the possibly contained value.
* - `iter_mut()`
  - Returns a mutable iterator on the possibly contained value.
* - `map(f)`
  - Maps the function `f()` on the contained value if any or returns
    `Err`.
* - `map_or(v, f)`
  - Maps the function `f()` on the contained value if any or returns `v`.
* - `ok()`
  - Transforms the `Result<T, E>` into an `Option<T>`, mapping `Ok(v)` to
    `Some(v)` and `Err(e)` to `None`.
* - `or(other)`
  - Returns this result if it contains a value, otherwise returns
    `other`.
* - `or_else(f)`
  - Returns this result if it contains a value, otherwise calls `f()`
    and returns its value.
* - `transpose()`
  - Transposes a `Result<Option<T>, E>` into an `Option<Result<T, E>>`.
* - `unwrap()`
  - Returns the current value `v` if `Ok(v)`, or *panics* if `Err`.
* - `unwrap_or(u)`
  - Returns the current value `v` if `Ok(v)`, or `u` if `Err`.
* - `unwrap_or_else(f)`
  - Returns the current value `v` if `Ok(v)`, or executes the function
    `f` and returns its value.
:::

## Returning a Result

Using `Result` we can now return an error from a function. Here is an
implementation of the *factorial* that takes a *signed* integer. We
handle the case of negative values by returning an `Err` value, while we
return an `Ok` value for the normal case:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

fn fact(n: i64) -> Result<i64, &'static str> {
  if n == 0 {
    Ok(1)
  } else if n < 0 {
    Err("Cannot compute factorial of a negative number.")
  } else {
    fact(n-1).map(|k| k * n)
  }
}
```

:::{note} map() method
In this code we use the `map()` method that applies a *closure* onto the
stored value. If no value is stored, but only an error, the function is
not run.
:::

Here is the result of the function on two integers, one negative and one
positive:

```{code-cell} rust
:class: seq-cont badges border

(fact(-2), fact(11))
```

## Handling a Result

Using the `match` keyword we can handle the two cases of the `Result`
enum:

```{code-cell} rust
:class: seq-stop badges border

for n in [5, -10] {
  match fact(n) {
    Ok(f) => println!("{n}! = {f}"),
    Err(e) => println!("Factorial error: {e}"),
  }
}
```

## Unwrapping

Like `Option`, `Result` offers methods to *unwrap* the contained value,
or handle the error.

Using `unwrap()` we can get the value directly but it will trigger a
*panic* if it is an error. In the following example we try to open the
file `hello.txt` for reading, but it will fail if the file does not
exist:

```{code-cell} rust
:tags: [raises-exception]

fn foo() -> Result<i32, &'static str> {
  Err("Unrecoverable error")
}

foo().unwrap()
```

We may use `expect()` to customize the error message:

```{code-cell} rust
:tags: [raises-exception]

fn foo() -> Result<i32, &'static str> {
  Err("Unrecoverable error")
}

foo().expect("Error when calling foo()")
```

Instead of panicking, we may use the `unwrap_or()` method to return a
default value:

```{code-cell} rust
fn foo() -> Result<i32, &'static str> {
  Err("Unrecoverable error")
}

foo().unwrap_or(1)
```

Or use the `unwrap_or_else()` method to call a *closure* that returns a
computed default value:

```{code-cell} rust
fn foo() -> Result<i32, &'static str> {
  Err("Unrecoverable error")
}

foo().unwrap_or_else(|e| { println!("{e}") ; 0 })
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
