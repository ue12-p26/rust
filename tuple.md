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

# Tuples

[The Tuple Type](https://doc.rust-lang.org/stable/book/ch03-02-data-types.html#the-tuple-type)
is a fixed size type (i.e.: we cannot remove or add values from/to a
*tuple*) that groups together values of miscellaneous types.

*Tuples* are declared using parenthesis, and commas to separate values:

```{code-cell} rust
let t = (5, 'h', 11.7);
t
```

To declare explicitly the types of the values, we use a tuple of types:

```{code-cell} rust
let u: (i8, f32, char) = (34, 78.56, 'a');
u
```

The values of a *tuple* are indexable:

```{code-cell} rust
let t = (5, 'h', 11.7);
t.2
```

We may decompose an existing tuple, by using a tuple of variables inside the
`let` declaration. Some values may be ignored by using the `_` (underscore)
notation:

```{code-cell} rust
let t = (5, 'h', 11.7);
let (_, c, _) = t;
c
```

:::{warning} Empty tuple
We may declare an *empty* tuple, using empty parenthesis. This special
tuple is called *unit* in Rust and represents an empty value or an empty
return type:

```{code-cell} rust
()
```

:::
