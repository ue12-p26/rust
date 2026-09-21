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

# `Vec` type

[Vec](https://doc.rust-lang.org/std/vec/struct.Vec.html) is a *generic*
type for allocating a growable array in the heap memory.

:::{note} Generic types
Generic types are defined using one or more parameter types, allowing
to define one type that can be specialized for one or more types.
Containers like `Vec` are all generic types. This allows to construct,
using a single type, containers of `f32`, of `f64`, of `i16`, of a
custom type, etc.
To know more about *generics*, see [Generics chapter](#chp-generics).
:::

We present here the basics of the `Vec` type and some of its methods. See
{numref}`tab-vec-methods` for a more complete list of its methods.

## Empty vector

Example of an empty vector of signed bytes:

```{code-cell} rust
let v: Vec<i8> = Vec::new();
v
```

:::{note} `new()` method
In Rust, `new()` is the usual name for the constructor method of a `struct`.
:::

## Adding elements

Using the `push()` we can add elements one by one:

```{code-cell} rust
let mut v: Vec<i8> = Vec::new();
v.push(10);
v
```

## `vec!` macro

The [vec!](https://doc.rust-lang.org/std/macro.vec.html) macro allows to
initialize a `Vec` instance with values as it is done with standard
arrays.

The first form of `vec!` takes a list of values:

```{code-cell} rust
let v = vec![1, 2, 3];
v
```

The second form of `vec!` takes a value and a number of repetitions:

```{code-cell} rust
let v = vec![5; 10];
v
```

## Accessing elements by index

We can access individual elements using the indexing operator (`[]`):

```{code-cell} rust
let v = vec![1, 2, 3];
v[1]
```

:::{warning} Indices start at `0`
As for *arrays*, the first element of a `vec` is at index `0`.
:::

With this operator, if the index is out of bounds, an unrecoverable error
is raised:

```{code-cell} rust
:tags: [raises-exception]

let v = vec![1, 2, 3];
v[5]
```

## Modifying elements by index

We can modify the values of a mutable vector using the indexing operator:

```{code-cell} rust
let mut v = vec![1, 2, 3];
v[2] = 8;
v
```

## Iterating over elements

Using the `for` statement (see [`for`](#chp-for)), we can iterate over the
elements of a vector:

```{code-cell} rust
let v = vec![1, 2, 3];
for e in v { // v is moved (see the warning below)
  print!("{e}, ");
}
```

The same can be done by obtaining an iterator explicitly using the
`into_iter()` method. The `Iterator` object can then be iterated over
thanks to the `next()` method, which returns an `Option<T>`:

```{code-cell} rust
:tags: [raises-exception]

let v = vec![1, 2, 3];
let mut i = v.into_iter(); // v is moved (see the warning below)
while let Some(e) = i.next() {
  print!("{e}, ");
}
```

:::{warning} Conversion of a vector into an iterator
When using a `loop` to iterate over a vector's elements, be aware that the
`Vector` type does not implement the `Copy` trait. As a consequence, a
call to `into_iter()` will move the elements of the vector into the newly
created iterator.

To loop onto the elements of a vector without moving them, we need to
call `into_iter()` onto a slice (see [Slices](#chp-slices)) of the vector
(`&v`):

```{code-cell} rust
let v = vec![1, 2, 3];
for e in &v {
  println!("{e}");
}
println!("v is still accessible: {v:?}");
```
:::

:::{exercise} Iterating over a vector's items
:label: vec-iter
:enumerated: true

1. Create a vector of 3 `String` objects with the following values:
   `"banana"`, `"strawberry"`, `"orange"`.
2. Iterate over the elements of the vector *without moving* them and
   print them on the standard output.
3. Inside the iteration loop, put the first letter of each string into
   uppercase before printing them.
:::

[see solution](#vec-iter-solution)
