# Integration tests

:::{danger} Draft
This section is still being written.
:::

Integration tests are written inside the `tests` folder.
Example:

```
root
|--src
|--tests
   |--integration_test.rs
```

Example of test file content:

```rust
use mypkg::my_fct;

#[test]
fn test_my_fct() {
  assert_eq!(my_fct(2), 10)
}
```

To run all test functions of a particular test file:

```bash
cargo test --test my_test_file
```
