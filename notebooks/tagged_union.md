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

# Tagged union

The `enum` keyword can also define a *tagged union*, which can be viewed
as an *enhanced enumerated type*.
A *tagged union* defines *variants* instead of *values*.
Each *Variant* can have zero or more associated types.

*Tagged unions* are useful in many cases, in particular for defining
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
