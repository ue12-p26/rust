# String slice methods

In {numref}`tab-str-methods` is a list of some methods of `str`. For a full
list, see the [reference page](https://doc.rust-lang.org/std/primitive.str.html)
about `str`.

:::{warning} Return type
Read well the documentation of each method before using it, some methods
returning a string or a sub-string return a `&str` (when no modification
is done), the others return a `String`.
:::

:::{list-table} Some methods of `str`
:name: tab-str-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `bytes()`
  - Get an iterator on the bytes.
* - `chars()`
  - Get an iterator on the characters.
* - `find(pattern)`
  - Search forward for a pattern.
* - `from_utf8(bytes)`
  - Convert a slice of bytes into a string slice.
* - `replace(pattern, s)`
  - Replace all matches of the pattern with the string s.
* - `rfind(pattern)`
  - Search backward for a pattern.
* - `to_lowercase()`
  - Convert the string into lowercase.
* - `to_string()`
  - Convert to a `String` object.
* - `to_uppercase()`
  - Convert the string into uppercase.
* - `trim()`
  - Remove white spaces at both ends of the string.
:::
