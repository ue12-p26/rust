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

# Trait exercises

## Shapes drawing

:::{solution} shapes-drawing
:label: shapes-drawing-solution
:::

We define first the `Shape` trait:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

trait Shape {
  fn draw(&self);
}
```

Then the rectangle:

```{code-cell} rust
:class: seq-cont badges border

struct Rectangle {
  x: i32,
  y: i32,
  width: u32,
  height: u32,
}
```

Its implementation:

```{code-cell} rust
:class: seq-cont badges border

impl Shape for Rectangle {
  fn draw(&self) {
    println!("Drawing rectangle {}x{} at ({}, {}).",
             self.width, self.height, self.x, self.y);
  }
}
```

The `Circle` structure:

```{code-cell} rust
:class: seq-cont badges border

struct Circle {
  x: i32,
  y: i32,
  radius: u32,
}
```

Its implementation:

```{code-cell} rust
:class: seq-cont badges border

impl Shape for Circle {
  fn draw(&self) {
    println!("Drawing circle of radius {} at ({}, {}).",
             self.radius, self.x, self.y);
  }
}
```

The `Drawing` contains now a `shapes` field that is a vector of
shapes:

```{code-cell} rust
:class: seq-cont badges border

struct Drawing<'a> {
  shapes: Vec<&'a (dyn Shape + 'a)>,
}
```

In the implementation of the `Drawing` structure, we now have a
`draw()` method that iterates over all shapes to call their `draw()`
methods, and a `add_shape()` method to add new shapes:

```{code-cell} rust
:class: seq-cont badges border

impl<'a> Drawing<'a> {

  fn draw(&self) {
    for shape in &self.shapes {
      shape.draw();
    }
  }

  fn add_shape(&mut self, shape: &'a dyn Shape) {
    self.shapes.push(shape);
  }
}
```

Let us instantiate a rectangle and a circle:

```{code-cell} rust
:class: seq-cont badges border

let rect = Rectangle { x: 4, y: 6, width: 20, height: 30 };
let circ = Circle { x: 5, y: 2, radius: 10 };
```

We then create the `Drawing` object and add our shapes to it, and
finally trigger the drawing:

```{code-cell} rust
:class: seq-stop badges border

{
  let mut drawing = Drawing { shapes: Vec::new() };
  drawing.add_shape(&rect);
  drawing.add_shape(&circ);
  drawing.draw();
}
```
