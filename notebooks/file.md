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

# File

:::{danger} TODO
:class: readiness-todo

Explain `std::fs::File`.
:::

For instance, the `File::open()` method returns a `Result`, either with
a `File` instance or an I/O error:

```{code-cell} rust
:tags: [raises-exception]

use std::fs::File;
use std::io::Read;

let myfile = "some/undefined/path/hello.txt";
let result = File::open(myfile);
let mut f = match result {
    Ok(file) => file,
    Err(error) => panic!("Problem opening the file {myfile}: {error:?}"),
};
let mut contents = String::new();
f.read_to_string(&mut contents)?;
contents
```

Check the error type:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

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

Detailed version:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

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

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

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

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username = String::new();
    File::open("hello.txt")?.read_to_string(&mut username)?;
    Ok(username)
}
```

Note that this function is already in the standard library:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

std::fs::read_to_string("hello.txt"); // Returns a Result<String, io::Error>
```

Returning an error from the `main()` function:

```{code-cell} rust
use std::error::Error;
use std::fs::File;

fn main() -> Result<(), Box<dyn Error>> {
  let greeting_file = File::open("hello.txt")?;
  Ok(())
}

main()
```
