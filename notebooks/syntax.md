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

# Code structure

## Semicolon separator

Rust code is organized in *statements* separated by *semicolons*.
In practice, each statement is written on one line and terminated with a
*semicolon*, like in the following example in which two statements are
written:

```{code-cell} rust
let a = 10;
println!("{a}");
```

Since the *semicolon* is a separator, we may also write those two
statements on a single line:

```{code-cell} rust
let a = 10; println!("{a}");
```

A statement may be divided into multiple lines, for instance to avoid
excessive length:

```{code-cell} rust
assert_eq!(format!("a {} b {} c {} d {} e {} f {}", 1, 2, 3, 4, 5, 6),
  format!("{} 1 {} 2 {} 3 {} 4 {} 5 {} 6", 'a', 'b', 'c', 'd', 'e', 'f'));
```

## Curly brackets

Statements can be grouped using *curly brackets*:

```{code-cell} rust
{
  let a = 10;
  println!("{a}");
}
{
  let b = 15;
  println!("{b}");
}
```

*Curly brackets* are also used to delimit the bodies of functions:

```{code-cell} rust
fn foo() {
  println!("Hello!");
}

foo();
```

Or the blocks of control flows:

```{code-cell} rust
for i in 0..10 {
  print!("{i} ");
}
println!("")
```

## Naming conventions

In Rust, naming conventions (see [Naming conventions](#chp-naming)) are
as shown in {numref}`tab-rust-naming`.

:::{list-table} Rust naming conventions
:name: tab-rust-naming
:header-rows: 1
:align: center

* - Object
  - Naming style
  - Examples
* - `struct`, `enum`
  - `PascalCase`
  - `struct YamlReader`, `enum CardSuit`
* - Local variable, function
  - `snake_case`
  - `size`, `nb_elements`, `parse_file()`.
* - Constant
  - `CONSTANT_CASE`
  - `MAX_THREADS`, `TIMEOUT`.
:::
