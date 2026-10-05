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

# OsStr & OsString

Operating systems use their own string encoding that they use for file
system paths. This means that the Rust strings cannot be used directly
with operating systems. Here are the differences between Rust and the
main operating systems:

- Rust's strings are UTF-8 and may contain NULL characters.
- Unix's strings are NULL terminated byte strings interpreted as UTF-8
  in many cases.
- Windows' strings are NULL terminated 16-bit strings interpreted as
  UTF-16 in many cases.

[OsStr](https://doc.rust-lang.org/std/ffi/struct.OsStr.html) and
[OsString](https://doc.rust-lang.org/std/ffi/struct.OsString.html)
allow to make the transition between Rust's strings and the operating
system:

- `OsString` stores its string on the *heap*.
- `OsStr` is a *slice* on an operating system's string.

See {numref}`tab-os-str` and {numref}`tab-os-string` for lists of the
most useful methods for these both types.

:::{list-table} Some methods of OsStr
:name: tab-os-str
:header-rows: 1
:align: center

* - Method
  - Description
* - `display()`
  - Returns an object that represent the current string and can be
    safely printed, eliminating *non-Unicode* characters.
* - `is_ascii()`
  - Returns `true` if all characters are ASCII.
* - `is_empty()`
  - Returns `true` if the string is empty.
* - `len()`
  - Returns the string's length.
* - `new(s)`
  - Creates a new `OsStr` slice from a string slice.
* - `make_ascii_lowercase()`
  - Puts ASCII characters in lowercase.
* - `make_ascii_uppercase()`
  - Puts ASCII characters in uppercase.
* - `to_ascii_lowercase()`
  - Returns an `OsString` with ASCII characters in lowercase.
* - `to_ascii_uppercase()`
  - Returns an `OsString` with ASCII characters in uppercase.
* - `to_os_string()`
  - Returns a copy of this string as an `OsString`.
* - `to_str()`
  - Returns a string slice of this string is a valid UTF-8 string,
    otherwise returns `None`.
* - `to_string_lossy()`
  - Converts this string into a UTF-8 string, replacing non-UTF-8
    characters by the Unicode `U+FFFD REPLACEMENT CHARACTER` (�).
:::

:::{list-table} Some methods of OsString
:name: tab-os-string
:header-rows: 1
:align: center

* - Method
  - Description
* - `as_os_str()`
  - Converts to an `OsStr` slice.
* - `clear()`
  - Removes all content.
* - `into_boxed_os_str()`
  - Converts into a `Box<OsStr>`.
* - `into_encoded_bytes()`
  - Converts into a `Vec<u8>`.
* - `into_string()`
  - Converts into a `String` or returns the original `OsString`
    through the error value.
* - `leak()`
  - Consumes the internal string and returns it as a `&'a mut OsStr`.
* - `push(s)`
  - Appends a string to this `OsString`.
:::

```{code-cell} rust
use std::ffi::OsString;

OsString::from("foo.txt")
```

```{code-cell} rust
use std::ffi::OsString;

let s: OsString = "foo.txt".into();
s
```

```{code-cell} rust
use std::ffi::OsString;

let mut s = OsString::new();
s.push("abc/def.txt");
s
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
