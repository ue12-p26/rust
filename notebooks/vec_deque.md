# VecDeque

:::{warning} To review
:class: readiness-toreview

:::

The `VecDeque` (*VECtor Double Ended QUEue*) structure is a
double-ended queue (see {numref}`fig-vecdeque`).
Elements can be added or retrieved using the four following methods,
whose performance is in 𝒪(1):

- `push_front()`: push an item at the front of the queue.
- `push_back()`: push an item at the back of the queue.
- `pop_front()`: pop an item from the front of the queue.
- `pop_back()`: pop an item from the back of the queue.

This means that we can use it either as a *stack* (a.k.a.: *LIFO*) or
a *queue* (a.k.a.: *FIFO*).

:::{code-block} text
:name: fig-vecdeque
:caption: A FIFO (queue)

                ┌────┬────┬────┬────┐
push_back() ──> │    │    │    │    │ <── push_front()
   O(1)         │ 10 │  5 │ 47 │ 13 │        O(1)
 pop_back() <── │    │    │    │    │ ──>  pop_front()
                └────┴────┴────┴────┘
:::

A *stack*, or *LIFO* (*Last In First Out*), is a data structure
in which items are put in their order of arrival, and only the last
one can be put out. See {numref}`fig-stack` for an illustration.

:::{code-block} text
:name: fig-stack
:caption: A LIFO (stack)

push_front()    pop_front()
   O(1)   │     ▲  O(1)
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
*FIFO* (*First In First Out*). In a *queue*, the items are put in and
put out in their order of arrival.

:::{code-block} text
:name: fig-queue
:caption: A FIFO (queue)

                ┌────┬────┬────┬────┐
push_back() ──> │ 10 │  5 │ 47 │ 13 │ ──> pop_front()
   O(1)         └────┴────┴────┴────┘       O(1)
:::

Like the `Vec` structure, the `VecDeque` uses an array as the
underlying structure. This array:

- is *growable*.
- is used as a *ring-buffer*.

*Growable* (see {numref}`fig-growable`) means it automatically expands
when the underlying storage is full. However this implies a *copy*
operation, whose performance is in 𝒪(n).

The *ring-buffer* feature (see {numref}`fig-ring-buffer`) means that
the start of the queue is not always at the start of the buffer. In
order to get 𝒪(1) performance for *push* and *pop* operations, the
*start* and *end* of the queue move in a circular way.

:::{code-block} text
:name: fig-growable
:caption: A VecDeque grows to accept new items

                           PUSH O(1)
                            │
                            ▼
                          ┌────┐
                          │    │
                          ├────┤
                          │    │
                          ├────┤
                          │    │
                          ├────┤
              PUSH O(1)   │ 21 │
               │          ├────┤
               ▼          │  7 │
┌────┐       ┌────┐ COPY  ├────┤
│    │       │ 10 │ ────> │ 10 │
├────┤       ├────┤ O(n)  ├────┤
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
