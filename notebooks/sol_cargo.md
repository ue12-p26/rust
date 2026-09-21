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

# Cargo exercises

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

## First project

:::{solution} first-cargo-project
:label: first-cargo-project-solution
:::

### New project

We first initialize a new project with the `init` sub-command. It will
create the folder, a Rust code file with a main function inside and a
`Cargo.toml` file:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo init hello
```

We enter the `hello` folder and build the project:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cd hello
cargo build
```

We run the project, a `Hello, world!` is printed:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo run
```

### Using a crate dependency

We add the `text2art` crate as a dependency:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo add text2art
```

See the added lines for the dependency into the project file:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat Cargo.toml
```

We write now the new code into the `src/main.rs` file:

```{code-cell} bash
:tags: [remove-cell]

cat >src/main.rs <<EOF
use text2art::BasicFonts;
use text2art::Font;
use text2art::Printer;

fn main() {
  let font = Font::from_basic(BasicFonts::Big).unwrap();
  let prntr = Printer::with_font(font);
  prntr.print_to_stdio("Hello, world!").ok();
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

We rebuild the application:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cargo build
```

And run it to print the same message in ASCII Art:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo run
```
