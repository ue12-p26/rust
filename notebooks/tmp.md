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

(chp-tmp)=
# Temporary files and folders

:::{warning} To review
:class: readiness-toreview

:::

*Temporary files and folder* are used by applications to, for instance:

- Store intermediate computations.
- Free memory, temporarily.
- Run tests.

:::{important} Specific folder
It is important to declare them explicitly as *temporary*, so the
operating system will recognize them as such, and may *delete* them at a
reboot, for instance. Their declaration is usually done by writing them
inside the right folder for the operating system. For instance on
*Linux*, the `/tmp` folder is the standard place to create temporary
files and folders.
:::

:::{important} Development constraints
Temporary items are particularly useful, however they pose some
constraints when developing:

- The temporary file or folder must be *unique*, so no other application
  will use the same file or folder at the same time.
- The temporary file or folder must be *deleted* on the file system once
  the application is done with it or, at worst, when the application
  leaves if it is not a service (i.e.: running in continuously).
:::

The [tempfile](https://docs.rs/tempfile/latest/tempfile/) crate provides
functions (see {numref}`tab-tempfile-fcts`) to deal with *temporary files
and folders*.

:::{list-table} Some functions of the tempfile module
:name: tab-tempfile-fcts
:header-rows: 1
:align: center

* - Function
  - Description
* - `tempfile()`
  - Creates a temporary file and returns a `File` object.
* - `tempdir()`
  - Creates a temporary folder and returns a `TempDir` object.
* - `spooled_tempfile()`
  - Creates and returns a `SpooledTempFile` object.
:::

```{code-cell} rust
:tags: [remove-cell]

:dep tempfile = "3"
```

## Temporary file

The `tempfile()` function creates a file inside the `env::temp_dir()`
folder. It returns a `File` object, so we do not have access to the file
path. The *deletion* of the file is *ensured by the operating system*,
not Rust's dropping system.

Example:

```{code-cell} rust
:class: seq-start badges border

use tempfile::tempfile;

let file = tempfile()?;
file
```

## Temporary folder

The `tempdir()` function creates a folder inside the `env::temp_dir()`
folder. It returns a `TempDir` object that ensures the *deletion* of the
*temporary folder* when it goes *out of scope*.

```{code-cell} rust
:class: seq-cont badges border

use tempfile::tempdir;

let dir = tempdir()?;
dir
```

We may also use directly the constructors of the `TempDir` structure
like `new()`, or `with_prefix()` that allows us to choose the folder's
prefix:

```{code-cell} rust
:class: seq-cont badges border

use tempfile::TempDir;

TempDir::with_prefix("myprefix-")?
```

Or `with_suffix()` that allows to choose the folder's suffix:

```{code-cell} rust
:class: seq-cont badges border

TempDir::with_suffix("-mysuffix")?
```

## Named temporary file

The `NamedTempFile` structure allows to create a *named* temporary file.
This is useful to get a real path to access the file, however it *less
secure* than the `tempfile()` function. It allows also to set the
*prefix* or the *suffix* of the filename.

Example:

```{code-cell} rust
:class: seq-cont badges border

use tempfile::NamedTempFile;

NamedTempFile::new()?
```

With a custom prefix:

```{code-cell} rust
:class: seq-cont badges border

NamedTempFile::with_prefix("myprefix-")?
```

With a custom suffix:

```{code-cell} rust
:class: seq-cont badges border

NamedTempFile::with_suffix("-mysuffix")?
```

## In-memory buffer backed by file system

The `spooled_tempfile()` function returns a `SpooledTempFile` object that
is used as a *Read/Write* in-memory buffer, but offers automatic writing
inside the temporary folder of the file system when the buffer gets *too
large*.

In the following example we create a spooled file with an in-memory
buffer of 16 bytes. The `is_rolled()` method tells us of the buffer has
been written to the file system:

```{code-cell} rust
:class: seq-cont badges border

use tempfile::spooled_tempfile;
use std::io::Write;

let mut file = spooled_tempfile(16);
writeln!(file, "Hello!")?;
file.is_rolled()
```

We write some more text in order to overflow the buffer, and see the
buffer has been written onto the file system:

```{code-cell} rust
:class: seq-cont badges border

writeln!(file, "How are you?")?;
file.is_rolled()
```

## The Builder structure

The [Builder](https://docs.rs/tempfile/latest/tempfile/struct.Builder.html)
structure allows to define a builder object with custom options and use
it as a *pattern* to create multiple temporary files or folders. Some of
`Builder`'s methods can be seen in {numref}`tab-builder-methods`.

```{code-cell} rust
:class: seq-cont badges border

use tempfile::Builder;

let mut builder = Builder::new();
builder.prefix("my-app-").suffix(".tsv").rand_bytes(3);
```

```{code-cell} rust
:class: seq-stop badges border

for i in 0..5 {
  println!("Tempfile #{i}: {:?}", builder.tempfile()?);
}
```

:::{list-table} Some methods of the Builder structure
:name: tab-builder-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `append(b)`
  - Sets append only mode for the temporary file with `append(true)`.
* - `new()`
  - Creates a new `Builder` instance.
* - `permissions(perms)`
  - Sets the permissions for temporary files and folders.
* - `prefix(s)`
  - Sets a custom prefix to use.
* - `rand_bytes(n)`
  - Sets the number of random bytes to use when building the temporary
    name.
* - `suffix(s)`
  - Sets a custom suffix to use.
* - `tempdir()`
  - Creates a temporary folder. Returns a `TempDir` object.
* - `tempfile()`
  - Creates a temporary file. Returns a `NamedTempFile` object.
:::

:::{important} Custom destination folder
Some methods or functions exist in `*_in()` variant: `tempdir_in()`,
`tempfile_in()`. They allow us to define a different *destination
folder* than the operating system temporary folder for our temporary
files or folders. This could be useful or necessary in some cases, like
when provided with big storage systems on a local network. We must
though be careful about access speed to a custom destination folder: it
may slow our application.
:::

:::{important} Keeping temporary files
The method `keep()` provided by `TempDir` and `NamedTempFile` allow to
persist the folder or file after leaving the scope. This is mainly
useful when debugging, and should only be used with a *custom
destination folder* since we do not want to *clutter* the file system
with *undeleted* temporary files.
:::

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
