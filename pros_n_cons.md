# Sum-up of pros and cons

Here is a list of good reasons to program in Rust:

- *Compiled* language: achieves performances comparable to C/C++.
- True threading *parallelism*: no GIL like in Python.
- Strong *memory* checking: avoid issues like null pointer dereferencing,
  data races and buffer overflows.
- *Cross platform*: Rust runs on Windows and Unix-like systems (macOS, Unix,
  Linux).
- *Packaging system* similar to Python or R: ease distribution.
- Pushed by major companies, the language has gain strong support and
  reached a satisfiable first stage of *stability*.

Depending from which main programming language a developer comes from,
he/she may have various reasons to switch or not to Rust:

- **From Python**: The Rust environment will look familiar, but not the
  language. The Python's ecosystem for science is still more advanced, but
  Rust's one is building steadily with packages similar to NumPy, Pandas or
  Matplotlib. The main gain will come from performance, with hands on a
  natively compiled language equipped with a powerful threading system.

- **From R**: Like Python, the R's ecosystem is still far better than
  Rust's. Switching to Rust will be harder for R developers, due to the
  difference of syntax, Rust's syntax being a lot more closer to Python's.
  As for Python, the main gain will come from the access to a compiled
  language, not having to rely on C/C++ coding of back-end to achieve
  reasonable speed.

- **From C/C++**: Developers that have hard time copping with memory leaks,
  C++ standard libraries or Boost, portability issues, lack of ecosystem
  (packages) for their field, should find a more friendly environment in
  Rust.
  Those mastering C/C++ will not find real advantages in Rust, and on
  the contrary may get confused with the memory ownership approach and
  lifetime concept. However they may gain access to a larger audience
  since Rust applications are easier to distribute and install than
  C/C++ ones.

The main drawbacks of Rust are:

- Contrarily to R and Python, there is no GC in Rust. Memory is managed by
  the developer. However, unlike C/C++, the compiler enforces good usage of
  the memory.

- As a consequence, some new concepts are introduced to manage memory that
  may require some time to grasp:
  - Memory *Ownership*.
  - Memory *Borrowing*.
  - Variable *Lifetimes*.

- Rust is not an OOP language. For developers coming form the OOP world
  (C++, Java, Python), designing an application or implementing a design
  pattern may turn out challenging. To achieve polymorphism, Rust does not
  rely on inheritance (a concept unknown in Rust), but on:
  - *Traits*: Similar to interfaces in Java or abstract classes in C++.
  - *Generics*: Similar to C++'s templates and Java's generics.

- The Rust community is a lot smaller than Python's, R's or C/C++'s, and
  as a consequence the ecosystems of various domains, when they exist, are
  smaller and less accomplished. However the system programming and network
  ecosystems are quite advanced, due to the usage of Rust in those domains
  at industrial level.

- The sizes of generated Rust binaries are quite high compared to C/C++
  equivalents. However they are comparable to R and Python systems that
  install tons of dependency libraries. Indeed, Rust is closer to the
  spirit of languages like Python in the sense that it relies a lot on
  community packages for application development. Each application using
  just 4 of 5 dependencies will trigger the installation of tens
  sub-dependencies. Rust binaries being statically compiled, this leads to
  huge binary sizes.
