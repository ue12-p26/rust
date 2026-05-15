# `String` methods

We list in {numref}`tab-string-methods` some of the methods of the
[String](https://doc.rust-lang.org/std/string/struct.String.html)
structure.

:::{list-table} Some methods of `String`
:name: tab-string-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `as_bytes()`
  - Returns a byte slice.
* - `as_mut_str()`
  - Returns a mutable string slice.
* - `as_str()`
  - Returns a string slice.
* - `capacity()`
  - Returns the instance's capacity in bytes.
* - `clear()`
  - Removes all characters.
* - `drain(r)`
  - Removes a range of characters and returns an iterator on them.
* - `from(s)`
  - Creates a string from a literal string.
* - `insert(i, c)`
  - Inserts a character at the specified index.
* - `insert_str(i, s)`
  - Inserts a string slice at the specified index.
* - `into_bytes()`
  - Converts (and consumes) the `String` into a `Vec<u8>`.
* - `is_empty()`
  - Returns `true` if the instance contains no character.
* - `len()`
  - Returns the number of bytes of the string.
* - `new()`
  - Creates an empty string.
* - `pop()`
  - Removes and returns the last character.
* - `push(c)`
  - Appends one character to the string.
* - `push_str(s)`
  - Appends a string slice to the string.
* - `remove(i)`
  - Removes and returns the character at the specified index.
* - `replace_range(r, s)`
  - Replaces a range of characters by a string slice.
* - `reserve(n)`
  - Reserves additional memory space (i.e.: increases the capacity).
* - `shrink_to(n)`
  - Shrinks the capacity to specified size.
* - `shrink_to_fit()`
  - Shrinks the capacity in order to match length.
* - `truncate(n)`
  - Shortens the string to the specified length.
* - `with_capacity(n)`
  - Creates a new empty `String` with the specified capacity.
:::
