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

(chp-howto-env-vars)=
# Environment variables

:::{warning} To review
:class: readiness-toreview

:::

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

As defined by the POSIX (*Portable Operating System Interface*)
standard, operating systems store a set of values called *environment
variables* that processes can access for getting information about the
system, or configuration values for instance. Each process can set new
environment variables or modify current ones, and pass them to *child
processes*.

Each environment variable has a *name*. They are thus stored as
*name*/*value* pairs, and retrieve through their *names*.

Here is an example in Bash for setting an environment variable:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

export MY_VAR=some_value
```

Still in Bash, we retrieve the value of the environment variable as any
other Bash variable:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

echo "$MY_VAR"
```

Each programming language proposes functions to retrieve and set
environment variables.

The following Python program prints the same environment variable:

```{code-cell} bash
:tags: [remove-cell]

cat >print_env_var.py <<EOF
import os
print(os.environ['MY_VAR'])
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat print_env_var.py
```

Here is its effect:

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

python print_env_var.py
```

We can do the same in Rust:

```{code-cell} bash
:tags: [remove-cell]

cat >print_env_var.rs <<EOF
fn main() {
  if let Ok(s) = std::env::var("MY_VAR") {
    println!("{s}");
  }
}
EOF
rustc -o print_env_var print_env_var.rs
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

bat print_env_var.rs
```

The effect is the same:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

./print_env_var
```
