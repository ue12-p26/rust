---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# `Vec` type

[Vec](https://doc.rust-lang.org/std/vec/struct.Vec.html) is a generic type
for allocating a growable array in the heap memory.

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

## `vec!()` macro

The `vec!()` macro allows to initialize a `Vec` instance with values as it
is done with standard arrays.

The first form of `vec!()` takes a list of values:

```{code-cell} rust
let v = vec![1, 2, 3];
v
```

The second form of `vec!()` takes a value and a number of repetitions:

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

Using the `for` statement, we can iterate over the elements of a vector:

```{code-cell} rust
let v = vec![1, 2, 3];
for e in v {
  print!("{e}, ");
}
```

The same can be done by obtaining an iterator explicitly:

```{code-cell} rust
:tags: [raises-exception]
let v = vec![1, 2, 3];
let mut i = v.iter();
while let Some(e) = i.next() {
  print!("{e}, ");
}
```
