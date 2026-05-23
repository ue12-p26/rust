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

:::{tip} How to insert a quote character inside a raw string?
However the quote character `"` being the closing symbol, and escape
characters being not interpreted, we cannot insert a quote character
as-is inside a raw string:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
r"Some string with a quote \" inside."
```

In order to be able to insert quote characters, Rust proposes an
additional notation where `#"` and `"#` become the start and stop
sequences of the raw string:

```{code-cell} rust
r#"Some string with a quote " inside."#
```

This solution, however, does not allow to insert a `"#` sequence as it
the closing symbol:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
r#"Some string with a quote " inside and some symbols "# at the end."#
```

To solve this limitation, Rust proposes in fact to use as many sharp
symbols `#` as necessary for the opening sequence, and as much for the
closing sequence. Thus we may use `##"` & `"##` for the start and stop
sequences, or `###"` & `"###`, or any number of sharp symbols.
Using this feature in the following example, we are able to insert the
sequence `"#` inside our raw string:

```{code-cell} rust
r##"Some string with a quote " inside and some symbols: "# at the end."##
```
:::

## Byte string

Byte string (slice of bytes (`u8`)):

```{code-cell} rust
let bytes = b"abc"; // Type is &[u8; 3]
bytes
```
