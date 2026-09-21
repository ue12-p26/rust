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

(chp-slices)=
# Slices

A *slice* is a *reference* to a part of an array-like structure (e.g.:
[array](#chp-arrays), [`Vec`](#chp-vec), [`String`](#chp-string)).

:::{important} The type of a slice
The type of a *slice* is `&[T]`. `[T]` is itself the type of an array of
type `T`. It has an unknown size, hence it is not usable as such. Real
arrays are of type `[T,N]` where `N` is the size, known at *compile time*.
The `&[T]` type, on the other hand, is a reference on an array of type `T`
whose size is known at *runtime*. For people used to C-type languages,
`&str` is a *fat pointer* that stores a pointer to the start of the
array-like object and a length. See {numref}`tab-array-slice-types` for a
sum-up of those three types.
:::

:::{list-table} Array and slice types
:name: tab-array-slice-types
:header-rows: 1
:align: center

* - Type
  - Description
* - `[T,N]`
  - An array of `T` elements, of fixed size `N` known at *compile-time*.
    Stored on the stack.
* - `[T]`
  - An array of `T` elements, of unknown size. This type is never used
    as-is.
* - `&[T]`
  - A slice: a reference on part of an array of `T` elements, of size
    known at *runtime*. The referenced array may be stored anywhere.
:::

*Slices* are constructed using the *reference* operator `&`, the array
descriptor `[]` and a range (`..` operator). The range (see
[Ranges](#chp-ranges)) describes the part of the array-like object to
reference. Here are some examples of slices of the same object `a`:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

&a[0..2]; // From start to index 2 excluded.
&a[..=2]; // From start to index 2 included.
&a[2..];  // From index 2 to end.
&a[2..2]; // Empty slice.
&a[..];   // All elements.
```

## Array slices

Array slices have type `&[T]`, and can be constructed from any array using
the *ampersand* operator and a range. Here are some examples of array
slices:

```{code-cell} rust
let a = [-10i16, 4, 8, -4, 12];
println!("Slice [1..3]: {:?}", &a[1..3]);
println!("Slice [3..3]: {:?}", &a[3..3]);
println!("Slice [2..]:  {:?}", &a[2..]);
println!("Slice [..2]:  {:?}", &a[..2]);
println!("Slice [..]:   {:?}", &a[..]);
```

Array slices can be taken from `Vec` objects too:

```{code-cell} rust
let v = vec![-33i8, 5, -14, 10, 55];
println!("Slice [1..3]: {:?}", &v[1..3]);
```

Slices from an array or a `Vec` object have exactly the same type `&[T]`.
This means we can write functions that accept an array slice, and we will
be able to run it on either a vector or an array. In Rust, functions that
need to access a vector or an array accept instead a slice in order to be
versatile. Example:

```{code-cell} rust
fn foo(x: &[i16]) {
  println!("Slice received by foo: {:?}", x);
}

let a = [-10i16, 4, 8, -4, 12];
let v = vec![-33i16, 5, -14, 10, 55];
foo(&a[1..3]);
foo(&v[..4]);
```

:::{important} Slice methods
Many very useful general methods are available for slices. See
{numref}`tab-slice-methods` for a list of them.
:::

(chp-str-slices)=
## String slices

The [str](https://doc.rust-lang.org/std/primitive.str.html) type
represents an *unsized* UTF-8 string (see [UTF-8](#chp-utf8)). The
characters are stored as a sequence of *bytes*. The `str` type is thus a
`[u8]` unsize type with a UTF-8 validation layer.

Like any `[T]` unsize type, `str` is not usable as such, but only as a
slice. As for other slices, `&str` is a *fat pointer* that stores a
pointer to the start of the string and the length of the string. The
length is only known at *runtime*.

### Defining a string slice

We may define a string slice using a literal string:

```{code-cell} rust
let s = "abcdef";
s
```

A literal string is itself a string slice, with a *static lifetime*. It
is stored inside the compiled program and hence, when loaded, resides
inside the read-only memory of the process (i.e.: where the code and
constant data reside).

Here is the same definition as above with the type made explicit:

```{code-cell} rust
let s: &'static str = "abcdef";
s
```

### Passing strings to functions

The following function accepts only a reference to a `String` object:

```{code-cell} rust
fn foo(s: &String) {
  println!("s: {s}");
}

let my_string = String::from("ABC");
foo(&my_string);
```

While the following function accepts a string slice, which allows us to
use either a `String` object or a slice on a string literal. The function
will not see the difference:

```{code-cell} rust
fn foo(s: &str) {
  println!("s: {s}");
}

let s1 = "ABC";
let s2 = String::from("DEF");
foo(&s1);
foo(&s2);
```

:::{note} Automatic conversion
In our example `&s2` is of type `&String`. Rust automatically converts it
into `&str` because `String` implements the
[Deref](https://doc.rust-lang.org/std/ops/trait.Deref.html) trait for
`str`.
:::

### `str` methods

:::{important} `str` methods
In addition to methods provided by the generic slice, the string slice
`str` defines specific ones and also improves some of the generic ones.
See {numref}`tab-str-methods` for a list of them.
:::

:::{exercise} Splitting a string
:label: str-split
:enumerated: true

Look into the `str` methods in order to split the following strings into
sub-strings:

1. Split the string `"a b c d e f"` using the space character as
   delimiter.
2. Split the string `"ab..cde..f..ghi..jk..l"` using the `".."`
   delimiter.
:::

[see solution](#str-split-solution)

:::{exercise} Iterating over a string
:label: str-iter
:enumerated: true

Iterate over the string `"Салам"` (*Salam*/*Hello* in Kyrgyz) with a `for`
loop and by finding the right `str` methods to call.

1. Iterate on the characters of the string, and print each character.
2. Iterate on the bytes of the string, and print each byte.
3. What do you observe?
:::

[see solution](#str-iter-solution)

:::{exercise} Searching into a string
:label: str-search
:enumerated: true

Find all lowercase character in the string `"AbCDeFGHijkL"` and print
them.
:::

[see solution](#str-search-solution)
