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

(chp-gen-traits)=
# Generic traits

Traits can also be generic.

Here is a *generic* `Convert` trait that we will use to convert
between numerical units. It declares a `name()` method that returns a
conversion's description and a `convert()` method that converts a `T`
value into another `T` value:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

trait Converter<T> {
  fn name(&self) -> &str;
  fn convert(&self, value: T) -> T;
}
```

We define two conversion structures that will implement the trait:

```{code-cell} rust
:class: seq-cont badges border

struct CelsiusToFahrenheit;
struct MilesToKilometers;
```

The first structure implements the trait for converting from *degree
Celsius* to *degree Fahrenheit*:

```{code-cell} rust
:class: seq-cont badges border

impl Converter<f64> for CelsiusToFahrenheit {

  fn name(&self) -> &str {
    "Celsius to Fahrenheit"
  }

  fn convert(&self, value: f64) -> f64 {
    value * 9.0 / 5.0 + 32.0
  }
}
```

The second structure converts from *miles* to *kilometers*:

```{code-cell} rust
:class: seq-cont badges border

impl Converter<f64> for MilesToKilometers {

  fn name(&self) -> &str {
    "Miles to Kilometers"
  }

  fn convert(&self, value: f64) -> f64 {
    value * 1.60934
  }
}
```

In order to illustrate the polymorphism aspect of the trait, we define
a function that prints the result of a conversion. It takes a
`Converter` trait and a value to convert. The type `T` needs to be
*copyable* and *displayable*, hence the double trait bound on `Copy`
and `Display`:

```{code-cell} rust
:class: seq-cont badges border

use std::fmt::Display;

fn print_conversion<T: Display + Copy>(conv: &dyn Converter<T>, v: T) {
  println!("{}: {} -> {}", conv.name(), v, conv.convert(v));
}
```

We define one instance for each converter structure:

```{code-cell} rust
:class: seq-cont badges border

let temp_converter = CelsiusToFahrenheit;
let distance_converter = MilesToKilometers;
```

And call once the printing function for each converter, with a sample
value:

```{code-cell} rust
:class: seq-stop badges border

print_conversion(&temp_converter, 100.0);
print_conversion(&distance_converter, 5.0);
```
