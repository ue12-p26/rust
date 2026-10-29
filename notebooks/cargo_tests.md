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

# Running tests

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

We suppose we have implemented some test inside the `tests` folder:

```{code-cell} bash
:tags: [remove-cell]

cargo init --bin foo
cd foo
mkdir tests
cat >tests/my_test.rs <<EOF
#[test]
fn test_01() {
  println!("My first test.");
}
EOF
```

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

eza -T tests
```

Running this test, is as simple as running the `test` sub-command.
Compiling of both the application and the tests will be triggered prior to
running the tests:

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

cargo test
```

:::{note} The two types of tests
Rust distinguises explicitly between two types of tests: the *Unit Tests*
and the *Integration Tests*. As we can see in the example above, the first
ones are located inside the sources, and run first. The second ones are
located inside the `tests` folder and run after.
:::
