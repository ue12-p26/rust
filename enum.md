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

# Enumeration

The `enum` keyword is used to define an
[enumerated type](https://en.wikipedia.org/wiki/Enumerated_type) or a
[tagged union](https://en.wikipedia.org/wiki/Tagged_union).

An *enumerated type* defines a fixed size set of possible values:
Here is an example that define the card suits:

```{code-cell} rust
#[derive(Debug)]
enum Suit {
  Club,
  Diamond,
  Heart,
  Spade,
}
```

```{code-cell} rust
for x in [Suit::Diamond, Suit::Club, Suit::Heart, Suit::Spade] {
  println!("{x:?}");
}
```

:::{note} Debug formatting
The `Debug` trait (see [Traits chapter](#chp-traits)) defines
automatically a debug formatting for a type. The `?` formatting mode
enables *debug* formatting (i.e.: using `Debug` trait for formatting).
:::

The `enum` keyword can also define a *tagged union*, which can be viewed
as an *enhanced enumerated type*.
A *tagged union* defines *variants* instead of *values*.
Each *Variant* can have zero or more associated types.

*Tagger unions* are useful in many cases, in particular for defining
various & heterogeneous error types for an application.
For instance the following code defines an error type and several error
variants with nothing in common:

```rust
enum MyError {
  ProcessingFailure(String),
  UnknownPath(std::path::PathBuf),
  WrongNumberOfElements(u32),
  WrongSize(u16, u16),
}
```
