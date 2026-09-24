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

:::{warning} To review
:class: readiness-toreview

:::

When a type implements a trait, we have the possibility to view this
type as-is, or as the trait it implements. This property is called
*polymorphism*. With *polymorphism* we have access to the different
views of an object. Each view restricts the actions we can make with
the object, letting us access only a *subset* of its methods.

To illustrate *polymorphism*, let us redefine our `Surface` trait, the
`Rectangle` structure and its implementation of the trait:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

trait Surface {
  fn area(&self) -> f64;
}

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

With *polymorphism*, our `Rectangle` can be seen as a `Surface` instead
of being seen as a `Rectangle`. Two kind of *polymorphism* are
possible:

- *Compile-time* polymorphism, in which the compiler hard-code the
  view of the object we want to use.
- *Runtime* polymorphism, in which the view on the object is used
  *dynamically*.

## Compile-time polymorphism

In *compile-time* polymorphism, a function accepting a trait as a
parameter will be generated multiple times by the compiler: once for
each concrete type used with the function.

To write a function that uses *compile-time* polymorphism to accept a
trait as input argument, we use the `impl` keyword. Here is a function
that prints the area of an object that implements the `Surface` trait:

```{code-cell} rust
:class: seq-cont badges border

fn print_surface(s: &impl Surface) {
  println!("Area is {}.", s.area());
}
```

Let us define a `Rectangle` instance and use it with this function:

```{code-cell} rust
:class: seq-cont badges border

let rect = Rectangle {width: 3.45, height: 10.8};
print_surface(&rect);
```

When calling the function, we pass a *reference* to our object. The
compiler creates a version of the `print_surface()` that accepts a
`Rectangle` instance but only accesses it through its `Surface` trait.

:::{important} Generic version
We may have implemented the same function as a *generic* function, the
compiler would have generated the same exact code, and the result
would have been the same:

```{code-cell} rust
:class: seq-cont badges border

fn print_surface_2<T: Surface>(s: &T) {
  println!("Area is {}.", s.area());
}

print_surface_2(&rect);
```
:::

The interest of having defined the function with a *trait* as
argument, is that we can use it on any other type that implements that
trait. For instance, we can define the following `Circle` structure:

```{code-cell} rust
:class: seq-cont badges border

struct Circle {
  radius: f64,
}
```

And implement the `Surface` trait for it:

```{code-cell} rust
:class: seq-cont badges border

impl Surface for Circle {
  fn area(&self) -> f64 {
    std::f64::consts::PI * self.radius * self.radius
  }
}
```

We can now define a `Circle` instance and call the `print_surface()`
function on it:

```{code-cell} rust
:class: seq-cont badges border

let circ = Circle {radius: 6.7};
print_surface(&circ);
```

As for the call with the `rect` instance, the compiler creates a
specific version of `print_surface()` that accepts a `Circle`
instance.

:::{important} Memory & performance
The *compile-time* polymorphism scheme generates multiple versions of
a function, leading to an *inflation* in the size of the generated
binary.
:::

## Runtime polymorphism

In *runtime* polymorphism, a function accepting a trait as parameter
will be generated just *once*, as-is, and will receive the parameter
as a dynamic object (i.e.: using a *vtable*).

To write a function that uses *runtime* polymorphism to accept a trait
as input argument, we use the `dyn` keyword. `dyn` stands for
*dynamic*.

The `dyn` keyword is used to construct a *fixed size* type composed of
a *data pointer* and a *vtable pointer*. The *data pointer* points to
the data fields of the instance, while the *vtable pointer* points to
a table containing the list of methods of the trait. *vtable* stands
for *virtual method table*. The methods defined by a trait are seen as
[virtual methods](https://en.wikipedia.org/wiki/Virtual_function) when
used dynamically.

Here is an illustration of the `&dyn Surface` for a `Circle` instance:

```text
       &dyn Surface
┌────────────┬──────────────┐
│data pointer│vtable pointer│  --> fixed size
└────────────┴──────────────┘
      │               │
      ▼               ▼
  [Circle data]   [Circle's vtable]
                    area  -> Circle::area()
```

Here is the implementation of the `print_surface()` function when
using a dynamic object as argument:

```{code-cell} rust
:class: seq-cont badges border

fn print_surface_3(s: &dyn Surface) {
  println!("Area is {}.", s.area());
}
```

The usage of the function is the same than in *compile-time*
polymorphism:

```{code-cell} rust
:class: seq-cont badges border

print_surface_3(&circ);
```

:::{important} Memory & performance
The *runtime* polymorphism scheme generates a single version of a
function, but uses indirections (i.e.: *virtual tables* a.k.a.
*vtables*), leading to a *slight decrease* of execution performance.
:::

## Runtime polymorphism in collections

Using runtime polymorphism, we can put objects that share a *common
trait* together into a same collection.

Here is a vector of objects that implement the `Surface` trait:

```{code-cell} rust
:class: seq-cont badges border

let mut surfaces: Vec<Box<dyn Surface>> = Vec::new();
```

We can put in it our two objects `rect` and `circ`:

```{code-cell} rust
:class: seq-cont badges border

surfaces.push(Box::new(rect));
surfaces.push(Box::new(circ));
```

When iterating over objects contained inside the vector, we can call
any method of the trait:

```{code-cell} rust
:class: seq-stop badges border

for s in &surfaces {
  println!("Area is {}.", s.area());
}
```

:::{note} Why `Box<dyn Surface>` and not `&dyn Surface`
:class: dropdown

A collection like this could just as well hold *borrowed* trait
objects (`Vec<&dyn Surface>`) instead of *owned, boxed* ones. Here we
use `Box` only because of how this book's interactive notebooks are
executed: each cell runs as a separate, isolated step, and a
collection of borrowed references cannot survive from one cell to the
next unless what it borrows lives for the entire program (`'static`).
`Box<dyn Surface>` sidesteps that by having `surfaces` *own* its
elements instead of borrowing them. In an ordinary, single-file Rust
program, `Vec<&dyn Surface>` would work perfectly well as long as
`rect` and `circ` outlive the vector.
:::

