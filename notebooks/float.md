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

# Floats

The
[Floating-Point Types](https://doc.rust-lang.org/stable/book/ch03-02-data-types.html#floating-point-types)
are available in 32-bit (`f32`) and 64-bit (`f64`) versions.

{numref}`tab-float-op` presents the available floating-point operators.

## Default type

The default type for floats is `f64`:

```{code-cell} rust
let x = 10.0; // Default type: f64
x
```

## Specifying the type

As for integers, the type can be set either to the variable or the value:

```{code-cell} rust
let x: f32 = 3.0;
let y = 3.0f32;
(x, y)
```

## Operations

Example of computing a remainder:

```{code-cell} rust
34.56 % 3.6
```

A division:

```{code-cell} rust
34.56 / 3.6
```

## Type related constants

Many useful constants are directly accessible on the primitive type
[f64](https://doc.rust-lang.org/std/primitive.f64.html) or
[f32](https://doc.rust-lang.org/std/primitive.f32.html).

For 32-bit float numbers:

```{code-cell} rust
println!("Number of significant digits: {}", f32::DIGITS);
println!("Maximum: {:.2e}", f32::MAX);
println!("Minimum: {:.2e}", f32::MIN);
println!("NaN: {}", f32::NAN);
println!("Infinity: {}", f32::INFINITY);
println!("Negative infinity: {}", f32::NEG_INFINITY);
println!("ε: {:.2e}", f32::EPSILON);
```

For 64-bit float numbers:

```{code-cell} rust
println!("Number of significant digits: {}", f64::DIGITS);
println!("Maximum: {:.2e}", f64::MAX);
println!("Minimum: {:.2e}", f64::MIN);
println!("NaN: {}", f64::NAN);
println!("Infinity: {}", f64::INFINITY);
println!("Negative infinity: {}", f64::NEG_INFINITY);
println!("ε: {:.2e}", f64::EPSILON);
```

## Mathematical constants

Multiple useful *mathematical* float constants can be found in
[std::f32::consts](https://doc.rust-lang.org/std/f32/consts/index.html)
and
[std::f64::consts](https://doc.rust-lang.org/std/f64/consts/index.html).

Here are some examples of constants for the 32-bit float type:

```{code-cell} rust
println!("e={}", std::f32::consts::E);
println!("π={}", std::f32::consts::PI);
println!("1/π={}", std::f32::consts::FRAC_1_PI);
println!("φ={}", std::f32::consts::GOLDEN_RATIO);
```
