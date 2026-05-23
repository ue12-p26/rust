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

# Function exercises

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

## First program

:::{solution} first-program
:label: first-program-solution
:::

We first create the binary project using `cargo`:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

cargo init factorial
```

Then we enter the folder:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

cd factorial
```

```{code-cell} bash
:tags: [remove-cell]

cat >src/main.rs <<EOF
fn fact(n: u64) -> u64 {
  if n > 1 {
    n * fact(n - 1)
  } else {
    1
  }
}

fn main() {
  println!("{}", fact(20));
}
EOF
```

And modify the main code file as follow, with a function `fact()` called by
the `main()` function:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat src/main.rs
```

Finally, we build & execute:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo run
```
