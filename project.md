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

# Project organisation

:::{danger} Draft
This section is still being written.
:::

```{code-cell} bash
:tags: [remove-cell]
source bash-setup.sh
```

As we have seen earlier, a `cargo` project is defined inside a
`Cargo.toml` file.
Inside will be defined, among other things:

- The project name.
- The dependencies.

The `Cargo.toml` file is placed at the root of the project, and under it
we find the `src` folder where reside Rust code. This is the organisation
of this `src` folder that interests us in this chapter.

To understand to what each file belongs and how to access each
declaration (function, struct, enum), the following definitions are
needed:

1. Package: A Cargo project containing one or more crates.
2. Crate: What are defined and distributed by packages and downloadable
   from [crates.io](https://crates.io/).
3. Module: An group of one or more files of code.
4. Path: The exact identification of a code element.

The following chapters present in more details those definitions.

## Package

A package is what is defined by a `Cargo.toml` file.
It can contain:

- At most one library crate.
- Zero or more binary crates (i.e.: binary executables).

When we start a new project with `cargo`, we have only the choice between
`--bin` (the default) to create a binary crate project or `--lib` to
create a library crate project.

With the following command, we create a project named `foo` with a binary
crate:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border
cargo new --bin foo
```

The project file `Cargo.toml` does not contain any information on the
fact that the project is a binary executable project:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
exa -T foo
```

However we see that a `main.rs` code file has been created:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat foo/Cargo.toml
```

The content of the `main.rs` is simply a single `main()` function:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat foo/src/main.rs
```

On the other hand, if we define a library crate with the `--lib`
argument:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
cargo new --lib foo2
```

We get a `lib.rs` inside the `src` folder:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
exa -T foo2
```

The content of the `Cargo.toml` file still convey no information on the
crate type:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat foo2/Cargo.toml
```

The `lib.rs` the code file contains a public function example and its
test function:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat foo2/src/lib.rs
```

## Crate

In a package, crates are defined by the main library or binary code
files.
In our `foo` and `foo2` examples, these are the files `src/lib.rs` and
`src/main.rs`.

A crate contains zero or more modules defined hierarchically. Modules
can be defined *internally*, in a *single file* or in a *folder*.

## Module

Modules are namespaces that regroup related code.
They are part of a crate, and can be declared:

- *Internally*: they are defined inside a file containing other code.
- *In a single file*: the whole module is part of a single file.
- *In a folder*: the module is divided among multiple files that all
  belong to the same folder.

### Internal module

```{code-cell} bash
:tags: [remove-cell]
cat >foo/src/main.rs <<EOF
mod math {
  fn add(a: i16, b: i16) -> i16 {
    a + b
  }
}

fn main () {
  println!("{}", math::add(2, 6));
}
EOF
```

Let us enter the `foo` project to do some experiment with modules:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
pushd foo
```

Here is the binary crate rewritten with an internal module:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat src/main.rs
```

If we build this project, we get an error about `math::add()` being
private:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
:tags: [raises-exception]
cargo build
```

Indeed, inside a module, every object is private by default. To make it
accessible from outside (i.e.: make it **public**), we need to use the
`pub` keyword.

```{code-cell} bash
:tags: [remove-cell]
cat >src/main.rs <<EOF
mod math {
  pub fn add(a: i16, b: i16) -> i16 {
    a + b
  }
}

fn main () {
  println!("{}", math::add(2, 6));
}
EOF
```

Here the corrected code with the `pub` keyword:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat src/main.rs
```

And now the program compiles:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
cargo build
```

We can run it:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
cargo run
```

### File module

A module can be defined using a file, in which case the whole file is
dedicated to the module's content and the file name is the module's
name.

Here we create the file `math.rs` that defines a module:

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

Now we change the `main.rs` file so that it contains only the `main()`
function calls the `math::add()` function:

```{code-cell} bash
:tags: [remove-cell]
cat >src/main.rs <<EOF
fn main () {
  println!("{}", math::add(2, 6));
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat src/main.rs
```

If we compiled, this we get an error:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
:tags: [raises-exception]
cargo build
```

The compiler knows nothing by default about external modules (*module
files* and *module folders*).

:::{warning} `mod` keyword
External modules need to be declared with the `mod` keyword, before
using them.
:::

Let us declare the `math` module with the `mod` keyword:

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

Now the program compiles and we can run it:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
cargo run
```

### Shortcuts (`use` keyword)

The `use` keyword allows to avoid repeating a full absolute localisation
of a module or an item's module.

For instance with our `math` module we can make the function `add()`
directly accessible with the `use` keyword:

```{code-cell} bash
:tags: [remove-cell]
cat >src/main.rs <<EOF
mod math;

use math::add;

fn main () {
  println!("{}", add(2, 6));
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border
bat src/main.rs
```

The program still compile and run:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border
cargo run
```

```{code-cell} bash
:tags: [remove-cell]
popd
```

The `use` keyword is especially useful with modules defined inside a
deep hierarchy. For instance the `std::time::Duration::from_millis()`
function is a bit long name. `use` can help by letting us access
directly the `Duration` class (the following examples are pure Rust
snippets, not executed under the bash kernel of this page):

```rust
use std::time::Duration;

let t = Duration::from_millis(300);
t
```

We may also rename the `Duration` structure:

```rust
use std::time::Duration as dur;

let t = dur::from_millis(300);
t
```

It is possible to access directly the whole public content of a module
like in the following example:

```rust
use std::collections::*;

let lst = LinkedList::from([1, 2, 3]);
lst
```

However this is better practice to name explicitly what we need from a
module:

```rust
use std::collections::LinkedList;

let lst = LinkedList::from([1, 2, 3]);
lst
```

And if we need more than one item, we use the curly braces to declare
them:

```rust
use std::collections::{LinkedList, VecDeque};

let lst = LinkedList::from([1, 2, 3]);
let deq = VecDeque::from([-1, 0, 1]);
(lst, deq)
```

## Path

The exact location of an item into a `crate` is called a *path*.
When referring a crate's item from inside a crate we may use *relative*
or *absolute* path.

In the following example, we use an absolute path to access the
`from_millis()` function:

```rust
let t = std::time::Duration::from_millis(700);
t
```

On the other hand, when accessing a module defined inside the current
crate, we use a relative path:

```rust
mod math {
  pub mod arithmetic {
    pub fn add(a: i16, b: i16) -> i16 {
      a + b
    }
  }
}

math::arithmetic::add(5, 10)
```
