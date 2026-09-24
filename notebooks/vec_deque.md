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
a *queue* (a.k.a.: *FIFO*). See {numref}`tab-vecdeque` for a list of
some of `VecDeque`'s most important methods.

:::{list-table} Some methods of `VecDeque`
:name: tab-vecdeque
:header-rows: 1
:align: center

* - Method
  - Description
* - `append(other)`
  - Appends another `VecDeque` object to this one.
* - `back()`
  - Provides a reference to the back element.
* - `binary_search(v)`
  - Binary searches for the value `v`. Supposes that this queue is
    *sorted*.
* - `clear()`
  - Removes all elements.
* - `contains(v)`
  - Returns `true` if this queue contains the value `v`.
* - `front()`
  - Provides a reference to the front element.
* - `get(i)`
  - Gets the element at index `i`. This is an 𝒪(1) operation.
* - `insert(i, v)`
  - Inserts the value `v` at a position `i`. Index `0` is the *front*
    of the queue.
* - `is_empty()`
  - Returns `true` if the queue contains no elements.
* - `iter()`
  - Returns a front-to-back iterator.
* - `len()`
  - Returns the number of elements.
* - `make_contiguous()`
  - Rearranges the ring-buffer so that the front element is at the
    start of the buffer. This is an 𝒪(n) operation as we need to move
    all the values.
* - `new()`
  - Creates a new vector.
* - `pop_back()`
  - Removes the back element and returns it.
* - `pop_front()`
  - Removes the front element and returns it.
* - `push_back(v)`
  - Appends an element to the back.
* - `push_front(v)`
  - Appends an element to the front.
* - `remove(i)`
  - Removes and returns the item at index `i`.
* - `resize(sz, v)`
  - Resizes the queue to size `sz`, appending copies of `v` if
    required.
* - `swap(i, j)`
  - Swaps elements `i` and `j`.
* - `truncate(sz)`
  - Shortens the queue to size `sz`.
:::

A *stack*, or *LIFO* (*Last In First Out*), is a data structure
in which items are put in their order of arrival, and only the last
one can be put out. See {numref}`fig-stack` for an illustration.

:::{code-block} text
:name: fig-vecdeque
:caption: A FIFO (queue)

                ┌────┬────┬────┬────┐
push_back() ──> │    │    │    │    │ <── push_front()
   O(1)         │ 10 │  5 │ 47 │ 13 │        O(1)
 pop_back() <── │    │    │    │    │ ──>  pop_front()
                └────┴────┴────┴────┘
                            │
                            │
                            ▼
                          get()  O(1)
:::

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
the front of the queue is not always at the start of the buffer. In
order to get 𝒪(1) performance for *push* and *pop* operations, the
*front* and *back* of the queue move in a circular way.

:::{note} Indices
In all cases, the *front* (i.e.: start) of the queue is always at
index *0* wherever it is placed inside the ring-buffer.
:::

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

  │   front          back
 T│    │              │
  │    ▼              ▼
 I│  ┌────┬────┬────┬────┬────┬────┬────┐
  │  │ 10 │  5 │ 47 │ 13 │    │    │    │
 M│  └────┴────┴────┴────┴────┴────┴────┘
  │
 E│             front          back
  │              │              │
 L│              ▼              ▼
  │  ┌────┬────┬────┬────┬────┬────┬────┐
 I│  │    │    │ 47 │ 13 │ 16 │  4 │    │
  │  └────┴────┴────┴────┴────┴────┴────┘
 N│
  │        back           front
 E│         │              │
  │         ▼              ▼
  │  ┌────┬────┬────┬────┬────┬────┬────┐
  │  │ 25 │ 17 │    │    │ 16 │  4 │ 17 │
  ▼  └────┴────┴────┴────┴────┴────┴────┘
:::
