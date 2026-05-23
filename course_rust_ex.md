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

# Rust examples

Most of the Rust examples of the book are written in a *simplified*
way in order to be more readable and help to concentrate on the main
topic.
However this makes these examples not compilable with just a copy &
paste.
We are going to see how to recognize what is missing, and how to
complete these examples.

## Missing main function

The first important thing is that they do no contain the `main()`
function that is compulsory for compiling and running.
Example:

```rust
println!("Hello!");
```

Such an example cannot be compiled *as-is*.
It needs to be wrapped inside a `main()` function, as following:

```rust
fn main() {
  println!("Hello!");
}
```

## Printed expression on last line

The second particularity is that many examples print one or more
values at the end of the code snippet, with an expression that does
not end with a semicolon:

```rust
let a = 10;
let b = 8;
a + b
```

In the last line is a perfect Rust expression that we could use for
instance as a value to return from a function. However in this
context, if we wrap it inside a `main()` function this will lead to an
error, as the `main()` must return nothing, except an integer or an
error.
To run such an example we must wrap the last line's expression into a
`println!()` macro as following:

```rust
fn main() {
  let a = 10;
  let b = 8;
  println!("{:?}", a + b);
}
```

## Multiple code snippets

Some Rust examples are split into several code snippets. As with the
bash examples, the first cell is tagged on its right with **start**
and the last cell with **stop**. To run them, just paste them
together, but pay attention to the last line of each snippet as it
could be an expression without a semicolon.

Here is the first part of an example:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border
let a = 10;
a
```

The second part:

```{code-cell} rust
:class: seq-cont badges border
let b = 8;
b
```

And the last part:

```{code-cell} rust
:class: seq-stop badges border
a + b
```

To run it, just paste all lines together, wrapping last lines
containing an expression into a `println!()` macro, and putting all
this code into a `main()` function, as following:

```rust
fn main() {
  let a = 10;
  println!("{:?}", a);
  let b = 8;
  println!("{:?}", b);
  println!("{:?}", a + b);
}
```
