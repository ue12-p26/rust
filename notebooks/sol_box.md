# Box exercises

## Type size

:::{solution} box-struct-size
:label: box-struct-size-solution
:::

The size of the `Book` type can be computed by adding the type size
of each field. We suppose we are on a 64-bit system:

- `String`: A `String` stores a string on the *heap*, and is itself
  made of a *pointer*, a *capacity* and a *size* (one word, so 64
  bits, each). Its size is thus 24 bytes.
- `Vec<String>`: A `Vec` object stores its data inside an array on the
  *heap*, and is itself made of a *pointer*, a *capacity* and a
  *size* (64 bits each). Its size is thus 24 bytes.
- `u64`: 8 bytes.
- `i16`: 2 bytes.
- `usize`: 64 bits, thus 8 bytes.
- `f32`: 4 bytes.

In total the fields of the `Book` type add up to
$24 * 4 + 8 + 2 + 8 + 4 = 118$ bytes (three `String` fields plus the
`Vec<String>` one). Since the type must be aligned on 8 bytes, the
compiler adds some padding and an instance of the `Book` type occupies
120 bytes, as reported by `std::mem::size_of::<Book>()`.
