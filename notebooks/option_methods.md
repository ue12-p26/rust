# `Option<T>` methods

We list here some of the methods of the `Option<T>` enum type. For a full
list, see
[Enum Option](https://doc.rust-lang.org/std/option/enum.Option.html)
inside the official Rust reference documentation.

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
