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

# Polymorphism with traits

:::{danger} Draft
This section is still being written.
:::

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

trait Shape {
  fn area(&self) -> f64;
  fn name(&self) -> &str;

  // Default method implementation
  fn describe(&self) -> String {
    format!("{} has an area of {:.2}", self.name(), self.area())
  }
}
```

```{code-cell} rust
:class: seq-cont badges border

struct Circle {
  radius: f64,
}

struct Rectangle {
  width: f64,
  height: f64,
}

impl Shape for Circle {
  fn area(&self) -> f64 {
    std::f64::consts::PI * self.radius * self.radius
  }
  fn name(&self) -> &str {
    "Circle"
  }
}

impl Shape for Rectangle {
  fn area(&self) -> f64 {
    self.width * self.height
  }
  fn name(&self) -> &str {
    "Rectangle"
  }
}
```

```{code-cell} rust
:class: seq-stop badges border

fn print_shape<T: Shape>(shape: &T) {
  println!("{}", shape.describe());
}

// or equivalently, using `impl Trait` syntax:
fn print_shape_impl(shape: &impl Shape) {
  println!("{}", shape.describe());
}

let c = Circle { radius: 2.0 };
let r = Rectangle { width: 3.0, height: 4.0 };

print_shape(&c);
print_shape_impl(&r);
```

```{code-cell} rust
let shapes: Vec<Box<dyn Shape>> = vec![
  Box::new(Circle { radius: 2.0 }),
  Box::new(Rectangle { width: 3.0, height: 4.0 }),
];

for shape in &shapes {
  println!("{}", shape.describe());
}
```

```{code-cell} rust
fn print_dyn(shape: &dyn Shape) {
  println!("{}", shape.describe());
}
```

Complex bound (multiple constraints):

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn foo<T>(x: T) where T: Shape + Clone { ... }
```
