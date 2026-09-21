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

# Enum & match exercises

## Automaton State

:::{solution} automaton-state
:label: automaton-state-solution
:::

We define the automaton states using an enumerated type:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug, PartialEq)]
enum State {
  Start,
  Stage1,
  Stage2,
  Stage3,
  Stop,
}
```

We use if/else statements to define the next state:

```{code-cell} rust
:class: seq-cont badges border

fn next_state(s: State) -> State {
  if s == State::Start {
    State::Stage1
  } else if s == State::Stage1 {
    State::Stage2
  } else if s == State::Stage2 {
    State::Stage3
  } else if s == State::Stage3 {
    State::Stop
  } else {
    State::Start
  }
}
```

We use a loop on call 10 times `next_state()`:

```{code-cell} rust
:class: seq-stop badges border

let mut s = State::Stop;
for i in 0..10 {
  s = next_state(s);
  println!("Step {i}: state = {s:?}");
}
```

## Shapes area

:::{solution} shapes-area
:label: shapes-area-solution
:::

We define an `enum` type with four variants accepting the needed
parameters for computing the area:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

enum Shape {
  Disk(f32),            // Radius
  Square(f32),          // Side length
  Rectangle(f32, f32),  // Side lengths
  Triangle(f32, f32),   // Base length and Height
}
```

The `area()` function accepts a `Shape` object as argument and uses a
`match` expression to compute the area for each shape:

```{code-cell} rust
:class: seq-cont badges border

fn area(s: Shape) -> f32 {
  match s {
    Shape::Disk(radius) => radius * radius * std::f32::consts::PI,
    Shape::Square(a) => a * a,
    Shape::Rectangle(a, b) => a * b,
    Shape::Triangle(b, h) => b * h / 2.0,
  }
}
```

Here are the results on each shape:

```{code-cell} rust
:class: seq-stop badges border

println!("Disk: {}", area(Shape::Disk(3.0)));
println!("Square: {}", area(Shape::Square(2.0)));
println!("Rectangle: {}", area(Shape::Rectangle(2.0, 3.0)));
println!("Triangle: {}", area(Shape::Triangle(2.0, 3.0)));
```

## Nuts price

:::{solution} variable-price
:label: variable-price-solution
:::

The function `new_price()` uses *ranges* inside the `match` statement to
handle the different cases:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

fn new_price(m: f32, x: f32) -> f32 {
  match m {
       ..1.0 => 1.2 * x,
    1.0..2.0 => x,
    2.0..4.0 => 0.8 * x,
        _    => 0.5 * x,
  }
}
```

We call the `new_price()` function on different values:

```{code-cell} rust
:class: seq-stop badges border

let mass_prices = [(0.3, 3.4), (1.2, 2.7), (2.0, 2.9), (4.0, 3.2)];
for (m, x) in mass_prices {
  print!("{}, ", new_price(m, x));
}
```

## Animal feet

:::{solution} animal-feet
:label: animal-feet-solution
:::

The `Animal` enumerated type is defined as following:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
enum Animal {
  Cat,
  Dog,
  Snake,
  Crow,
}
```

We use a `match` statement on `self` to process each animal:

```{code-cell} rust
:class: seq-cont badges border

impl Animal {
  fn get_nb_feet(&self) -> u8 {
    match self {
      Animal::Cat | Animal::Dog => 4,
      Animal::Snake => 0,
      Animal::Crow => 2,
    }
  }
}
```

We loop on all animals and call the `get_nb_feet()` method to get the
number of feet:

```{code-cell} rust
:class: seq-stop badges border

for animal in [Animal::Cat, Animal::Dog, Animal::Snake, Animal::Crow] {
  println!("The {animal:?} has {} feet.", animal.get_nb_feet());
}
```
