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

In Rust, almost any data type can implement a trait:

- *Structs*.
- *Enums*.
- *Primitive types*.
- *Tuples*.

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
in {numref}`tab-std-traits`.
Among them are the comparison operators from the
[cmp](https://doc.rust-lang.org/std/cmp/index.html) module.
Other operators (`*`, `/`, `+`, `%`, ...) are defined inside the
[ops module](https://doc.rust-lang.org/stable/std/ops/index.html). They
are listed inside the
[ops traits](https://doc.rust-lang.org/stable/std/ops/index.html#traits)
section.

:::{list-table} Some of the most common traits
:name: tab-std-traits
:header-rows: 1
:align: center

* - Trait
  - Description
* - [Clone](https://doc.rust-lang.org/std/clone/trait.Clone.html)
  - To make a object clonable.
* - [Copy](https://doc.rust-lang.org/std/marker/trait.Copy.html)
  - Reserved for copiable types.
* - [Debug](https://doc.rust-lang.org/std/fmt/trait.Debug.html)
  - To provide the Debug formatter.
* - [Display](https://doc.rust-lang.org/std/fmt/trait.Display.html)
  - To provide the Display formatter.
* - [Default](https://doc.rust-lang.org/std/default/trait.Default.html)
  - To set a default value for a type.
* - [Eq](https://doc.rust-lang.org/std/cmp/trait.Eq.html)
  - Like `PartialEq` plus reflexivity (`a == a`).
* - [Ord](https://doc.rust-lang.org/std/cmp/trait.Ord.html)
  - Like `PartialOrd` plus `min()`, `max()` and `clamp()`.
* - [PartialEq](https://doc.rust-lang.org/std/cmp/trait.PartialEq.html)
  - To provide operators `==` and `!=`.
* - [PartialOrd](https://doc.rust-lang.org/std/cmp/trait.PartialOrd.html)
  - To provide operators `<`, `<=`, `>` and `>=`.
:::

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
