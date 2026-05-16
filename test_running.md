# Running tests

:::{danger} Draft
This section is still being written.
:::

Plain run:

```bash
cargo test
```

Use `--` to separate arguments for the `cargo test` subcommand and the
test application:

```bash
cargo test --help    # Help text of the cargo test subcommand
cargo test -- --help # Help text of the test application
```

By default multiple tests are run in parallel in threads.
To disable parallelism, set the number of threads to one:

```bash
cargo test -- --test-threads=1
```

Print stdout also for passed tests:

```bash
cargo test -- --show-output
```

Run a subset of tests by name:

```bash
cargo test my_text
```

Only function whose name matches `.*my_text.*` will be run.

Ignore some tests by default:

```rust
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

```bash
cargo test -- --ignored
```
