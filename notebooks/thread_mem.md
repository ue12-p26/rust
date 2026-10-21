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

# Shared memory

:::{warning} To review
:class: readiness-toreview

:::

In contrast to the technique of *messaging* in which we pass
*ownership* of objects, the *shared memory* technique involves
*borrowing* objects. With those two techniques we are thus back to
the traditional Rust choice between *ownership* and *borrowing*.

In this chapter, we focus on *sharing memory* between threads. Thanks
to the `Mutex` structure, we will see how to share and access
individual objects between threads.

## Sync

An object can be shared between threads, if its type implements the
[Sync](https://doc.rust-lang.org/std/marker/trait.Sync.html) trait.

- The `Sync` trait is a *marker* trait, used by the compiler. We must
  *never implement it manually* for types.
- Most of built-in types and types from the standard library implement
  the `Sync` trait. More precisely any type `T` implements `Sync` if
  `&T` implements `Send`.
- Any type composed of types that implement `Sync`, will also
  automatically implement `Sync`.
- Among the types that do not implement `Sync` are `Rc`, `RefCell` and
  `Cell`. Instead, one must use `Arc` and `Mutex`.

## Mutexes

A *mutex* (*mutual exclusion*) is a mechanism to control access to
shared data. It uses an internal *lock* structure to keep track of
which thread is currently using the data. To access the shared data
controlled by the mutex, a thread must:

1. Acquire the *lock*.
2. Read/write into the shared data.
3. Release the *lock* so that other threads may access the data.

:::{danger} Deadlock
There are two ways for a thread to acquire a *lock*:

- It may acquire it by blocking. The thread *waits* (i.e.: *blocks*)
  until it gets the lock.
- It may also *try* to acquire it. The thread makes a *non-blocking*
  request to acquire the lock. If it is rejected, the thread goes on
  to other tasks.

The case of the *blocking* acquisition is the most common one, since a
thread has often only *one task* to perform. One danger is that if the
thread that has acquired the lock does not release it, then all other
threads will block and stop performing their tasks. Another danger is
that multiple locks on different resources may be required to perform
a task, and several threads acquire each one lock, blocking each other
in a *deadlock*.
:::

The [Mutex](https://doc.rust-lang.org/std/sync/struct.Mutex.html)
structure implements the concept of the mutex. Some of its methods are
presented in {numref}`tab-mutex-methods`.

:::{list-table} Some methods of Mutex
:name: tab-mutex-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `clear_poison()`
  -
* - `get_mut()`
  -
* - `into_inner()`
  -
* - `is_poisoned()`
  -
* - `lock()`
  -
* - `new(v)`
  - Creates a new mutex on the value `v`.
* - `try_lock()`
  -
:::

## Locking

The `Mutex` structure provides a `lock()` method to acquire it. It
returns a
[LockResult](https://doc.rust-lang.org/std/sync/type.LockResult.html)
that is just an alias for the `Result` enumerate with a special error
type
[PoisonError](https://doc.rust-lang.org/std/sync/struct.PoisonError.html).
The `LockResult` gives access to a
[MutexGuard](https://doc.rust-lang.org/std/sync/struct.MutexGuard.html)
around the data. The lock is automatically *released* when the
`MutexGuard` goes *out of scope*.

As an example we create a mutex on an integer value:

```{code-cell} rust
:class: seq-start badges border

let m = std::sync::Mutex::new(13);
m
```

:::{note} Mutex fields
We can see that the mutex object contains at least two fields:

- `data`: the object we created the mutex on.
- `poisoned`: a boolean value indicating if the mutex is in a correct
  state. We will come back on that later.
:::

We call now the `lock()` method to acquire the lock on the mutex.
Since the `lock()` method returns a `MutexGuard` that implements RAII
(Resource acquisition is initialization), it ensures that the lock
will be released when getting out of scope. Hence we create a special
scope, using curly braces, to force the release of the lock. The
`MutexGuard` also implements `Deref`, which allows to access the
underlying data through the dereferencing operator `*` or by calling
its methods.

```{code-cell} rust
:class: seq-cont badges border

{
  let mut n = m.lock().unwrap();
  *n = 7; // Using the Deref trait we modify the underlying data
}
```

:::{important} RAII
The RAII technique, invented by Bjarne Stroustrup, the creator of the
C++ language, is used to create types targeted to controlling access
to a resource. An RAII type enforces that:

1. It acquires the resource at initialization (i.e.: construction), or
   fails initialization (i.e.: returns an error or panic).
2. It releases the resource at termination (i.e.: destruction).
:::

After the release of the lock, we can check the mutex state and see
that the value has changed:

```{code-cell} rust
:class: seq-stop badges border

m
```

## Shared access

To share access to data between threads, we need to share a `Mutex`
between threads. Using an `Rc` pointer would not work, because it is
not *thread-safe* (i.e.: it does not handle concurrency access to its
interface). Instead we are going to use an `Arc` pointer. `Arc` stands
for *Atomically Referenced Counted*, and is just a *thread-safe*
version of `Rc`.

Here is an example extracted from [The Rust Programming
Language](https://doc.rust-lang.org/book/title-page.html) book ([Shared
Access to
Mutex\<T\>](https://doc.rust-lang.org/book/ch16-03-shared-state.html#shared-access-to-mutext)),
in which we launch 10 threads that each increment a *shared counter*
by 1.

We start by importing the necessary objects:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::sync::{Arc, Mutex};
use std::thread;
```

We create the counter inside a `Mutex` that will control its access,
and we place the mutex inside an `Arc` so we can share it across
threads:

```{code-cell} rust
:class: seq-cont badges border

let counter = Arc::new(Mutex::new(0));
```

We initialize an empty vector that will store the thread handles:

```{code-cell} rust
:class: seq-cont badges border

let mut handles: Vec<std::thread::JoinHandle<()>> = Vec::new();
```

We create 10 threads. For each thread:

1. We clone the `Arc` object so we can move the clone into the new
   thread.
2. We spawn the new thread that will *lock* the mutex inside the `Arc`
   object and increment the counter. The *lock* is *released* when
   exiting the thread's closure.
3. We store the *handle* inside our vector.

```{code-cell} rust
:class: seq-cont badges border

for _ in 0..10 {
  let counter = Arc::clone(&counter);
  let handle = thread::spawn(move || {
    let mut num = counter.lock().unwrap();
    *num += 1;
  });
  handles.push(handle);
}
```

We wait for each thread to terminate:

```{code-cell} rust
:class: seq-cont badges border

for handle in handles {
  handle.join().unwrap();
}
```

At the end, we check that the counter has been incremented:

```{code-cell} rust
:class: seq-stop badges border

println!("Result: {}", *counter.lock().unwrap());
```

:::{exercise} Dining philosophers problem (★★★★★)
:label: dining-philosophers
:enumerated: true

The *Dining Philosophers Problem* is a classic example used to
illustrate the *deadlock* (i.e.: threads wait forever) and the
*starvation* (i.e.: some threads get nothing to do) issues.

Imagine $N$ philosophers sitting around a circular table. Each
philosopher alternates between *thinking* and *eating* inside a common
dish.

- The common dish is at the center of the table and contains $B$
  *bites* to eat.
- $N$ *chopsticks* are shared between the $N$ philosophers, such as
  each philosopher has a chopstick on its *left* and a chopstick on
  its *right*.
- Each chopstick is shared between 2 philosophers.
- To eat, a philosopher needs both the chopstick to its left and the
  chopstick to its right. Philosophers must share chopsticks with
  their neighbors, leading to potential *deadlocks*.

Objective:

1. Construct the shared object that represents the *dish* containing
   $B$ bites to eat.
2. Construct the $N$ shared objects that represent the *chopsticks*
   used by the philosophers.
3. Spawn $N$ threads representing the philosophers.
4. Each philosopher must be in one of two states, either *eating* or
   *thinking*:
   - In the *thinking* state, the thread just does nothing during a
     certain amount of time. Print a message to show when the thread
     is thinking.
   - In the *eating* state, the thread tries to acquire its two
     chopsticks *one after the other*, when done it can eat one bite
     of food inside the common dish. Print a message to show when the
     thread successfully eats one bite.
5. Check that a deadlock occurs with $N = 5$ and $B = 500$. Run the
   program multiple times to check, since the deadlock case does not
   appear systematically.
6. Check that a starvation occurs with $N = 5$ and $B = 10$. The first
   thread should eat all bites, while other threads, starting later,
   get nothing to eat.
7. Design a protocol that allows the philosophers to eat without
   causing deadlock (where everyone waits forever) or starvation
   (where someone never gets to eat).
8. Check that no deadlock occurs anymore with $N = 5$ and $B = 500$.
9. Check that each philosopher gets to eat $1$ bite for $B = N$.
:::

[see solution](#dining-philosophers-solution)
