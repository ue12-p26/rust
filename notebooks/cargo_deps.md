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

# Adding dependencies

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

To use external dependencies (e.g.: packages from
[crates.io](https://crates.io/)), like in the following example with the
`colour` package, we need first to declare it with `cargo`:

```{code-cell} bash
:tags: [remove-cell]

cargo init --bin foo
cd foo
cat >src/main.rs <<EOF
use colour::*;

fn main() {
  magenta_ln!("My coloured message.");
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

bat src/main.rs
```

To declare the dependency, we use the `add` sub-command:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo add colour
```

:::{note} Sub-dependencies
We can see in the output that other crates (`winapi`, ...) have been
added too. These are dependencies of the `colour` crate dependency.
They need to be added in order to compile the application. In this
particular case all sub-dependencies are libraries for the Windows
operating system. When compiling on \*nix machines, they will not be
used.
:::

The `dependencies` section now contains a line for the `colour` package with
a version requirement:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat Cargo.toml
```

Cargo also creates a lock file that contains the version used for each
dependency. Here is an excerpt from the `Cargo.lock` file:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat -r 5:27 Cargo.lock
```

:::{warning} Lock file versioning
The `Cargo.lock` needs to be tracked by the versioning system (i.e.:
Git). It will be used by all developers when building the project, and
also by users installing the crate with `cargo install --locked ...`
command.
:::

Running the application, will trigger the installation of the dependencies,
as well as compilation, before running:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

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

:::{exercise} First project (★☆☆☆☆)
:label: first-cargo-project
:enumerated: true

1. Using `cargo`, generate a new project named `hello`.
2. Build and run the project.
3. Add the crate dependency `text2art` to the project.
4. See in the log messages how `cargo` adds the dependency and its
   dependencies and prints the selected versions.
5. Check what has changed inside the file `Cargo.toml`.
6. Overwrite the file `src/main.rs` with the following code:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

use text2art::BasicFonts;
use text2art::Font;
use text2art::Printer;

fn main() {
  let font = Font::from_basic(BasicFonts::Big).unwrap();
  let prntr = Printer::with_font(font);
  prntr.print_to_stdio("Hello, world!").ok();
}
```

7. Build again the project and see how it downloads and compiles the
   dependencies.
8. Run the project.
:::

[see solution](#first-cargo-project-solution)
