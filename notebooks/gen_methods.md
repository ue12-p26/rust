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

(chp-gen-methods)=
# Generic methods

:::{warning} To review
:::

We will use the following `Point` structure to illustrate various
aspects of generic methods:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Point<T> {
  x: T,
  y: T,
}
```

## Constructor (T as argument)

The constructor of our generic `struct` takes some `T` arguments and
copy or move them into the fields, according to their type:

```{code-cell} rust
:class: seq-cont badges border

impl<T> Point<T> {
  fn new(x: T, y: T) -> Self {
    Self {
      x,
      y,
    }
  }
}
```

## Returning a T

To return a field of type `T` from a method, we usually return a
reference on `T`. It is always efficient whatever `T` is. The caller
will decide if he/she uses the reference on `T` as-is to only access
the value, or if he/she wants to copy or clone it:

```{code-cell} rust
:class: seq-cont badges border

impl<T> Point<T> {

  fn x(&self) -> &T {
    &self.x
  }

  fn y(&self) -> &T {
    &self.y
  }
}
```

Here is an example in which we only *use* the returned value:

```{code-cell} rust
:class: seq-cont badges border

let p = Point::new(1.5, 3.2);
(p.x(), p.y())
```

In the following code, however we *copy* the values into some
variables:

```{code-cell} rust
:class: seq-stop badges border

{
  let (x, y) = (p.x(), p.y());
  println!("{:?}", (x, y));
}
```
