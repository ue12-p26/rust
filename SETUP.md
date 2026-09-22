# Setup

Dependencies needed to build and execute this course locally, and the
versions currently known to work together (as of 2026-09-22).

## Conda environment

Everything below runs inside the `ue12-p26-rust-class` conda environment.

## Rust toolchain

- `rustup` managed, `stable` channel.
- `rustc 1.98.1` / `cargo 1.98.1`.

## evcxr (Rust Jupyter kernel)

Installed via `cargo install`, **not** part of the conda env:

```
cargo install --locked evcxr_jupyter@0.22.0 evcxr_repl@0.22.0
```

- `evcxr_jupyter 0.22.0` — the actual Jupyter kernel (`rust` kernelspec).
- `evcxr_repl 0.22.0` (binary name `evcxr`) — the bare REPL, handy for
  isolated testing outside Jupyter.

**Known trap:** these are compiled binaries, pinned to whatever `rustc`
was current when built. `rustup` silently floats the `stable` channel
forward; if it moves past what `evcxr_jupyter` was built against, the
kernel breaks in confusing ways (e.g. `Couldn't automatically determine
type of variable` on code that is obviously fine — even a bare `let s =
String::from("hello");`). If code that should work starts failing like
this, rebuild both against the current `rustc` (bumping the version pin
above to whatever is latest on crates.io first, if needed) — `--locked`
avoids an unrelated `unicode-properties`/`unicode-ident` version
conflict in `evcxr_jupyter`'s own dependency tree.

## Bash kernel

- `bash_kernel 0.10.0` (Jupyter kernelspec `bash`).

## MyST

- `mystmd 1.11.0` (`myst` CLI), installed both in the conda env and via
  the repo-root `package.json`.
- Build: `cd notebooks && make style && myst build --html --execute`.
- Live preview: `myst start --execute` (caches execution results
  in-memory across reloads within the same process — prefer this over
  repeated `myst build --execute` invocations, whose on-disk execution
  cache under `notebooks/_build/execute` does not reliably persist
  across separate CLI runs).

## Other CLI tools used in bash examples

- `eza` (maintained fork of the unmaintained `exa`) — invoke with an
  explicit path (`eza -T .`), not bare, per a known bug in this
  environment where bare `eza -T` prints nothing.
