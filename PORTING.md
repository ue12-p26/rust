# Porting notes

This file tracks how the MyST port in `with-myst/` differs from the upstream
LaTeX source, and records the reference commit we forked from.

When upstream changes, the plan is to `git diff <ref>..HEAD -- foo.tex` per
file (the file-name correspondence is 1:1) and port the delta into the
matching `.md`. The entries below flag the regions where a naïve overwrite
would lose a deliberate local choice.

## Status

Porting paused at the end of **Part 3 (*Fundamentals*)** — i.e. through
chapter 14 *Slices* inclusive. Chapters covered:

- Part 1 (*Preliminaries*): 1 *Introduction*, 2 *Environment*
- Part 2 (*Basics*): 3 *Variables & constants*, 4 *Atomic types*,
  5 *Memory — Part I*, 6 *Complex types*, 7 *Syntax & control flow*,
  8 *Functions — Part I*
- Part 3 (*Fundamentals*): 9 *Macros introduction*, 10 *Dynamic types —
  Part I*, 11 *Memory — Part II*, 12 *Enum type*, 13 *Dynamic types —
  Part II*, 14 *Slices*

Chapters 15+ (*Proficiency*, *Expertise*, *Mastery*) are not yet ported.

Of the *Appendices* part, **Tables** is fully ported and **Solutions**
contains the *First program* (chapter 8) and *Nuts price* (chapter 12)
entries. The remaining *Overflow in hash function* solution is still
pending (chapter 24, not yet ported).

Three chapters in Part 3 carry an upstream `\DRAFT` / `\TODO` marker
that has been preserved as a `:::{danger} Draft` admonition at the top
of the corresponding MyST page: *More about Vec* (`vec_bis.md`),
*Slices* (`slices_intro.md`), *String slices* (`str.md`), and *Array
slices* (`arr_slices.md` — essentially a stub).

## Upstream reference

This porting wave was made against:

```
upstream: git@gitlab.com:cnrgh/teaching/rust-class.git
commit:   a23b9f88719067bc26ce7b57ccc0192bd979ba4b
subject:  Resolve "Change admonition colors"
date:     2026-05-12
```

When resuming, fetch upstream and use
`git -C <repo> diff a23b9f88..<new-ref> -- <foo>.tex` per file to identify
the deltas to port into the matching `<foo>.md`.

## Local divergences from upstream

### 1. `.bss` example wrapped in a function (`memory.md`)

Upstream LaTeX:

```rust
static mut N: usize = 0;
static mut BUFFER: [u8; 16] = [0; 16];

#[allow(static_mut_refs)]
unsafe {
  N = 10;
  // ...
  println!("BUFFER={BUFFER:?}");
}
```

MyST port:

```rust
static mut N: usize = 0;
static mut BUFFER: [u8; 16] = [0; 16];

#[allow(static_mut_refs)]
fn fill_and_print() {
  unsafe {
    N = 10;
    // ...
    println!("BUFFER={BUFFER:?}");
  }
}

fill_and_print();
```

**Why:** `#[allow(...)]` (or `#![allow(...)]`) on an `unsafe { ... }` block
is an attribute on a *block expression*, which is gated by the unstable
`stmt_expr_attributes` feature. The LaTeX build apparently wraps each
snippet in a way that accepts the experimental form (or compiles with the
feature enabled); evcxr's cell-wrapping does not. Item-level attributes (on
`fn`, `struct`, `mod`, ...) are stable, so we wrap the body in a function
and put `#[allow(static_mut_refs)]` on the function instead.

**Semantically equivalent.** The `.bss` demonstration is unchanged: same
two `static mut` declarations, same writes, same prints, same lint
suppression.

**Status:** the LaTeX source also fails to run in some environments
(reported upstream). If upstream adopts a similar workaround, we may be
able to converge.

### 2. `:::{important}` → `:::{warning}`

We use `:::{warning}` everywhere the LaTeX has `\begin{important}{...}`,
because MyST's default `book-theme` renders both `note` and `important`
with the same blue chrome. `warning` gives us a visually distinct second
admonition style (orange/amber), matching the LaTeX original's intent of
having `note` and `important` look different.

**On merge:** if upstream adds new `\begin{important}{...}` blocks, port
them as `:::{warning}` (not `:::{important}`).

### 3. `[disable]` cells → plain fenced code blocks

LaTeX's `\begin{minted}[disable]{...}` means "render but don't execute".
The MyST equivalent of a non-executable code block is a plain fenced code
block (no `{code-cell}` directive). Pages affected:

