# Introduction to the Rust language

This repository contains a [MyST](https://mystmd.org/) port of a Rust
course originally authored in LaTeX by Pierrick Roger, for the CIC 1A
class at Mines Paris - PSL.

The upstream LaTeX source lives at
[gitlab.com/cnrgh/teaching/rust-class](https://gitlab.com/cnrgh/teaching/rust-class),
and is mirrored here (with build/write adaptations) commit by commit
under `notebooks/`.

> [!WARNING]
> The translation from LaTeX to MyST has been made with the help of an
> AI agent, and while it has been carefully supervised, there may be
> errors or inaccuracies in the content. Please report any issues you
> find to the maintainers of this repository.

## Building

See `SETUP.md` for the toolchain (Rust, evcxr, MyST). Once set up:

```
cd notebooks && myst build --html --execute
```

or, for a live preview:

```
cd notebooks && myst start --execute
```
