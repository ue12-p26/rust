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

# Setter methods (instance methods)

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
