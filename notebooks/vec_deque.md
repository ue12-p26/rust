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

A *stack*, or *LIFO* (*Last In First Out*), is a data structure
in which items are put in their order of arrival, and only the last
one can be put out. See {numref}`fig-stack` for an illustration.

:::{code-block} text
:name: fig-stack
:caption: A LIFO (stack)

push_front()    pop_front()
          │     ▲
          │     │
          ▼     │
         ┌────────┐
         │   10   │
         ├────────┤
         │    5   │
         ├────────┤
         │   47   │
         ├────────┤
         │   13   │
         └────────┘
:::

On {numref}`fig-queue` we can see the illustration of a *queue*, or
*FIFO* (*First In First Out*). In a *queue*, the items are put out in
their order of arrival.

:::{code-block} text
:name: fig-queue
:caption: A FIFO (queue)

                ┌────┬────┬────┬────┐
push_back() ──> │ 10 │  5 │ 47 │ 13 │ ──> pop_front()
                └────┴────┴────┴────┘
:::

Like the `Vec` structure, the `VecDeque` uses an array as the
underlying structure. This array:

- is *growable*.
- is used as a *ring-buffer*.

*Growable* means

:::{code-block} text
:name: fig-growable
:caption: A VecDeque grows to accept new items

                           PUSH
                            │
                            ▼
                          ┌────┐
                          │    │
                          ├────┤
                          │    │
                          ├────┤
                          │    │
                          ├────┤
              PUSH        │ 21 │
               │          ├────┤
               ▼          │  7 │
┌────┐       ┌────┐ COPY  ├────┤
│    │       │ 10 │ ────> │ 10 │
├────┤       ├────┤       ├────┤
│    │       │  5 │       │  5 │
├────┤       ├────┤       ├────┤
│ 47 │       │ 47 │       │ 47 │
├────┤       ├────┤       ├────┤
│ 13 │       │ 13 │       │ 13 │
└────┘       └────┘       └────┘
╰────────┬────────╯         │
  ORIGINAL BUFFER       NEW BUFFER
:::

:::{code-block} text
:name: fig-ring-buffer
:caption: Demonstration of a ring-buffer usage

  │   back           front
 T│    │              │
  │    ▼              ▼
 I│  ┌────┬────┬────┬────┬────┬────┬────┐
  │  │ 10 │  5 │ 47 │ 13 │    │    │    │
 M│  └────┴────┴────┴────┴────┴────┴────┘
  │
 E│             back           front
  │              │              │
 L│              ▼              ▼
  │  ┌────┬────┬────┬────┬────┬────┬────┐
 I│  │    │    │ 47 │ 13 │ 16 │  4 │    │
  │  └────┴────┴────┴────┴────┴────┴────┘
 N│
  │   front               back
 E│    │                   │
  │    ▼                   ▼
  │  ┌────┬────┬────┬────┬────┬────┬────┐
  │  │ 25 │    │    │    │ 16 │  4 │ 17 │
  ▼  └────┴────┴────┴────┴────┴────┴────┘
:::

It is implemented as a growable ring-buffer.
