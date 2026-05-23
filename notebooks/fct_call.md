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

# Using functions

## Accepting parameters

Each function parameter is declared with its *type*, separated by a *colon*.
Multiple parameters are separated by *commas*.

Here is an example with one integer parameter:

```{code-cell} rust
fn foo(n: u8) {
  println!("The number is {n}");
}

foo(5);
```

Here is an example with two parameters:

```{code-cell} rust
fn foo(n: u8, c: char) {
  println!("The number is {n}.");
  println!("The character is {c}.");
}

foo(5, 'Z');
```

## Parameter mutability

Any parameter can be declared *mutable* in order to allow its modification
inside the function:

```{code-cell} rust
fn foo(mut n: u8) {
  n += 10;
  println!("The number is {n}.");
}

foo(5);
```

:::{warning} Passing by value
In our examples we have been using the *passing by value* scheme in which
values are passed by the caller into the function. We will later on see
that the exact same syntax can lead to a totally different scheme: the
*passing by ownership*. However in both cases the *mut* keyword only
applies to the `n` variable declared inside the function not the one
declared outside, as shown in the following example:

```{code-cell} rust
fn foo(mut n: u8) {
  n += 10;
  println!("The number is {n}.");
}

let n = 5;
foo(n);
println!("The original number is {n}.");
```

:::

## Returning a value

The most used form for returning a value is by writing an expression at the
end of the function, without a semicolon. The type of the returned value
must be declared using the `->` symbol:

```{code-cell} rust
fn foo() -> u8 {
  let x = 2;
  x + 4
}

foo()
```

Since the `if` statement can also be used to build an expression, we can
use it to return a value conditionally:

```{code-cell} rust
fn foo(n: u8) -> u8 {
  if n > 100 {
    n / 2
  } else {
    n
  }
}

foo(128)
```

## The `return` keyword

The `return` keyword is used to leave the function. It can be used anywhere
inside the function's scope:

```{code-cell} rust
fn foo(n: i8) {
  if n < 5 {
    return;
  }
  println!("The number is {n}.");
}

foo(-3);
foo(6);
```

It can also return a value:

```{code-cell} rust
fn foo() -> u8 {
  let x = 2;
  return x + 4;
}

foo()
```
