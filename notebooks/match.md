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

(chp-match)=
# Match

The [match](https://doc.rust-lang.org/book/ch06-02-match.html) statement
allows to evaluate an *expression* and run *actions* depending on the
obtained value. The value may tested using:

- A single value.
- A list of choices separated by `|` characters.
- A range.
- A variable name that caches all values or the `_` to catch those values
  but ignore them.

Example:

```{code-cell} rust
for i in [-50, 3, 46, 7, 10] {
  match i {
    0..5        => println!("Between 0 and 5 excluded."),
    7 | 13 | 20 => println!("Some number in 7, 13, 20."),
    10          => println!("Exactly 10!"),
    _           => println!("Other value."),
  };
}
```

The actions may themselves be *expressions*, in which case they must all
return the *same type*.
Example:

```{code-cell} rust
for i in [-50, 3, 46, 7, 10] {
  let j = match i {
    0..5        => 1,
    7 | 13 | 20 => 2,
    10          => 3,
    _           => 10,
  };
  println!("{:?}", (i, j));
}
```

## Missing cases

`match` must be exhaustive and cover all cases, otherwise the compiler
will raise an error:

```{code-cell} rust
:tags: [raises-exception]

let n = 1111;
match n {
  -100..100 => println!("My single case.")
};
```

## Using variables

For each match case, we may set the matched value into a variable that
we can use:

- Inside an additional `if` condition.
- In the action part, on the right of `=>`.

For instance, if we define the following function:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

fn double(n: i32) -> i32 {
  2 * n
}
```

We may test its returned values with `match`, and set them into a
variable `n`:

```{code-cell} rust
:class: seq-stop badges border

for i in [-50, 3, 46, 5, 7, 10] {
  match double(i) {
    n if n <= -10      => println!("{n} is <= -10."),
    n @ 0..7           => println!("Between 0 and 7 excluded: {n}."),
    n @ (7 | 13 | 20)  => println!("{n} is in 7, 13, 20."),
    10                 => println!("Exactly 10!"),
    n                  => println!("Other value: {n}."),
  };
}
```

## Handling floats

Float values can be used inside a `match` statement. One way to match
them is to use *float ranges*:

```{code-cell} rust
match 1.4 {
  0.0..0.9  => println!("First case"),
  0.9..1.8  => println!("Second case"),
     x      => println!("Unhandled value {x}"),
}
```

Another way is to use variables with `if` statements:

```{code-cell} rust
match 3.7 {
  x if x <= 0.0  => println!("First case: {x}"),
  x if x <= 0.9  => println!("Second case: {x}"),
  x if x <= 3.3 => println!("Third case: {x}"),
  x if x <= 7.6 => println!("Fourth case: {x}"),
     x      => println!("Unhandled value {x}"),
}
```

:::{exercise} Variable price (★★☆☆☆)
:label: variable-price
:enumerated: true

Write a function `new_price()` that takes two floating-point numbers (the
quantity of bought nuts in kg and the current price per kg) and returns
one floating-point number (the new price per kg).
Depending of the *quantity bought* $m$, the function returns a *new
price* per kg $y$ computed from the *initial price* $x$ as following:

$$
y = \begin{cases}
  1.2x  & \text{for } m < 1 \\
     x  & \text{for } 1 \le m < 2 \\
   .8x  & \text{for } 2 \le m < 4 \\
   .5x  & \text{for } m \ge 4 \\
\end{cases}
$$

Use a `match` expression to handle the different cases and compute the
new price.
Apply the function on the following values, stored as tuples inside an
array:
:::

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start seq-stop badges border

let mass_prices = [(0.3, 3.4), (1.2, 2.7), (2.0, 2.9), (4.0, 3.2)];
mass_prices
```

[see solution](#variable-price-solution)

## With variants

The `match` statement is often used on `enum` values or variants. Match
cases can extract data stored inside the variants.

Here is an `enum` type `Color` that defines two variants. One for grey
levels, and another for RGB colors:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

enum Color {
  Grey(u8),
  Rgb(u8, u8, u8),
}
```

The following `match` statement extracts variants' data in both cases:

```{code-cell} rust
:class: seq-stop badges border

for c in [Color::Grey(99), Color::Rgb(10, 30, 60)] {
  match c {
    Color::Grey(n)    => println!("Grey level {n}."),
    Color::Rgb(r,g,b) => println!("RGB color ({r}, {g}, {b})."),
  }
}
```

:::{exercise} Shapes area (★★☆☆☆)
:label: shapes-area
:enumerated: true

1. Implement an `enum` named `Shape` that can represent a disk, a
   square, a rectangle and a triangle as *variants*.
2. Each variant must take the necessary parameters to compute the area
   of the shape (radius, side lengths, height).
3. Write a function `area()` that takes a `Shape`, then compute and
   return the area. The `PI` constant can be found in
   [std::f32::consts](https://doc.rust-lang.org/std/f32/consts/index.html)
   and
   [std::f64::consts](https://doc.rust-lang.org/std/f64/consts/index.html).
4. Test the computing of the area on the 4 different shapes and print
   each result.
:::

[see solution](#shapes-area-solution)
