# Documenting items

A special style comment exists, the **Documentation Comments**.
These special comments are used to write documentation that will be
published on `crates.io` site alongside the publication of the package.
They start with `///` or `//!`.

The `///` is used to document the item that comes after the comments:

```rust
/// Divides by 100.
///
/// # Examples
///
/// ```
/// assert_eq!(div100(10), 0);
/// ```
pub fn div100(n: i16) -> i16 {
  n / 100
}
```

The `//!` is used to document the item inside which the comments is
written. It is usually used to document a crate, at the start of a
file:

```rust
//! # My crate foo
//!
//! The `foo` crate has been created to show to use of the //! comments.
```

To learn more about crates documentation, see
[Making Useful Documentation Comments](https://doc.rust-lang.org/stable/book/ch14-02-publishing-to-crates-io.html#making-useful-documentation-comments).
