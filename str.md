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

# String slices

:::{warning} Draft
This section is still being written.
:::

The [str](https://doc.rust-lang.org/std/primitive.str.html) type
represents a *unsized* string of characters as a sequence of *bytes*
(i.e.: `u8`). The string is supposed to be a *valid UTF-8* string.

Being *unsized*, the *str* type is mostly used as a string slice
(`&str`), hence a *fat pointer* that stores a pointer to the start of
the string and the length of the string.

See {numref}`tab-str-methods` for a list of the main methods available
for string slices.

## Defining a string slice

We may define a string slice using a literal string:

```{code-cell} rust
let s = "abcdef";
s
```

A literal string is itself a string slice, with a *static lifetime*. It
is stored inside the compiled program and hence, when loaded, resides
inside the read-only memory of the process (i.e.: where the code and
constant data reside).
Here is the same definition as above with an explicit type:

```{code-cell} rust
let s: &'static str = "abcdef";
s
```

## String length

Get length:

```{code-cell} rust
"abc".len()
```

## Splitting a string

The `split_whitespace()` splits a string on white spaces and returns an
*iterator* on the sub-strings:

```{code-cell} rust
let n = "a b c d e f";
for s in n.split_whitespace() {
  print!("{s}")
}
```

The more generic `split()` method does the same on a pattern (e.g.: a
string, a character, a function or a closure):

```{code-cell} rust
let n = "a..b..c..d..e..f";
for s in n.split("..") {
  print!("{s}")
}
```

## Iterating

We may iterate over characters (`char` type) or bytes (`u8` type).
Depending on the content (i.e.: if some characters are NON-ASCII, and
thus encoded on more than one byte), it may give different results:

Iterating over unicode scalars:

```{code-cell} rust
for c in "Зд".chars() {
  print!("{c}, ");
}
```

Iterating over bytes:

```{code-cell} rust
for b in "Зд".bytes() {
  print!("{b}, ");
}
```

## Getting a slice from an UTF-8 string

:::{note} TODO
- Move that in Advanced part.
- Present ASCII, extended ASCII, latin-1 & co encoding, UNICODE, UTF-8
  encoding, character fonts, ...
- Add a chapter presenting binary, octal, hexadecimal.
:::

Getting byte slices:

```{code-cell} rust
:tags: [raises-exception]
let my_string = "abcdef"; // ASCII
let s = &my_string[0..4]; // A &str slice (=> u8 values).
let hello = "Здравствуйте"; // UTF-8
let s = &hello[0..1]; // Compiler error as the first char cannot be split.
```

## Searching into a string

Using the methods `find()` and `rfind()` (reverse search) we can search
for a pattern (e.g.: a string, a character, a function or a closure)
inside a string.

Example with a character:

```{code-cell} rust
"abcdef".find('c')
```

Example with a function:

```{code-cell} rust
"ABCdEF".find(char::is_lowercase)
```
