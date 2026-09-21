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

(chp-gen-enum)=
# Generic enum

In the following example we use a parametric type `T` to define a
*generic* enum type to represent colors. The possible levels of grey or
each color component (i.e.: red, green, blue) is stored as a value of the
specified type:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
enum Color<T> {
  Grey(T),
  Rgb(T, T, T),
}
```

To use the `Color<T>` enum type, we must specify what is `T`:

```{code-cell} rust
:class: seq-stop badges border

let c1 = Color::<u8>::Grey(0xa0);
let c2 = Color::<u16>::Grey(0xff00);
let c3 = Color::<u8>::Rgb(0x00, 0xa0, 0x57);
(c1, c2, c3)
```

:::{exercise} Using two parameters in a generic (★☆☆☆☆)
:label: gen-enum
:enumerated: true

Modify the `Color` enum to accept a different type for `Grey` and `Rgb`.
Create a `u16` `Grey` value and a `Rgb` value with `u8` using the same
`Color` realisation and print them.
:::

[see solution](#gen-enum-solution)
