---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# Generic function

:::{danger} Draft
This section is still being written.
:::

In the following example we write a generic comparison function.
Type `T` must be restricted to `std::cmp::PartialOrd` trait, in order
to have the `>` on `T` type.

```{code-cell} rust
fn largest<T: std::cmp::PartialOrd>(list: &[T]) -> &T {
  let mut largest = &list[0];

  for item in list {
    if item > largest {
      largest = item;
    }
  }

  largest
}

fn main() {
  let number_list = vec![34, 50, 25, 100, 65];

  let result = largest(&number_list);
  println!("The largest number is {result}");

  let char_list = vec!['y', 'm', 'a', 'q'];

  let result = largest(&char_list);
  println!("The largest char is {result}");
}

main();
```
