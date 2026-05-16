# Examples

Many examples are found throughout this book. Some are Bash commands,
all others are Rust code snippets.
A tiny tag on the top right of the example allows to recognize if the
example is to run in Bash or compiled with Rust. In the following
example we can see the tag *bash* on the right:

```bash
echo "Hello!"
```

This example, as most examples in this book, is followed by an output
that is shown on black background just after the code snippet.
This means the code has been tested automatically when generating this
book, and the black output is the result of this execution.

## Bash examples

To run a bash example by yourself, open a bash session using your
favourite terminal emulator (macOS Terminal, iTerm, Kitty, Git Bash,
MobaXterm, ...).
Most bash examples run on multiple snippets, so let your terminal open
and type the commands in one after the other to see the same outputs
and effects than in the course.

:::{warning} Pay attention to folder changes
Pay particular attention to commands that:

- Create directories.
- Change to a directory (i.e.: `cd some/folder` or `pushd some/folder`).
- Leave a directory (i.e.: `cd ..` or `popd`).

If you miss one of them, you will end running following commands
inside the wrong path and obtain the wrong results.
:::

:::{note} zsh & other shells
Other shells should work too with the examples of this book. So, for
instance, for macOS users, there is no need to run `bash`, they may
stay with `zsh`.
:::

## Rust examples

Most of the Rust examples of the book are written in a *simplified*
way in order to be more readable and help to concentrate on the main
topic.
However this makes these examples not compilable with just a copy &
paste.
We are going to see how to recognize what is missing, and how to
complete these examples.

### Missing main function

The first important thing is that they do no contain the `main()`
function that is compulsory for compiling and running.
Example:

```rust
println!("Hello!");
```

Such an example cannot be compiled *as-is*.
It needs to be wrapped inside a `main()` function, as following:

```rust
fn main() {
  println!("Hello!");
}
```

### Printed expression on last line

The second particularity is that many examples print one or more
values at the end of the code snippet, with an expression that does
not end with a semi-colon:

```rust
let a = 10;
let b = 8;
a + b
```

In the last line is a perfect Rust expression that we could use for
instance as a value to return from a function. However in this
context, if we wrap it inside a `main()` function this will lead to an
error, as the `main()` must return nothing, except an integer or an
error.
To run such an example we must wrap the last line's expression into a
`println!()` macro as following:

```rust
fn main() {
  let a = 10;
  let b = 8;
  println!("{:?}", a + b);
}
```

### Multiple code snippets

Some Rust examples are split into several code snippet. To run them,
just paste them together, but pay attention to last line of each
snippet as it could be an expression without semi-colon.
Here is the first part of an example:

```rust
let a = 10;
a
```

The second part:

```rust
let b = 8;
b
```

And the last part:

```rust
a + b
```

To run it, just paste all lines together, wrapping last lines
containing an expression into a `println!()` macro, and putting all
this code into a `main()` function, as following:

```rust
fn main() {
  let a = 10;
  println!("{:?}", a);
  let b = 8;
  println!("{:?}", b);
  println!("{:?}", a + b);
}
```
