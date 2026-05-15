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

# Arrays

In Rust, an
[array](https://doc.rust-lang.org/stable/book/ch03-02-data-types.html#the-array-type)
is defined with a type and a fixed size.
It is defined on the *stack* memory, and thus must be used with *reasonable
sizes*.
It provides few methods (see {numref}`tab-array-methods`), but can be
coerced to *slices*, which provide most of the interesting methods (see
{numref}`tab-slice-methods`).

Here is an array of four `i32` integers:

```{code-cell} rust
let a = [1, 2, 3, 4];
a
```

If we want to specify another integer type, we need also to specify the
array size:

```{code-cell} rust
let a: [i16; 3] = [-8, 4, 6];
a
```

We may construct an array using the repetition of a value:

```{code-cell} rust
let a = [4/*value*/; 3/*Number of repetition*/];
a
```

Accessing a value is done using the indexing operator `[]`:

```{code-cell} rust
let a = [1, 2, 3, 4];
a[2]
```

Any type whose size is known at compile time may be used to build an array.
Here is a table of booleans:

```{code-cell} rust
let a = [true, false, false];
a
```

A table of floats:

```{code-cell} rust
let a = [1.5, -45.23, 10.3];
a
```

A table of strings:

```{code-cell} rust
let a = ["a", "ab", "abc"];
a
```

And a table of tuples:

```{code-cell} rust
let a = [(1, 4), (-10, 18)];
a
```

Note that all tuples must be similar (i.e.: same element types, same number
of elements), otherwise compilation will fail:

```{code-cell} rust
:tags: [raises-exception]
let a = [(1, 4), (-10, 18, 4)];
a
```
