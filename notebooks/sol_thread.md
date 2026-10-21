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

## Dining philosophers problem

:::{solution} dining-philosophers
:label: dining-philosophers-solution
:::

We start with importing the various needed types:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;
```

We create a function that creates and runs a diner. It will allow us
to run multiple diners. It takes as arguments:

1. `n`: the number of philosophers and chopsticks.
2. `n_bites`: the number of bites to eat.
3. `think_ms`: the time spent to think.

We need an array to store the philosopher threads and chopsticks
mutexes, and a mutex on the common dish, then we initialize the
chopsticks. We run a loop to spawn the threads, in which the index `i`
is used to get the indices of the two chopsticks. We clone the
reference on the common dish, then the references on the needed
chopsticks, and spawn the $i^{th}$ thread. Inside the closure, we
first initialize two variables to count the number of bites eaten by
the philosopher, and the time spent to think. The main body of the
closure is an infinite loop that alternates between an *eating* phase
(trying to lock the left & right chopsticks, then the common dish, to
eat one bite) and a *thinking* phase (the thread sleeps during a fixed
time). When the philosopher is done, we return a sum-up of its
actions. Finally, we wait for the threads to terminate:

```{code-cell} rust
:class: seq-cont badges border

fn diner(n: usize, n_bites: usize, think_ms: u64) -> Vec<(u16, f32)> {
  let mut philosophers = vec![];
  let mut chopsticks = vec![];
  let dish = Arc::new(Mutex::new(n_bites));
  for _ in 0..n {
    chopsticks.push(Arc::new(Mutex::new(true)));
  }
  for i in 0..n {
    let dish = Arc::clone(&dish);
    let left_chopstick = Arc::clone(&chopsticks[(i+n-1) % n]);
    let right_chopstick = Arc::clone(&chopsticks[(i+1) % n]);
    let philosopher = thread::spawn(move || -> (u16, f32) {
      let mut eaten = 0u16; // Total eaten
      let mut thinking = 0.0f32; // Total thinking time
      loop {
        // Eat
        if let Ok(_lc) = left_chopstick.try_lock()
           && let Ok(_rc) = right_chopstick.try_lock() {
          // We got the two chopsticks

          // We lock the common dish
          let mut bites = dish.lock().unwrap();
          if *bites == 0 {
            break; // Nothing to eat, we leave
          }
          *bites -= 1;
          eaten += 1;
        }

        // Think
        let t = think_ms as f32 / 1000.0;
        thinking += t;
        thread::sleep(Duration::from_millis(think_ms));
      }
      (eaten, thinking)
    });
    philosophers.push(philosopher);
  }
  let mut results = vec![(0u16, 0f32); n];
  for (i, philosopher) in philosophers.into_iter().enumerate() {
    let res = philosopher.join().unwrap();
    results[i] = res;
  }
  results
}
```

:::{note} Computing with unsigned integers
Note the computing of the index of the left chopstick: $i+n-1$. The
index `i` is an unsigned integer, as `n` is. Thus $i-1$ would lead to
an unhandled overflow error at compile time. By writing $i+n-1$ we
avoid this error.
:::

We add a convenient function to print the results returned by
`diner()`:

```{code-cell} rust
:class: seq-cont badges border

fn print_res(results: &[(u16, f32)]) {
  for (i, res) in results.iter().enumerate() {
    println!("Philosopher {i} ate {} bite(s) and spent {} seconds thinking.",
             res.0, res.1);
  }
}
```

We run a first time the `diner()` function with 5 philosophers, 500
bites to eat and a thinking time of 1 ms, in order to check if *no
deadlocks* appear:

```{code-cell} rust
:class: seq-cont badges border

let results = diner(5, 500, 1);
print_res(&results);
```

We run then the `diner()` function with 5 philosophers, 5 bites to eat
and a thinking time of 1 ms, in order to check if each philosopher
eats *exactly one bite*:

```{code-cell} rust
:class: seq-stop badges border

let results = diner(5, 5, 1);
print_res(&results);
```
