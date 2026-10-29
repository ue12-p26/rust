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

# String literal definitions

String literals are constant data, embedded in the program, and thus stored
inside the read-only memory zone.

Strings literals are written between quotes and can be used to initialize
string variables:

```{code-cell} rust
let s = "abcdef";
s
```

:::{note} s type
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
println!("my string\n \x3f \u{211d}");
```

The *NULL* character (character ASCII `0`) is not interpreted as a
string terminator and is printed as-is:

```{code-cell} rust
println!("abc\0def");
```
