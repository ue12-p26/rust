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

# Path & PathBuf

:::{warning} To review
:class: readiness-toreview

:::

[Path](https://doc.rust-lang.org/std/path/struct.Path.html) and
[PathBuf](https://doc.rust-lang.org/std/path/struct.PathBuf.html) use
`OsStr` and `OsString` respectively to handle operating system paths to
file systems. `Path` is thus a *slice* on a file system path, and
`PathBuf` a path stored on the heap.

See {numref}`tab-path` and {numref}`tab-path-buf` for lists of the most
useful methods for these both types.

:::{list-table} Some methods of Path
:name: tab-path
:header-rows: 1
:align: center

* - Method
  - Description
* - `ancestors()`
  - Returns an iterator over all parent paths starting from this
    path.
* - `as_os_str()`
  - Returns the underlying `OsStr` slice.
* - `canonicalize()`
  - Returns the canonical & absolute form of the path with symbolic
    links resolved.
* - `components()`
  - Returns an iterator over all individual components of the path.
* - `display()`
  - Returns an object that can be used to *safely* print the path.
* - `ends_with(p)`
  - Tests if `p` is a suffix of this path.
* - `exists()`
  - Returns `true` if this path exists on the file system.
* - `extension()`
  - Returns the extension without the dot.
* - `file_name()`
  - Returns the final component, including any extension.
* - `file_prefix()`
  - Returns the start of the file name up to the eventual dot
    character. If the file name starts with a dot, it does not
    account as a termination.
* - `file_stem()`
  - Returns the final component, without the eventual extension.
* - `has_root()`
  - Returns `true` if this path has a root. Equivalent to
    `is_absolute()` on Unix.
* - `is_absolute()`
  - Returns `true` if this path is absolute.
* - `is_dir()`
  - Returns `true` if this path is a directory.
* - `is_empty()`
  - Returns `true` if this path is empty.
* - `is_file()`
  - Returns `true` if this path is a regular file.
* - `is_relative()`
  - Returns `true` if this path is relative.
* - `is_symlink()`
  - Returns `true` if this path is a symbolic link.
* - `iter()`
  - Returns an iterator over the components of this path, viewed as
    `OsStr` slices.
* - `join(p)`
  - Returns a `PathBuf` built from joining this path with `p`.
* - `metadata()`
  - Returns the [Metadata](https://doc.rust-lang.org/std/fs/struct.Metadata.html)
    (size, file type, ...) of this path.
* - `parent()`
  - Returns the `Path` without its final component.
* - `read_dir()`
  - Returns an iterator over the entries of a directory.
* - `read_link()`
  - Returns the `Path` pointed to by a symbol link.
* - `starts_with(p)`
  - Tests if `p` is a prefix of this path.
* - `strips_prefix(p)`
  - Returns the path without the prefix `p`.
* - `to_path_buf()`
  - Converts this path to a `PathBuf`.
* - `to_str()`
  - Converts this path into a string slice.
* - `to_string_lossy()`
  - Converts this path into a string with non-UTF-8 sequences
    replaced with `U+FFFD REPLACEMENT CHARACTER` (�).
* - `with_extension()`
  - Create a `PathBuf` from this path by replacing the extension.
* - `with_file_name()`
  - Create a `PathBuf` from this path by replacing the file name.
:::

The `Path` struct resides inside the `std::path` module. We declare it
using the `use` keyword:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::path::Path;
```

The `new()` method can be used to create a new `Path` object from a
string slice:

```{code-cell} rust
:class: seq-cont badges border

let file = Path::new("data/measures.tsv");
```

We can extract the file name from the path as following:

```{code-cell} rust
:class: seq-cont badges border

file.file_name()
```

The extension:

```{code-cell} rust
:class: seq-cont badges border

file.extension()
```

The name without the extension:

```{code-cell} rust
:class: seq-cont badges border

file.file_stem()
```

We can change the extension:

```{code-cell} rust
:class: seq-cont badges border

file.with_extension("txt")
```

:::{warning} Empty path
The `is_empty()` method only tests if a `Path` object is empty, not if
a file is empty:

```{code-cell} rust
:class: seq-cont badges border

(Path::new("").is_empty(), Path::new("foo.txt").is_empty())
```

:::

:::{list-table} Some methods of PathBuf
:name: tab-path-buf
:header-rows: 1
:align: center

* - Method
  - Description
* - `add_extension()`
  - Appends an extension to this path.
* - `as_path()`
  - Returns the underlying `Path` slice.
* - `clear()`
  - Empty this path.
* - `new()`
  - Creates a new empty path.
* - `pop()`
  - Truncates this path to its parent.
* - `push(p)`
  - Appends p to this path.
* - `set_extension(e)`
  - Replaces the current extension with `e`.
* - `set_file_name(f)`
  - Replaces the current file name with `f`.
:::

The `PathBuf` struct resides inside the `std::path` module. We declare
it using the `use` keyword:

```{code-cell} rust
:class: seq-cont badges border

use std::path::PathBuf;
```

The `new()` method can be used to create a new empty `PathBuf` object:

```{code-cell} rust
:class: seq-cont badges border

let mut file2 = PathBuf::new();
```

We can then add some path to it:

```{code-cell} rust
:class: seq-cont badges border

file2.push("README.md");
file2
```

We may also transform a `Path` instance into a new `PathBuf` instance:

```{code-cell} rust
:class: seq-stop badges border

file.to_path_buf()
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
