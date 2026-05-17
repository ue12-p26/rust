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

# Generic enum

A *generic* type is a type that is defined using a parametric type instead
of a fixed one. In Rust, the *generic* notation uses the bracket
characters `<>`. One or more parametric types can be declared inside the
brackets.
To know more about *generics*, see [Generics chapter](#chp-generics).

In the following example we use a parametric type `T` to define a
*generic* enum type to represent colors. The possible levels of grey or
each color component (i.e.: red, green, blue) is stored as a value of the
specified type:

```{code-cell} rust
#[derive(Debug)]
enum Color<T> {
  Grey(T),
  Rgb(T, T, T),
}
```

To use the `Color<T>` enum type, we must specify what is `T`:

```{code-cell} rust
let c1 = Color::<u8>::Grey(0xa0);
let c2 = Color::<u16>::Grey(0xff00);
let c3 = Color::<u8>::Rgb(0x00, 0xa0, 0x57);
(c1, c2, c3)
```

We may also use two parameter types to differentiate between the capacity
of RGB colors and the number of levels of greys:

```{code-cell} rust
#[derive(Debug)]
enum Color<C, G> {
  Grey(G),
  Rgb(C, C, C),
}

let c1 = Color::<u8, u16>::Grey(0xa0b4);
let c2 = Color::<u8, u16>::Rgb(0x60, 0x70, 0x80);
(c1, c2)
```
