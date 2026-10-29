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

# Fixing automatically linting issues

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

The `fix` sub-command is able to solve automatically some of the warnings
pointed out by the Rust compiler.

In the following example we have introduced a useless `mut` (mutable)
specifier:

```{code-cell} bash
:tags: [remove-cell]

cargo init --bin foo
cd foo
cat >src/main.rs <<EOF
fn main() {
  let mut s = "ABC".to_string();
  println!("{s}");
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

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

git add Cargo.* src .gitignore
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
