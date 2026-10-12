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

# Threading exercices

## Rendez-vous

:::{solution} thread-rendez-vous
:label: thread-rendez-vous-solution
:::

We define the error type to return from threads:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::error::Error;
type ThreadErr = Box<dyn Error + Send + Sync>;
```

We create two synchronize channels, with no buffers. The absence of
buffer will force the sender to block until a receiver takes its
message (this is called a *rendez-vous*):

```{code-cell} rust
:class: seq-cont badges border

let (tx1, rx1) = std::sync::mpsc::sync_channel::<bool>(0);
let (tx2, rx2) = std::sync::mpsc::sync_channel::<bool>(0);
```

We start first the thread 2 that will count the odd numbers. At
each step of the loop, it:

1. Waits for a message from thread 1.
2. Prints its number.
3. Sends a message to thread 1 in order to unlock it.

```{code-cell} rust
:class: seq-cont badges border

let h2 = std::thread::spawn(move || -> Result<(), ThreadErr> {
  for i in (1..=21).step_by(2) {
    let _ = rx1.recv()?;
    print!("{i} ");
    tx2.send(true)?;
  }
  Ok(())
});
```

The thread 1 counts the even numbers. In each loop step, it:

1. Prints its number.
2. Sends a message to thread 2 in order to unlock it.
3. Waits for a message from thread 2.

```{code-cell} rust
:class: seq-cont badges border

let h1 = std::thread::spawn(move || -> Result<(), ThreadErr> {
  for i in (0..=20).step_by(2) {
    print!("{i} ");
    tx1.send(true)?;
    let _ = rx2.recv()?;
  }
  Ok(())
});
```

Finally, we wait for the two threads to finish:

```{code-cell} rust
:class: seq-stop badges border

h1.join().unwrap().expect("Error in thread 1");
h2.join().unwrap().expect("Error in thread 2");
println!();
```
