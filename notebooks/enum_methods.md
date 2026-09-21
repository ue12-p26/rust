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

# Enum methods

*Methods* can be attached to an `enum` type. Thus, instead of defining
an independent function that takes an `enum` as argument (i.e.:
`my_function(my_enum_value)`), we can define a method attached to the
`enum` type. We will call this method directly onto the object:
`my_enum_value.my_method()`.

Let us define a `Suit` enum for representing card suits:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

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
:class: seq-cont badges border

impl Suit {
  fn is_black(&self) -> bool {
    [Suit::Club, Suit::Spade].contains(self)
  }
}
```

We can call this method on any `Suit` instance:

```{code-cell} rust
:class: seq-stop badges border

for x in [Suit::Diamond, Suit::Club, Suit::Heart, Suit::Spade] {
  if x.is_black() {
    println!("{x:?}");
  }
}
```

:::{exercise} Animal feet (★★☆☆☆)
:label: animal-feet
:enumerated: true

1. Implement an `enum` type named `Animal` that represents the following
   animals: `Cat`, `Dog`, `Snake`, `Crow`.
2. Implement a method `get_nb_feet()` that returns the number of feet of
   each animal.
3. Write a loop on all animals, and for each print its name and its
   number of feet on one line.
:::

[see solution](#animal-feet-solution)
