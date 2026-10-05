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

# Static methods

The *static* methods are mainly used to constructor and return an
instance of the `struct`. By convention the default constructor is
called `new()`, but we can define others.

In the following example we define a `Window` struct that represents an
application window:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Window {
  x: u16,
  y: u16,
  width: u16,
  height: u16,
}
```

The `new()` constructor takes as arguments all values required for
fields, and returns a `Window` instance denoted by the `Self` type:

```{code-cell} rust
:class: seq-cont badges border

impl Window {

  fn new(x: u16, y:u16, width: u16, height: u16) -> Self {
    Self {
      x,
      y,
      width,
      height,
    }
  }
}
```

Here is an example of usage of the constructor:

```{code-cell} rust
:class: seq-stop badges border

let wnd = Window::new(10, 20, 200, 80);
(wnd.x, wnd.y, wnd.width, wnd.height)
```

:::{exercise} Rectangle & square (★☆☆☆☆)
:label: rect-square
:enumerated: true

1. Write a structure `Rect` that represents a rectangle.
2. Implement a constructor `new()` that builds a `Rect` instance.
3. Implement another constructor named `square()` that takes only *one*
   value and builds a `Rect` instance that is a square.
4. Use the `new()` constructor to build a regular rectangle, then prints
   the values of its fields.
5. Use the `square()` constructor to build a square, then prints the
   values of its fields.
:::

[see solution](#rect-square-solution)
