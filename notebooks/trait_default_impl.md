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

# Default implementation

:::{warning} To review
:::

We may define default implementations for trait methods. These
implementations may be overwritten in types that implement the trait.

Here is a `Surface` trait that provides a header for a `area()` method
and a default implementation for a `describe()` method that returns a
description of the object:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

trait Surface {
  fn area(&self) -> f64;

  fn describe(&self) -> String {
    format!("Area is {:.2}.", self.area())
  }
}
```

We define a `Rectangle` structure that implements the `Surface` trait:

```{code-cell} rust
:class: seq-cont badges border

struct Rectangle {
  width: f64,
  height: f64,
}

impl Surface for Rectangle {
  fn area(&self) -> f64 {
    self.width * self.height
  }
}
```

The `Rectangle` structure uses the default implementation of the
`Surface` trait:

```{code-cell} rust
:class: seq-cont badges border

let rect = Rectangle {width: 7.2, height: 9.5};
rect.describe()
```

Here is a `Circle` structure that implements the `Surface` trait too,
but also overwrite its `describe()` method:

```{code-cell} rust
:class: seq-cont badges border

struct Circle {
  radius: f64,
}

impl Surface for Circle {
  fn area(&self) -> f64 {
    std::f64::consts::PI * self.radius * self.radius
  }
  fn describe(&self) -> String {
    format!("Circle area is {:.5}.", self.area())
  }
}
```

We see that `Circle`'s version of the `describe()` methods is indeed
called in place of the default implementation:

```{code-cell} rust
:class: seq-stop badges border

let circ = Circle {radius: 6.7};
circ.describe()
```
