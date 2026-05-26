---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# Collections summary

We have not yet seen all the composite types provided by Rust, and in
particular we have not yet seen the `Vec` type; however, here's a table
that summarizes the most commonly used composite types in Rust:

:::{list-table} Properties and indexing of Rust's basic composite types.
:name: tab-rust-composites
:header-rows: 1
:align: center

* - Type
  - Fixed size?
  - Homogeneous?
  - Read n-th
  - Write n-th
* - Tuple `(T1, T2, ...)`
  - yes
  - no
  - `t.0`
  - `t.0 = v;`
* - Array `[T; N]`
  - yes
  - yes
  - `a[i]`
  - `a[i] = v;`
* - Vector `Vec<T>`
  - no
  - yes
  - `v[i]`
  - `v[i] = v;`
:::
