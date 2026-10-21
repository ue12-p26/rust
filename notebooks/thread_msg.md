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

# Thread messaging

:::{warning} To review
:class: readiness-toreview

:::

One technique to solve *concurrency* between threads involves
communication. If threads are able to send each other `messages`,
they can synchronize to, for instance, access shared resources.

The [std::sync::mpsc](https://doc.rust-lang.org/std/sync/mpsc/index.html)
module provides functions (see {numref}`tab-mpsc-fcts`) to open
communication channels between threads. In an MPSC (Multiple
Producers, Single Consumer) model, only one thread listen for
arriving messages, while one or more threads can emit messages.

In practice, the `std::sync::mpsc` module provides methods to *pass
ownership* of an object from one thread to another.

:::{list-table} Functions of the mpsc module
:name: tab-mpsc-fcts
:header-rows: 1
:align: center

* - Method
  - Description
* - `channel<T>()`
  - Creates an *asynchronous* channel of communication to send `T`
    objects. Returns a tuple made of a `Sender<T>` (transmitter) and
    a `Receiver<T>`.
* - `sync_channel<T>(sz)`
  - Creates a *synchronous* channel of communication to send `T`
    objects. Returns a tuple made of a `SyncSender<T>` (transmitter)
    and a `Receiver<T>`.
:::

## Send

The channels provided by the `std::sync::mpsc` module are made to
transmit objects of the *same type* from one thread to another. The
only *condition* is that the type must implement the
[Send](https://doc.rust-lang.org/std/marker/trait.Send.html) trait.

- The `Send` trait is a *marker* trait, used by the compiler. We must
  *never implement it manually* for types.
- Most of built-in types and types from the standard library implement
  the `Send` trait.
- Any type composed of types that implement `Send`, will also
  automatically implement `Send`.
- Among the types that do not implement `Send` is `Rc`. Instead, one
  must use `Arc`, which is thread-safe.

## Asynchronous channel

In an *asynchronous* communication, the *channel* has an *unlimited
buffer* in which it stores the messages:

- A *send* operation *does not block* the execution of the emitter
  thread.
- On the receiver thread, the *receive* operation *blocks* until a
  message is received.

To open an *asynchronous* channel, we use the `channel()` function.
It returns a tuple containing first a transmitter (`tx`), then a
receiver (`rx`):

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let (tx, rx) = std::sync::mpsc::channel::<&str>();
```

:::{warning} Types of the transmitter and the receiver
The transmitter `tx` has type `Sender<T>`. This means it sends only
objects of type `T`. The `T` type is determined at *compile-time*,
by looking at the first use of the `send()` method. The receiver
`rx` has type `Receiver<T>`, its type `T` will be the same as type
`T` of `tx`.
:::

We spawn a thread that sends a message into the channel:

```{code-cell} rust
:class: seq-cont badges border

let handle = std::thread::spawn(move || { tx.send("Hello!") });
```

We wait for a message to arrive, and then print it:

```{code-cell} rust
:class: seq-cont badges border

println!("{:?}", rx.recv()?);
```

Before quiting, we make sure the spawned has terminated:

```{code-cell} rust
:class: seq-stop badges border

handle.join().unwrap()?;
```

:::{note} Result of the send() function
Note how to closure return the `Result` object of the `send()`
function. This on this result object that the `?` operator is used
after the call to `unwrap()`.
:::

## Synchronous channel

In a *synchronous* communication, the *channel* has a *size limited
buffer* in which it stores the messages:

- A *send* operation *does not block* the execution of the emitter
  thread, unless the *buffer becomes full*.
- On the receiver thread, the *receive* operation *blocks* until a
  message is received.
- A buffer size of *zero* is allowed. In that case all *send*
  operations will block until a *receive* operation is paired with
  it.

To open a *synchronous* channel, we use the `sync_channel()`
function. It takes as argument the *buffer size* (i.e.: the maximum
number of messages that can be stored in it). It returns a tuple
containing first a transmitter (`tx`), then a receiver (`rx`).

In the following example, we create a *synchronous* channel with a
buffer capicity of *two messages* only:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let (tx, rx) = std::sync::mpsc::sync_channel::<String>(2);
let start = std::time::Instant::now();
```

We spawn a thread that sends multiple messages and prints a
timestamp after each successful send:

```{code-cell} rust
:class: seq-cont badges border

use std::error::Error;
type ThreadErr = Box<dyn Error + Send + Sync>;

let sender = std::thread::spawn(move || -> Result<(), ThreadErr> {
  for i in 1..=10 {
    let msg = format!("Message #{i}");
    tx.send(msg.clone())?;
    println!("[{:>4} ms] Sent \"{msg}\".", start.elapsed().as_millis());
  }
  Ok(())
});
```

We spawn a receiver thread that waits for messages to arrive, prints
them, and pause for 20 ms after each received message:

```{code-cell} rust
:class: seq-cont badges border

let t = 20;
let receiver = std::thread::spawn(move || -> Result<(), ThreadErr> {
  for msg in rx {
    println!("[{:>4} ms] Received \"{msg}\", pause {t} ms.",
             start.elapsed().as_millis());
    std::thread::sleep(std::time::Duration::from_millis(t));
  }
  Ok(())
});
```

We wait for the two threads to terminate:

```{code-cell} rust
:class: seq-stop badges border

sender.join().unwrap().expect("Error with sender thread");
receiver.join().unwrap().expect("Error with receiver thread");
```

We can observer that the sender thread must *wait* each time for a
slot to be freed inside the channel, starting at the *third
message*.

:::{exercise} Rendez-vous (★★★☆☆)
:label: thread-rendez-vous
:enumerated: true

1. Write a thread that counts even numbers from 0 to 20.
2. Write another thread that counts odd numbers from 1 to 21.
3. The two threads must wait each other to write the numbers from 0
   to 21, ordered.
:::

[see solution](#thread-rendez-vous-solution)

## Multiple senders

As stated in the introduction, with the `std::sync::mpsc` module,
*multiple threads can send* messages, while *only one can receive*
them. To allow multiple threads to send messages on the same
channel, we just have to *clone* the transmitter for each new
thread.

Let us create an *asynchronous* channel:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let (tx1, rx) = std::sync::mpsc::channel::<&str>();
```

And clone the transmitter:

```{code-cell} rust
:class: seq-cont badges border

let tx2 = tx1.clone();
```

We can then spawn two sender threads using both transmitters:

```{code-cell} rust
:class: seq-cont badges border

let sender1 = std::thread::spawn(move || { tx1.send("Hello 1!") });
let sender2 = std::thread::spawn(move || { tx2.send("Hello 2!") });
```

And listen for arriving messages on the receiver:

```{code-cell} rust
:class: seq-cont badges border

for msg in rx {
  println!("Received message: {msg}");
}
```

We finally wait for the two threads to terminate:

```{code-cell} rust
:class: seq-stop badges border

sender1.join().unwrap().expect("Error with sender1 thread");
sender2.join().unwrap().expect("Error with sender2 thread");
```
