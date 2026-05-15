# Slices

:::{warning} Draft
This section is still being written.

TODO: What are slices.
:::

A slice is a kind of reference.

String slices:

```rust
let s = String::from("Hello");
let slice = &s[0..2]; // from start to index 2 excluded
let slice = &s[..2]; // from start to index 2 excluded
let slice = &s[2..]; // from index 2 to end
let slice = &s[2..len]; // from index 2 to end
let slice = &s[0..len]; // whole string
let slice = &s[..]; // whole string
```

Function returning a string slice:

```rust
fn foo(s: &String) -> &str {
  // ...
}
```

String literals are slices, their type is `&str`.
A more generic function would take a `&str` instead of a `&String`:

```rust
fn foo(s: &str) -> &str {
  // ...
}
```

Array slice:

```rust
let a = [1, 2, 3, 4];
let slice = &a[1..3];
```
