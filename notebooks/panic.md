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

# Panic

:::{warning} To review
:class: readiness-toreview

:::

The [panic!()](https://doc.rust-lang.org/std/macro.panic.html) macro is
used to emit an *unrecoverable* error. When the `panic!()` macro is
called, it triggers an immediate exit of the program. The system may also
trigger a *panic* when a fatal error occurs (e.g.: reading/writing an
array past the end).

We may call the `panic!()` macro ourselves to provoke an immediate exit
of our program:

```{code-cell} rust
:tags: [raises-exception]

panic!("An unrecoverable error occurred!");
```

## Unwrapping

Some types like `Option` or `Result` have an `unwrap()` method that
returns the contained value or *panics* if there is no value.

For instance, the `find()` method of `str` returns an `Option`. If we
call `unwrap()` on it, a *panic* will be thrown if `None` is returned:

```{code-cell} rust
:tags: [raises-exception]

"abcdef".find('h').unwrap()
```

The `expect()` method is an equivalent to `unwrap()` but accepts a
custom message:

```{code-cell} rust
:tags: [raises-exception]

"abcdef".find('h').expect("Character was not found!")
```

Instead of panicking, we may use the `unwrap_or()` method to return a
default value:

```{code-cell} rust
"abcdef".find('h').unwrap_or(0)
```

Or use the `unwrap_or_else()` method to call a *closure* that returns a
computed default value:

```{code-cell} rust
let i = "abcdef".find('h').unwrap_or(0);
"abcdef".find('k').unwrap_or_else(|| i + 1)
```

## Disabling the unwinding of the stack

By default, when `panic!()` is called Rust unwinds the stack and cleans
up data. This operation takes memory space at compile time, and time at
runtime. To disable it, place the following lines into the `Cargo.toml`
file:

```toml
[profile.release]
panic = 'abort'
```
