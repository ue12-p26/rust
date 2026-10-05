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

# Regular struct

In Rust, a structure is defined using the `struct` keyword, as in the
following example that defines a `Book` data type:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Book {
  title:  &'static str,
  author: &'static str,
  year:   i16,
}
```

We initialize an instance of a `struct` by setting a *value* for each
field:

```{code-cell} rust
:class: seq-cont badges border

let book1 = Book {
  title: "La Nuit du carrefour",
  author: "Georges Simenon",
  year: 1931,
};
```

To retrieve a field's value, we simply name the field we want to access
on the instance:

```{code-cell} rust
:class: seq-cont badges border

(book1.title, book1.author, book1.year)
```

:::{tip} Field Init Shorthand
The *Field Init Shorthand* uses the name of variables to initialize a
struct instance.
:::

If we define the three following variables:

```{code-cell} rust
:class: seq-cont badges border

let title = "Mon ami Maigret";
let author = "Georges Simenon";
let year: i16 = 1949;
```

We can use them to create a `Book` instance. The names of the variables,
because they match the names of the fields, will be used by the compiler
to know how to initialize the `Book` instance:

```{code-cell} rust
:class: seq-cont badges border

let book3 = Book {
  title,
  author,
  year,
};
```

Here is the instance's content:

```{code-cell} rust
:class: seq-cont badges border

(book3.title, book3.author, book3.year)
```

:::{tip} Struct Update Syntax
The *Struct Update Syntax* allows to create a new object from an
existing object. In the following code, we use the fields from `book1`
to complete the missing fields in `book2`:
:::

```{code-cell} rust
:class: seq-cont badges border

let book2 = Book {
  title: "Le Chien jaune",
  ..book1
};
```

Here is the result:

```{code-cell} rust
:class: seq-stop badges border

(book2.title, book2.author, book2.year)
```

For constructing an object, we do not usually use directly the curly
braces syntax, but define a *constructor method*, named `new()` by
convention. We will see the `new()` method in the next chapter.
