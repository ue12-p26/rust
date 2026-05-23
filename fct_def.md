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

# Function definition

Functions are defined using the `fn` keyword and can be placed inside
various scopes:

- At global level.
- Inside another function.
- Inside an `impl` (implementation) block of a `struct` (structure).
- Inside a `trait` definition (see [Traits chapter](#chp-traits)).

Here is a function that takes no argument and returns nothing:

```{code-cell} rust
fn foo() {
  println!("Hello!");
}

foo();
```

## Definition order

The order of definition of functions does not matter. We can use a function
that is not yet defined:

```{code-cell} rust
fn foo() {
  foo2();
}

fn foo2() {
  println!("Hello!");
}

foo();
```

## Nested function

Functions can be defined inside other functions:

```{code-cell} rust
fn foo() {

  fn my_nested_fct() {
    println!("Hello!");
  }

  my_nested_fct();
}

foo();
```

However, they cannot be accessed outside their definition's scope:

```{code-cell} rust
:tags: [raises-exception]

fn foo() {

  fn my_nested_fct() {
    println!("Hello!");
  }
}

my_nested_fct();
```

## Function overloading

In Rust, function overloading is *forbidden*.

:::{note} Overloading
An *overloading* of a function means the definition of a function with the
same exact name as another function already defined. This makes sense only
if:

- The language is *typed*.
- The parameter types of the two functions are *different*.

Languages like C/C++ or Java accept function overloading.
In Rust, this is simply *forbidden*.
:::

Here is an example with an overloading of a function `foo()`, rejected by
the compiler:

```{code-cell} rust
:tags: [raises-exception]

fn foo() {
  println!("Function with no parameter.");
}

fn foo(n: u8) {
  println!("Function with a u8 parameter ({n}).");
}

foo();
```

To define the two functions we need to name them differently:

```{code-cell} rust
fn foo() {
  println!("Function with no parameter.");
}

fn foo2(n: u8) {
  println!("Function with a u8 parameter ({n}).");
}

foo();
foo2(16);
```