- `env_install.md` — `rustup default stable`
- `env_cargo.md` — `cargo --list`, `cargo install bat`,
  `cargo run --bin foo2 -- arg1 ...`, the two `cargo add` examples in
  admonitions
- `resources.md` — `cargo install rustlings` block
- `var_scope.md` — the `{ let x = 1; }` scope demo
- `comments.md` — all examples
- `loop.md` — the infinite-loop example

**On merge:** treat new `[disable]` cells the same way (plain fences).

### 4. Stack-overflow demo in `memory.md`

The 1-billion-element array `let array = [123; 1_000_000_000];` is rendered
as a *plain* (non-executable) rust fence with a one-line note. The LaTeX
version executes it; in evcxr that would SIGSEGV the kernel and break the
rest of the page. `:tags: [raises-exception]` doesn't help because a
native stack overflow is a kernel death, not a recoverable error.

### 5. Cross-references to appendix tables — restored after Tables port

All references that were dropped during chapters 4–8 (in `int.md`,
`float.md`, `bool.md`, `array.md`, `env_cargo.md`) were restored as
`{numref}` directives once the *Tables* appendix was ported. Mapping
of original LaTeX labels to MyST names:

| LaTeX label            | MyST `:name:`        | File                |
|------------------------|----------------------|---------------------|
| `tab:CargoSubCmds`     | `tab-cargo-subcmds`  | `cargo_cmds.md`     |
| `tab:RustApps`         | `tab-rust-apps`      | `rust_apps.md`      |
| `table:ArrayMethods`   | `tab-array-methods`  | `array_methods.md`  |
| `table:VecMethods`     | `tab-vec-methods`    | `vec_methods.md`    |
| `table:StrSliceMethods`| `tab-str-methods`    | `str_methods.md`    |
| `table:StringMethods`  | `tab-string-methods` | `string_methods.md` |
| `table:SliceMethods`   | `tab-slice-methods`  | `slice_methods.md`  |
| `table:OptionMethods`  | `tab-option-methods` | `option_methods.md` |
| `tab:MacroFctLike`     | `tab-macro-fct-like` | `macro_fct_list.md` |
| `table:LogicalOp`      | `tab-logical-op`     | `bool_ops.md`       |
| `table:CompOp`         | `tab-comp-op`        | `bool_ops.md`       |
| `table:ArithOp`        | `tab-arith-op`       | `int_ops.md`        |
| `table:BitwiseOp`      | `tab-bitwise-op`     | `int_ops.md`        |
| `table:FloatOp`        | `tab-float-op`       | `float_ops.md`      |

In-file table refs (`\autoref{table:CharEsc}` in `char.tex`,
`\autoref{tab:RangeSyntax}` in `ranges.tex`) were always kept and
converted to MyST `{numref}` against `{list-table}` blocks in the same
file.

**On merge:** when porting a new LaTeX file that references one of the
appendix tables, use the corresponding `{numref}` name from the table
above. When porting a new appendix table, add a row to this table and
restore any dangling references in the body chapters.

**Two appendix tables still marked `\INPROGRESS` upstream**
(`array_methods.tex`, `slice_methods.tex`) are rendered with a
`:::{danger} In progress` admonition at the top of the MyST page.

### 6. Bibliography citations — inlined

`\cite{...}` was replaced with inline hyperlinks to the referenced URL
(e.g. `[Perkel 2020](http://dx.doi.org/10.1038/d41586-020-03382-2)`).
`refs.bib` is not currently consumed by MyST.

**On merge:** new `\cite{Foo}` references need the matching `@Foo` entry
from `refs.bib` looked up by hand and inlined.

### 7. Side-by-side figures — currently stacked

In `memory.tex`, `call_stack.png` and `memory_heap.png` are placed
side-by-side using LaTeX `minipage`s. In the MyST port they are stacked
vertically. The cleanest MyST equivalent is a `::::{grid} 2` wrapper with
two `:::{figure}` children — to be applied when we revisit `memory.md`.

### 8. `\paragraph{}` → `###` heading

In `env_cargo.md`, the LaTeX `\paragraph{Creating a new project from
scratch}` and `\paragraph{It is also possible to initialize a project
inside a Git repository}` became `### Creating a new project from scratch`
and `### Initializing a project inside a Git repository`. This gives them
visible structure in the sidebar instead of inline bold.

### 9. Exercise / solution pattern

