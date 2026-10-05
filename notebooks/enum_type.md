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

# Enumerated type

An *enumerated type* defines a fixed size set of possible values. It is
declared using the `enum` keyword.

Here is an example that defines the card suits:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
enum Suit {
  Club,
  Diamond,
  Heart,
  Spade,
}
```

```{code-cell} rust
:class: seq-stop badges border

for x in [Suit::Diamond, Suit::Club, Suit::Heart, Suit::Spade] {
  println!("{x:?}");
}
```

:::{note} Debug formatting
The `Debug` trait (see [Traits chapter](#chp-traits)) defines
automatically a debug formatting for a type. The `?` formatting mode
enables *debug* formatting (i.e.: using `Debug` trait for formatting).
:::
