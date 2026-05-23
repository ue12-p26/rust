---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: bash
  display_name: Bash
  language: bash
---

# Cargo

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

`cargo` is the Rust package manager, and is as well used to manage a Rust
project as to install applications (crates) from the official repository.

The different actions provided by `cargo` are accessed through a set of
sub-commands. See {numref}`tab-cargo-subcmds` for a list of the main
sub-commands.
To get the full list of sub-commands, run the following command:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo --list
```

(chp-app-inst)=
## Installing an application

:::{warning} To review
:::

Rust public packages are called *crates* and provide binaries as well
as libraries. Very useful Rust applications are available today on
the official crate repository
([https://crates.io/](https://crates.io/)).
We present in {numref}`tab-rust-apps` a list of some of them.
For instance, there are several re-implementations of standard Unix
tools (e.g.: `ls`, `find`, `cat`, `tree`) in Rust, usually with a
nicer output and greater processing speed.
See [Install a crate with Cargo](#chp-howto-cargo-inst-crate) to
learn how to *search* for a crate and how to *install* it.

## Initializing a project

### Creating a new project from scratch

This is easily done with Cargo.
To initialize a new project inside a new directory named `foo`, we run:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo init --bin foo
```

This will create a project file `Cargo.toml` and a source file `src/main.rs`
that contains a default `main()` function:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

exa -T foo
```

The project file defines a *project name*, a *project version* and the
*edition year* of the `cargo` tool to use for managing this project:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat foo/Cargo.toml
```

### Initializing a project inside a Git repository

Let us a create an empty Git repository first:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

git init foo2
```

Then let we run Cargo to initialize a Rust project:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo init --bin foo2
```

Cargo created the same files as before:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

exa -T foo2
```

But also a `.gitignore` file that contains a single line in order to ignore
the `target` folder which is used by Cargo for compiling:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat foo2/.gitignore
```

:::{note} `new` sub-command
The `new` sub-command is also used for initializing a project, but only when
creating a new directories. If the directory already exists, the command will
fail.
:::

:::{note} Application or Library
The `--bin` argument we have been using with `cargo`, generates a project
for an application.
To generate a library project, we would use the `--lib` argument.
:::

## Building the project

To compile a whole project, we use the `build` sub-command:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

pushd foo2
cargo build
```

To build in *release* (i.e.: no debug information) mode:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo build -r
```

## Running the application

To run the application, we use the `run` sub-command:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo run
```

If there are multiple binaries in the project, we use the `--bin` option to
set the binary to run:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo run --bin foo2
```

To pass, argument to our binary, we would set them after a double dash `--`:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo run --bin foo2 -- arg1 arg2 arg3 ...
```

## Adding dependencies

To use external dependencies (e.g.: packages from
[crates.io](https://crates.io/)), like in the following example with the
`colour` package, we need first to declare it with `cargo`:

```{code-cell} bash
:tags: [remove-cell]

cat >src/main.rs <<EOF
use colour::*;

fn main() {
  magenta_ln!("My coloured message.");
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

To declare the dependency, we use the `add` sub-command:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo add colour
```

The `dependencies` section now contains a line for the `colour` package with
a version requirement:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat Cargo.toml
```

Running the application, will trigger the installation of the dependencies,
as well as compilation, before running:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo run
```

:::{warning} Installing features for dependencies
Some packages offer optional features. By default they are not installed, and
we cannot use them in our code. To enable them, we need to specify them
explicitly when adding the dependency. This is done with the `-F` flag.
For instance, to install the `clap` package with the `derive` feature, we
would run:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo add -F derive clap
```

:::

:::{warning} Adding development dependencies
Some dependencies may be needed when running tests or building the
documentation.
These dependencies must not be added to the main `dependencies` section, but
to a specific `dev-dependencies` section.
To do that, we must run the `add` sub-command with the `--dev` flag.
The following command install the `glob` package for development purposes:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo add --dev glob
```

:::

## Running tests

We suppose we have implemented some test inside the `tests` folder:

```{code-cell} bash
:tags: [remove-cell]

mkdir tests
cat >tests/my_test.rs <<EOF
#[test]
fn test_01() {
  println!("My first test.");
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

exa -T tests
```

Running this test, is as simple as running the `test` sub-command.
Compiling of both the application and the tests will be triggered prior to
running the tests:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo test
```

:::{note} The two types of tests
Rust distinguises explicitly between two types of tests: the *Unit Tests*
and the *Integration Tests*. As we can see in the example above, the first
ones are located inside the sources, and run first. The second ones are
located inside the `tests` folder and run after.
:::

## Checking the project

The `check` sub-command checks for errors inside the local packages and its
dependencies. To do that, it runs a compiling up to, but excluding, the code
generation. This means that most of compiling errors will be detected, but not
all. However, it performs faster that the `build` sub-command, and thus is
interesting for quick error checking:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo check
```

## Linting the project

The `clippy` sub-command catches common mistakes, and gives advice to
correct them. It helps us improve the quality of our code.

In the following example, we define a `Book` structure:

```{code-cell} bash
:tags: [remove-cell]

cat >src/main.rs <<EOF
struct Book {
  title: String,
  author: String,
}

impl Book {
  fn new(title: String, author: String) -> Self {
    Self {
      title: title,
      author: author,
    }
  }
}

fn main() {
  let book = Book::new(
    "Le Petit Prince".to_string(),
    "Antoine de Saint-Exupéry".to_string());
  println!("{}, {} ", book.title, book.author);
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

The program compiles perfectly:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo build
```

However, `clippy` finds some issues in it:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo clippy
```

In this other example, plain `clippy` misses the possible style improvement:

```{code-cell} bash
:tags: [remove-cell]

cat >src/main.rs <<EOF
fn main() {
  let array = ["abc", "def", "ghi"];
  for s in array.iter() {
    println!("{s}");
  }
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

Nothing is pointed out by `clippy`:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo clippy
```

To get the hint, we need to use the *pedantic* mode:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo clippy -- -W clippy::pedantic
```

:::{note} Linting test code
By default, `clippy` does not check test code.
The `--tests` flag enables the checking of test code:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo clippy --tests
```

:::

## Fixing automatically linting issues

The `fix` sub-command is able to solve automatically some of the warnings
pointed out by the Rust compiler.

In the following example we have introduced a useless `mut` (mutable)
specifier:

```{code-cell} bash
:tags: [remove-cell]

cat >src/main.rs <<EOF
fn main() {
  let mut s = "ABC".to_string();
  println!("{s}");
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

The `check` sub-command catches the mistake:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo check
```

Running the `fix` sub-command will solve the issue for us:

```{code-cell} bash
:tags: [remove-cell]

git init .
git add Cargo.* src tests .gitignore
git commit -m Init
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo fix
```

The `mut` keyword has been removed:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

bat src/main.rs
```

:::{warning}
The `fix` sub-command will refuse to correct a code that is not managed by
Git or if some modifications have not been committed. This is because it may
damage permanently our code.
Before running `fix`, we must thus make sure our code is saved inside a
Git database.
:::

```{code-cell} bash
:tags: [remove-cell]

popd
```
