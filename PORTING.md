# Porting notes

This file tracks how the MyST port in `with-myst/` differs from the upstream
LaTeX source, and records the reference commit we forked from.

When upstream changes, the plan is to `git diff <ref>..HEAD -- foo.tex` per
file (the file-name correspondence is 1:1) and port the delta into the
matching `.md`. The entries below flag the regions where a naïve overwrite
would lose a deliberate local choice.

## Status

**Full port complete** — every chapter from `main.tex` is now in the
MyST output. Parts covered:

- Part 1 (*Preliminaries*): 1 *Introduction*, 2 *Environment*
- Part 2 (*Basics*): 3 *Variables & constants*, 4 *Atomic types*,
  5 *Memory — Part I*, 6 *Complex types*, 7 *Syntax & control flow*,
  8 *Functions — Part I*
- Part 3 (*Fundamentals*): 9 *Macros introduction*, 10 *Dynamic types —
  Part I*, 11 *Memory — Part II*, 12 *Enum type*, 13 *Dynamic types —
  Part II*, 14 *Slices*
- Part 4 (*Proficiency*): 15 *Functions — Part II*, 16 *Memory*,
  17 *Project*, 18 *Defining custom types*, 19 *Error handling —
  Part I*, 20 *File system*, 21 *Input & output*, 22 *Testing*
- Part 5 (*Expertise*): 23 *Traits*, 24 *Generics*, 25 *Collections*
- Part 6 (*Mastery*): 26 *Advanced projects*, 27 *Defining Macros*
  (skipped — empty upstream), 28 *Bitwise operations*, 29 *Error
  handling — Part II*, 30 *Character encoding*, 31 *Documenting*

Of the *Appendices*, **Tables** is fully ported and **Solutions**
contains all three entries: *First program* (chapter 8), *Nuts price*
(chapter 12), and *Overflow in hash function* (chapter 29).

**Chapter 27 *Defining Macros* is omitted from the TOC** because
`main.tex` declares the `\chapter{Defining Macros}` heading but lists
no subfiles. There is no upstream source for it, so no `.md` was
created. When a `.tex` is added upstream, port it and re-add the
chapter entry to `myst-toc.yml`.

**`folder_mod.md` carries a local fix vs. upstream**: `folder_mod.tex`
references `src/...` paths after `cargo new --bin foo` without a
`pushd foo`, so its hidden setup cell would fail in a fresh kernel.
The MyST port adds a hidden `pushd foo` cell after the `cargo new`
step. Easy to remove once upstream patches.

**Part 4 is heavy on `\DRAFT` / `\TODO` upstream**: every chapter except
*Functions — Part II* carries draft markers, and the *File system*
chapter is essentially stubs (`pathbuf.md`, `path.md`, `osstring.md`,
`osstr.md` each have one TODO line). All draft pages render a
`:::{danger} Draft` admonition at the top.

**Mixed kernel issue in `project.md`**: the upstream `project.tex`
mixes bash cells (cargo project demos) and rust cells (`use` keyword
examples). MyST allows only one kernel per page, so the file uses the
bash kernel for the cargo demos and the rust cells appearing after
`popd` are rendered as plain (non-executable) rust fences. Pedagogical
content is preserved; execution of the rust examples is lost.

## Upstream reference

This porting wave was made against:

```
upstream: git@gitlab.com:cnrgh/teaching/rust-class.git
commit:   8426c9c
subject:  closures
date:     2026-09-18
```

Previously caught up to 201fe3409a26cb083dfef2fb46158a8dd848923a (2026-09-18).

When resuming, fetch upstream and use
`git -C <repo> diff 7834f97..<new-ref> -- <foo>.tex` per file to identify
the deltas to port into the matching `<foo>.md`.

## Local divergences from upstream

### -1. Language and "disabled" badges (cross-cutting)

Every bash cell automatically gets a small `bash` tag in its top-right
corner because the CSS keys off the existing `dark-background` class.
Rust cells do **not** get a `rust` tag (upstream LaTeX does, but we
haven't ported that yet — would need a `rust`-equivalent class
applied to every rust code-cell).

For cells we want to **display but not execute** (the upstream
`\begin{minted}[disable]{...}` convention), the MyST equivalent is
the standard `skip-execution` cell tag, combined with a `disabled`
class for the badge:

````md
```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled
some command that should be shown but not run
```
````

- `:tags: [skip-execution]` tells the jupyter-cache pipeline not to
  send the cell to the kernel.
- `:class: ... disabled` causes the `disabled` badge to appear in
  place of the language tag (the two share the right edge via the
  CSS `::after` pseudo-element).

The `disabled` cell can still combine with sequence classes
(`seq-start` / `seq-cont` / `seq-stop` + `badges` modifier) — the
sequence tag uses `::before` and the language/disabled tag uses
`::after`, so they coexist.

A demo cell is in `course_ex.md` right after the paragraph that
explains the *disabled* convention.

