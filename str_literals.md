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

# String literal definitions

String literals are constant data, embedded in the program, and thus stored
inside the read-only memory zone.

Strings literals are written between quotes and can be used to initialize
string variables:

```{code-cell} rust
let s = "abcdef";
s
```

:::{note} `s` type
The exact type of `s` will be explained later in the course.
:::

## Multi-lines definition

We have seen a string literal defined on one line, but it can also be
defined on multiple lines (new line characters are included):

```{code-cell} rust
let s = "my string
on
multiple
lines.";
s
```

Using the backslash (`\`) escape character, we can avoid the new line
characters:

```{code-cell} rust
let s = "my string \
on \
multiple \
lines.";
s
```

## Using escape characters

The escape characters we have seen for the `char` type can be used inside a
literal string definition:

```{code-cell} rust
"my string\n \x3f \u{211d}"
```

## Raw string

Using the `r` prefix we can define a *raw* string in which escape characters
are not interpreted (much like Python's raw strings):

```{code-cell} rust
r"My string with any char\n \x3f.'abc'"
```

Since escape characters are not interpreted inside a raw string, it is not
possible to insert quote characters this way. For this reason, a sharp
(`#`) notation is also available. With this method we add an equal number
of sharp characters before the start quote and after the end quote.
Example with one sharp character:

```{code-cell} rust
r#"Some string with a quote " inside."#
```

Example with two sharp characters:

```{code-cell} rust
r##"Some string with a quote " and sharp # inside."##
```

## Byte string

Byte string (slice of bytes (`u8`)):

```{code-cell} rust
let bytes = b"abc"; // Type is &[u8; 3]
bytes
```
