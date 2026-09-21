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

# Structures

A structure (or
[record](https://en.wikipedia.org/wiki/Record_(computer_science))) is a
composite data structure made of several *fields* in sequence. In Rust,
the fields of a structure are *typed*. They may have identical or
different types.

:::{note} Fields order
The order of declaration of the fields is only relevant for destruction.
When an instance of the `struct` is destroyed (`dropped` in Rust
language), its fields are destroyed in the order of declaration.
:::

There exist two types of structures in Rust:

- The *regular struct* that uses *named* fields.
- The *tuple struct* that uses a `tuple` notation and uses *unnamed*
  fields.

## Regular struct

In Rust, a structure is defined using the `struct` keyword, as in the
following example that defines a `Book` data type:

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
```

We initialize an instance of a `struct` by setting a *value* for each
field:

```{code-cell} rust
:class: seq-cont badges border

let book1 = Book {
  title: "La Nuit du carrefour",
  author: "Georges Simenon",
  year: 1931,
};
```

To retrieve a field's value, we simply name the field we want to access
on the instance:

```{code-cell} rust
:class: seq-cont badges border

(book1.title, book1.author, book1.year)
```

:::{tip} Field Init Shorthand
The *Field Init Shorthand* uses the name of variables to initialize a
struct instance.
:::

If we define the three following variables:

```{code-cell} rust
:class: seq-cont badges border

let title = "Mon ami Maigret";
let author = "Georges Simenon";
let year = 1949;
```

We can use them to create a `Book` instance. The names of the variables,
because they match the names of the fields, will be used by the compiler
to know how to initialize the `Book` instance:

```{code-cell} rust
:class: seq-cont badges border

let book3 = Book {
  title,
  author,
  year,
};
```

Here is the instance's content:

```{code-cell} rust
:class: seq-cont badges border

(book3.title, book3.author, book3.year)
```

:::{tip} Struct Update Syntax
The *Struct Update Syntax* allows to create a new object from an
existing object. In the following code, we use the fields from `book1`
to complete the missing fields in `book2`:
:::

```{code-cell} rust
:class: seq-cont badges border

let book2 = Book {
  title: "Le Chien jaune",
  ..book1
};
```

Here is the result:

```{code-cell} rust
:class: seq-stop badges border

(book2.title, book2.author, book2.year)
```

For constructing an object, we do not usually use directly the curly
braces syntax, but define a *constructor method*, named `new()` by
convention. We will see the `new()` method in the next section.

## Methods

To define *methods* for a `struct`, we use the `impl` keyword onto the
name of our structure and define the functions inside.

There exist two types of methods:

- *Static* methods: they do not reference an existing instance and are
  called using the `struct` name (e.g.: `MyStruct::new()`). They are
  usually used to construct an object.
- *Instance* methods: they refer to an instance on which their code
  applies. They are called on an instance (e.g.: `my_obj.foo()`).

### Instance methods

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

### Static methods

The *static* methods are mainly used to constructor and return an
instance of the `struct`. By convention the default constructor is
called `new()`, but we can define others.

In the following example we define a `Window` struct that represents an
application window:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Window {
  x: u16,
  y: u16,
  width: u16,
  height: u16,
}
```

The `new()` constructor takes as arguments all values required for
fields, and returns a `Window` instance denoted by the `Self` type:

```{code-cell} rust
:class: seq-cont badges border

impl Window {

  fn new(x: u16, y:u16, width: u16, height: u16) -> Self {
    Self {
      x,
      y,
      width,
      height,
    }
  }
}
```

Here is an example of usage of the constructor:

```{code-cell} rust
:class: seq-stop badges border

let wnd = Window::new(10, 20, 200, 80);
(wnd.x, wnd.y, wnd.width, wnd.height)
```

:::{exercise} Rectangle & square (★☆☆☆☆)
:label: rect-square
:enumerated: true

1. Write a structure `Rect` that represents a rectangle.
2. Implement a constructor `new()` that builds a `Rect` instance.
3. Implement another constructor named `square()` that takes only *one*
   value and builds a `Rect` instance that is a square.
4. Use the `new()` constructor to build a regular rectangle, then prints
   the values of its fields.
5. Use the `square()` constructor to build a square, then prints the
   values of its fields.
:::

[see solution](#rect-square-solution)

### Builder setters (instance methods)

In Rust, it is no possible to define default values in methods and
functions. This implies that in a constructor method we cannot make
optional the setting of certain fields. To be able to set default values
to fields and still allow the user to easily set his/her own values
while building a new object, we need another mechanism called *Builder
Setters*. The convention in Rust is to name those methods using the
`with_` prefix. The idea is to chain one more `with_...()` methods after
the call to the constructor `new()`. Each method takes ownership of the
object, modifies it and returns it.

Example:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

let color = Color::new(0x00, 0xff, 0x50)
  .with_transparency(60)
  .with_blinking(true);
```

:::{exercise} Postal Mail (★★☆☆☆)
:label: postal-mail
:enumerated: true

1. Define a new `struct` named `Mail` that defines a postal mail.
2. Define the following fields:
   - `recipient`: string.
   - `sender`: string.
   - `weight`: float.
   - `priority`: boolean.
3. Implement the following methods:
   - A constructor that takes the `recipient` and the `sender`, only.
   - A builder setter for the `weight` field.
   - A builder setter for the `priority` field.
4. Create an instance of the `Mail` struct and print the values of all
   fields.
:::

[see solution](#postal-mail-solution)

### Setter methods (instance methods)

Once an object has been built, we may modify its data through *setter
methods*. Those methods take a *mutable reference* to the `self`
instance, and thus can modify the values of the fields. We usually name
the *setter methods* using the `set_` prefix.

As an example, let us write a `struct` representing the weight of a
car, with its empty weight and the current volume of petrol:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Car {
  weight: f32, /* Empty weight in kg */
  petrol_vol: f32, /* Volume of petrol inside the tank in L */
}
```

The constructor accepts only the empty weight, the volume of petrol
being set to a default value of 0L:

```{code-cell} rust
:class: seq-cont badges border

impl Car {
  fn new(weight: f32) -> Self {
    Self {
      weight,
      petrol_vol: 0.0,
    }
  }
}
```

We implement a *builder setter* for the volume of petrol:

```{code-cell} rust
:class: seq-cont badges border

impl Car {
  fn with_petrol(mut self, vol: f32) -> Self {
    self.petrol_vol = vol;
    self
  }
}
```

And also a *setter method*:

```{code-cell} rust
:class: seq-cont badges border

impl Car {
  fn set_petrol(&mut self, vol: f32) {
    self.petrol_vol = vol;
  }
}
```

We create an instance of `Car`:

```{code-cell} rust
:class: seq-cont badges border

let mut car = Car::new(800.0).with_petrol(60.0);
(car.weight, car.petrol_vol)
```

And we modify the petrol volume in this instance using the *setter
method*:

```{code-cell} rust
:class: seq-stop badges border

car.set_petrol(40.0);
(car.weight, car.petrol_vol)
```

:::{exercise} Book (★☆☆☆☆)
:label: book-ex
:enumerated: true

1. Define a `struct` type named `Book` with fields `title`, `author`
   and `year`. Use `&'static str` type for strings.
2. Implement the `new()` constructor that takes three arguments to set
   the three fields.
3. Implement the three getter methods `title()`, `author()` and
   `year()`.
4. Create an instance of `Book` using the `new()` constructor and
   display the values of the fields using the getter methods.
:::

[see solution](#book-ex-solution)

:::{exercise} Square area (★★☆☆☆)
:label: square-area
:enumerated: true

1. Define a `Square` structure that stores both the `side` length and
   the `area` of a square.
2. Implement the `new()` constructor that must:
   - Accept both fields `side` and `area`.
   - Compute a field from the other, if this field's value is negative.
3. Implement the two access methods for the two fields.
4. Create an instance of a `Square` named `square` with an area of
   `1.0001` and a negative value for the side length.
5. Print the value of the area field of `square`.
6. Print value of the area computed from the side field of `square`.
7. Compare.
:::

[see solution](#square-area-solution)

## Tuple struct

In *tuple structs*, the fields are *not* named but *indexed*.

As an example, here is a `Color` tuple struct that defines an RGB color
on 8-bit values. The declaration uses parenthesis instead of curly
braces:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Color(u8, u8, u8);
```

For defining an instance we use also parenthesis and specify the values
in the order of definition:

```{code-cell} rust
:class: seq-cont badges border

let yellow = Color(0xff, 0xff, 0);
```

To access values from an instance, we use integer *indices*:

```{code-cell} rust
:class: seq-stop badges border

println!("red={}, green={}, blue={}", yellow.0, yellow.1, yellow.2);
```
