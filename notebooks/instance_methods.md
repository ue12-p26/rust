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

# Instance methods

The *instance* methods are applied onto an existing object. Inside the
header and the body of the method, this instance is represented by the
`self` keyword. As with other arguments, we can apply the keyword `mut`
and/or the reference operator `&` onto `self`.

In the following example, the `self` instance is moved into the method,
and made mutable so we can modify a field. The instance is then returned
at the end of the method. Note the return type declaration with the
`Self` keyword that represents the type of the `self` instance:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn with_size(mut self, size: usize) -> Self {
  self.size = size;
  self
}
```

:::{note} self & Self
Note the distinction between `self` in lowercase, which refers to the
current instance, and `Self` in capitalization, which refers to the
*type* of `self`.
:::

In this other example, the `size()` method takes the `self` instance as
a *reference*, thus it will not be moved. We then return the value of a
field:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn size(&self) -> usize {
  self.size
}
```

:::{exercise} Rectangle area (★☆☆☆☆)
:label: rect-area
:enumerated: true

Here is a representation of a rectangle:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

struct Rect {
  width: u32,
  height: u32,
}
```

Write a method `area()` that computes the area of the rectangle, and
returns the value. Test the method on a `Rect` instance.
:::

[see solution](#rect-area-solution)
