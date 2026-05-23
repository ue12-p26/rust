# The 3 ways of passing a value

When passing a value to a function, Rust proposes three possibilities:

- Passing by *value*: this is done implicitly, when the value's type
  implements the `Copy` trait (e.g.: integers, floats, ...).
- Passing by *ownership*: this is done implicitly, when a value's type
  does *not* implement the `Copy` type. The ownership of the value is
  passed to the function. The caller has the choice to make a *clone*
  if the value's type implements the `Clone` trait, in which case the
  *clone*'s ownership will be passed to the function instead of the
  original value's.
- Passing by *reference*: this is done explicitly by both the caller
  and the function.
  The caller keeps the ownership of the value, and the function
  borrows the value.
