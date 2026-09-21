---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  name: bash
  display_name: Bash
  language: bash
---

# Project organisation

:::{warning} To review
:::

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

A Rust project is made of:

- A project description (i.e.: `Cargo.toml` file).
- Code files.
- Declarations of *code elements* (i.e.: functions, structures,
  enumerate types, traits, ...) written inside the code files.

It is organized as a hierarchy of the following elements:

1. *Package*: A Cargo project containing one or more crates.
2. *Crate*: What are defined and distributed by packages and
   downloadable from [crates.io](https://crates.io/).
3. *Module*: A group of one or more code files.
4. *Path*: The exact identification of a code element inside a file.

The following chapters present in more details those definitions.

## Package

When we start a new project/package with the `cargo` command-line
tool, we have only the choice between two options:

- `--bin` (the default) to create a *binary* crate project.
- `--lib` to create a *library* crate project.

### Binary package

With the following command, we create a new project named `foo`,
containing a single binary crate:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo new --bin foo
cd foo
```

A Rust *package* is a folder with at its root:

- A `Cargo.toml` file.
- A `src` folder, containing the Rust code.
- Eventually a `Cargo.lock` file, if we have added dependencies.
- Eventually a `tests` folder.

Our `foo` package contains only a `Cargo.toml` file and one source
file `src/main.rs`:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

eza -T .
```

A package is defined by its `Cargo.toml` file. It contains (among
other things):

- The project name.
- The dependencies.
- At most one library crate.
- Zero or more binary crates (i.e.: binary executables).

Here is the content of your `Cargo.toml` file:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat Cargo.toml
```

The content of the `main.rs` is simply a single `main()` function:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

The default generated project compiles and runs:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo run
```

### Library package

With the `--lib` argument, we define a library crate:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo new --lib foo2
cd foo2
```

We get a `lib.rs` inside the `src` folder:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

eza -T .
```

The content of the `Cargo.toml` file still conveys no information on
the crate type:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat Cargo.toml
```

The `lib.rs` file contains a public function example and its test
function:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/lib.rs
```

The default generated project compiles and passes its test:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo test
```

## Crate

By default a package contains only one crate, described inside the
`Cargo.toml` file and whose code is stored inside the `src` folder.
Multiple crates are possible in a project, see
[Multiple crates](#chp-mult-crates).

A crate contains zero or more modules defined hierarchically inside
the `src` folder.

## Module

Modules are namespaces that regroup related code.
They are part of a crate, and can be declared:

- *Internally*: they are defined inside a file containing other code.
- *In a single file*: the whole module is part of a single file.
- *In a folder*: the module is divided among multiple files that all
  belong to the same folder. See [Folder module](#chp-folder-module).

### Internal module

An internal module, is a module defined using the `mod` keyword. Here
is the module `math` in which we define a single function `add()`
(the following examples are pure Rust snippets, not executed under
the bash kernel of this page):

```rust
mod math {
  pub fn add(a: i16, b: i16) -> i16 {
    a + b
  }
}
```

:::{warning} Public/private
Everything inside a module is *private* by default. To make an object
accessible from the outside of a module, we need to make it *public*
explicitly. Hence the `pub` keyword in front of the function
declaration.
:::

To call the `add()` function of the `math` module, we need to specify
its *path*:

```rust
math::add(2, 6)
```

### File module

A module can be defined using a file, in which case the whole file is
dedicated to the module's content and the file name is the module's
name.

Let us create a new binary project to illustrate that:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo new --bin foo4
cd foo4
```

We create the code file `math.rs` that we will use as a module. We
define inside a function `add()`:

```{code-cell} bash
:tags: [remove-cell]

cat >src/math.rs <<EOF
pub fn add(a: i16, b: i16) -> i16 {
  a + b
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/math.rs
```

Now we change the `main.rs` file so that it contains a `main()`
function that calls the `math::add()` function. Note the declaration
of the module `math` using the `mod` keyword. This declaration tells
the compiler to look for a file `math.rs` inside the same folder as
the `main.rs` file and to load it as a module named `math`:

```{code-cell} bash
:tags: [remove-cell]

cat >src/main.rs <<EOF
mod math;

fn main () {
  println!("{}", math::add(2, 6));
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

The program compiles & runs:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo run
```

:::{note} Effect of the mod keyword
The file `math.rs` is not a module in itself. This is the fact that we
load it with the `mod` keyword that makes it a module named `math`.
:::

## Path

The exact location of an item into a `crate` is called a *path*.

If we need to access an item inside an external crate, we use an
absolute path. Cargo will find the location of the needed crate by
looking into its installation folders. In the following example, to
access the `from_millis()` function inside the `std` crate, we use the
full path of the item:

```rust
let t = std::time::Duration::from_millis(700);
t
```

When referring a crate's item from inside a crate we may use
*relative* or *absolute* path.

For instance, in the following `math` module defined inside the
current file, the `double()` function can access the `add()` function
from the `arithmetic` sub-module relatively. We can use a relative
path to access it:

```rust
mod math {

  pub mod arithmetic {
    pub fn add(a: i16, b: i16) -> i16 {
      a + b
    }
  }

  pub fn double(n: i16) -> i16 {
    arithmetic::add(n, n)
  }
}

math::double(5)
```

:::{note} Keywords crate and super
The keywords `crate` and `super` allow to load modules from the
crate's root or from the same folder, when inside a module file. We
will see them in [Sub-modules](#chp-sub-modules).
:::

## Use keyword

The `use` keyword allows to avoid repeating a full absolute
localisation of a module or an item's module. It is especially useful
with modules defined inside a deep hierarchy.

For instance, the `std::time::Duration::from_millis()` function is a
bit long name. `use` can help by letting us access directly the
`Duration` structure:

```rust
use std::time::Duration;

let t = Duration::from_millis(300);
t
```

We may also rename the `Duration` structure:

```rust
use std::time::Duration as Dur;

let t = Dur::from_millis(300);
t
```

It is also possible to access directly the whole public content of a
module using the `*` wildcard, like in the following example:

```rust
use std::collections::*;

let lst = LinkedList::from([1, 2, 3]);
lst
```

However, a better practice is to name explicitly each item we need to
access, possibly using curly braces to group multiple items:

```rust
use std::collections::{LinkedList, VecDeque};

let lst = LinkedList::from([1, 2, 3]);
let deq = VecDeque::from([-1, 0, 1]);
(lst, deq)
```
