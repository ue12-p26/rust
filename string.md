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

# String

The [String](https://doc.rust-lang.org/std/string/struct.String.html) type
is a wrapper around `Vec<u8>` that handles UTF-8 strings allocated inside
the heap memory.

:::{note} UTF-8 encoding
UTF-8 is a common encoding scheme of Unicode characters on plain byte
(i.e.: 8 bits) values. In UTF-8, each Unicode character is encoded on
one or more bytes. Not all combinations of bytes give a legitimate
UTF-8 encoding.
`String` instances, like string literals and string slices as we will
see later, store sequences of plain bytes in a `Vec<u8>` vector, and
add a layer of UTF-8 checking, thus ensuring that a valid UTF-8 string
is stored.
We will see more, later, about character encoding inside a dedicated
chapter.
:::

We present here the basics of the `String` type and some of its methods.
See {numref}`tab-string-methods` for a more complete list of its methods.

## New empty string

The `new()` method builds a new *empty* string:

```{code-cell} rust
let s = String::new();
s
```

## New instance from literal string

Using the `from()` method, we can build a `String` instance from a *literal*
string:

```{code-cell} rust
let s = String::from("abc");
s
```

## Appending to a `String` object

The `push()` method appends a character to a string:

```{code-cell} rust
let mut s = String::new();
s.push('a'); // Append a single character
s
```

The `push_str()` method appends a *string slice* to a string:

```{code-cell} rust
let mut s = String::new();
s.push_str("def");
s
```

:::{note} String slice
A *literal string* is a type of *string slice*.
We will present *string slices* in a later chapter. For now, we only need
to see them as a sort of sub-strings that are defined by a *start* and a
*length*.
:::

(chp-format)=
## `format!()` macro

The [format macro](https://doc.rust-lang.org/std/macro.format.html) allows
to build a `String` instance using formatting codes from
[fmt](https://doc.rust-lang.org/std/fmt/index.html) module.

Plain literal strings are transformed into `String` objects:

```{code-cell} rust
let s = format!("My string");
s
```

However the real advantage of the `format!()` macro is the formatting
instructions inserted with curly brackets (`{}`).
In the following example with the curly brackets notation to insert the
value of the variable `n`:

```{code-cell} rust
let n = 10;
let s = format!("Number: {n}");
s
```

:::{note} Format trait
As long as a type define the required *format trait* (see
[Traits chapter](#chp-traits)), we can use it inside a `format!()`
macro.
Examples of *format traits*: `Display`, `Debug`, `Binary`, ...
We will see later how to define a *format trait* for a custom type.
:::

In the following example, we use `format!()` to concatenate two strings:

```{code-cell} rust
let s1 = String::from("abc");
let s2 = String::from("def");
let s3 = format!("{s1}{s2}");
s3
```

String alignment:

```{code-cell} rust
let s = "abc";
format!("#{s:<7}#{s:.<7}#{s:^7}#{s:>7}#")
```

Formatting a zero padded integer:

```{code-cell} rust
let n = 16;
format!("{n:05}")
```

Formatting a floating-point number:

```{code-cell} rust
let x = 1893.7834;
format!("{x} {x:.5} {x:.2} {x:.3e} {x:.2E}")
```

Formatting an integer into binary, octal or hexadecimal:

```{code-cell} rust
let n = 170;
format!("{n:b} {n:o} {n:x} {n:X} {n:04x}")
```

Formatting a complex object using the *Debug* formatter:

```{code-cell} rust
let t = (1.5, "abc", true);
format!("{t:?}")
```
