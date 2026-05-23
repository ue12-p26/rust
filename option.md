---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# Option

The `Option<T>` (see
[Option type](https://en.wikipedia.org/wiki/Option_type) for a general
presentation of this concept)
is defined inside the standard library and is used everywhere in Rust to
handle the Value/No-value case. It allows to declare and handle the
possiblity of the absence of value.

Some of the methods of `Option<T>` are presented in this chapter. See
{numref}`tab-option-methods` for more interesting methods.

The `Option<T>` type is a *generic enum type* that defines a `None`
*variant* that represents the No-value case, and a `Some(T)` variant
that represents a value.

Here the definition of `Option<T>` inside the standard library:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
enum Option<T> {
    Some(T),
    None,
}
```

In the following example, the same variable `n`, declared as an
`Option<i32>`, can be set to either `None` or `Some(...)`:

```{code-cell} rust
let mut n: Option<i32> = None;
println!("{n:?}");
n = Some(-1230);
println!("{n:?}");
```

## `is_none()` & `is_some()`

We may check if an `Option<T>` instance has a value or not with the
following methods:

```{code-cell} rust
let x: Option::<u8> = Some(10);
(x.is_none(), x.is_some())
```

## `unwrap()` & `expect()`

We may try to get the possible value stored in an `Option<T>` by using
the `unwrap()` method.
If there is a value, then we get it:

```{code-cell} rust
let x: Option::<u8> = Some(10);
x.unwrap()
```

Otherwise, we get a *panic*:

```{code-cell} rust
:tags: [raises-exception]
let x: Option::<u8> = None;
x.unwrap()
```

The `expect()` method works in the same way, but allow us to define a
custom *panic* message:

```{code-cell} rust
:tags: [raises-exception]
let x: Option::<u8> = None;
x.expect("A value is required !")
```

## Returning an `Option<T>`

Many functions return an `Option<T>` in order to handle the possibility
of absence of value.

For instance the `find()` method of the `str` type that searches for a
patter inside a string returns a `Option<usize>` in order to handle the
case of no match. Its declaration is as follow:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
fn find<P>(&self, pat: P) -> Option<usize> {
  ...
}
```

It returns `None` when no match is found:

```{code-cell} rust
("abcdef".find('c'), "ghijkl".find('c'))
```
