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

(chp-boxed-trait)=
# Use Box to store different objects in a collection

:::{warning} To review
:class: readiness-toreview

:::

Let us create a `Shape` trait for which we declare an `area()` method:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

trait Shape {
  fn area(&self) -> f64;
}
```

We define two structs `Circle` and `Rectangle`:

```{code-cell} rust
:class: seq-cont badges border

struct Circle {
  radius: f64,
}

struct Rectangle {
  width: f64,
  height: f64,
}
```

And implement the `Shape` trait for both structures:

```{code-cell} rust
:class: seq-cont badges border

impl Shape for Circle {
  fn area(&self) -> f64 {
    self.radius * self.radius * std::f64::consts::PI
  }
}

impl Shape for Rectangle {
  fn area(&self) -> f64 {
    self.width * self.height
  }
}
```

The two instances we create now can be seen as shapes using their
common `Shape` trait:

```{code-cell} rust
:class: seq-cont badges border

let circ = Circle { radius: 2.0 };
let rect = Rectangle { width: 3.0, height: 4.0 };
```

One way to show this, is to build a vector of `Shape` references that
mixes a `Rectangle` and a `Circle` objects, and then to loop on the
vector's items and use the `Shape`'s method on them:

```{code-cell} rust
:class: seq-cont badges border

{
  let shapes: Vec<&dyn Shape> = vec![&circ, &rect];
  for shape in &shapes {
    println!("Area: {}", shape.area());
  }
}
```

However we are limited by the fact that these are only *references*,
meaning their lifetime depends on the lifetime of the original objects
that reside on the *stack*.
What if we want to move these objects altogether to another data
structure on the *heap*?
Using the [Box](https://doc.rust-lang.org/std/boxed/struct.Box.html)
structure we can move objects that have a *common* trait.

Here is again a vector of `Shape` objects, but this time we use a
`Box` to store them:

```{code-cell} rust
:class: seq-cont badges border

let shapes: Vec<Box<dyn Shape>> = vec![
  Box::new(circ),
  Box::new(rect),
];
```

:::{warning} Stack/heap usage
We have created the `circ` and `rect` objects primarily on the
*stack*.
When calling `Box::new(circ)` the `circ` is moved on the *heap*.
In practice it is preferable to write `Box::new(Circle::new(10.0))`,
because while in *debug* mode the result will be the same with a
`Circle` object first created on the *stack* then moved on the
*heap*, in *release* mode the compiler will optimize and directly
create the `Circle` object on the heap.
:::

We can access them the same way:

```{code-cell} rust
:class: seq-stop badges border

for shape in &shapes {
  println!("Area: {}", shape.area());
}
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
