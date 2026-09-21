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

# Using trait bounds

:::{danger} Draft
This section is still being written.
:::

Function parameters can be typed using traits:

```{code-cell} rust
:tags: [raises-exception]

pub fn foo(x: &impl MyTrait) {
  // ...
}
```

The previous example is translated into the following *trait bound*
syntax:

```{code-cell} rust
:tags: [raises-exception]

pub fn foo<T: MyTrait>(x: &T) {
  // ...
}
```

The *trait bound* syntax is necessary when we need multiple arguments
with the same concrete type:

```{code-cell} rust
:tags: [raises-exception]

pub fn foo<T: MyTrait>(x: &T, y: &T) {
  // ...
}
```

We can specify multiple traits on the same parameter:

```{code-cell} rust
:tags: [raises-exception]

pub fn notify(item: &(impl Summary + Display)) {
  // ...
}
```

or

```{code-cell} rust
:tags: [raises-exception]

pub fn notify<T: Summary + Display>(item: &T) {
  // ...
}
```

## Returning a trait

```{code-cell} rust
:tags: [raises-exception]

fn foo() -> impl MyTrait {
  // ...
}
```

## Using where clauses

The `where` clause allows for clearer declarations:

```{code-cell} rust
:tags: [raises-exception]

fn some_function<T, U>(t: &T, u: &U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug,
{
  // ...
}
```

## Implement a generic method only for some type

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

impl<T: MyTrait> MyStruct<T> {
  fn foo(&self) {
    // ...
  }
}
```

## Trait bound

:::{danger} TODO
Implement a function for only T that implements a trait ...
:::

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

impl<T: ...> Point<T> {
}
```

It is possible to implement a method only for one realisation of a
generic:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

impl Point<f32> {
  fn distance_from_origin(&self) -> f32 {
    (self.x.powi(2) + self.y.powi(2)).sqrt()
  }
}
```

## Where clause

## Complex bound

Multiple constraints:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn foo<T>(x: T) where T: Shape + Clone { ... }
```
