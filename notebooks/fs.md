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

# File system functions

The [std::fs](https://doc.rust-lang.org/std/fs/index.html) module
provides multiple functions to interact with the file system. See
{numref}`tab-file-system`.

:::{list-table} Some functions of the std::fs module
:name: tab-file-system
:header-rows: 1
:align: center

* - Function
  - Description
* - `copy(p, q)`
  - Copies the content of file `p` into `q`.
* - `create_dir(p)`
  - Creates a new folder.
* - `create_dir_all(p)`
  - Creates a new folder and all its parents if necessary.
* - `hard_link(p, q)`
  - Creates a new hard link `q` for `p`.
* - `read(p)`
  - Reads the whole content of a file into a byte vector `Vec<u8>`.
* - `read_to_string(p)`
  - Reads the whole content of a file into a `String`.
* - `remove_dir(p)`
  - Deletes an *empty* folder.
* - `remove_dir_all(p)`
  - Deletes a folder and all its content.
* - `remove_file(p)`
  - Deletes a file.
* - `rename(p, q)`
  - Renames a file or folder, overwriting any existing file at `q`.
* - `set_permissions(p, perm)`
  - Changes permissions of a file or directory.
* - `set_times(p, times)`
  - Changes the timestamps of a file or directory.
* - `write(p, s)`
  - Writes the content of `s` into the file at `p`. The file is
    created if it does not exist, and overwritten otherwise. `s` can
    be a regular *string slice* or a *byte slice*.
:::

:::{danger} TODO
:class: readiness-todo

Create a directory, ... Check a file is readable/writable/executable.
Create a folder.
:::

```{code-cell} rust
:tags: [remove-cell]

:clear

let tmp_dir = std::env::temp_dir().join(format!("myst-rust-{}", std::process::id()));
std::fs::create_dir_all(&tmp_dir)?;
std::env::set_current_dir(&tmp_dir)?;
```

## Writing a whole file

The `write()` function writes an entire string or byte string into a
file:

```{code-cell} rust
:class: seq-start badges border

let content = "abcdef";
let file = std::path::Path::new("foo.txt");
std::fs::write(file, content)?;
```

## Reading a whole file

The `read_to_string()` function reads a whole text file into a
`String`:

```{code-cell} rust
:class: seq-cont badges border

let content = std::fs::read_to_string(file)?;
content
```

## Getting the size of a file

To obtain the size of a file, we need first to access the file's
metadata and then call the `len()` method onto the
[Metadata](https://doc.rust-lang.org/std/fs/struct.Metadata.html)
object:

```{code-cell} rust
:class: seq-cont badges border

file.metadata()?.len()
```

Checking if a file is empty is thus as easy as:

```{code-cell} rust
:class: seq-cont badges border

file.metadata()?.len() == 0
```

## Checking path existence

The `exists()` method of the `Path` struct tests the existence of a
path:

```{code-cell} rust
:class: seq-cont badges border

file.exists()
```

## Testing file or folder

To test if a path is a file or a folder we use the `is_file()` and
`is_dir()` methods:

```{code-cell} rust
:class: seq-cont badges border

(file.is_file(), file.is_dir())
```

## Creating a folder

The `create_dir()` function creates a new folder, at the condition
that the parent path exists:

```{code-cell} rust
:class: seq-cont badges border

std::fs::create_dir("my_folder")
```

The `create_dir_all()` function creates a new folder, with all missing
parent folders:

```{code-cell} rust
:class: seq-stop badges border

std::fs::create_dir_all("my/other/folder")
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
