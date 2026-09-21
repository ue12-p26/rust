# `slice` methods

:::{danger} In progress
This section is still being written.
:::

We list here some of the numerous methods of the `slice` type. For a full
list, see
[Primitive Type `slice`](https://doc.rust-lang.org/std/primitive.slice.html)
inside the official Rust reference documentation.

:::{list-table} Some methods of `slice`
:name: tab-slice-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `contains(x)`
  - Returns `true` if the element `x` is inside the slice.
* - `ends_with(sub_slice)`
  - Test the end of the slice.
* - `get(range)`
  - Get a slice of the slice.
* - `get_mut(range)`
  - Get a mutable slice of the slice.
* - `len()`
  - Return the length of the `str` object (i.e.: the number of elements).
* - `repeat(n)`
  - Build a new slice by repeating the slice n times.
* - `split(predicate)`
  - Split a slice in sub-slices, using a predicate function to know where
    to cut.
* - `starts_with(sub_slice)`
  - Test if a string starts with a pattern.
:::
