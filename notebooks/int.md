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

# Integers

[The Integer Types](https://doc.rust-lang.org/stable/book/ch03-02-data-types.html#integer-types)
are available in **signed** and **unsigned** flavours, from 8 bits to 128
bits. The **unsigned** versions are: `u8`, `u16`, `u32`, `u64` and `u128`.
The **signed** versions are: `i8`, `i16`, `i32`, `i64` and `i128`.

{numref}`tab-arith-op` provides a list of available operators.

## Default type

If unspecified, an integer is of type `i32`:

```{code-cell} rust
let i = 15; // Default type: i32
i
```

## Specifying the type

To set explicitly the integer type, we can either set it to the variable or
the value:

```{code-cell} rust
let i: u8 = 27;         //  8 bits unsigned integer
let j     = 516i16;     // 16 bits   signed integer
(i, j)
```

## Separator

For big literal numbers, the underscore can be used to ease reading:

```{code-cell} rust
let n = 1_000_000_000;
let m = 12_34_56;
(n, m)
```

## Binary, octal and hexadecimal

Binary, octal and hexadecimal numbers can be defined using the appropriate
prefix (`0b`, `0o`, `0x`):

```{code-cell} rust
let bin = 0b0100_0001_1110;
let oct = 0o466;
let hex = 0x23ff_89c8;
(bin, oct, hex)
```

## Size types

Two architecture dependent integer types exist to store sizes (e.g.: array
sizes, string sizes). One is *signed* and the other *unsigned*:

```{code-cell} rust
let n: isize = -1;
let m: usize = 8000;
(n, m)
```

:::{warning} Size types
The size of these types depend on the target architecture (32 bits or 64 bits)
for which we compile.
:::

## Character byte

A special notation exists to define a character byte, which is stored as a
plain 8 bit integer (`u8`):

```{code-cell} rust
let n = b'A';
n
```

The type of `n` will be `u8`.

:::{note} Character byte
Character bytes are used to define character strings, either UTF-8
character strings (`str` and `String`) or raw byte character strings
(`&[u8]`).
See [String slices](#chp-str-slices) and [String](#chp-string) to know
more about strings.
:::

## Operations

Examples of computing a remainder:

```{code-cell} rust
(11 % 3, -11 % 3, 11 % -3, -11 % -3)
```

A division:

```{code-cell} rust
(11 / 3, -11 / 3, 11 / -3, -11 / -3)
```
