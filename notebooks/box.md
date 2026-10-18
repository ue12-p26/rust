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

# Box

:::{warning} To review
:class: readiness-toreview

:::

The [Box](https://doc.rust-lang.org/std/boxed/struct.Box.html)
pointer is a *unique pointer*. It owns an object of type `T` that
resides on the *heap*.
A `Box`:

- Stores its internal object on the *heap*.
- Automatically *drops* (i.e.: deletes) the contained object when it
  is itself dropped.
- Is itself stored on the *stack*.
- Implements [Deref](https://doc.rust-lang.org/std/ops/trait.Deref.html)
  and [DerefMut](https://doc.rust-lang.org/std/ops/trait.DerefMut.html).
  This means the methods of the contained object can be used directly
  on the `Box` object, as if it were the contained object itself.
- Is a very light object. It is passed quickly from one function to
  another, takes very little space. Thus it can be used to improve
  both speed and memory performance, when an object is heavy: instead
  of storing the object on the stack, we store it on the heap.

## Putting an object in a Box

Let us create a structure with many fields:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
#[allow(unused)]
struct Book {
  title: String,
  authors: Vec<String>,
  isbn: u64,
  year: i16,
  editor: String,
  npages: usize,
  price: f32,
  pitch: String,
}
```

:::{exercise} Type size
:label: box-struct-size
:enumerated: true

Compute the size of this `struct` type.
See [Word](#chp-word) to learn about what is a *word*.
:::

[see solution](#box-struct-size-solution)

We add some methods to it:

```{code-cell} rust
:class: seq-cont badges border

impl Book {

  fn new(title: String, year: i16, npages: usize, price: f32) -> Self {
    Self {
      title,
      authors: Vec::new(),
      isbn: 0,
      year,
      editor: String::new(),
      npages,
      price,
      pitch: String::new(),
    }
  }

  fn with_editor(mut self, editor: String) -> Self {
    self.editor = editor;
    self
  }

  fn with_author(mut self, author: String) -> Self {
    self.authors.push(author);
    self
  }

  fn with_isbn(mut self, isbn: u64) -> Self {
    self.isbn = isbn;
    self
  }

  fn with_pitch(mut self, pitch: String) -> Self {
    self.pitch = pitch;
    self
  }

  fn title(&self) -> &str {
    &self.title
  }

  fn price_per_page(&self) -> f32 {
    self.price / self.npages as f32
  }
}
```

We create an instance of `Book`:

```{code-cell} rust
:class: seq-cont badges border

let book = Book::new("Le Petit Prince".into(), 1999, 104, 7.50)
  .with_editor("Gallimard".into())
  .with_author("Antoine de Saint-Exupéry".into())
  .with_isbn(2070408507)
  .with_pitch("J'ai ainsi vécu seul, sans personne avec qui parler véritablement, \
  jusqu'à une panne dans le désert du Sahara, il y a six ans. Quelque chose \
  ...".into())
  ;
book
```

Now we move the `Book` instance into a `Box` struct:

```{code-cell} rust
:class: seq-cont badges border

let book = Box::new(book);
```

The new `book` object, though being a `Box`, behaves like a plain
`Book` object:

```{code-cell} rust
:class: seq-cont badges border

book
```

We can call `Book` methods on it:

```{code-cell} rust
:class: seq-cont badges border

book.price_per_page()
```

## Size of a Box

The size of a `Box` depends on the stored type:

- For a *sized* type like an integer, a float or a structure, the
  `Box`'s size is one word (8 bytes on a 64-bit architecture) for the
  pointer to the object.
- For an *unsized* type like a slice or trait, the `Box` is a fat
  pointer and its size is two words (16 bytes on a 64-bit
  architecture): one word for the pointer to the object, and one word
  for the size of the object.

See [Word](#chp-word) to know what is a *word*.

## Passing a Box

Compared to the 120 bytes of our `Book` structure, the 8 bytes of the
`Box` object is *15 times lighter*. This seems like a huge improvement
if we need to move often our object to functions.

For instance we could write the following function:

```{code-cell} rust
:class: seq-cont badges border

fn print_price_per_page(book: Box<Book>) {
  println!("Price per page of {}: {}", book.title(), book.price_per_page());
}
```

When calling it, we would pass it our light `Box` object that would be
moved:

```{code-cell} rust
:class: seq-stop badges border

print_price_per_page(book);
```

## Is Box really useful?

However the following function, that also involves a move would not be
less performant:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn print_price_per_page(book: Book) {
  println!("Price per page of {}: {}", book.title(), book.price_per_page());
}
```

This is because, in practice, there is *no actual move* of the
object. The passed object, `Book` in one case, `Box` in the other, is
not *moved* but resides in its place on the stack inside the caller's
frame. The callee only gets a pointer to the object inside the
caller's frame.

:::{warning} Saving stack space
With the `Box` solution, the only real improvement is that we save
some place on the stack. Instead of storing 120 bytes, we store only
8 bytes. On a 1 MiB stack, this is not critical. On the other hand,
if we had an array of 40 million 32-bit integers (i.e.: 160MB), moving
the array onto the *heap* with a `Box` would be necessary in order to
avoid a potential *stack overflow*. However we would better use
instead a `Vec`. Indeed, all collections store their internal objects
on the heap. Thus any solution involving a collection, is usually
better than storing objects on the stack.
:::

:::{warning} Box in polymorphism
So what is the `Box` structure useful for? Mainly for *trait
polymorphism*, when we need to mix various objects that share a
common trait. We will see that in
[Use Box to store traits in a collection](#chp-boxed-trait).
:::

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::

(chp-box-recursive)=
## Recursive type

The `Box` is also useful for defining recursive type. As an example
we are going to create a chain `List` type as an `enum`. The type
will be generic, and thus will be able to store any type of values.

Let us define it by making a recursive reference to the type itself.
The following definition states that the `Val` variant contains a
*value* and the *next element*, and that the `Nil` value marks the
end of the list:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

enum List<T> {
  Val(T, List<T>),
  Nil,
}
```

However an enum can only be defined if we can compute its size. The
size of an enum is the size of its biggest variant. The *size* of
the `Val` variant being *impossible to compute*, this enum
definition is *invalid*, the compiler will reject it.

We must thus give a *fixed size* to the `Val` variant. The `Box`
structure is exactly what we need. It will move the next element
onto the heap, and it has a fixed size whatever the value it points
to. Here is the new definition:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

enum List<T> {
  Val(T, Box<List<T>>),
  Nil,
}
```

Let us import the enum's variants to ease their use:

```{code-cell} rust
:class: seq-cont badges border

use List::{Val, Nil};
```

We implement a `print()` that we will use to print the content of a
list:

```{code-cell} rust
:class: seq-cont badges border

impl<T> List<T>
  where T: std::fmt::Debug {

  fn print(&self) {
    match self {
      Val(x, next) => {
        print!("({x:?}, ");
        next.print();
        print!(")");
      },
      Nil => print!("Nil"),
    }
  }
}
```

We can now create a list of, for instance, 32-bit integers, and
prints it:

```{code-cell} rust
:class: seq-stop badges border

let list = Val(4, Box::new(Val(10, Box::new(Val(-13, Box::new(Nil))))));
list.print();
println!();
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