LaTeX `\begin{exercise}{Title} ... Solution in \autoref{sol:Foo}.
\end{exercise}` becomes the pair:

```md
:::{exercise} Title
:label: <slug>
:enumerated: true

...prompt body...
:::

[see solution](#<slug>-solution)
```

with a matching `sol_xxx.md` page in the *Appendices > Solutions* chapter
that contains an empty solution anchor:

```md
:::{solution} <slug>
:label: <slug>-solution
:::

...solution body lives as plain content below the directive...
```

Keeping the body **outside** the `{solution}` directive matters: if the
content were inside the directive, hovering the cross-reference link in
the exercise would preview the solution, defeating the purpose.

**Status of solution files:**

- `sol_fct.md` — ported (just the *First program* entry; matches the
  upstream `sol_fct.tex` 1:1).
- `sol_enum.md` — not yet ported (corresponds to *Variable price* exercise
  in `match.tex`, chapter 11, also not yet ported).
- `sol_int.md` — not yet ported (corresponds to *Overflow in hash
  function* exercise in `int_overflow.tex`, chapter 24, also not yet
  ported).

**On merge:** when a new `\begin{exercise}{X}` appears with `\autoref{sol:Y}`,
port the prompt with the directive form above and append the solution
subsection to the matching `sol_*.md` (create the file if needed).

### 10. LaTeX text macros → plain text

`\rust`, `\C`, `\cpp`, `\python`, `\R`, `\rustc`, `\cargo`, `\nix`,
`\unix`, `\windows`, `\macos`, `\linux`, `\homebrew`, `\GIL`, `\GC`, etc.
are all spelled out as plain text in the MyST port (Rust, C, C++, Python,
R, rustc, cargo, ...). Pervasive; no per-occurrence action needed on
merge — just spell things out.

### 11. Image paths

LaTeX `\IncImg{...}` resolves paths relative to the repo root.
MyST sees paths relative to each `.md` file, so all image references in
the port use `../img/...`, `../gen_img/...` or `../common/...`. The
`\CeaLogo` macro was resolved to its target file (`common/cea_logo.png`).

**On merge:** new figures need their paths rewritten with the `../`
prefix and pointed at the same source assets.

### 13. evcxr can't store top-level lets that hold non-static references

evcxr wraps each cell so top-level `let` bindings persist across cells
via a struct stored between executions. That struct cannot hold values
whose type carries a non-static reference (e.g. `&i32`, `&mut String`,
`std::slice::Iter<'_, T>`, `Option<&i32>`). The kernel error reads
roughly:

```
Error: The variable `b` contains a reference with a non-static lifetime so
```

This happens with pedagogically *correct* Rust that compiles fine under
`rustc` — the LaTeX build wraps every snippet in `fn main()`, where the
reference's lifetime is the function body, so it's a non-issue there.

**Workaround applied:** affected cells carry `:tags: [raises-exception]`
so the build keeps going. The rendered page will show an error for
demos that are not actually wrong — accept this UX trade-off, or rewrite
the cell to avoid storing the reference at top level (e.g. wrap the body
in a `{ ... }` block, or use a helper `fn`).

**Cells currently affected** (Part 3):
- `vec.md` — the explicit `iter()` walkthrough (`let mut i = v.iter()`).
- `vec_bis.md` — `let a = &v[1]` indexing demo, `let elem = v.get(0)`
  (`Option<&i32>`) demo.
- `ref.md` — five cells (every "happy path" demo that ends with a
  top-level `let b = &a` / `let t = &s` / `let u = &mut s`).

**On merge:** every time a new chapter introduces a snippet of the form
`let r = &something;` or `let it = something.iter();` where `r`/`it` is
the trailing top-level binding, expect to need `:tags: [raises-exception]`
in evcxr. Function-wrap or block-wrap if you want the demo to actually
succeed.

### 14. Directive fence convention: `:::` not `` ``` ``

Every directive other than `{code-cell}` uses colon fences (`:::{...}` /
`:::`) rather than backtick fences (`` ```{...} `` / `` ``` ``).
Backtick-fenced directives whose **title or body contains backticked
code** (e.g. `` ```{list-table} Some methods of `Vec` ``) render
unreliably with the stock `book-theme` parser; colon fences are
consistent.

Reserved for backticks:

- `{code-cell}` — required by the jupytext/jupyter-cache pipeline.

**On merge:** new directives ported from upstream LaTeX should default to
`:::` fences. Bump to `::::` (four colons) when nesting directives.
