# VecDeque

:::{warning} To review
:class: readiness-toreview

:::

The `VecDeque` structure is a double-ended queue.
Elements can be added or retrieved using the following methods:

- `push_front()`.
- `push_back()`.
- `pop_front()`.
- `pop_back()`.

This means that we can use it either as a *stack* (a.k.a.: *LIFO*) or
a *queue* (a.k.a.: *FIFO*).

:::{danger} TODO
:class: readiness-todo

- Do a diagram of a LIFO.
- Do a diagram of a FIFO.
- Do a diagram of a ring-buffer.
:::

It is implemented as a growable ring-buffer.
