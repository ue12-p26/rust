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

# Struct exercises

## Rectangle area

:::{solution} rect-area
:label: rect-area-solution
:::

The rectangle structure has two fields `width` and `height`:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Rect {
  width: u32,
  height: u32,
}
```

The `area` method takes a reference on `self` and does its computing:

```{code-cell} rust
:class: seq-cont badges border

impl Rect {
  fn area(&self) -> u32 {
    self.width * self.height
  }
}
```

Here is a call to `area()` on an example of instance:

```{code-cell} rust
:class: seq-stop badges border

let rect = Rect { width: 10, height: 20 };
rect.area()
```

## Rectangle & square

:::{solution} rect-square
:label: rect-square-solution
:::

The rectangle structure may be implemented as following, using 32-bit
floats:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Rect {
  width: f32,
  height: f32,
}
```

The default constructor takes both the `width` and the `height` to
build a new `Rect` object:

```{code-cell} rust
:class: seq-cont badges border

impl Rect {

  fn new(width: f32, height: f32) -> Self {
    Self {
      width,
      height,
    }
  }
}
```

The `square()` constructor takes only one `f32` value as argument. It is
used to set both `width` and `height`:

```{code-cell} rust
:class: seq-cont badges border

impl Rect {
  fn square(sz: f32) -> Self {
    Self {
      width: sz,
      height: sz,
    }
  }
}
```

Here is an example of building a regular rectangle:

```{code-cell} rust
:class: seq-cont badges border

let a_rect = Rect::new(5.0, 4.5);
(a_rect.width, a_rect.height)
```

The same for a square:

```{code-cell} rust
:class: seq-stop badges border

let a_square = Rect::square(10.0);
(a_square.width, a_square.height)
```

## Postal mail

:::{solution} postal-mail
:label: postal-mail-solution
:::

Here is a possible structure for modelling a postal mail:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Mail {
  recipient: &'static str,
  sender: &'static str,
  weight: f32,
  priority: bool,
}
```

:::{note} Static string
In place of the static string `&'static str`, which only allows us to
pass a hard-coded string, we should have used a string slice with a
lifetime `&'a str` (see [Lifetimes](#chp-lifetimes)) or a heap string
`String` (see [`String`](#chp-string)).
:::

We implement the `new()` constructor and the builder setters for
`weight` and `priority`:

```{code-cell} rust
:class: seq-cont badges border

impl Mail {

  fn new(recipient: &'static str, sender: &'static str) -> Self {
    Self {
      recipient,
      sender,
      weight: 20.0,
      priority: false,
    }
  }

  fn with_weight(mut self, weight: f32) -> Self {
    self.weight = weight;
    self
  }

  fn with_priority(mut self, priority: bool) -> Self {
    self.priority = priority;
    self
  }
}
```

An example of `Mail` instance:

```{code-cell} rust
:class: seq-cont badges border

let mail = Mail::new(
  "RMN 254 rue de Bercy 75577 Paris Cedex 12",
  "Marcel Dupond 3 rue de Bruxelles 59000 Lille")
  .with_weight(100.0)
  .with_priority(true);
```

The content of the instance:

```{code-cell} rust
:class: seq-stop badges border

(mail.recipient, mail.sender, mail.weight, mail.priority)
```

## Book

:::{solution} book-ex
:label: book-ex-solution
:::

We define the `Book` structure, its constructor and three access
functions to access the values of the three fields:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Book {
  title:  &'static str,
  author: &'static str,
  year:   i16,
}

impl Book {

  fn new(title: &'static str, author: &'static str, year: i16) -> Self {
    Self {
      title,
      author,
      year,
    }
  }

  fn title(&self) -> &'static str {
    self.title
  }

  fn author(&self) -> &'static str {
    self.author
  }

  fn year(&self) -> i16 {
    self.year
  }
}
```

Here is an example of usage of the *constructor* and the *access
functions*:

```{code-cell} rust
:class: seq-stop badges border

let book = Book::new("Robinson Crusoe", "Daniel Defoe", 1719);
(book.title(), book.author(), book.year())
```

In both the *constructor function* and the *access functions*, the idea
is to *encapsulate* the construction and the access. If later we need
to *run code* during construction or access, it will be easy inserted
inside the function.

## Square area

:::{solution} square-area
:label: square-area-solution
:::

We define a `struct` named `Square` that we can define be either giving
the area or the side length. From one value the constructor function
computes the other, leaving the original value untouched. This example
shows how we can force to run the same computation for each constructed
object:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Square {
  a: f32,
  area: f32,
}

impl Square {
  fn new(mut a: f32, mut area: f32) -> Self {
    if a < 0.0 {
      a = area.sqrt();
    }
    if area < 0.0 {
      area = a * a;
    }
    Self {
      a,
      area,
    }
  }

  fn a(&self) -> f32 {
    self.a
  }

  fn area(&self) -> f32 {
    self.area
  }
}
```

Excepted the representation error, the original value of the area of
the following square is untouched, while the re-computed area
propagates an error:

```{code-cell} rust
:class: seq-stop badges border

let c = Square::new(-1.0, 1.0001);
println!("a={:.10}, a*a={:.10}", c.a(), c.area());
println!("a={:.10}, a*a={:.10} (recomputed)", c.a(), c.a() * c.a());
```
