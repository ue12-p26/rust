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

# Enum methods

We can define methods attached to an `enum` type.

Let us define a `Suit` enum for representing card suits:

```{code-cell} rust
#[derive(Debug, PartialEq)]
enum Suit {
  Club,
  Diamond,
  Heart,
  Spade,
}
```

Using the `impl` statement we declare the `is_black()` method that
returns `true` for black color cards (i.e.: clubs and spades):

```{code-cell} rust
impl Suit {
  fn is_black(&self) -> bool {
    [Suit::Club, Suit::Spade].contains(self)
  }
}
```

We can call this method on any `Suit` instance:

```{code-cell} rust
for x in [Suit::Diamond, Suit::Club, Suit::Heart, Suit::Spade] {
  if x.is_black() {
    println!("{x:?}");
  }
}
```
