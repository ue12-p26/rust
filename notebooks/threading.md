# Threading

:::{warning} To review
:class: readiness-toreview

:::

A *thread* is the execution of a piece of code inside a *process*.
Multiple threads can execute simultaneously inside a process. They
are put, altogether, inside an execution priority queue by the
operating system, then are run by small groups on the cores of the
processor. See {numref}`fig-thread-exec`.

:::{figure} media/thread_process_program.jpg
:name: fig-thread-exec
:alt: Program vs Process vs Thread

Thread execution (from Wikipedia)
:::

*Threads*:

- Are part of the *same process*.
- Share the *same memory* inside their process.

With threading we can design applications that use:

- *Concurrent programming*.
- *parallel programming*.
- *both*.

In *concurrent programming*:

- Threads share the *same resources* (memory data, files, ...). They
  are in a *race condition*: they need to access resources in order
  to execute.
- We need to *coordinate* the threads in order to avoid *deadlock*
  (two threads that wait for each other indefinitely).

In *parallel programming*:

- Threads access *different resources* (memory data, files, ...).
- The resources must be *shared equally* in order to achieve the
  best speed gain.
