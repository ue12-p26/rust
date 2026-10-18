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

# Thread module

:::{warning} To review
:class: readiness-toreview

:::

The [std::thread](https://doc.rust-lang.org/std/thread/index.html)
module provides several functions to deal with thread programming.
See [std::thread functions](https://doc.rust-lang.org/std/thread/index.html#functions)
inside the language reference, and {numref}`tab-thread-fcts`.

:::{list-table} Main functions of the thread module
:name: tab-thread-fcts
:header-rows: 1
:align: center

* - Method
  - Description
* - `available_parallelism()`
  - Returns an estimate of the *current* amount of new threads the
    system may support. It is not the raw number of threads the
    hardware system support, but an estimate based on the current
    load of the machine. It may thus vary between two calls of this
    function.
* - `current()`
  - Returns the handle (i.e.: a `Thread` object) of the current
    thread.
* - `park()`
  - Blocks the thread until its token is made available.
* - `park_timeout(d)`
  - Blocks the thread until its token is made available or the
    duration `d` is reached.
* - `scope(f)`
  - Creates a scope for spawning scoped threads.
* - `sleep(d)`
  - Makes current thread to sleep for duration `d`.
* - `spawn(f)`
  - Spawns a new thread. Returns a `JoinHandle` object that provides
    a `join()` method that we can use to wait for the thread to
    finish.
:::

```{code-cell} rust
:tags: [remove-cell]

:clear

let tmp_dir = std::env::temp_dir().join(format!("myst-rust-{}", std::process::id()));
std::fs::create_dir_all(&tmp_dir)?;
std::env::set_current_dir(&tmp_dir)?;
```

## Spawning a thread

The code of the `main()` function in a programm is what is run
inside the *main thread* of the process. We can *spawn* additional
threads using the `thread::spawn()` function:

```{code-cell} rust
std::thread::spawn(|| { println!("Hello!"); });
```

:::{warning} Termination of threads
The text of our spawned thread is *not printed*, because the main
thread *terminates* first. On termination, the main thread closes
all spawned threads immediately, without waiting for their normal
termination.
:::

## Waiting for termination

To make sure a spawned thread executes all its code, we need to
*wait* explicitly for its termination. For this, the `spawn()`
function returns a handle of type `JoinHandle` on which we can call
the `join()` that waits for the job to finish.

We spawn again the same thread, but this time storing the *handle*
returned by `spawn()`:

```{code-cell} rust
:class: seq-start badges border

let handle = std::thread::spawn(|| { println!("Hello!"); });
```

We call `join()` on the thread handle:

```{code-cell} rust
:class: seq-stop badges border

handle.join().unwrap();
```

:::{warning} Error type returned by join()
The error type returned from the `join()` may be of any type. Thus
we cannot use the `?` operator on it. Instead we use the `unwrap()`
or `expect()` methods, which lead to a `panic!()` if any error is
returned. In any case, if an error occures, it will be an error
almost impossible to recover. A thread should never terminate badly,
unless something very bad happens.
:::

## Thread's returned value

The [Closure](https://doc.rust-lang.org/book/ch13-01-closures.html)
of a thread may return a value:

```{code-cell} rust
:class: seq-start badges border

let handle = std::thread::spawn(|| { 10 });
```

This value will be returned by the `join()` method:

```{code-cell} rust
:class: seq-stop badges border

let result = handle.join().unwrap();
result
```

:::{note} The Send trait
The [Send](https://doc.rust-lang.org/std/marker/trait.Send.html)
trait is implemented for types that can be passed from one thread to
another. The compiler automatically implements the `Send` trait for
a type, when needed.
:::

## Returning an error

We may return a `Result` from a thread, and even use the
[Question Mark Operator](https://doc.rust-lang.org/stable/book/ch09-02-recoverable-errors-with-result.html#the--operator-shortcut)
inside a thread. However the type of the returned error must
declared *threadsafe*. The error type must implement the following
traits:

- [Send](https://doc.rust-lang.org/std/marker/trait.Send.html):
  because we pass an error object from one thread to another.
- [Sync](https://doc.rust-lang.org/std/marker/trait.Sync.html):
  because the `?` operator requires it, being implemented only for
  `Error` or `Error + Send + Sync`.

We use the [type](https://doc.rust-lang.org/std/keyword.type.html)
keyword to define a thread compatible error type. We also need to
have a file `foo.txt` already present, so we create it first:

```{code-cell} rust
:tags: [remove-cell]

std::fs::write("foo.txt", "placeholder content")?;
```

```{code-cell} rust
:class: seq-start badges border

use std::error::Error;

type ThreadErr = Box<dyn Error + Send + Sync>;
```

We use the error type inside the return type of the thread. This
allows us to use the `?` operator in the code:

```{code-cell} rust
:class: seq-cont badges border

let handle = std::thread::spawn(|| -> Result<std::fs::File, ThreadErr> {
  let file = std::fs::File::options().read(true).open("foo.txt")?;
  Ok(file)
});
```

We wait for the thread to finish and return the `File` object:

```{code-cell} rust
:class: seq-stop badges border

let file = handle.join().unwrap().expect("Thread failure");
file
```

## Execution ordering

Threads have no defined execution order. The operating system does
*not guarantee* any execution ordering.

We are going to spawn *multiple threads* and see in which order they
are executed. Let us create first a vector in which we will store
the thread handles:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let mut handles: Vec<std::thread::JoinHandle<()>> = Vec::new();
```

We then spawn 20 threads, passing an index to each of them. Thanks
to the printed index, we may see that the order of execution is not
the order of creation. Two runs of this code could not show the same
order of execution:

```{code-cell} rust
:class: seq-cont badges border

for i in 0..20 {
  let handle = std::thread::spawn(move || {
    println!("Hello from thread {i}!");
    std::thread::sleep(std::time::Duration::from_millis(100));
  });
  handles.push(handle);
}
```

:::{warning} The move keyword
Note the usage of the [move](https://doc.rust-lang.org/std/keyword.move.html)
keyword at the beginning of the closure declaration. It is *required*
to *capture by value* the variable `i`. Without it, the compiler
would use a reference to `i`, because that what needs the
`println!()` macro. But the spawned thread is not due to terminate
before the loop terminates, and a reference to `i` would not be
valid outside of the loop. Moreover the `i` variable varies inside
the loop. A reference would give the value of `i` at the moment the
`println!()` is executed, not at the moment of the thread creation.
:::

We finish by waiting each thread to terminate:

```{code-cell} rust
:class: seq-stop badges border

for h in handles {
  h.join().unwrap();
}
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
