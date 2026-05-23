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

# Running tests

:::{danger} Draft
This section is still being written.
:::

Plain run:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo test
```

Use `--` to separate arguments for the `cargo test` subcommand and the
test application:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo test --help    # Help text of the cargo test subcommand
cargo test -- --help # Help text of the test application
```

By default multiple tests are run in parallel in threads.
To disable parallelism, set the number of threads to one:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo test -- --test-threads=1
```

Print stdout also for passed tests:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo test -- --show-output
```

Run a subset of tests by name:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo test my_text
```

Only function whose name matches `.*my_text.*` will be run.

Ignore some tests by default:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

#[cfg(test)]
mod tests {

    #[test]
    #[ignore]
    fn my_test() {
        // code that takes an hour to run
    }
}
```

To run ignored tests:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

cargo test -- --ignored
```
