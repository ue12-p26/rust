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

(chp-traits)=
# Traits

:::{warning} To review
:class: readiness-toreview

:::

A *trait* represents a *functionality*. It defines a list of one or
more methods that a type must implement in order to provide this
functionality.

In Rust, almost any data type can implement a trait: *structs*,
*enums*, *primitive types*, and *tuples*.

Inside the *standard library*:

- Many traits are defined
  ([Clone](https://doc.rust-lang.org/std/clone/trait.Clone.html),
  [Copy](https://doc.rust-lang.org/std/marker/trait.Copy.html),
  [Debug](https://doc.rust-lang.org/std/fmt/trait.Debug.html),
  [PartialEq](https://doc.rust-lang.org/std/cmp/trait.PartialEq.html),
  ...).
- Most of them declare only one method.
- Most of the provided types (*structs*, *primitive types*, ...)
  implement multiple traits.

A list of the most common traits of the standard library is available
in [Traits of the Standard library](#chp-std-traits).

## Defining a trait

As an example we want to create a trait `Surface` that defines a
method for computing the area. We will use this trait for a structure
`Rectangle`.

Here is the `Rectangle` structure:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Rectangle {
  width: f64,
  height: f64,
}
```

And an instance of that structure:

```{code-cell} rust
:class: seq-cont badges border

let rect = Rectangle {width: 7.2, height: 9.5};
```

To define a custom trait, we use the `trait` keyword. At least one
method must be defined, and only its *declaration* (i.e.: function's
header, without a body) is necessary. In the following example, we
define the trait `Surface` with its method `area()`:

```{code-cell} rust
:class: seq-cont badges border

trait Surface {
  fn area(&self) -> f64;
}
```

To implement the trait for our structure, we use the `impl` keyword in
its form `impl <trait> for <struct>`:

```{code-cell} rust
:class: seq-cont badges border

impl Surface for Rectangle {
  fn area(&self) -> f64 {
    self.width * self.height
  }
}
```

The `area()` method is now available for our `rect` object:

```{code-cell} rust
:class: seq-stop badges border

rect.area()
```
