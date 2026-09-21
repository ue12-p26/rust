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

(chp-for)=
# for

The `for` statement is a shortcut to iterate over an iterator object or an
object convertible into an iterator.
If the object on which the `loop` is applied is not an iterator but
implements the `IntoIterator` trait, then a call to `into_iter()` is made
for us to convert the object.
This is what happens for instance with collections like `Vec`.
It is implemented as a `loop` statement with a call to the `next()` method
of the iterator at its start.

In the following example, we use the `for` statement to iterate over an
array:

```{code-cell} rust
let a = [1, 2, 3, 4];
for n in a {
  print!("{n} ");
}
```

A range being an iterator, we can use the `for` statement on it:

```{code-cell} rust
for i in 1..=10 {
  print!("{i} ");
}
```

Many methods (see [`Iterator` methods](#chp-iter-methods) for a list of
the main iterator methods) can be called onto the iterator to transform
it.
For instance, in the following example, we reverse the range to iterate
from higher values to lower values, using the `rev()` iterator method:

```{code-cell} rust
for i in (1..=10).rev() {
  print!("{i} ");
}
```

As for the `loop` statement:

- The `continue` keyword is used to skip a step.
- The `break` keyword is used to exit the loop prematurely.
- *Labels* are used to exit *nested* loops.

:::{exercise} Checker (★★☆☆☆)
:label: checker
:enumerated: true

Draw the following grid on the console using two nested `for` loops and
the *print* macros (see [Print macros](#chp-print)):

```
X
 X
X X
 X X
X X X
 X X X
X X X X
 X X X X
X X X X X
 X X X X X
X X X X X X
 X X X X X X
X X X X X X X
 X X X X X X X
X X X X X X X X
 X X X X X X X X
X X X X X X X X X
 X X X X X X X X X
```
:::

[see solution](#checker-solution)
