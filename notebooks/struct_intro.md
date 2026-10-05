# Introduction

A structure (or
[record](https://en.wikipedia.org/wiki/Record_(computer_science))) is a
composite data structure made of several *fields* in sequence. In Rust,
the fields of a structure are *typed*. They may have identical or
different types.

:::{note} Fields order
The order of declaration of the fields is only relevant for destruction.
When an instance of the `struct` is destroyed (`dropped` in Rust
language), its fields are destroyed in the order of declaration.
:::

There exist two types of structures in Rust:

- The *regular struct* that uses *named* fields.
- The *tuple struct* that uses a `tuple` notation and uses *unnamed*
  fields.
