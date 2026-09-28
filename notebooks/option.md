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

# Option

```{code-cell} rust
:tags: [remove-cell]

// to prevent the stacktrace in case of panic
std::panic::set_hook(Box::new(|info| {
    eprintln!("{}", info);
}));
```

The generic enum `Option<T>` (see
[Option type](https://en.wikipedia.org/wiki/Option_type) for a general
presentation of this concept)
is defined inside the standard library and is used everywhere in Rust to
handle the Value/No-value case. It allows to declare and handle the
possiblity of the absence of value.

Some of the methods of `Option<T>` are presented in this chapter. See
{numref}`tab-option-methods` for more interesting methods and
[Enum Option](https://doc.rust-lang.org/std/option/enum.Option.html) for a
full list.

:::{list-table} Some methods of `Option<T>`
:name: tab-option-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `expect(m)`
  - Returns `t` if `Some(t)`, or *panic* with the custom message `m` if
    `None`.
* - `filter(p)`
  - Returns `None` if `None`, and `Some(t)` if predicates `p` evaluates to
    `true` on `t`.
* - `flatten()`
  - Returns `Option<T>` if the object is a `Option<Option<T>>`.
* - `get_or_insert(v)`
  - Sets value to `v` if `None`, then returns a mutable reference to the
    internal value.
* - `insert(v)`
  - Sets value to `v` and returns a mutable reference to the internal
    value.
* - `inspect(f)`
  - Calls function `f()` on the contained value, then returns this
    `Option<T>` instance.
* - `is_none()`
  - Returns `true` if `None`.
* - `is_some()`
  - Returns `true` if `Some(v)`.
* - `iter()`
  - Returns an iterator on the possibly contained value.
* - `iter_mut()`
  - Returns a mutable iterator on the possibly contained value.
* - `map(f)`
  - Maps the function `f()` on the contained value if any or returns
    `None`.
* - `map(v, f)`
  - Maps the function `f()` on the contained value if any or returns `v`.
* - `replace(v)`
  - Sets object to `Some(v)` and returns the old value, if any.
* - `take()`
  - Returns the current value as `Some(v)` or `None`, and leaves only
    `None`.
* - `take(p)`
  - Same as `take()` but only if predicate `p()` is `true`.
* - `unwrap()`
  - Returns the current value `v` if `Some(v)`, or *panics* if `None`.
* - `unwrap(u)`
  - Returns the current value `v` if `Some(v)`, or `u` if `None`.
:::

The `Option<T>` type is a *generic enum type* (see
[Generic enum](#chp-gen-enum)) that defines a `None` *variant* that
represents the No-value case, and a `Some(T)` variant that represents a
value.

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

## is_none() & is_some()

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

The `expect()` method works in the same way, but allows us to define a
custom *panic* message:

```{code-cell} rust
:tags: [raises-exception]

let x: Option::<u8> = None;
x.expect("A value is required !")
```

## Returning an Option<T>

Many functions return an `Option<T>` in order to handle the possibility
of absence of value.

For instance the `find()` method of the `str` type that searches for a
pattern inside a string returns an `Option<usize>` in order to handle
the case of no match. Its declaration is as follow:

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

:::{exercise} Returning an Option<T> (★☆☆☆☆)
:label: ret-option
:enumerated: true

1. Write a function `foo()` that takes an index and returns the value
   at that index inside an array of three booleans: `true`, `false`,
   `true`.
2. The function must return the value as an `Option` enum.
3. Test the function for indices `0` to `4`.
:::

[see solution](#ret-option-solution)