The old plain-fence convention (a ` ```bash ` block with no
`{code-cell}` directive) is still acceptable for one-off display-only
snippets where you don't want the dark-background styling either,
but `skip-execution` + `disabled` is now preferred when you want
the bash-cell look-and-feel without execution.

### 0. Multi-cell sequence styling (cross-cutting)

Upstream LaTeX flags multi-cell sequences with `\begin{minted}[start]{...}`
/ `[cont]` / `[stop]` and renders small badges on the right of each cell
(from `common/newminted.sty`).

In the MyST port, cells inside a sequence carry one of the role classes
`seq-start`, `seq-cont`, `seq-stop` on `:class:`, plus the two
composable style modifiers `badges border`. For **rust kernel pages**, a
hidden `{code-cell} rust` containing `:clear` (the evcxr magic) is
inserted immediately before each `seq-start` to drop persisted state
between sequences. Bash kernel pages do not get a `:clear` cell
(bash_kernel has no equivalent magic and the bash session state at the
top of a page is already empty).

The CSS that drives the badges and border lives in `_static/style_local.css`
(never edit `style.css` directly — it's regenerated).

**Gotcha — blank line after directive options.** Every `{code-cell}`
must have a blank line between its option lines (`:tags:`, `:class:`,
etc.) and the cell body. This applies to *all* code cells, not just
`:clear` resets:

````markdown
```{code-cell} rust
:tags: [raises-exception]

use std::error::Error;
use std::fs::File;
// ... body
```
````

Two reasons:

1. The compact form (body directly under `:tags:`) breaks parsing in
   jupyter lab — most visibly for cells whose body itself starts with
   a `:` (e.g. the `:clear` magic), which the parser misreads as
   another option.
2. Jupytext normalises every cell to the blank-line form on
   round-trip. Authoring without the blank line guarantees phantom
   diffs the next time anyone opens the file in jupyter lab and saves
   it back.

Always emit the blank line — this is the canonical form.

**Affected files (1 sequence each unless noted):** `bool.md`, `enum.md`,
`enum_methods.md`, `gen_enum.md`, `int_overflow.md`, `macro_derive.md`,
`match.md` (2), `lifetimes.md` (3), `ownership.md`, `sol_int.md`,
`env_compiler.md`, `fct_main.md`, `folder_mod.md`, `sol_fct.md`,
`env_cargo.md`, `project.md`, `course_ex.md`, `course_bash_ex.md`,
`course_rust_ex.md`.

**Not covered (intentional):** upstream's first `[start,disable]` cells
in `env_cargo.md` (`cargo --list`) remain plain `bash` fences in our
port — converting them to executable cells would change the
disabled-cell convention without much visual gain. The visible
seq-start lands on the next cell. Same for the *use std::time::Duration*
rust snippets at the end of `project.md` which are plain rust fences
(the page is bash-kernel; those cells stayed non-executable).

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

### 13. evcxr can't store top-level lets with non-persistable types

evcxr wraps each cell so top-level `let` bindings persist across cells
via a struct stored between executions. That struct cannot hold values
whose type either:

- carries a non-static reference, e.g. `&i32`, `&mut String`,
  `std::slice::Iter<'_, T>`, `Option<&i32>`, `&str` from a non-static
  source; or
- is *unnameable*, e.g. a closure `let f = |x| x + 1` (each closure has
  a fresh anonymous type), an `impl Trait` return type, an async block.

Typical kernel errors:

```
Error: The variable `b` contains a reference with a non-static lifetime
       so can't be persisted.

Error: Variable `f` has a type that cannot be persisted across
       executions.
```

This happens with pedagogically *correct* Rust that compiles fine under
`rustc` — the LaTeX build wraps every snippet in `fn main()`, where the
binding lives only inside the function body, so it's a non-issue there.

**Workaround applied:** affected cells carry `:tags: [raises-exception]`
so the build keeps going. The rendered page will show an error for
demos that are not actually wrong — accept this UX trade-off, or rewrite
the cell to avoid storing the reference at top level (e.g. wrap the body
in a `{ ... }` block, or use a helper `fn`).

**Cells currently affected:**

- `vec.md` — the explicit `iter()` walkthrough (`let mut i = v.iter()`).
- `vec_bis.md` — `let a = &v[1]` indexing demo, `let elem = v.get(0)`
  (`Option<&i32>`) demo.
- `ref.md` — five cells (every "happy path" demo that ends with a
  top-level `let b = &a` / `let t = &s` / `let u = &mut s`).
- `closures.md` — the closure definition cell
  (`let equal_to_x = |z| ...`) — closure type is unnameable.
- `lifetimes.md` — two cells (`let t = borrow_example(s)` and
  `let t = first_word(s)`) — return type `&str` whose lifetime evcxr
  may not infer as `'static` even when the input is a literal.
- `slices_intro.md` — four cells (all top-level slice bindings).
- `str.md` — the byte-slice cell (`let s = &my_string[0..4]`).

**On merge:** every time a new chapter introduces a top-level `let X =
expr;` where `expr` returns a reference / iterator / closure / Option
of a reference / slice / impl-Trait, expect to need
`:tags: [raises-exception]` in evcxr. Function-wrap or block-wrap if
you want the demo to actually succeed.

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

### 15. Upstream `[disable]` cells → `skip-execution` + `disabled` class

Upstream LaTeX marks non-executable code samples with `[disable]` on
`\begin{minted}`. Ported to MyST as executable cells that the kernel
skips, with a visual badge:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
// example code that won't actually run
```

For bash on a bash-kernel page, add the dark theme + language tag
classes:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled
some command that won't actually run
```

CSS in `style_local.css` emits a grey `disabled` badge in place of the
`bash` language tag (`.dark-background::after` vs `.disabled::after`
share the same slot).

**Mixed-kernel pages:** jupyter notebooks have exactly one kernel. If
a page is on the rust kernel but upstream had a `[disable]` bash cell
(e.g. `args.md`, `test_integration.md`), the bash cell stays as a
plain `` ```bash `` fence — no `{code-cell}`, no badge — because using
`{code-cell} bash` on a rust-kernel page would either be rejected or
sent to the wrong kernel. Same in reverse for bash-kernel pages with
stray rust samples.

**Exceptions kept as plain fences (intentional):**

- `memory.md` line 221 — stack-overflow demo (safety: must not run).
- `project.md` — illustrative `std::time::Duration` cells on a
  bash-kernel page.
- `course_rust_ex.md` — wrapping examples.
- `trait_impl.md` line 35 — `use foo::{...}` snippet (not strictly
  `[disable]` upstream).

### 16. Wrap-in-brackets workaround for evcxr persistence

Several cells in `ref.md`, `slices_intro.md`, `vec_bis.md` have their
body wrapped in an extra `{ … }` block, with the final trailing
expression replaced by `println!("…", …);`. This is a workaround for
evcxr-specific quirks that the LaTeX source does not have to deal
with:

- Top-level `let` bindings whose value is (or contains) a reference
  with a non-static lifetime cannot be persisted across cells. The
  kernel reports either *"The variable `x` contains a reference with
  a non-static lifetime so can't be persisted"* or *"Couldn't
  automatically determine type of variable `x`"*. Examples: cells
  defining `let b = &a;`, `let b = &mut a;`, `let slice = &a[1..3]`,
  `let a = &v[1]`, or passing `&mut s` to a function.
- Wrapping in `{ … }` makes every binding block-local, so nothing
  needs persisting; trailing expressions are switched to `println!`
  because a block-returning expression of the same type would
  reintroduce the persistence attempt.

The equivalent change has been proposed upstream (in the `.tex`
sources) so the next pass-through-upstream-commits cycle should not
re-introduce drift between this repo and the LaTeX source. If a
future upstream commit lands LaTeX cells that read like our
pre-workaround form, port them with the wrap-in-brackets shape
rather than the raw shape.

Commits applying this pass: `e735519` (`ref.md`), `3766e81`
(`slices_intro.md`), `98262ac` (`vec_bis.md`, partial).

### 17. Chapter restructuring from upstream commit `095fbc0`

Upstream commit `095fbc0` ("Write chapter Dynamic types Part II")
renamed/merged several chapters. Mapping applied to the MyST port
(file names unchanged unless noted; only `title:` in `myst-toc.yml`
and the one-line `chap_*.md` stub changed):

- *Atomic types* → **Types I** (`chap_atomic_types.md`, unchanged subfiles).
- *Complex types* → **Types II** (`chap_complex_types.md`, unchanged subfiles).
- *Enum type* → **Types III - Enumerates/Variants** (`chap_enum_type.md`,
  unchanged subfiles).
- *Dynamic types I* → **Types IV - Vec & String** (`chap_dynamic_types_i.md`,
  unchanged subfiles).
- *Dynamic types II* chapter (`chap_dynamic_types_ii.md` / `vec_bis.md`) is
  **removed**. Its content was redistributed:
  - the non-copiable-vector move/iterate demo → folded into `vec.md`'s
    updated *Iterating over elements* section (now using `into_iter()`
    and a new warning box) plus the new *Iterating over a vector's
    items* exercise (solution in `sol_mem.md`, label `vec-iter`);
  - the indexing-then-borrow demo → new *Indexing a vector* section in
    `ref.md`, with exercise `indexing-vec` (solution in `sol_mem.md`);
  - the borrow/`get()` demos → new chapter **Collections**
    (`chap_collections_i.md` / `coll.md`) under *Proficiency*, right
    after *Defining custom types*. **Careful:** there is already an
    unrelated *Collections* chapter under *Expertise*
    (`chap_collections.md` / `vec_deque.md`, `hashmap.md`, ...) — upstream
    itself reuses the bare title "Collections" for both, disambiguated
    only by their part. Do not merge the two.
  - the `MyEnum` polymorphism demo → new chapter **Polymorphism I**
    (`chap_polymorphism_i.md` / `enum_poly.md`) under *Proficiency*,
    right before *Attributes & Macros I*.
- The *Slices* chapter (previously 3 subfiles: `slices_intro.md`,
  `str.md`, `arr_slices.md`) is **merged into a single file**,
  `slices.md` (`str.md` renamed via `git mv`). Structure of the merged
  page: `slices_intro` content stays at top level (no heading), then
  `## Array slices` (ex-`arr_slices.md`, demoted one level), then
  `## String slices` (ex-`str.md`'s own `# String slices`, demoted one
  level — its own `##` subheadings became `###`). The chapter keeps its
  title *Slices* and anchor `(chp-slices)=`; the `(chp-str-slices)=`
  anchor is preserved on the `## String slices` heading so existing
  cross-references (`int.md`, `string.md`) keep working. As of this
  commit `slices.tex` still opens with its own `\chapter{Slices}`, so
  it stays a sibling chapter of *Memory II* rather than nested inside
  it — **but see the update in commit `25651b9` below**, where upstream
  demotes this to a `\section` and it folds into *Memory II* for real.
- New file `utf8.md` (chapter *Character encoding*, after `unicode.md`).
- New file `sol_mem.md` (chapter *Solutions*, after `sol_fct.md`) with
  labels `indexing-vec-solution` and `vec-iter-solution`.

**On merge:** when porting the next upstream commits, expect chapter
titles/anchors from *this* mapping (e.g. "Types I".."IV") rather than
the old ones ("Atomic types", "Complex types", ...).

### 18. `slices.md` folded into *Memory II*, from upstream commit `25651b9`

Upstream commit `25651b9` ("Write slices chapter") rewrites `slices.tex`
and, in passing, changes its top command from `\chapter{Slices}` to
`\section{Slices}`. Since `main.tex` places `\subfile{slices}` right
after `\subfile{ref}` inside `\chapter{Memory~\rom{2}}` with no chapter
break in between, *Slices* is no longer its own chapter: `slices.md` is
now the third child of `chap_memory_ii.md` (after `ownership.md` and
`ref.md`), and the now-unused `chap_slices.md` stub was deleted. The
`(chp-slices)=` anchor on `slices.md`'s own `# Slices` heading is kept
unchanged, so existing links (`ranges.md`, `vec.md`) still resolve.

Content-wise this commit also:

- Rewrites the *Array slices* subsection with real examples (was two
  `TODO`s) and adds a new *Array and slice types* table
  (`tab-array-slice-types`, a `{list-table}`, no upstream equivalent
  table existed before).
- Rewrites *String slices*: drops the *String length*, *Splitting a
  string*, *Iterating*, *Getting a slice from a UTF-8 string* and
  *Searching into a string* subsections in favour of a new *Passing
  strings to functions* subsection and a *`str` methods* subsection
  with three exercises (`str-split`, `str-iter`, `str-search`),
  solved in a new file `sol_str.md` (chapter *Solutions*, after
  `sol_mem.md`).
- The dropped *Getting a slice from a UTF-8 string* content resurfaces
  (expanded, with a `get()`-based fix) under `utf8.md` as a new
  `### Getting a slice from a UTF-8 string` subsection — `utf8.md`
  gained code cells and thus needed a `jupytext`/rust-kernel frontmatter
  it didn't have before.
- `len()`, `repeat(n)`, `get()`/`get_mut()`, `split()`,
  `starts_with()`/`ends_with()` moved from the `str`-methods table
  (`str_methods.md`) to the generic slice-methods table
  (`slice_methods.md`), since they apply to any slice, not just `str`.
- New cross-reference anchors added (all upstream `\label{...}` on
  existing sections): `(chp-arrays)=` in `array.md`, `(chp-ranges)=` in
  `ranges.md`, `(chp-vec)=` in `vec.md`, `(chp-stack)=` on `## Stack` in
  `memory.md`, `(chp-utf8)=` in `utf8.md`.
- `unicode.md`'s draft admonition gained the same two `TODO` bullets
  that were duplicated into `utf8.md` upstream (present in both files,
  intentionally, matching upstream's own duplication).

**On merge:** `slices.md` is a child of `chap_memory_ii.md`, not its own
chapter — don't recreate `chap_slices.md`.

**Bugfix folded in:** while verifying this commit with `myst build
--execute` (actually running every cell, not just checking for broken
links), the `## Getting a slice from a UTF-8 string` example added to
`utf8.md` in this same commit turned out to hit the evcxr
non-nameable-type issue below (item 13): `let s = String::from(...)` /
`s.get(...)` — wrapped in `{ ... }` to fix, no upstream-visible change.

### 19. Exercise difficulty levels — `\ExLvlOne`..`\ExLvlFive` → star rating

Starting with upstream commit `85cca2f`, some exercise titles carry a
LaTeX difficulty marker, e.g. `\begin{exercise}{Some title (\ExLvlOne)}`.
`common/ex.sty` defines these as a 5-star rating (filled/open,
`\FiveStar`/`\FiveStarOpen`): One=★☆☆☆☆, Two=★★☆☆☆, Three=★★★☆☆,
Four=★★★★☆, Five=★★★★★. The MyST port renders this literally as unicode
stars appended to the exercise title, e.g.:

```md
:::{exercise} Using two parameters in a generic (★☆☆☆☆)
:label: gen-enum
:enumerated: true
...
```

**On merge:** apply the matching star string whenever a new/changed
upstream exercise title carries an `\ExLvlN` marker; exercises without
the marker keep a plain title (unchanged convention).

### 20. Chapter restructuring from upstream commit `85cca2f` ("polymorphism")

This is the second large chapter reshuffle (see also item 17). Summary of
the moves — file names are chosen to stay stable/descriptive rather than
mirror upstream's shifting roman numerals (as already established for
"Types I".."IV" in item 17):

- *Types III* chapter (`chap_enum_type.md`) renamed "Enums & structs"
  (was "Enumerates/Variants") and gains `struct.md` as a 4th child.
  `struct.tex` itself is untouched by this commit — only its chapter
  changed.
- NEW chapter **Polymorphism I - Generics** (`chap_polymorphism_gen.md`),
  inserted right after *Types III*, before *Syntax III*: `poly.md` (new,
  "What is polymorphism?", 2 figures `media/param_poly.svg` /
  `media/runtime_poly.svg` copied from upstream's `gen_img/*.svg`),
  `generics.md` (new, "Generics" — **carries the `(chp-generics)=` anchor,
  moved off of `gen_fct.md`, which had it by accident from the old
  Expertise/Generics chapter grouping**), `gen_enum.md`, `gen_fct.md`,
  `gen_struct.md` (all three moved in from elsewhere, see below).
- NEW chapter **Syntax III - Option** (`chap_syntax_iii.md`): `option.md`,
  `if_let.md`, `while_let.md` — split out of the old *Types III* chapter.
- *Memory II* renamed "Ownership & references" (children unchanged).
- *Polymorphism I* chapter (`chap_polymorphism_i.md`, was just
  `enum_poly.md`) renamed **Polymorphism II - Runtime polymorphism**,
  gains new `trait_poly.md` (Draft, "Polymorphism with traits") as first
  child. `enum_poly.md` itself is rewritten (no longer Draft, "Polymorphism
  with enums", new `HashMap<String, Value>` dictionary example — needed
  an explicit type annotation on `dict` to dodge an evcxr
  "can't automatically determine type" error, see item 13).
- NEW chapter **Polymorphism III - Generic traits & methods**
  (`chap_polymorphism_traits.md`), inserted after *Functions II*, before
  *Memory III*: `gen_methods.md` (moved in from Expertise/Generics,
  4-space→2-space reformat + `(chp-gen-methods)=` anchor), `gen_traits.md`
  (new, empty upstream stub — rendered as a bare Draft placeholder).
- *Memory* chapter (`chap_memory.md`) renamed **Memory III - Lifetimes**.
- *Defining custom types* chapter (`chap_custom_types.md`) **removed**;
  its only child `struct.md` moved to *Types III* (see above).
- *Collections* chapter under Proficiency (`chap_collections_i.md`)
  renamed **Types V - Collections**.
- Expertise's *Generics* chapter (`chap_generics.md`) **removed
  entirely**: `gen_fct.md` and `gen_struct.md` moved to the new
  *Polymorphism I - Generics* chapter, `gen_methods.md` moved to the new
  *Polymorphism III* chapter (all above). Expertise's *Collections*
  chapter (`chap_collections.md`, vec_deque/hashmap/...) is a different,
  untouched chapter — don't confuse the two (see item 17's note on
  upstream reusing bare chapter titles).
- Appendices: `howto_env_vars.md` added to *How-tos* (new, bash-kernel,
  `source bash-setup.sh` + `(chp-howto-env-vars)=` anchor, embeds a Rust
  source file via heredoc/`rustc` rather than a `{code-cell} rust` —
  not a mixed-kernel page, the Rust code is just a string written to
  disk). `sol_gen.md` added to *Solutions* (new: "Generic enum" solving
  `gen-enum`, "Generic function for getting env vars" solving
  `gen-fct-env-var`).
- `gen_struct.md`'s last two examples (`use num_traits::Float; impl<T>
  Point<T> where T: Float {...}` and the `p1.distance(&p2)` call) use an
  external crate not available in the evcxr kernel here — kept as
  `skip-execution` + `disabled` (shown, not run), broken out of the
  cell sequence's border/badge styling since they don't execute.
- `gen_fct.md`'s `largest()` demo needed the wrap-in-braces workaround
  (item 16) on both call sites (`result` is a non-`'static` reference).

**On merge:** the two "Collections" and any future "Generics"-adjacent
chapters need their home chapter double-checked against `main.tex`
before assuming a `chap_*.md` file name — this commit alone moved
`gen_fct.md`/`gen_struct.md`/`gen_methods.md` across three different
chapters relative to where they started this porting pass.

### 21. `struct.md` full rewrite + `mod`/visibility demo moved out, from `d093d28`

Upstream commit `d093d28` ("Struct & impl") replaces essentially all of
`struct.tex`:

- The old `mod foo { struct Foo { ... } }` field-visibility demonstration
  (4 cells building up to a `new()`/`a()` accessor pair) is **moved out**
  of `struct.tex` into `sub_mod.tex` (previously just a `TODO` stub for
  *sub-modules*). Ported verbatim into `sub_mod.md`, same
  `:tags: [raises-exception]` on the first two cells as before.
- `struct.md` itself is rewritten top to bottom: intro (structs as
  records, *Fields order* note), *Regular struct* (`Book` example, Field
  Init Shorthand and Struct Update Syntax as `:::{tip}` boxes — kept as
  **prose-only admonitions**, with their code examples as ordinary
  top-level cells right after, not nested inside the `:::` fence: no
  precedent in this repo for a `{code-cell}` nested inside a directive,
  and nesting would risk breaking the `seq-*`/border CSS which assumes
  sibling top-level cells), *Methods* (instance vs. static, `self` vs.
  `Self`, `Window` example, *Builder setters* with `with_` prefix,
  *Setter methods* with `set_` prefix, `Car` example, a worked `Book`
  example with accessors, a `Square` example demonstrating
  invariant-preserving constructors), *Tuple struct* (`Color`).
- Three exercises added, all **without** an `\ExLvlN` star marker (that
  convention started in the previous commit but isn't applied here):
  `rect-area`, `rect-square`, `postal-mail` — solved in new
  `sol_struct.md` (chapter *Solutions*, between `sol_str.md` and
  `sol_gen.md`).
- All the illustrative/incomplete snippets (`fn with_size`, `fn size`,
  the exercise's bare `Rect` struct, the `Color::new().with_...()`
  chain) are upstream `[disable]` cells → `skip-execution` + `disabled`
  (item 15), same as elsewhere.
- Wording fixes rippling into other files: "N bits" → "N-bit" in
  `float.md`, `int.md`, `gen_struct.md`. New `(chp-lifetimes)=` anchor on
  `lifetimes.md` (referenced by `sol_struct.md`'s note about `Mail`'s
  `&'static str` fields).
- Chapter renames: *Project* → **Project I - Organization & definition**
  (`chap_project.md`, children unchanged); *Advanced projects* →
  **Project II - Modules** (`chap_advanced_projects.md`, children
  unchanged). The empty upstream *Defining Macros* chapter heading was
  removed from `main.tex` — no action needed, we never had a
  `chap_*.md` for it (see the *Status* section at the top of this file).

**On merge:** if a future commit adds a real "Defining Macros" chapter
with actual subfiles, it'll need a new `chap_defining_macros.md` created
from scratch (currently still intentionally absent).

### 22. Course-wide exercise review pass, from `d9b8ec6`

Upstream commit `d9b8ec6` ("Make a review of the stable part of the
course and imagine exercices") is the largest single commit ported so
far: ~60 upstream files touched. Highlights:

- **Heading de-styling, cross-cutting.** Upstream stripped `\var{...}`
  wrapping from most `\section`/`\subsection`/note/important/exercise
  *titles* (body text keeps its `\var{}`/code-span styling). Mirrored by
  removing backticks from the corresponding MyST headings/admonition
  titles across ~20 files (`array_methods.md`, `binaryheap.md`,
  `btreemap.md`, `btreeset.md`, `cargo_cmds.md`, `hashset.md`,
  `linked_list.md`, `macro_derive.md`, `option_methods.md`,
  `project_toml.md`, `slice_methods.md`, `string_methods.md`,
  `vec_deque.md`, `vec_methods.md`, `while.md`, `str_literals.md`,
  `bool.md`, `memory.md`, `project.md`, `env_compiler.md`, `for.md`,
  `if.md`, `loop.md`, `if_let.md`, `vec.md`, `env_install.md`,
  `iter_methods.md`). **On merge:** when upstream removes `\var{}` from
  a title, remove the matching backticks/code-span on our side too —
  it's cosmetic but consistent across the whole course.
- **Exercise difficulty stars added retroactively.** Several
  *pre-existing* exercises gained an `\ExLvlN` marker with no other
  change: `int_overflow.md` (★★★★☆), `ref.md` (★☆☆☆☆), `vec.md`
  (★★☆☆☆), `match.md`'s "Variable price" (★★☆☆☆), `fct_main.md`'s
  "First program" (★☆☆☆☆). New exercises across the board also carry
  their star rating per item 19 above.
- **`iter_methods.md`** finally gets real content (was a bare `TODO`):
  a `{list-table}` of ~20 `Iterator` methods (`tab-iter-methods`).
- **New chapter I/O I - Printing** (`chap_io_i.md` / `print.md`),
  inserted in *Basics* right after *Types II*, before *Syntax II*.
  `print.md` itself moves out of the *Input & output* chapter (renamed
  **I/O II**, `chap_input_output.md`) and gets a full rewrite: print
  macro table (`tab-print-macros`), several new examples (precision,
  named/unnamed markers).
- **`var_ex.md`** (new, chapter *Variables & constants*, last child):
  upstream's subfile has no `\section` of its own (just a bare
  exercise) — titled the page after the exercise itself
  (`# Constant and variable`) for TOC/tab-title purposes. Solved in new
  `sol_var.md` (chapter *Solutions*, first entry, before `sol_ctrl.md`
  and `sol_enum.md`).
- **New chapter-less solution files**, all new chapters immediately
  before/after their usual neighbours in *Solutions*:
  `sol_cargo.md` (bash kernel; "First project" — `cargo init`, `cargo
  add text2art`, rebuild, run — **verified this actually compiles and
  runs with real network access in this sandbox**, kept fully
  executable, not disabled), `sol_var.md`, `sol_ctrl.md` (Loop exercise,
  Checker, Multiple search in a string, Iterating over results),
  `sol_option.md` (Returning an Option<T>), `sol_vec.md` (Iterating over
  a vector's items — **relocated** from `sol_mem.md`, see below).
- **`sol_vec.md` bugfix:** upstream's own solution calls a non-existent
  `str::capitalize()` method. Replaced with a small working
  `capitalize()` helper (`chars().next()` + `to_uppercase()` + rest of
  the slice) that produces the same output — this is a correctness fix,
  not a style choice; flag it if upstream ever "fixes" this differently.
- **`gen_struct.md` / `sol_gen.md`: new "Integer wrapper" exercise**,
  kept `skip-execution`/`disabled` like the pre-existing `Float`/
  `num_traits` example next to it (item on `num_traits` from commit
  `85cca2f`). Verified in isolation with evcxr that (a) `:dep num-traits
  = "0.2"` **does** work in this environment (network access confirmed
  — see `sol_cargo.md` above), but (b) introducing a *new* `impl<T:
  Float> Point<T>` block on an already-`:clear`-reset generic struct
  mid-page causes evcxr to silently drop all previously bound variables
  of that type ("type of the variable was redefined, so was lost") —
  a real evcxr limitation, not a network issue. Decided **not** to
  "fix forward" and re-enable execution; kept both examples disabled,
  consistent with the prior commit's choice. Also: upstream's exercise
  text says to use `PrimInt::is_power_of_two()`, which doesn't exist on
  that trait (verified) — the solution uses `count_ones() == 1` instead
  (documented inline in `sol_gen.md`).
- **`struct.md`: "### Example" subsection (Book‑with‑accessors +
  Square demos) turned into two exercises** ("Book", "Square area"),
  their old demo code relocated verbatim into `sol_struct.md` as the
  solutions. The "Book" exercise prompt says `enum` where it clearly
  means `struct` (the solution defines a `struct`) — corrected to
  `struct` when porting (a real error, not a style choice).
- **`env_cargo.md`: new "First project" exercise** using the
  `text2art` crate, solved in `sol_cargo.md` (see above).
- Many small wording fixes ported as-is (ownership.md's
  `"hello world!"` → `"hello, world!"` comma fixes, option.md/ref.md
  phrasing tweaks, ranges.md's `Iterator` hyperlink, etc.) — no
  divergence, just keeping prose in sync.

**On merge:** this kind of "sweep across many small files" commit is
best handled by first triaging the `git show --stat` output into (a)
pure 1-line heading destyles (batch them), (b) small wording tweaks
(quick individual edits), (c) exercises/solutions (need careful
label/star bookkeeping), (d) anything touching `main.tex` (chapter
moves — always check before assuming a file's current chapter).

**Post-hoc bugfix note:** a *second*, cache-cleared `myst build
--execute` run (after porting `4d16a43`) turned up two more evcxr bugs
in this commit's `sol_str.md`/`sol_vec.md` that an earlier validation
pass had missed, plus disproved an initial hypothesis about *why*
(see item 23). **Lessons for future porting sessions:**
1. `myst build --execute` can silently reuse stale/cached execution
   results even right after an edit; when in doubt, `rm -rf
   notebooks/_build/execute` before the pass you actually want to
   trust.
2. Do **not** validate multi-line/multi-statement evcxr behavior by
   piping a heredoc to the bare `evcxr` CLI (`cat <<EOF | evcxr`) —
   that REPL treats each *line* of stdin as its own submission, which
   does not represent how the real Jupyter kernel (`evcxr_jupyter`,
   what `myst build --execute` actually drives) receives a multi-line
   `{code-cell}` fence as a single execute request. A fix that "works"
   under line-piped CLI testing may still fail for real — the only
   trustworthy signal is `myst build --execute`'s own log.

### 23. `Vec::new()` needs an explicit type annotation for evcxr persistence, even same-cell (fixed, not part of any upstream commit)

Fixed in a standalone commit (not tied to an upstream sha) right after
`d9b8ec6`:

- `sol_vec.md`: `let fruits = vec!["banana", "strawberry", "orange"];`
  (a `Vec<&'static str>`) fails evcxr's persisted-variable type
  detection ("Couldn't automatically determine type"). Fixed with an
  explicit `let fruits: Vec<&str> = ...` annotation.
- `sol_str.md`'s "Vector of strings" solution: `let mut v = Vec::new();`
  followed by `.push(...)` calls fails with `E0282: type annotations
  needed for Vec<_>`. The initial fix attempt merged what were 3
  sequenced cells (`seq-start`/`seq-cont`/`seq-stop`) into one plain
  cell, on the theory that evcxr treats a whole cell as one rustc
  compilation unit (so trailing `.push()` calls would let it infer
  `v`'s type) — **this did not fix it**: evcxr resolves and persists
  the type of every new top-level `let` at the point of that
  statement, not by looking ahead at how the binding is used later,
  even within the same cell/submission. The prose explicitly taught
  "there is no need to define the type... the compiler will wait to
  see what we put in it" — true for a real rustc compilation unit,
  false for evcxr's per-`let` persistence probing. Fixed for real with
  an explicit `let mut v: Vec<String> = Vec::new();` annotation, and
  the prose adjusted to say we specify the element type up front
  rather than claiming the compiler infers it later.

**On merge:** `Vec::new()` (or any other type that needs a generic
parameter fixed, e.g. `HashMap::new()` per item 20's `enum_poly.md`
note) assigned to a top-level `let` **always** needs an explicit type
annotation for evcxr, regardless of whether the vector is filled in the
same cell or a later one — evcxr cannot infer it from subsequent
`.push()`/`.insert()` calls the way a normal Rust compilation would.
Watch for upstream prose that emphasizes "the compiler infers the type
later" for this pattern — it needs adjusting when ported, not just the
code.

### 24. Type-related and mathematical constants, from `4d16a43`

- `float.md` / `int.md` gain a new "Type related constants" section
  each (`f32`/`f64` and `i8`..`u64` `MIN`/`MAX`/`BITS`/etc.), plus
  `float.md` gets a "Mathematical constants" section
  (`std::f32::consts`: `E`, `PI`, `FRAC_1_PI`, `GOLDEN_RATIO`) — all
  verified to compile/run with the toolchain in this environment
  (`GOLDEN_RATIO` is stable here).
- `match.md`'s "Shapes area" exercise (from `d9b8ec6`) gets a hint
  pointing at `std::f32::consts`/`std::f64::consts` for the `PI`
  constant needed to compute a disk's area.

### 25. Enum/match/methods/struct each get their own chapter, from `9be2e91`

Pure `main.tex` reshuffle, no content changes. The old "Types III -
Enums & structs" chapter (`enum.md`, `match.md`, `enum_methods.md`,
`struct.md` all together) is split into four single-page chapters:

- **Types III - Enums** (`chap_enum_type.md`, kept): `enum.md` only.
- **Syntax III - Match** (new `chap_syntax_match.md`): `match.md` only.
- **Types IV - Methods** (new `chap_types_methods.md`): `enum_methods.md`
  only.
- **Types V - Structs** (new `chap_types_structs.md`): `struct.md` only.

Everything after shifts up one roman numeral: *Syntax III - Option* →
**Syntax IV - Option** (`chap_syntax_iii.md`, file kept), *Types IV -
Vec & String* → **Types VI - Vec & String** (`chap_dynamic_types_i.md`,
file kept). *Polymorphism I - Generics* is unaffected (sits between
*Types V - Structs* and *Syntax IV - Option*).

**On merge:** `enum.md`, `match.md`, `enum_methods.md`, `struct.md` are
now each the sole child of their own chapter — don't assume they're
still grouped together.

### 26. Traits overhaul, from `8627be0` ("dyn and impl for Traits - runtime polymorphism")

Another big restructuring, this time centered on `Polymorphism II`
(Proficiency part) and the old Expertise `Traits` chapter:

- **Old `trait_intro.md`/`trait_def.md`/`trait_impl.md` deleted**
  entirely (were thin `MyTrait`/`MyStruct` drafts) and superseded by
  two much richer new files: `traits.md` (new — merges what was
  upstream's *two* `\section`s in one `traits.tex` subfile,
  "Traits" + "Defining a trait", into one page with the second demoted
  to `##`; carries the `(chp-traits)=` anchor moved off the deleted
  `trait_intro.md`) and `trait_default_impl.md` (new). Both use a
  `Surface`/`Rectangle`/`Circle` running example.
- **`trait_poly.md` completely rewritten**, dropping the old
  `Shape`/`describe()` example for the same `Surface` example, with
  new subsections *Compile-time polymorphism*, *Runtime polymorphism*
  (`dyn`, vtable explanation with an ASCII-art diagram rendered as a
  plain ` ```text ` fence — no image asset upstream, just a LaTeX
  `verbatim` block) and *Runtime polymorphism in collections*
  (`Vec<&dyn Surface>`).
- **New chapter Polymorphism III - Enum** (`chap_polymorphism_enum.md`):
  `enum_poly.md` moved out of the old "Polymorphism II" chapter (which
  is retitled **Polymorphism II - Traits**, `chap_polymorphism_i.md`
  kept, now holds `traits.md`/`trait_poly.md`/`trait_default_impl.md`).
- **Polymorphism III - Generic traits & methods** → **Polymorphism IV**
  (`chap_polymorphism_traits.md` kept, children unchanged). Gains the
  "Complex bound" illustrative snippet (`fn foo<T>(x: T) where T: Shape
  + Clone { ... }`) moved here from the old `trait_poly.md`, still
  `skip-execution`/`disabled` (references an undefined `Shape`).
- **New chapter Types VI - Pointers** (`chap_types_pointers.md`):
  `box.md` (new, Draft). Its only code sample references `Shape`,
  `Circle`, `Rectangle`, `.describe()` — none defined in the file
  (leftover from before `Shape` was retired in favour of `Surface`);
  kept `skip-execution`/`disabled`, matching its upstream Draft state —
  **do not** "fix" it to compile by inventing a `Shape` trait, that
  would be scope creep not present upstream.
- **Old Expertise "Traits" chapter deleted**
  (`chap_traits.md`, was `trait_intro`/`trait_def`/`trait_impl`/
  `trait_bounds`/`format_traits`) and replaced with:
  - `format_traits.md` **moved** to the *I/O II* chapter
    (`chap_input_output.md`, after `logs.md`) — it's referenced from
    `string.md`'s format! note, nothing else changes.
  - New **Polymorphism V - Traits** chapter (`chap_polymorphism_fields.md`,
    under Expertise): `traits_in_fields.md` (new, Draft,
    `&'a (dyn MyTrait + 'a)` field example, `skip-execution`/`disabled`
    since `MyTrait` is undefined) + `trait_bounds.md` (unchanged,
    relocated).
- **New `std_traits.md`** (Appendices > Tables, between
  `slice_methods.md` and `str_methods.md`): table of common std traits
  (`Clone`, `Copy`, `Debug`, `Display`, `Default`, `Eq`, `Ord`,
  `PartialEq`, `PartialOrd`), anchor `(chp-std-traits)=`, referenced
  from `traits.md`.
- `gen_methods.md`, `array_methods.md` (heading recapitalized to
  "Array methods"), `rust_apps.md` (crate names become crates.io
  hyperlinks, new `hexler` row, "and propose *colourful* outputs"
  wording) get minor additions/tweaks.

**On merge:** the Expertise "Traits" chapter (`chap_traits.md`) no
longer exists — check `main.tex` before assuming any trait-related
file's chapter. `format_traits.md` lives in *I/O II* now, not with the
other trait pages.

### 27. `closures.md` full rewrite — closures can never survive a cell boundary in evcxr

Upstream commit `8426c9c` replaces the old "Difference with functions"
section (two small examples, dropped entirely) with a much longer
treatment: closure syntax, passing a closure to a function (`impl
Fn(i32) -> i32`), the `Fn`/`FnMut`/`FnOnce` note, returning a closure
from a function (`make_closure`), then "Capturing variables"
(borrowing, and a mutable-variable-borrowed-by-closure error case).

**evcxr adaptation needed throughout:** per item 13, evcxr cannot
persist a `let`-bound closure across a cell boundary (unnameable
type) — and unlike the `Vec::new()` case (item 23), there is no type
annotation that fixes this, since a closure's type is fundamentally
anonymous/unnameable. Concretely this means every one of upstream's
`[cont]`/`[stop]`-sequenced cells that *defines* a closure in one cell
and *uses* it in a later cell had to be either merged into a single
cell, or have the closure's definition duplicated in the cell that
uses it. Applied here:
- `let double = |x| x * 2;` + `double(5)` → merged into one cell.
- `foo(double)` (several cells after `double`'s original definition) →
  `double` is *redefined* right before the call, in the same cell,
  since `foo` itself (a named `fn`, not a closure) persists fine on its
  own across cells — only closures bound via `let` have this problem.
- `let x = 4; let equal_to_x = |z| z == x;` + `equal_to_x(5)` → merged
  into one cell.
- The final mutable-borrow example was already a single un-sequenced
  snippet upstream; wrapped in `{ }` and tagged
  `:tags: [raises-exception]` — verified with evcxr directly that it
  reproduces the intended `E0506`-class borrow error (`x is assigned to
  here but it was already borrowed`), not an evcxr artifact.

**On merge:** any future closures-related content needs the same
treatment — a closure bound with `let` must be defined and used within
the *same* cell (or have its definition duplicated across cells);
functions (including ones returning `impl Fn`) don't have this problem
and can be split across cells freely.
