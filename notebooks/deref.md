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

# Deref

:::{warning} To review
:class: readiness-toreview

:::

The *dereferencing* operator `*` is used to access the value pointed
to by a reference. Here is an example from
[Dereferencing](#chp-deref-op):

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
{
  let a = 16;
  let b = &a;
  println!("{}", 16 == *b);
}
```

The `Box` structure is a kind of pointer/reference, and accepts too
the usage of the *dereferencing* operator `*` to access the original
value thanks to the implementation of the
[Deref](https://doc.rust-lang.org/std/ops/trait.Deref.html) trait:

```{code-cell} rust
:class: seq-start badges border

let a = 16;
let b = Box::new(a);
16 == *b
```

The `Deref` trait is implemented as following for a pointer type
`Foo<T>`:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

use std::ops::Deref;

impl<T> Deref for Foo<T> {
  type Target = T;

  fn deref(&self) -> &Self::Target {
    // Returns a reference to the target
  }
}
```

The `deref()` method returns a reference to the original value of
type `Target` (i.e.: `T`), it does not actually *dereference*.
Instead, what happens in our example above with the `*b` line is the
following:

1. The compiler sees that `b` is a type implementing `Deref`.
2. It calls `b.deref()` and gets a reference on the original value.
3. It applies the *dereferencing* operator `*` on this reference.

:::{note} Target type
The definition `type Target = T;` inside the `Deref` implementation
example does not seem to be very useful. The reason of its presence
is that the default code inside the `Deref` trait expects `Target`
to be defined.
:::

:::{exercise} Custom Box-like implementation (★★★☆☆)
:label: deref-impl
:enumerated: true

Re-implement a simplified version of the `Box` structure.

1. Define a `MyBox` generic *tuple* structure that stores a value of
   type `T`.
2. Implement a `new()` method for this `MyBox`.
3. Implement the `Deref` trait for `MyBox`.
4. Define a variable `x` with an integer value.
5. Define a variable `y` that is a `MyBox` of `x`.
6. Print the value pointed to by `y` using the dereferencing
   operator.
:::

[see solution](#deref-impl-solution)

## Automatic Deref coercion

The `Deref` trait is implemented for multiple types in Rust. For
instance the `String` type implements the `Deref` trait to allow the
*automatic conversion* of `&String` into `&str`.

Let us see it in effect. First we create a function that accepts a
`&str`:

```{code-cell} rust
:class: seq-cont badges border

fn hello(name: &str) {
  println!("Hello, {name}!");
}
```

Let us suppose now that we have a `String` inside a `Box`:

```{code-cell} rust
:class: seq-cont badges border

let x = Box::new(String::from("Rust"));
```

:::{note} String in a `Box<T>`
Putting a `String` inside a `Box` is not very useful, since a
`String` has already its content on the heap. The `Box` adds nothing
to it, except an *overhead*. This example has been taken from the
official book at
[Using Deref Coercion in Functions and Methods](https://doc.rust-lang.org/book/ch15-02-deref.html#using-deref-coercion-in-functions-and-methods).
:::

The following call works because:

1. The `Box` implementation of the `Deref` trait allows the compiler
   to convert `&x` into a `&String`.
2. The `String` implementation of the `Deref` trait allows the
   compiler to convert the `&String` into a `&str`.

```{code-cell} rust
:class: seq-cont badges border

hello(&x);
```

## Method access

Thanks to the `Deref` trait we can also access methods that are
defined inside the pointed objects.

Using this property, we can for instance call the `to_uppercase()`
method of `str` onto the `Box` object `x`:

```{code-cell} rust
:class: seq-stop badges border

x.to_uppercase()
```

## DerefMut

There exists also a
[DerefMut](https://doc.rust-lang.org/std/ops/trait.DerefMut.html)
trait that permits to dereference a mutable object.

Let us define a mutable `Box` object on a `String`:

```{code-cell} rust
:class: seq-start badges border

let mut x = Box::new(String::from("Hello, "));
```

We can call any method that modifies the internal string, like
`push_str()`, on `x`:

```{code-cell} rust
:class: seq-cont badges border

x.push_str("John!");
```

Here is the result:

```{code-cell} rust
:class: seq-stop badges border

x
```
