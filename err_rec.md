---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# Recoverable errors

:::{danger} Draft
This section is still being written.
:::

The definition of `Result<T, E>` is:

```rust
enum Result<T, E> {
  Ok(T),
  Err(E),
}
```

Example of usage:

```{code-cell} rust
:tags: [raises-exception]
use std::fs::File;

fn main() {
    let result = File::open("hello.txt");
    let f = match result {
        Ok(file) => file,
        Err(error) => panic!("Problem opening the file: {error:?}"),
    };
}
```

Check the error type:

```{code-cell} rust
:tags: [raises-exception]
let f = match result {
  Ok(file) => file,
  Err(error) => match error.kind() {
    ErrorKind::NotFound => match File::create("hello.txt") {
      Ok(fc) => fc,
      Err(e) => panic!("Problem creating the file: {e:?}"),
    },
    _ => {
      panic!("Problem opening the file: {error:?}");
    }
  },
};
```

## Using unwrap and expect

Using `unwrap()` to get the wanted value:

```{code-cell} rust
:tags: [raises-exception]
let f = File::open("hello.txt").unwrap();
```

- `unwrap()` will return the file handle on success, or call `panic!`
  on error.

Using `expect()` to customize the error message:

```{code-cell} rust
:tags: [raises-exception]
let f = File::open("hello.txt")
  .expect("hello.txt should be included in this project");
```

- `expect()` will return the file handle on success, or exit and print
  our error message.

## Using closures

```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
  let greeting_file = File::open("hello.txt").unwrap_or_else(|error| {
    if error.kind() == ErrorKind::NotFound {
      File::create("hello.txt").unwrap_or_else(|error| {
        panic!("Problem creating the file: {error:?}");
      })
    } else {
      panic!("Problem opening the file: {error:?}");
    }
  });
}
```

## Propagating errors

Detailed version:

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let username_file_result = File::open("hello.txt");

    let mut username_file = match username_file_result {
        Ok(file) => file,
        Err(e) => return Err(e),
    };

    let mut username = String::new();

    match username_file.read_to_string(&mut username) {
        Ok(_) => Ok(username),
        Err(e) => Err(e),
    }
}
```

Using the `?` operator:

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username_file = File::open("hello.txt")?;
    let mut username = String::new();
    username_file.read_to_string(&mut username)?;
    Ok(username)
}
```

One-liner:

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username = String::new();
    File::open("hello.txt")?.read_to_string(&mut username)?;
    Ok(username)
}
```

Note that this function is already in the standard library:

```rust
std::fs::read_to_string("hello.txt"); // Returns a Result<String, io::Error>
```
