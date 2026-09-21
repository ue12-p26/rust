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

# Generic struct

:::{warning} To review
:::

*Structures* also can be generic. We use the generic parameter(s) inside
at least one of the fields, and inside some of the methods.

## Defining a generic struct

Here is the definition of structure `Point` for a cartesian point:

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

This `Point` structure may be generated for any type `T`.

Here we generate the `Point` structure for 32-bit signed integers:

```{code-cell} rust
:class: seq-cont badges border

let p = Point { x: 5, y: 10 };
```

Now we generate the `Point` structure for 64-bit floats:

```{code-cell} rust
:class: seq-cont badges border

let p1 = Point { x: 1.0, y: 4.0 };
```

As we have defined the `struct`, it is also possible to use a string
type, or any other type:

```{code-cell} rust
:class: seq-cont badges border

let _p = Point { x: "abc", y: "def" };
```

## Defining methods

When defining methods for a generic struct, the *impl* statement must
list the *generic parameters* with their eventual constraints.

Here we define two methods `x()` and `y()` in order to retrieve the two
coordinates:

```{code-cell} rust
:class: seq-cont badges border

impl<T> Point<T> {

  pub fn x(&self) -> &T {
    &self.x
  }

  pub fn y(&self) -> &T {
    &self.y
  }
}
```

And we use them to print the coordinates of point `p`:

```{code-cell} rust
:class: seq-stop badges border

println!("p=({},{})", p.x(), p.y());
```

If we restrict `T` to floating point types (`f32` and `f64`), we can
define functions that use floating point operations. This example
requires the external `num_traits` crate, which is not available in
this notebook's kernel, so it is shown but not executed:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

use num_traits::Float;

impl<T> Point<T>
where
    T: Float
{

  pub fn distance(&self, other: &Self) -> T {
    let a = self.x - other.x;
    let b = self.y - other.y;
    (a * a + b * b).sqrt()
  }
}
```

In the following example, we compute the distance between two points
`p1` and `p2`:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

let p2 = Point { x: 6.5, y: 11.0 };
println!("Distance between p1 and p2: {}", p1.distance(&p2));
```
