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

# Linting the project

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

The `clippy` sub-command catches common mistakes, and gives advice to
correct them. It helps us improve the quality of our code.

In the following example, we define a `Book` structure:

```{code-cell} bash
:tags: [remove-cell]

cargo init --bin foo
cd foo
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
:class: dark-background full-color-output seq-start badges border

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
:class: dark-background full-color-output seq-stop badges border

cargo clippy --tests
```

:::
