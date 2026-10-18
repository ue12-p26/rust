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

# Drop

:::{warning} To review
:class: readiness-toreview

:::

The [Drop](https://doc.rust-lang.org/std/ops/trait.Drop.html) trait
is implemented by types that have *resources to free* when an
instance goes *out of scope*. For instance the `Vec` handles an
array stored onto the heap. `Vec` implements the `Drop` trait, so
that when a `Vec` variable goes out of scope the heap memory is
freed.

To show how the `Drop` trait works, we create a `Foo` structure with
just an integer field:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
struct Foo {
  n: i64,
}
```

We then implement the `Drop` trait for `Foo` with a fake `drop()`
method that just prints a message:

```{code-cell} rust
:class: seq-cont badges border

impl Drop for Foo {

  fn drop(&mut self) {
    println!("Dropping object Foo with value {}.", self.n);
  }
}
```

If we create a `Foo` object inside a scope, we see the call to the
`drop()` method at the end of the scope:

```{code-cell} rust
:class: seq-cont badges border

{
  let x = Foo { n: -6 };
  println!("x: {x:?}");
}
```

Using the `drop()` function we can trigger the cleaning of a
variable before it goes out of scope. We must not call the `drop()`
method of the object directly, because we need to disable the
automatic drop at the end of the scope. Calling the `drop()`
function will *disable the automatic drop*:

```{code-cell} rust
:class: seq-stop badges border

{
  let y = Foo { n: 18 };
  drop(y);
  println!("Dropping of y has been done.");
}
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
