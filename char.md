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

# Characters

In Rust,
[the character type](https://doc.rust-lang.org/stable/book/ch03-02-data-types.html#the-character-type)
(`char`) represents a unicode character.

Literal values are written using single quotes (`'`):

```{code-cell} rust
let c1 = 'A';
let c2 = 'ô';
let c3 = '∉';
(c1, c2, c3)
```

Some special characters (see {numref}`tab-char-esc`) are inserted using the
escape character (backslash):

```{code-cell} rust
('\t', '\n')
```

The escape character is also used to insert ASCII, 8-bit or Unicode
characters knowing their number:

```{code-cell} rust
('\x39', '\u{2208}')
```

The `from()` method permits to convert an integer into a character:

```{code-cell} rust
char::from(0x30u8)
```

:::{list-table} Character escapes
:name: tab-char-esc
:header-rows: 1
:align: center

* - Escape
  - Number
  - Name
  - Description
* - `\0`
  - 0x00
  - NL, NUL or NULL
  - Null
* - `\t`
  - 0x09
  - HT
  - Tab
* - `\n`
  - 0x0A
  - LF
  - Newline (a.k.a.: line feed)
* - `\r`
  - 0x0D
  - CR
  - Carriage return
* - `\\`
  - 0x5C
  -
  - Backslash
* - `\'`
  - 0x27
  -
  - Single quote
* - `\"`
  - 0x22
  -
  - Double quote
* - `\x41`, `\x7f`, ...
  -
  -
  - ASCII or 8-bit character code
* - `\u{7fff}`
  -
  -
  - 24-bit Unicode character code (up to 6 hex digits)
:::
