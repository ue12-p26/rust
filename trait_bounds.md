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

## Returning a trait

```{code-cell} rust
:tags: [raises-exception]

fn foo() -> impl MyTrait {
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
