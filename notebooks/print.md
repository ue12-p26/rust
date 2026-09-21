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

(chp-print)=
# Print macros

The *print* macros are used to print on console, either on *standard
output* (a.k.a.: stdout) or *standard error* (a.k.a.: stderr). The ones
terminating with the suffix `ln` add a *line feed* character at the end
of the printed string. See {numref}`tab-print-macros` for a sum-up of
those macros.

:::{list-table} Print macros
:name: tab-print-macros
:header-rows: 1
:align: center

* - Macro
  - Stream
  - Line feed
* - `print!()`
  - `stdout`
  - No
* - `println!()`
  - `stdout`
  - Yes
* - `eprint!()`
  - `stderr`
  - No
* - `eprintln!()`
  - `stderr`
  - Yes
:::

All macros take a literal string as first argument, then zero or more
values that are used to replace format string markers `{}`.

:::{note} format!() macro
They work the same way as the `format!()` macro (see
[the `format!()` macro section](#chp-format) for details).
:::

Printing a simple string:

```{code-cell} rust
println!("Hello, world!");
```

Printing a variable:

```{code-cell} rust
let my_var = 123;
println!("my_var: {my_var}");
```

Insert leading characters:

```{code-cell} rust
let my_var = 123;
println!("my_var: {my_var:05}");
```

Setting precision on a float:

```{code-cell} rust
println!("x: {:.5}", 0.123456789);
```

Using a variable for precision:

```{code-cell} rust
let prec = 3;
println!("x: {:.*}", prec, 0.123456789);
```

Using unnamed markers:

```{code-cell} rust
println!("my values: {} {}", 12.34, 789);
```

Using a named marker:

```{code-cell} rust
println!("my_value: {value}", value=12.34);
```

Printing a *complex object* (here a *tuple*) using the *pretty-print*
(`:?`) formatting option of the *Debug* formatter:

```{code-cell} rust
let t = (1.5, "abc", true);
println!("{t:#?}");
```
