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

# Function-like macros

The *function-like* macros are a type of *procedural* macros that look like
function calls.
They can, however, accept an unknown number of arguments.
Like the *declarative* macros they end with an exclamation mark (`!`).
A list of the main *function-like* macros is provided in
{numref}`tab-macro-fct-like`.

:::{list-table} Most used function-like macros
:name: tab-macro-fct-like
:header-rows: 1
:align: center

* - Macro
  - Description
  - Example
* - `format!()`
  - Create a formatted `String`.
  - `let tag = format!("{}_{}.{}", prefix, x.name(), get_version());`
* - `print!()`
  - Print formatted text on standard output stream.
  - `print!("Hello {name}! You have {} messages.", msg.count());`
* - `println!()`
  - Same as `print!()`, but appends a new line character.
  -
* - `eprint!()`
  - Same as `print!()`, but prints on the standard error stream.
  - `eprint!("My important message");`
* - `eprintln!()`
  - Same as `eprint!()`, but appends a new line character.
  -
* - `panic!()`
  - Issue an unrecoverable error.
  - `panic!("Data impossible to process.");`
* - `todo!()`
  - Mark unfinished code section. Panic if reached.
  - `todo!("I really need to code this.");`
* - `unimplemented!()`
  - Mark non-implemented code section. Panic if reached.
  - `todo!("There is no plan to implement this functionality, ever.");`
* - `unreachable!()`
  - Mark unreachable code. Panic if reached.
  - `unreachable!("We should never get here.");`
:::

Example with the `println!` macro:

```{code-cell} rust
println!("Good morning.");
```

The same macro can accept additional arguments:

```{code-cell} rust
let name = "John";
println!("Good morning, {}.", name);
```
