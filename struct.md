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

# Structures

:::{danger} Draft
This section is still being written.

- TODO: explain `struct`.
- TODO: explain visibility of `struct` in module. How fields are accessed
  or not?
:::

## Regular struct

```{code-cell} rust
struct Foo {
  a: i16
}

let x = Foo {a: 12};
x.a
```

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
- Explain to do not make fields public, but to write a "constructor" and
  an access function.
- Why does this work? Because everything that is defined inside a module
  is accessible from anyplace inside this same module. In C++ language:
  inside a module, everything is `friend` with everything.
:::

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

Declare a struct:

```{code-cell} rust
struct MyStruct {
  a: bool,
  b: i32,
}
```

Use a struct:

```{code-cell} rust
let obj = MyStruct {
  a: false,
  b: 10,
};
```

Use the Field Init Shorthand:

```{code-cell} rust
let a = false;
let b = 10;
let obj = MyStruct {
  a,
  b,
};
```

Use the Struct Update Syntax to create a new object from an existing
object:

```{code-cell} rust
let obj2 = MyStruct {
  a: true,
  ..obj
};
```

## Tuple struct

```{code-cell} rust
struct Color(u8, u8, u8);

let yellow  = Color(0xff, 0xff, 0);

println!("red={}, green={}, blue={}", yellow.0, yellow.1, yellow.2)
```

## Methods

```{code-cell} rust
:tags: [raises-exception]

struct Rect {
  witdh: u32;
  height: u32;
}
```

Defining a method:

```{code-cell} rust
:tags: [raises-exception]

impl Rect {
  fn area(&self) -> u32 {
    self.width * self.height
  }
}
```

Associated method (i.e.: *static* method):

```{code-cell} rust
:tags: [raises-exception]

impl Rect {
  fn square(sz: u32) -> Self {
    Self(width: sz, height: sz)
  }
}
//...
let my_square = Rect.square(10);
```
