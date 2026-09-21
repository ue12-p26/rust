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

# Enumeration

The `enum` keyword is used to define an
[enumerated type](https://en.wikipedia.org/wiki/Enumerated_type) or a
[tagged union](https://en.wikipedia.org/wiki/Tagged_union).

## Enumerated type

An *enumerated type* defines a fixed size set of possible values.

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

## Tagged union

The `enum` keyword can also define a *tagged union*, which can be viewed
as an *enhanced enumerated type*.
A *tagged union* defines *variants* instead of *values*.
Each *Variant* can have zero or more associated types.

*Tagger unions* are useful in many cases, in particular for defining
various & heterogeneous error types for an application.
For instance the following code defines an error type and several error
variants with nothing in common:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

enum MyError {
  ProcessingFailure(String),
  UnknownPath(std::path::PathBuf),
  WrongNumberOfElements(u32),
  WrongSize(u16, u16),
}
```

:::{exercise} Automaton State (★★☆☆☆)
:label: automaton-state
:enumerated: true

1. Implement an `enum` that represents the states of an automaton:
   `Start`, `Stage1`, `Stage2`, `Stage3`, `Stop`.
2. Write a function `next_state()` that takes a state and returns the
   next. The order of the state is their order of definition. The next
   state after `Stop` is `Start`.
3. Starting from state `Stop` call 10 times `next_state()` and print
   each state.
:::

[see solution](#automaton-state-solution)
