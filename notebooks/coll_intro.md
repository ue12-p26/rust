# Collections

:::{warning} To review
:::

Collections are standard and general purpose data structures provided
by the *standard library* (i.e.: `std`). We already have seen the
`Vec` structure. All other collections of the standard library are
part of the `std::collections` module. They may be classified
according to their underlying structure:

- Array-like structure: `Vec`, `VecDeque`.
- List-like structure: `LinkedList`.
- Tree-like structure: `BTreeSet`, `BTreeMap`, `BinaryHeap`.
- Hash table structure: `HashSet`, `HashMap`.

In [Module collections](https://doc.rust-lang.org/std/collections/index.html)
is a guide to help choosing the right collection.
