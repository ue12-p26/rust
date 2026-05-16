# Result

:::{danger} Draft
This section is still being written.

TODO: explain `Result`.
:::

The standard library `Result<T, E>`:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```
