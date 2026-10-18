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

# Using a trait as field's type

:::{warning} To review
:class: readiness-toreview

:::

It is possible to use a *trait* as a field's type inside a
structure. This allows to store in this field any object whose type
implements the trait. To do that we need:

- To use the `dyn` keyword, in order to state that we use a
  *Dynamically Sized Type* (DST). Only the trait is specified, not
  the real type of the object that will be stored. The real type,
  and thus its size, will only be known at compile time.
- To use a *reference* (`&`) on the `dyn Trait`. The reference is a
  *fat pointer*, that contains a pointer to the real object, the
  object's size, a pointer to the *vtable* (virtual table) that
  contains the available methods of the object and its traits.
- Use a *lifetime* specifier to link the lifetime of the pointed
  object to the lifetime of the structure.

As an example, we will use a structure for a drawing in which we
store a single shape as a trait. The trait provides a `draw()`
method that we will use to simulate the drawing on screen.

Let us start with the trait definition:

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

We define a `Rectangle` structure:

```{code-cell} rust
:class: seq-cont badges border

struct Rectangle {
  x: i32,
  y: i32,
  width: u32,
  height: u32,
}
```

With its implementation of the `Shape` trait that just prints a
message:

```{code-cell} rust
:class: seq-cont badges border

impl Shape for Rectangle {
  fn draw(&self) {
    println!("Drawing rectangle {}x{} at ({}, {}).",
             self.width, self.height, self.x, self.y);
  }
}
```

We now define a structure `Drawing` that stores a single shape as a
trait:

```{code-cell} rust
:class: seq-cont badges border

struct Drawing<'a> {
  shape: &'a (dyn Shape + 'a),
}
```

We implement a `draw()` method for it that calls the `draw()` method
of the `Shape` object:

```{code-cell} rust
:class: seq-cont badges border

impl<'a> Drawing<'a> {
  fn draw(&self) {
    self.shape.draw();
  }
}
```

Let us instantiate a `Rectangle` object:

```{code-cell} rust
:class: seq-cont badges border

let rect = Rectangle { x: 4, y: 6, width: 20, height: 30 };
```

We also instantiate a `Drawing` object using our `Rectangle` object
for the field's value. The `draw()` method of `Drawing` calls the
`draw()` method of the `Shape` object without knowing anything about
its concrete type:

```{code-cell} rust
:class: seq-stop badges border

{
  let drawing = Drawing { shape: &rect };
  drawing.draw();
}
```

:::{exercise} Shapes drawing (★★★★☆)
:label: shapes-drawing
:enumerated: true

Our example only used one shape, which is not very useful. Modify
this example as following:

1. Define another shape: `Circle`.
2. Implement the `draw()` method of the trait for `Circle`.
3. Change the `Drawing` structure so it can contain multiple shapes.
4. Add a method `add_shape()` to `Drawing` so we can add the shapes
   we want to it.
5. Modify the `draw()` method of `Drawing` so it draws all the
   shapes.
6. Define a `circ` variable that contains a `Circle` object.
7. Modify the creation of the `Drawing` instance and add the two
   shapes to it.
8. The call to the `draw()` method of `Drawing` should now print the
   messages of both shapes.
:::

[see solution](#shapes-drawing-solution)
