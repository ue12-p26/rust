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

(chp-sub-modules)=
# Sub-modules

:::{danger} Draft
:class: readiness-draft

TODO: explain how to define and use sub-modules.

TODO: explain visibility of `struct` in module. How fields are accessed
or not?

TODO: make chapter about `pub` and `mod` and explain usage of both
together.

TODO: explain `super::` and `crate::`.
:::

Inside a module:

```{code-cell} rust
:tags: [raises-exception]

mod foo {
  struct Foo {
    a: i16
  }
}

let x = foo::Foo {a: 12};
x.a
```

```{code-cell} rust
:tags: [raises-exception]

mod foo {
  pub struct Foo {
    a: i16
  }
}

let x = foo::Foo {a: 12};
x.a
```

```{code-cell} rust
mod foo {
  pub struct Foo {
    pub a: i16
  }
}

let x = foo::Foo {a: 12};
x.a
```

:::{danger} TODO
:class: readiness-todo

Why does this work? Because everything that is defined inside a module
is accessible from anyplace inside this same module. In C++ language:
inside a module, everything is `friend` with everything.
:::

Using constructor function `new()`:

```{code-cell} rust
mod foo {
  pub struct Foo {
    a: i16
  }

  impl Foo {

    pub fn new(value: i16) -> Self {
      Self { a: value }
    }

    pub fn a(&self) -> i16 {
      self.a
    }
  }
}

let x = foo::Foo::new(12);
x.a()
```
