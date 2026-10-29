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

Of the *Appendices*, **Solutions** (the former **Tables** appendix
was dissolved into the body chapters, item 57)
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
commit:   8bb6efc
subject:  Bump version
date:     2026-10-27
```

Previously caught up to 754b4e2cece8da407e5fd052bd56e9ffa00f0b44
(2026-10-26).

1 more upstream commit remains to port after this one (as of this pass):
`9fbecdf` (move howtos into course).

When resuming, fetch upstream and use
`git -C <repo> diff 94eb476..<new-ref> -- <foo>.tex` per file to identify
the deltas to port into the matching `<foo>.md`.

**The `common` submodule must also be kept current.** `upstream-tex`
pulls shared macros/assets (`alias.sty`, and several `texts/howto_*.tex`
files) from a separate `courses-common` git submodule at `common/`.
Each superproject commit records a `common` pointer, but checking that
pointer out requires an *explicit* `git submodule update` (or
`git -C upstream-tex/common fetch && git -C upstream-tex submodule
update --remote common`) — it is not automatic on `git fetch`/`git
log` of the superproject alone. **This was missed for a while**: the
local `common/` checkout silently lagged several commits behind what
every superproject commit since `803b3be` actually recorded, which led
to two false "this file doesn't exist upstream" conclusions (items 56
and 59, corrected in item 62 below). On resuming, update the submodule
checkout *before* concluding that any `\subfile{howto_*}` or similar
reference is dangling.

### History: the `109-collections` branch, and how it landed on `main`

Starting from `eb55b74`, upstream opened a feature branch
`origin/109-collections`, ported here commit-by-commit on a matching
local branch `109-collections` (21 commits, `b776886` through
`cb86a30`; see the git log for the full per-commit trail — each is a
`port of <sha>: <subject>` commit). Our local `109-collections` was
kept as a strict superset of `main` throughout (rebased onto `main`'s
tip whenever `main` moved), so it never diverged.

Upstream, however, did **not** merge `origin/109-collections` into
`origin/main` as a merge/fast-forward — instead they pushed a single
new commit directly on `main`, `5fd00ab` ("Resolve \"Collections\""),
whose sole parent is the old `main` tip (`941f878`). It reproduces
most, but not all, of what `origin/109-collections` had, plus some
additional new/changed content, and `origin/109-collections` itself
was deleted upstream after the merge.

Rather than re-derive everything from `941f878` by hand, we confirmed
(via `git diff cb86a30..origin/main`, i.e. comparing upstream's actual
new commit against our own fully-ported `109-collections` tip) that
**~85% of `5fd00ab`'s content was already captured** by our 21-commit
trail (317 insertions/29 deletions remaining vs. 1433/198 for the full
naïve diff from `941f878`). Since local `main`'s tip was confirmed to
be a plain ancestor of `109-collections`' tip (no divergence — ancestor
check via `git merge-base --is-ancestor`), we fast-forward-merged
`109-collections` into `main` (zero conflicts, nothing re-done), then
ported just the small remaining delta as one final commit,
`port of 5fd00ab: Resolve "Collections"` — see the item below. End
state mirrors upstream exactly; the local `109-collections` branch is
now fully merged and redundant (left in place, not deleted).

**On merge:** if a future upstream commit again squash-merges a
feature branch we've been tracking separately, check for this same
situation first (diff the squash commit against our own branch tip,
not just against `main`) before assuming a full from-scratch port is
needed.

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

### 5. Cross-references to former appendix tables

The tables of the former *Appendices > Tables* chapter now live in the
body chapters (item 57). Mapping of LaTeX labels to MyST names, all
resolved with `{numref}`:

| LaTeX label            | MyST `:name:`        | File                |
|------------------------|----------------------|---------------------|
| `tab:CargoSubCmds`     | `tab-cargo-subcmds`  | `env_cargo.md`      |
| `tab:RustApps`         | `tab-rust-apps`      | `env_cargo.md`      |
| `table:ArrayMethods`   | `tab-array-methods`  | `array.md`          |
| `table:VecMethods`     | `tab-vec-methods`    | `vec.md` (moved from `vec_methods.md`, item 46) |
| `table:StrSliceMethods`| `tab-str-methods`    | `slices.md`         |
| `table:StringMethods`  | `tab-string-methods` | `string.md`         |
| `table:SliceMethods`   | `tab-slice-methods`  | `slices.md`         |
| `table:OptionMethods`  | `tab-option-methods` | `option.md`         |
| `tab:MacroFctLike`     | `tab-macro-fct-like` | `macro_fct.md`      |
| `table:LogicalOp`      | `tab-logical-op`     | `bool.md`           |
| `table:CompOp`         | `tab-comp-op`        | `bool.md`           |
| `table:ArithOp`        | `tab-arith-op`       | `int.md`            |
| `table:BitwiseOp`      | `tab-bitwise-op`     | `bitwise_intro.md`  |
| `table:FloatOp`        | `tab-float-op`       | `float.md`          |
| `table:IterMethods`    | `tab-iter-methods`   | `ranges.md`         |
| `table:StdTraits`      | `tab-std-traits`     | `traits.md`         |

In-file table refs (`\autoref{table:CharEsc}` in `char.tex`,
`\autoref{tab:RangeSyntax}` in `ranges.tex`) were always kept and
converted to MyST `{numref}` against `{list-table}` blocks in the same
file.

**On merge:** when porting a new table, keep the `:name: tab-…` and use
`{numref}` for the reference.

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

### 28. `gen_methods.md` rewrite + content reshuffled into `trait_bounds.md`, from `9565df2`; evcxr persistence probing is per-statement, not per-cell

Upstream commit `9565df2` rewrites `gen_methods.md` around a single
`Point<T>` running example (`Constructor (T as argument)`, `Returning a
T`), dropping the old `distance_from_origin`/"Complex bound" examples,
which move into `trait_bounds.md` as three new subsections at the end
(`Trait bound`, an empty `Where clause` stub, `Complex bound`) — all
kept `skip-execution`/`disabled` since they reference undefined
types/traits (`Point<T>` isn't defined in `trait_bounds.md`, `Shape` is
retired). `trait_bounds.md`'s pre-existing "Returning a trait" section
also moves up, right after the intro examples, ahead of "Using where
clauses".

**Important correction to the mental model from item 23:** testing
`gen_methods.md`'s final example (`let (x, y) = (p.x(), p.y()); (x,
y)`) exposed that evcxr's persisted-`let`-type resolution happens
**immediately at each `let` statement**, not deferred to "end of cell"
or "end of submission" — i.e. it is *per-statement*, not *per-cell*.
Bundling a problematic `let` and its use into the same cell/submission
does **not**, by itself, avoid a persistence failure; item 23's
"same-cell" framing was imprecise. What actually matters:
- A `let` binding whose type is a non-`'static` reference (here: `&T`
  borrowed from a local `Point<T>`) **always** fails to persist,
  regardless of grouping — confirmed by testing the exact same
  single-line submission both split across "cells" and joined with
  `;` on one line; both failed identically with "contains a reference
  with a non-static lifetime so can't be persisted."
- The fix is item 16's wrap-in-braces: `{ let (x, y) = (...); println!(...); }`
  — the block's return type is `()`, so nothing escapes for evcxr to
  try to persist. Applied here.
- Item 23's `Vec::new()`/closure cases still stand, but for a
  different, related reason: an *unresolved generic* or *unnameable*
  type also can't persist, whether alone in a cell or followed by
  clarifying statements in the same submission.

**On merge:** when a `[cont]`/`[stop]`-sequenced example ends with a
`let` binding of a non-`'static` reference, generic-still-unresolved,
or unnameable type, don't assume grouping it with its usage in one
cell is sufficient — verify with a real single-line-`;`-joined evcxr
submission (bare CLI is fine for this specific check, since the
behavior is per-statement, not per-cell/session-transport), and reach
for wrap-in-braces or an explicit type annotation as needed.

### 29. `gen_traits.md` filled in, from `7d08cdd`

Was an empty stub (just the section heading); now a full `Converter<T>`
example (generic trait, two unit-struct implementations
`CelsiusToFahrenheit`/`MilesToKilometers`, a `print_conversion<T:
Display + Copy>(conv: &dyn Converter<T>, v: T)` function). Verified to
compile/run as-is with evcxr — no adaptation needed (unit structs and
`dyn Converter<T>` with a concrete `T` per call site are all
persistence-friendly).

### 30. `lifetimes.md` full rewrite, from `b16c239`

Upstream commit `b16c239` replaces the messy draft (duplicated
"In functions"/"In structures & methods" sections, a stray generic
`longest_with_an_announcement` example) with a cleaner structure:
*What is a lifetime?*, *Function/block scope lifetimes*, *Static
lifetimes*, *Lifetimes of borrowed objects*, *Lifetimes of returned
objects*, *Explicit lifetime in functions*, *Struct lifetimes*, *Enum
lifetimes* (new — `Message<'a>` enum).

Each example was individually verified with evcxr (this file has more
lifetime/reference edge cases per line than any other page so far):

- `let m = { let n = 17; &n }; m` — this **is** a genuine `E0597`
  ("`n` does not live long enough") compile error, confirmed by
  wrapping the whole thing in `{ }` with a `println!` (which rules out
  it being merely an evcxr persistence artifact) — kept
  `:tags: [raises-exception]`.
- `let s = "abc def ghi"; let t = first_word(s); (s, t)` — this
  **does** work standalone with evcxr (verified), unlike what the
  *previous* (now-replaced) version of this file assumed when it
  tagged the equivalent cell `raises-exception`. No tag needed.
- The `Book`/`title()` struct-lifetime example (`let book = ...; let
  title = book.title(); title`) fails under evcxr with "contains a
  reference with a non-static lifetime" — but wrapping in `{ }` with a
  `println!` (item 16) proves it's a pure evcxr persistence artifact,
  not a real compile error. Fixed that way rather than tagging
  `raises-exception` (which would misrepresent perfectly valid Rust as
  broken).
- The enum-lifetime example (`m1.text(), m2.text()` as a trailing
  tuple, `m1`/`m2` being concrete `Message<'static>` enum instances)
  works fine as-is, no adaptation needed.

**On merge:** don't assume a `raises-exception` tag from a previous
version of a file still applies after a rewrite — the underlying code
may have changed enough (or the previous tag may have been
overcautious) that it's worth re-testing with evcxr directly. When a
"contains a reference with a non-static lifetime" evcxr error shows up,
always try wrap-in-braces first to check whether it's a genuine
compile error or just an evcxr persistence artifact, before reaching
for `raises-exception`.

### 31. `project.md` full rewrite, `exa` → `eza`, from `7f1bd8d`

Upstream commit `7f1bd8d` rewrites `project.tex` extensively:
- **Package** section split into **Binary package** / **Library
  package** subsections, each now `cd`s into the freshly-created
  project (`cargo new --bin foo; cd foo`, later `cargo new --lib foo2;
  cd foo2` — nested *inside* `foo`, verified this causes no error,
  cargo doesn't mind a nested unrelated package) instead of always
  prefixing paths with `foo/`. Both end by actually running the
  project (`cargo run` / `cargo test`), which the previous version
  never did.
- **Crate** section reworded, references the new *Multiple crates*
  chapter (`(chp-mult-crates)=` anchor added to `mult_crates.md`).
- **Internal module**: the entire old bash workflow (write bogus
  private-fn code, `cargo build` fails, warning box, fix with `pub`,
  rebuild, run) is **dropped**, replaced by two plain (non-executed)
  Rust snippets — matches the pre-existing "mixed kernel" convention
  for this bash-kernel page (see the *Local divergences* entry at the
  top of this file: rust snippets on `project.md` are plain fences, not
  `{code-cell}`).
- **File module**: the old "fails without `mod` declaration, here's why,
  now fixed" demo is dropped too; goes straight from a fresh `foo4`
  project to a working `mod math;` + `cargo run`, ending with a new
  note box. No more `pushd`/`popd` anywhere in this file — every
  section now creates its own fresh project and just `cd`s forward.
- **Path** section **moved up** (was last, now right after *Module*,
  before *Use keyword*), gains a new relative-path example (`arithmetic`
  sub-module, `math::double()`) and a note pointing at the new `(chp-sub-modules)=`
  anchor on `sub_mod.md` (which also gains a `TODO: explain super::/crate::`
  line).
- **Use keyword** promoted from a `###` under *Module* to a top-level
  `##`, moved to be the last section, and **drops** the bash demo
  entirely (no more `use math::add;` + `cargo run` + the final `popd`)
  — it's now purely the plain-Rust-snippet content that already
  existed (`Duration`, wildcard `*`, explicit/grouped imports), with
  the single-`LinkedList`-import example removed in favour of just the
  combined `{LinkedList, VecDeque}` one.
- `env_cargo.md`, `fct_main.md`, `project.md`: `exa` → `eza` in every
  executed tree-listing command (`exa` is unmaintained/archived
  upstream; `eza` is its actively maintained fork — matches what
  `rust_apps.md`'s table already called it, from `8627be0`).

**`eza` had to actually be installed** (`brew install eza`, pulled in
`openssl@3` as a build dependency) to test this — it wasn't present
before. `bash-setup.sh` gained `alias eza='eza --color=always'`
alongside the existing `exa` one.

**Real bug found in `eza` (v0.23.5, this environment): bare `eza -T`
(no path argument) after a `cd` prints nothing** (exit 0, empty
output) — `exa -T` (bare) always worked this way, but `eza` apparently
needs an explicit path. Verified reproducible in isolation (`cd
/tmp/x && eza -T` → empty; `cd /tmp/x && eza -T .` → correct tree).
Worked around by writing `eza -T .` everywhere a bare current-directory
tree listing was intended (`project.md`, `fct_main.md`) —
`env_cargo.md`'s calls were already using an explicit subdirectory
name (`eza -T foo`) and needed no change. Verified the whole `project.md`
bash flow end-to-end (`cargo new --bin/--lib`, `eza -T .`, `bat`,
`cargo run`/`cargo test`, the `foo4` module demo) in one real shell
session sourcing `bash-setup.sh`, and again with the `eza` alias
active.

**On merge:** if a future commit adds more `eza` invocations, always
pass an explicit path (`.` for the current directory) — don't rely on
`eza`'s bare/no-argument default in this environment.

### 32. `project_toml.md` filled in, from `eb55b74`

Was a bare `TODO` stub; now explains the `Cargo.toml` sections
(`package`/`dependencies`/`lib`/`bin`), a `{list-table}` of the
`package` section's fields (`tab-package-fields`), and a full example
`Cargo.toml` as a numbered, captioned listing. This is the **first use
in this repo of a plain (non-`{code-cell}`) numbered/captioned
listing**: MyST's `{code-block}` directive with `:name:`/`:caption:`,
cross-referenced via `{numref}`, same as `{list-table}`/`{figure}` — no
kernel/frontmatter needed since it's a `toml` listing, never executed.
Verified with a link-check build that both the table and the listing
get real enumerators (`1`) and their `{numref}` refs resolve as
`crossReference` nodes, not dangling text.

This is the last upstream commit ported in this pass — `myst` and
`origin/main` (upstream) point to the same commit as of this session;
see the *Upstream reference* block at the top of this file for
whatever the next porting pass should resume from.

### 33. Course-readiness banners get distinct colors via `:class: readiness-*` (fixed, not part of any upstream commit)

Upstream LaTeX gives each of the 5 readiness levels (`\DRAFT`=red,
`\INPROGRESS`=orange, `\TODO`=yellow, `\TOREVIEW`=light green,
`\FINALIZED`=dark green) its own color. The MyST port maps them onto
plain admonition kinds (`danger`/`warning`/`note`), and the
`book-theme` only has 4 color groups, so 3 of the 5 levels (Draft, In
progress, TODO — all `:::{danger}`) rendered identically.

Fixed by adding 5 marker classes to `notebooks/_static/style_local.css`
(`readiness-draft`, `readiness-inprogress`, `readiness-todo`,
`readiness-toreview`, `readiness-finalized`), each overriding the 3 CSS
custom properties (`--myst-color-{group}`, `-bg`, `-text`) that the
theme resolves colors from, scoped to `.myst-admonition.readiness-*`
(plus an `html.dark` variant for dark mode). Every admonition matching
one of these 5 title patterns now carries the matching class:

| Admonition | `:class:` |
|---|---|
| `:::{danger} Draft` | `readiness-draft` |
| `:::{danger} In progress` | `readiness-inprogress` |
| `:::{danger} TODO` | `readiness-todo` |
| `:::{warning} To review` | `readiness-toreview` |
| `:::{note} Finalized` | `readiness-finalized` |

The option line is inserted right after the title line, followed by a
blank line before the body (same option-then-blank-line convention as
`{code-cell}`, item 0 above), even on the ~60 pre-existing pages whose
body previously started immediately under the title with no blank
line.

**On merge:** whenever porting content that introduces or keeps one of
these 5 admonition title patterns (new file or existing one), add the
matching `:class: readiness-*` line (plus the blank line before body).
This is now a permanent step in the per-commit porting routine, not a
one-off — see the *Course-readiness banners* memory note.

Porting then continues on branch `109-collections` (see the *Upstream
reference* section above), tracking upstream's own
`origin/109-collections` feature branch.

### 34. Automatic chapter-prefix numbering, from `9d418c0` (branch `109-collections`)

Upstream introduces a new LaTeX macro `\PrefixedChapter{Prefix}{Suffix}`
(defined in `common/text.sty`, bumped submodule ref) that
auto-increments a per-prefix roman-numeral counter and replaces every
`\chapter{Prefix~\romX - Suffix}` call across `main.tex`. This is a
pure mechanism change (LaTeX macro authoring convenience) with **no
prose/content changes** — the counters happen to reproduce the exact
same roman numerals we already use almost everywhere, since our MyST
chapter titles were already hand-numbered in the same document order.

Verified this by diffing the old and new `main.tex` chapter lists
side by side (stripping numerals) to confirm ordering is unchanged,
then working out by hand what each per-prefix counter evaluates to.
Only **four** titles actually change, all because the automatic
counter doesn't "restart" a prefix per book part/section the way the
old hand-numbering sometimes did:

- `chap_attributes_macros_i.md` / "Attributes & Macros I" → **"Attributes
  and Macros I"** (the `&` becomes literal "and" — this one's a real
  wording change, not a numbering artifact).
- `chap_collections_i.md` (Proficiency part) / "Types V - Collections"
  → **"Types VII - Collections"** (the global `Types` counter had
  already reached VI by the time this chapter appears, from
  Atomic/Complex/Enums/Methods/Structs/Vec&String — the old manual
  numbering had reset to V here, out of sync with the sequential
  reality).
- `chap_types_pointers.md` / "Types VI - Pointers" → **"Types VIII -
  Pointers"** (same reason, off by two).
- `chap_collections.md` (Expertise part) / bare **"Collections"** (no
  numeral at all previously) → **"Types IX - Collections"** (this
  chapter reuses the `Types` prefix upstream now, whereas before it
  was its own unnumbered `\chapter{Collections}`).

**On merge:** if a future upstream commit adds another `Types`/`Memory`/
`Syntax`/etc. chapter anywhere in `main.tex`, don't hand-assign the
next roman numeral by guessing from nearby context — count *every*
occurrence of that exact prefix from the top of `main.tex` down to
that point, in document order, across all parts.

### 35. `coll.md` wording tweak, from `bd4fd2c`

`get()` example switched from an in-range index (always `Some`) to an
out-of-range one (`v.get(4)` on a 3-element vec, always `None`), with
matching wording. Kept the pre-existing `:tags: [raises-exception]` —
confirmed it's still needed for the same reason as before (`elem:
Option<&i32>` is a non-`'static`-reference-containing type, item 13).

### 36. Collections chapters moved from Expertise to Proficiency, split three ways, from `4c82af1`

`coll.tex` → `coll_borrow.tex` (`git mv coll.md coll_borrow.md`, no
content change), and its chapter changes prefix from `Types` to
`Memory` (**"Types VII - Collections"** → **"Memory IV - Accessing
collections"**, same file id `chap_collections_i.md` kept, still right
after *Project I*). The old Expertise chapter "Types IX - Collections"
(`chap_collections.md`: `vec_deque`/`linked_list`/`hashmap`/`hashset`/
`btreemap`/`btreeset`/`binaryheap`) is **deleted** and its seven pages
redistributed into three *new* Proficiency chapters, inserted between
`coll_borrow.md` and the (renumbered) Pointers chapter:

- **Types VII - Sequences** (new `chap_types_sequences.md`):
  `vec_deque.md`, `linked_list.md`.
- **Types VIII - Hashes** (new `chap_types_hashes.md`): `hashmap.md`,
  `hashset.md`.
- **Types IX - Trees** (new `chap_types_trees.md`): `btreemap.md`,
  `btreeset.md`, `binaryheap.md`.
- **Types X - Pointers** (was "Types VIII", `chap_types_pointers.md`
  kept, children unchanged) — shifts by two since two new `Types`
  chapters now sit before it.

After this, the Expertise part has only one chapter left
("Polymorphism V - Traits").

**On merge:** `chap_collections_i.md` is now a `Memory`-prefixed
chapter, not `Types` — don't assume its title tracks the `Types`
counter. The Expertise "Collections" chapter is gone; if upstream adds
new collection types later, check `main.tex` for which of the three
new Proficiency chapters (or a new one) they land in.

### 37. `coll_intro.md` new page, `vec_deque.md` filled in, from `06fa7e1`

New `coll_intro.md` (chapter "Types VII - Sequences", first child,
before `vec_deque.md`): overview of `std::collections`, classifying
`Vec`/`VecDeque` (array-like), `LinkedList` (list-like),
`BTreeSet`/`BTreeMap`/`BinaryHeap` (tree-like), `HashSet`/`HashMap`
(hash table). Also swaps the relative order of the "Types Sequences"
and "Memory Accessing collections" chapters back (Sequences now comes
first) — pure reordering, doesn't change either prefix's roman
numeral since no chapters were added/removed between them.
`vec_deque.md` gains two sentences (double-ended queue / growable
ring-buffer) replacing its bare `TODO`.

`vec.tex`'s diff is almost entirely `\var{...}` → `\cod{...}` (both
macros render identically — `\var` is literally defined as `\cod` in
`common/newminted.sty`) plus swapping a hardcoded `\href{...}{Vec}` for
a new `\Vec` alias macro pointing at the same URL — **no content or
rendering change**, so `vec.md` needed no edits at all.

**On merge:** a `\var{X}` → `\cod{X}` diff with no other change is a
no-op for us (same backtick rendering) — don't spend time on these,
just confirm via `grep`/diff that nothing else changed in the hunk.

### 38. `vec_deque.md` gains method list + diagram TODOs, from `01a434a`

Small wording fix in `coll_intro.md`. `vec_deque.md` gains a
`push_front()`/`push_back()`/`pop_front()`/`pop_back()` bullet list and
a 3-item `TODO` (LIFO/FIFO/ring-buffer diagrams) — the next few
upstream commits (`471e3ca` "Draw diagrams", `16fd304` "Center
diagrams", `f983aea` "Add figure ref") fill these in, so don't be
surprised when this TODO shrinks/disappears shortly. `\listoffigures`/
`\listoftables` and the `\Vec` → `\VecStruct` macro rename are
LaTeX-only, no action.

### 39. Two ASCII-art figures in `vec_deque.md`, from `471e3ca`

Two LaTeX `\begin{figure}` blocks with `\begin{verbatim}` box-drawing
diagrams (stack push/pop, queue push/pop) — no real image asset,
same situation as the vtable diagram in `trait_poly.md` (item 26), but
this time with a `\label`/`\caption` upstream (`fig:Stack`, `fig:Queue`)
that a later commit (`f983aea`) cross-references. Ported as MyST
`{code-block} text` with `:name:`/`:caption:` (same numbered/captioned
listing pattern as item 32's `project_toml.md`, `kind: code`) rather
than a plain fence, specifically so the upcoming `{numref}` reference
has something to resolve to. The upstream `TODO` list right above
these (LIFO/FIFO/ring-buffer diagrams) is **not** cleaned up even
though 2 of its 3 items are now fulfilled — ported faithfully,
matching upstream's current (slightly redundant) state; don't
"fix" it preemptively.

### 40. Stack diagram element order corrected, from `16fd304`

Mostly a LaTeX-only change (`minipage`+`verbatim` → `BVerbatim` for
centering, no MyST equivalent needed). The one real content change:
the "LIFO (stack)" diagram's element order (top to bottom) was
`13/47/5/10`, now `10/5/47/13` — a real correction to the illustration,
applied verbatim to our `{code-block}`.

### 41. Figure cross-reference, from `f983aea`

The "Do a diagram of a LIFO" `TODO` item is replaced by a sentence
referencing the stack figure via `{numref}` — ported with the same
trailing `...` upstream left (an intentionally unfinished draft
sentence, not a typo to fix). The other two `TODO` items (FIFO/
ring-buffer diagrams) remain.

### 42. `coll_borrow.md` split into `coll_borrow.md` + new `safe_access.md`, from `8dae87a`

`coll_borrow.tex` ("Accessing & borrowing collections", 2 subsections)
is split in two:

- `coll_borrow.md` retitled **"Borrowing a collection"**, kept as the
  *second* child of "Memory IV - Accessing collections". Its example
  is now self-contained (`let mut v = vec![1, 2, 3]; let elem = &v[0];
  v.push(10); (elem, v)` — previously `v`/`i` were undefined,
  presumably always erroring for the wrong reason). Verified with a
  single-line-joined evcxr submission that this **is** a genuine
  `E0505` ("cannot move out of `v` because it is borrowed") — kept
  `:tags: [raises-exception]`.
- New `safe_access.md` ("Safe access to elements" — upstream's actual
  title is "Safe access to a elements", a clear grammar slip; wrote
  correct English instead of porting the typo, since this is prose we
  author, not verbatim quoted text), inserted as the *first* child of
  the same chapter. Two subsections: "Vector" (the `get()` example,
  moved here verbatim from the old `coll_borrow.md`, "out-of-range" →
  "index is out of range") and "Map" (new, bare `TODO` stub).
- `coll_intro.md` retitled "Collections" → **"Collections overview"**.

**On merge:** "Memory IV - Accessing collections" now has two pages,
`safe_access.md` then `coll_borrow.md`, in that order — don't assume
it's still a single page.

### 43. `vec_deque.md` ring-buffer explanation + 2 new figures, from `c02b7e2`

Both remaining `TODO` items on this page ("Do a diagram of a FIFO",
"Do a diagram of a ring-buffer") are resolved: the truncated "A stack,
... see fig:Stack, ..." sentence is completed, a new paragraph
introduces the queue figure, and two new ASCII-art figures are added
(`fig-growable`: how a `VecDeque` copies into a bigger buffer when it
grows; `fig-ring-buffer`: front/back pointers wrapping around a fixed
buffer over three snapshots in time) — same `{code-block} text` with
`:name:`/`:caption:` pattern as the existing `fig-stack`/`fig-queue`
(item 39). The `TODO` admonition is now fully resolved and removed.

Ported the closing sentence **"*Growable* means"** verbatim, including
its being cut off mid-thought — this is upstream's own draft-in-
progress state (confirmed by reading the raw `.tex`, not a porting
mistake), matching this repo's convention of not "fixing" prose we
don't author. `\VecStruct` (a macro not yet seen in this repo, defined in the main
repo's `rust_alias.sty`, not the `common` submodule) renders as plain
`Vec`, matching the existing convention for type-name macros.

**On merge:** if a future commit finishes the "*Growable* means..."
sentence, port the completion normally — no special handling needed,
it's just a paragraph that currently ends early.

### 44. `vec_deque.md` finished (intro, complexity annotations, growable/ring-buffer explanation), from `4d960dc`

Follow-up to item 43 — this is the commit that actually finishes the
"*Growable* means" sentence, plus a lot more:

- New intro sentence with the `VecDeque` acronym expansion ("VECtor
  Double Ended QUEue") and a brand new figure, `fig-vecdeque`, showing
  all 4 methods (`push_front`/`push_back`/`pop_front`/`pop_back`) on a
  single queue diagram with 𝒪(1) annotations — inserted **before**
  `fig-stack`, not after.
- Each method bullet gains a one-line description and an overall
  "performance is in 𝒪(1)" note. **Fixed a copy-paste error while
  porting**: upstream's own text says `pop_back()`: "*push* an item
  from the back of the queue" (should obviously be *pop* — every other
  bullet's description verb matches its method name) — this is a
  factual/typo fix, not a style choice, matching this repo's existing
  precedent for correcting genuine upstream mistakes (e.g. item 21's
  "Book" exercise enum→struct fix, item 22's `sol_vec.md`
  `str::capitalize()` fix).
- `fig-stack`/`fig-queue` ASCII art both gain 𝒪(1) annotations next to
  their arrows (cosmetic, ported verbatim).
- The "*Growable* means" sentence (left incomplete in item 43) is
  finished: "means it automatically expand[s] when the underlying
  storage is full. However this implies a *copy* operation, whose
  performance is in 𝒪(n)." **Fixed a grammar slip while porting**:
  upstream literally has "it automatically expand" (missing the `s`) —
  corrected to "expands", same rationale as above (finished, non-draft
  prose — item 43's note about *not* touching the sentence while it was
  still a fragment no longer applies now that it's complete).
- New paragraph introducing `fig-ring-buffer` (this figure existed
  already from item 43 but had no prose referencing it yet): "the
  *start* and *end* of the queue move in a circular way" to get 𝒪(1)
  push/pop despite the underlying array being fixed-size until a
  growth/copy is needed. Upstream's own LaTeX has an unmatched-brace
  typo here (`\autoref{fig:RingBuffer} means` — missing the closing
  `}`); ported with the reference correctly closed
  (`` {numref}`fig-ring-buffer` ``), since MyST's directive syntax
  doesn't have LaTeX's brace-matching leniency.
- `fig-growable`'s ASCII art gains 𝒪(1)/𝒪(n) annotations.
- The old closing sentence "It is implemented as a growable
  ring-buffer." is **removed** by upstream (redundant now that the
  growable/ring-buffer behavior is explained in full above it) —
  removed here too.

**Note (not fixed, upstream's own choice):** `fig-vecdeque` (new in
this commit) and `fig-queue` (pre-existing) share the exact same
caption text, "A FIFO (queue)" — looks like it could be an oversight,
but it's not a clear-cut factual error like the two above, so ported
faithfully rather than silently changed.

**On merge:** `fig-vecdeque` is a genuinely new anchor — don't confuse
it with the pre-existing `fig-queue`, they're different figures with
(currently) identical captions.

### 45. `vec_deque.md` methods table + ring-buffer note, from `9c0b00e`

- New `tab-vecdeque` list-table (~20 methods), same
  `{list-table}`/`:name:`/`:header-rows:`/`:align: center` pattern as
  the existing `str_methods.md`/`slice_methods.md` tables. Intro
  sentence rephrased slightly from upstream's literal "a list of most
  important VecDeque's methods" (awkward word order) to "a list of
  some of `VecDeque`'s most important methods" — a clarity tweak, not
  a factual correction like item 44's two fixes.
- The ring-buffer paragraph (added in item 44) is reworded by upstream
  itself, replacing "start"/"end" with "front"/"back" for consistency
  with the rest of the page — ported as reworded, verbatim, no
  independent judgment call needed here.
- New `:::{note} Indices` admonition (upstream's `\begin{note}{...}`
  maps directly to MyST `:::{note}`, distinct from `\begin{important}`
  → `:::{warning}`, item 2's rule).
- `fig-ring-buffer` ASCII art: front/back labels swapped in the first
  two snapshots, and the third snapshot gains a second `17` value
  (demonstrating a value wrapping around the ring-buffer) — ported
  verbatim.

**Correction to this repo's own previous port (item 44), found while
re-reading the full current upstream file for this commit:** `fig-
vecdeque` had been placed right after the intro paragraph, *before*
the "A stack, or LIFO..." paragraph. Re-checking upstream's actual
`vec_deque.tex` shows it belongs *after* that paragraph and *before*
`fig-stack` — the figure sits between the stack topic sentence and the
stack diagram, which is what upstream's source has always shown (a
misreading of the diff context, not an upstream change). Fixed here,
forward, rather than rewriting the already-committed item-44 history
(this is an unpublished local branch, but the fix doesn't need a
history rewrite to be correct).

**On merge:** if a future commit adds more methods to the `VecDeque`
table, keep the alphabetical-by-method-name ordering upstream uses.

### 46. `vec_methods.md` deleted, its table moved (and expanded) into `vec.md`, from `ec77c0f`

The standalone `Vec methods` appendix page (`table:VecMethods` /
`tab-vec-methods`) is removed; an **expanded** version of the same
table (now with method parameters shown, plus new `append(other)`,
`dedup()`, `truncate(sz)` rows) is inlined directly into `vec.md`,
right after its intro paragraph and before "## Empty vector" — same
`:name: tab-vec-methods` label preserved, so the existing
`{numref}`tab-vec-methods`` cross-reference in `vec.md` itself keeps
resolving with no change needed (confirmed no other file references
this table or `vec_methods.md`).

- Removed `vec_methods.md` from `myst-toc.yml`'s *Tables* appendix
  chapter and `git rm`'d the file.
- **Fixed a copy-paste error while porting**: the new table's
  `resize(sz, v)` row says "Resizes the *queue* to size..." — copied
  verbatim from the `VecDeque` methods table (item 45) without
  adapting "queue" to "vector". Corrected, same rationale as the other
  copy-paste fixes in items 44/45.
- `vec_deque.md`'s `fig-vecdeque` diagram (item 44) gains a small
  `get()  O(1)` annotation with a downward arrow — ported verbatim.

**On merge:** `table:VecMethods` now lives in `vec.md`, not
`vec_methods.md` — the mapping table in item 5 above has been updated
to reflect this; don't recreate a `vec_methods.md` file if upstream
references it again, check `vec.md` first.

### 47. `linked_list.md` filled in + `vec_deque.md` reshuffled again, from `0e76e33`

**`linked_list.md`** (was a bare `TODO` stub): intro paragraph, a new
`:::{warning} LinkedList vs Vec` admonition (upstream's own
`\begin{important}{...}`, per item 2's rule — `important` maps to
`warning`, not `note`), a new `fig-linked-list` diagram (push/pop at
both ends, 𝒪(1) annotations), and a `tab-linked-list` methods table
(same `{list-table}` pattern as the `VecDeque`/`Vec` tables). **Fixed a
typo while porting**: upstream's own figure caption is "A doubly-linked
list)" — a stray, unmatched closing parenthesis — corrected to "A
doubly-linked list".

**`vec_deque.md` reshuffled a third time.** Upstream keeps
repositioning `fig-vecdeque` across these last few commits: item 44
first placed it right after the intro paragraph; item 45's port
"corrected" that to *after* the "A stack..." paragraph, believing the
first placement had been a porting mistake — but re-reading this
commit's full file shows upstream itself moves it *back* to right
after the intro paragraph (before the methods bullet list), which is
where item 44 originally (correctly, as it turns out) had it. Neither
this repo's item-44 nor item-45 placement was a mistake — upstream
has simply moved this figure more than once across consecutive
commits; each port matched its commit's actual state at the time.
Also in this commit: `fig-stack` and `fig-queue`'s own ASCII art swap
which end (front/back) is used for push vs. pop (e.g. `fig-stack`
was `push_front()`/`pop_front()`, now `push_back()`/`pop_back()`) —
ported verbatim, and the "ring-buffer feature" paragraph + `Indices`
note move from *before* `fig-growable` to *after* it.

**On merge:** don't assume `fig-vecdeque`'s position is stable —
upstream has moved it 3 times across items 44/45/47; always re-check
the current full `vec_deque.tex` rather than trusting the position
from the last port.

### 48. `hashmap.md` full rewrite (Draft → To review) + chapter reorder, from `00f5022`

**`hashmap.md`** goes from a `\DRAFT` stub to a fully-written page —
new intro, a `fig-hashmap` bucket diagram, a `tab-hashmap` methods
table, and one long `seq-start`/`seq-cont`.../`seq-stop` sequence (10
cells) replacing the old, disconnected per-section snippets.

- **New admonition mapping**: upstream introduces `\begin{danger}{Index
  out of range}` — a genuine content warning (indexing a missing key
  panics), not a readiness marker. Mapped to plain `:::{danger} Index
  out of range` with **no** `:class: readiness-*` (the repo-wide
  propagation script only ever matched the 3 exact readiness title
  patterns, so this is naturally excluded — a `:::{danger}` block can
  coexist as ordinary content-warning styling alongside the readiness
  system without conflict).
- **First use of LaTeX math in this repo**: upstream's `\begin{note}`
  admonition has inline `$\alpha$` and a display equation
  `\[\alpha = \frac{n}{m}\]` — ported as standard MyST/KaTeX
  `` $\alpha$ `` inline and `` $$\alpha = \frac{n}{m}$$ `` display math
  (no special repo convention needed, this just works).
- **evcxr fix needed, not in the original 2-cell form**: upstream's
  "Updating an existing value" section is two separate `[cont]` cells
  (`let count = scores.entry(...).or_insert(0);` then, after a prose
  paragraph, `*count += 1;`). `or_insert()` returns a non-`'static`
  `&mut V`, so — per item 13/16 — it can't survive a cell boundary.
  Verified directly against the real kernel that merging into *one*
  cell (without wrapping) still fails identically (matches item 28's
  finding: same-submission doesn't help for non-`'static` references
  either). Fixed with the established wrap-in-braces pattern: merged
  both cells (and their two paragraphs' worth of narrative) into one
  `{ ... }` block ending in a `println!` showing the incremented
  count. `scores` itself (the persisted top-level `HashMap`) is
  unaffected and still correctly mutated afterward — verified `scores`
  reflects the increment in the next (`stop`) cell.
- `HashMap::new()` needed **no** explicit type annotation this time
  (unlike the old draft's version, and unlike item 23's `Vec`/`HashMap`
  precedent) — verified directly: since the evcxr rebuild earlier this
  session (0.21.1 → 0.22.0), a bare `HashMap::new()` followed by
  `.insert()` calls in the same cell now infers fine. Item 23's
  guidance to default to an explicit annotation still stands as the
  safe choice for *future* ports — this is a note that the exact
  boundary of what needs one may have shifted with the evcxr upgrade,
  not a blanket lifting of that guidance.

**`linked_list.md` and `vec_deque.md`** each gain small new stub
subsections (`## Create`, `## push/pop`, plus `## Searching` and
`## split_off` for `linked_list.md` only), each a bare `:::{danger}
TODO` — same pattern as any other unwritten subsection. **Fixed a
copy-paste error while porting**: upstream's `split_off` subsection
TODO literally says "show push/pop() usage" (copied from the section
above it) — corrected to reference `split_off()`.

**Chapter reorder**: `main.tex` moves the "Memory IV - Accessing
collections" chapter (`safe_access.md`, `coll_borrow.md`) from *before*
"Types VIII - Hashes" to *after* "Types IX - Trees" (right before
"Types X - Pointers"). Mirrored in `myst-toc.yml`. No chapter numerals
change — "Memory" and "Types" are different `\PrefixedChapter` prefixes
with independent per-prefix counters (item 34), and no *other*
same-prefix chapter sits between the old and new positions of either
one.

**On merge:** `hashmap.md`'s "Updating an existing value" section is
now a single merged cell/paragraph, not two — if upstream edits either
half, check whether the merge still makes sense before splitting it
back apart (it can't be split without reintroducing the evcxr error).

### 49. `hashset.md` intro sentence, from `e9c880b`

Small, matches the same pattern as `hashmap.md`'s and `hashset.md`'s
own earlier bare stubs: one intro sentence, banner goes from
`:::{danger} TODO` to `:::{warning} To review`. No code, no figures,
no tables yet — just the opening sentence.

### 50. `hashset.md` filled in, `hashmap.md` tweaked, from `5683783`

**`hashmap.md`** (small fixes/additions, no new content):
- Section retitled "Hash Maps" → "HashMap", gains a
  `(chp-hashmap)=` anchor (upstream adds `\label{chp:HashMap}`,
  referenced from the new `hashset.md` content below).
- The `Performance` note gains `:name: hashmap-performance`.
  **Fixed a real upstream authoring bug while porting**: upstream's
  edit was `\begin{note}{performance}\autoref{HashMapPerformance}` —
  an `\autoref` (not `\label`) stuffed into the note's title argument,
  which cannot possibly work as a real LaTeX cross-reference (nothing
  named `HashMapPerformance` is ever defined with `\label`). This is
  almost certainly upstream trying to add a link target for the new
  `hashset.tex` content's `\autoref{HashMapPerformance}` references and
  getting the macro backwards. Ported the *intent* (a working
  cross-reference from `hashset.md` to this note) via a proper
  `:name:`/`` [text](#hashmap-performance) `` link instead of the
  broken source.
- The "verify" code block converts from a plain ```` ```text ```` fence
  to real display math (`` $$k1 = k2 \Rightarrow ...$$ ``) — upstream's
  own style change, ported as such.
- `get(k)`'s table row: `Option<V>` → `Option<&V>` (upstream fixing its
  own earlier mistake — `get()` on a `HashMap` returns `Option<&V>`,
  never `Option<V>`).
- Minor grammar fix ("let the compiler infer" → "is to let the
  compiler infer") ported verbatim.

**`hashset.md`** goes from a 2-sentence stub to a full page: intro
extension linking to `hashmap.md` (both the new `(chp-hashmap)=` anchor
and the `hashmap-performance` note), a `fig-hashset` bucket diagram
(simpler than `HashMap`'s — single values, no key/value pairs), a
`tab-hashset` methods table (~17 methods), a new `:::{warning}
Important features` admonition listing set-operation math notation
($\setminus$, $\cap$, $\triangle$, $\cup$, $\subseteq$, $\supseteq$,
$\emptyset$), and one 10-cell `seq-start`/`seq-cont`.../`seq-stop`
sequence (create, `from()`, `contains()`, `union()`/`intersection()`/
`difference()`/`symmetric_difference()`, `is_subset()`/`is_superset()`/
`is_disjoint()`). Verified the entire sequence directly against the
real kernel before writing it up — no evcxr persistence issues this
time (every binding here is either a plain owned value or immediately
consumed within its own cell).

**Fixed 3 more clear upstream typos while porting** (not stylistic
choices — plain typos in finished, non-draft prose): "if it exits" →
"if it exists"; "the values o this set" → "the values of this set";
"put them inside a the new `HashSet<&str>`" → "puts them inside the
new `HashSet<&str>`" (also fixed the subject-verb agreement to match
"The `collect()` method... puts").

**On merge:** `hashmap-performance` is now a real, working named
target (`:name:` on the note admonition) — if upstream ever properly
adds its own `\label{HashMapPerformance}` in a later commit, treat it
as confirming (not superseding) this fix.

### 51. `linked_list.md` filled in, from `99584b8`

Replaces the 4 bare `TODO` subsections (`## Create`, `## push/pop`,
`## Searching`, `## split_off`) with real content — gains a rust
kernelspec frontmatter (its first real code). New/renamed sections:
"Creating a new instance" (`LinkedList::new()` + `push_back()`,
`LinkedList::from([...])` array constructor), "Concatenating" (new,
`append()`), "Pushing & removing" (new, `push_front()`/`pop_back()`),
"Searching" (`Iterator::position()`, two variants of
`Iterator::find()` demonstrating the double-reference
(`&&T`)-vs-single-reference-plus-deref pattern), "Splitting" (renamed
from "split_off", `split_off()` returning both halves as a tuple).
Verified the full 10-cell sequence directly against the real kernel
before writing it up — no evcxr issues, every binding is either
consumed same-cell or a plain owned value that persists fine.

`tab-linked-list`'s `append(other)` row updated to `append(&other)`
with a corrected description ("Moves all elements from another
`LinkedList` into this one" — matches the trait signature and actual
behavior, not the old "Appends another... object to this one", which
undersold that it's a *move*, not a copy/append-by-value).
`split_off(i)`'s description gains detail about what the returned
list contains. **Fixed a grammar typo while porting**: "The
`split_off()` method cut a list" → "...method *cuts* a list"
(subject-verb agreement, plain typo not a style choice).

Small unrelated tweak bundled in this same upstream commit:
`hashset.md`'s `Important features` admonition method signatures gain
`&` (`difference(other)` → `difference(&other)`, etc., matching what
`tab-hashset` already had) — ported the same fix.

**On merge:** upstream's own diff has `autoref{chp:Vec}` (missing the
leading backslash on `\autoref`) in this commit's `linked_list.tex` —
a real LaTeX typo, harmless for us since we always port the *intent*
(a link to the Vec page) as `` [Vec type](#chp-vec) ``, not the raw
macro call.

### 52. `vec_deque.md` filled in, small `linked_list.md` wording, from `a635d7c`

Same pattern as item 51, one chapter behind: replaces `vec_deque.md`'s
2 remaining bare `TODO` subsections (`## Create`, `## push/pop`) with
real content — "Creating a new instance" (`VecDeque::new()` +
`push_back()`, `VecDeque::from([...])` array constructor) and
"Pushing & removing" (`push_front()`/`pop_back()`). Verified the
4-cell sequence directly against the real kernel first — no issues.

**Caught a real gap while build-verifying**: `vec_deque.md` never
had a `jupytext`/`kernelspec` frontmatter block — harmless while the
page was all figures/tables/prose (items 43-45), but now that it has
real `{code-cell} rust` blocks the build failed with "Notebook does
not declare the necessary 'kernelspec' frontmatter key". Added the
same rust-kernel frontmatter block `linked_list.md` already got in
item 51.

Small unrelated tweak bundled in this commit: `linked_list.md`'s
"Pushing & removing" intro sentence reworded ("We push back or front
an element in the list at any time" → "We can push back or front an
element in the list") — ported verbatim.

Same upstream `autoref{chp:Vec}` (missing backslash) typo as item 51,
same handling (ported as the intended `` [Vec type](#chp-vec) `` link).

### 53. `btreemap.md` filled in (near-identical structure to `hashmap.md`) + `btreeset.md` gains a figure, from `ada59fb`

**`btreemap.md`** goes from a bare `TODO` stub to a full page,
structurally almost identical to `hashmap.md` (item 48): intro (B-tree
specific this time — `Ord` trait requirement, per-node key capacity
$K$, 𝒪($\log_K(n)$) iteration), a `fig-btreemap` tree diagram (not a
bucket diagram), a `tab-btreemap` methods table (mostly the same
methods as `HashMap`'s, minus the 𝒪(1)-time annotations since B-tree
operations are 𝒪(log n), plus two B-tree-specific methods:
`range(r)` and `split_off(k)`), then the *exact same* worked-example
flow as `hashmap.md` (create, ownership/clone note, `get()`, indexing
+ danger box, iterating, replacing, `entry().or_insert()`, then the
increment-via-`or_insert()` sequence). Verified the whole sequence
directly against the real kernel first, rather than assuming it'd
behave like `HashMap` just because the API shape matches — it does
behave identically, including needing the exact same item-48
wrap-in-braces fix for `let count = ...or_insert(0); *count += 1;`
(a non-`'static` `&mut V` still can't cross a cell boundary, same as
for `HashMap`).

**Fixed a grammar typo while porting** (`split_off(k)`'s description):
upstream's "The current is modified to contains all elements..." —
missing a noun after "current" and a stray "s" on "contain" — corrected
to "The current map is modified to contain all elements...".

**`btreeset.md`** stays a bare `TODO` stub for now, just gains a new
`fig-btreeset` tree diagram (same shape as `fig-btreemap` but with
single values instead of key/value pairs) — upstream added the figure
ahead of writing the prose that will reference it.

Small unrelated tweak bundled in this commit: `hashmap.md`'s "Adding a
value if no key present" section — "the `Entry` struct" → "the `Entry`
structure" — ported verbatim.

**On merge:** if BTreeSet's intro prose arrives in a later commit
before this figure gets a caption/cross-reference from the text, check
whether the figure needs repositioning relative to the new prose (same
situation `vec_deque.md`'s `fig-vecdeque` went through in items
44/45/47 — don't assume the figure stays where item 53 left it).

### 54. `btreeset.md` filled in (predicted in item 53) + a complexity-notation fix, from `cb86a30`

**`btreemap.md`**: the iteration-complexity bullet changes from
𝒪($\log_K(n)$) to 𝒪($\log(n)$) — dropping the base-$K$ subscript is
the mathematically correct simplification (Big-O drops constant
multiplicative factors, and $\log_K(n) = \log(n)/\log(K)$ — a genuine
correction, not a style choice) — ported verbatim.

**`btreeset.md`** gets its intro prose (the figure arrived one commit
early, in item 53, exactly as flagged). **Fixed two clear copy-paste
errors while porting**, both in the same paragraph:
- "The `BTreeSet` is a *B-tree* data structure that stores **key/value
  pairs** in an ordered way" — copy-pasted from `btreemap.md`'s
  identical sentence; a `BTreeSet` stores plain values, not key/value
  pairs. Corrected to "stores values".
- "The main features of a `BTreeMap` are:" — literally names the wrong
  type (`BTreeMap` instead of `BTreeSet`) in a `BTreeSet` page's own
  intro. Corrected.

Also **fixed the methods table's identity**: upstream's own LaTeX has
`\caption{Some methods of \HashSet}` / `\label{table:HashSet}` on this
*new* `BTreeSet` table — copy-pasted from `hashset.tex` and never
updated, which would collide with the *already-existing*
`table:HashSet` label from `hashset.tex` itself (a real duplicate-
label bug upstream). Named it `tab-btreeset` / "Some methods of
`BTreeSet`" instead, consistent with every other collection page's
naming in this repo.

The methods list itself is (correctly) near-identical to `HashSet`'s
own table — same API shape, just ordered. Carried forward the same 2
typo fixes already applied to `hashset.md` in item 50 ("if it exits" →
"if it exists", "the values o this set" → "the values of this set"),
since this table is a copy of that one and inherited the same typos.

**On merge:** `table:BTreeSet`/`tab-btreeset` is the correct
label/name for this table going forward — if upstream's own LaTeX
ever gets a proper unique label here, treat it as confirming this fix,
not superseding it (same pattern as item 50's `hashmap-performance`
fix).

### 55. Delta port after `109-collections` landed on `main` as a squash commit, from `5fd00ab`

See the "History" note in the *Upstream reference* section above for
how this commit was handled (fast-forward-merge `109-collections` into
`main`, then port just the remaining delta rather than everything).
Content of that delta:

- **`binaryheap.md`**: brand new page (was a bare `TODO` stub) — intro
  (max-heap concept, complexity bullets), a `fig-maxheap` tree diagram,
  a `tab-binaryheap` methods table, and a `seq-start`/`seq-cont`.../
  `seq-stop` worked example (create, `from()`, `append()` to merge two
  heaps, `peek()`/`pop()`). Verified the whole sequence directly
  against the real kernel — no issues. Upstream references an
  undefined `\MaxHeap` LaTeX macro (never defined anywhere in the
  source tree, including the `common` submodule) — rendered as plain
  *max-heap* text instead of a broken/missing macro expansion. Also
  **fixed a typo while porting**: "If we remote it with `pop()`" →
  "If we remove it with `pop()`".
- **`btreemap.md`**: `fig-btreemap` gains a third tree level (existing
  content, figure only got more detailed) — ported verbatim; small
  wording fix to `append(&other)`'s description ("Moves the elements
  of *others*" → "of *another map*").
- **`btreeset.md`**: gains the full worked-example flow it was
  missing (items 53/54 only had intro/figure/table) — same
  create/`from()`/`contains()`/combining-methods/comparing-methods
  shape as `hashset.md` (item 50), figure gains a third tree level.
  Verified the sequence directly against the kernel (identical
  behavior to `HashSet`, as expected). New `tab-btreeset` rows
  (`first()`, `last()`) and `&`-reference fixes on several existing
  rows (`contains(&v)`, `get(&v)`, `remove(&v)`, `take(&v)`) — matches
  a parallel set of fixes upstream also applied to `hashset.tex` in
  this same commit (see below). New `:::{warning} Important features`
  admonition (same content/pattern as `hashset.md`'s).
- **`hashmap.md`**: new demo inserted between the "Ownership of keys
  and values" warning and "Getting a value" — constructing a `HashMap`
  from two `Vec`s via `.into_iter().zip(...).collect()`. Verified
  against the kernel, no issues. Small wording fix ("Entry struct" →
  "Entry structure", bundled in this commit, mirrors item 53's
  `btreemap.md` wording).
- **`hashset.md`**: same `&`-reference fixes as `btreeset.md`
  (`contains(&v)`, `get(&v)`, `remove(&v)`, `take(&v)`), two new rows
  (`first()`, `last()`), and gains a trailing `Add exercise` `TODO`
  (previously had none). **Fixed a typo while porting**: upstream's
  own new edit has `contains(v\&)` (ampersand *after* the parameter,
  backwards) — corrected to `contains(&v)`, consistent with every
  other reference-taking method in the same table.
- **`safe_access.md`**: fills in the "Map" `TODO` subsection — a
  3-cell sequence (create a `HashMap`, index with `[]`, `get()`) plus
  a separate standalone cell demonstrating that indexing an unknown
  key *panics* (tagged `raises-exception`, verified against the kernel
  — genuine panic, not an evcxr artifact).
- `rust_alias.sty` gains a `\BinaryHeap` macro (supports the new page
  above) and a `common` submodule bump (no content impact).

**On merge:** the `109-collections`-branch PORTING.md items above
(33-54) and this item both describe real, already-applied state — no
further action needed for them; resume normal per-commit porting from
`5fd00ab` onward.

### 56. Box chapter written, new `boxed_trait.md` and `sol_box.md`, from `961c19c`

**`box.md`** goes from a `Draft` stub (one disabled snippet) to a full
page: what a `Box` is, "Putting an object in a Box" (a `Book` struct
with many fields, builder-style `with_*` methods, moving it into a
`Box`), "Size of a Box", "Passing a Box", "Is Box really useful?" (with
the by-value `print_price_per_page` variant kept as a
`skip-execution`/`disabled` cell, as upstream's `[disable]`), and two
`:::{warning}` admonitions (upstream's `egin{important}`). Also a new
exercise "Type size" (`box-struct-size`, solution in the new
`sol_box.md`, item 9's exercise/solution pattern). The whole
`start`/`cont`.../`stop` sequence was verified against the real kernel
first: it all runs as-is.

**Real upstream factual errors fixed while porting** (verified with
`std::mem::size_of::<Book>()`, which is **120**, not upstream's 86):
- `String` and `Vec<T>` are 3 words (24 bytes: pointer, capacity,
  length), not 2 words (16 bytes) as upstream's solution states; also
  its list says `i16: 8 bytes` (it is 2, and the sum used 2). Corrected
  in `sol_box.md`: 24×4 + 8 + 2 + 8 + 4 = 118 bytes, padded to 120 by
  8-byte alignment.
- Consequently the prose figures in `box.md` ("Compared to the 86
  bytes of our `Book`... 10 times lighter", "instead of storing 86
  bytes, we store only 10 bytes") became "120 bytes... 15 times
  lighter" and "120 bytes... only 8 bytes" (a `Box` is 8 bytes,
  upstream's "10 bytes" was inconsistent with its own "8 bytes" two
  sentences earlier).
- "an array of 40000 32-bit integers (i.e.: 320MB)" is off by orders of
  magnitude (40000 × 4 bytes = 160 KB, which would not overflow a 1 MiB
  stack). Changed to "40 million 32-bit integers (i.e.: 160MB)" — a
  guess at the intended magnitude, worth reporting upstream.
- Typo "instead the object on the stack, we stored it" → "instead of
  storing the object on the stack, we store it".

**Missing upstream file (CORRECTED — see item 62)**: `box.tex` (twice)
says `See \autoref{chp:Word} to learn about what is a word`, and
`main.tex` adds `\subfile{howto_sizes}` to the How-tos — this was
reported here as **`howto_sizes.tex` does not exist**, but that was
wrong: the file lives in the `common` submodule
(`common/texts/howto_sizes.tex`), which our local checkout had never
been updated to fetch (see "Upstream reference" above). At the time, we
did not create a `howto_sizes.md`; the exercise text instead defined
the term inline ("a *word* is the natural unit of data of the
processor (8 bytes on a 64-bit architecture)") and the second reference
(in "Size of a Box") was dropped. **Fixed in item 62**: `howto_sizes.md`
now exists and both references link to it properly.

**`boxed_trait.md`** (new, in *Polymorphism V - Traits* between
`traits_in_fields.md` and `trait_bounds.md`; anchor `(chp-boxed-trait)=`
for upstream's `\label{chp:BoxedTrait}`, linked from `box.md`): a
`Shape` trait with `Circle`/`Rectangle`, first collected as
`Vec<&dyn Shape>`, then as `Vec<Box<dyn Shape>>`. **evcxr adaptation
needed (item 13/16 again)**: verified directly that the
`let shapes: Vec<&dyn Shape> = vec![&circ, &rect];` cell fails ("contains
a reference with a non-static lifetime so can't be persisted") — the
same limitation as `trait_poly.md`'s `Vec<&dyn Surface>`. Fixed by
merging upstream's two cells (build the reference vector + loop over
it) into one `{ ... }` block; the `Box` version afterwards persists
fine (owned values) and keeps its own separate loop cell.

**`sol_vec.md`**: upstream fixes its own exercise — item 22's
`capitalize()` workaround (for the non-existent `str::capitalize()`)
is no longer needed. The exercise now asks to print the strings in
*upper case* (`to_uppercase()`), accepts `&str` or `String`, and the
solution became a 3-cell sequence (create, loop, `fruits.len()` to show
the vector is intact). `let fruits = vec![...]` now needs **no** explicit
`Vec<&str>` annotation (item 23's annotation is unnecessary since the
evcxr upgrade, see item 48's note). `vec.md`'s exercise text updated to
match.

Small items: `traits_in_fields.md` gains a trailing `Add exercise` `TODO`;
the *Pointers* chapter (`chap_types_pointers.md`) becomes **"Memory V -
Pointers"** (was "Types X - Pointers"; upstream's `main.tex` now uses
the `Memory` prefix — item 34's per-prefix counter gives V, after IV
*Accessing collections*; no other chapter's numeral shifts since
nothing with the `Types` prefix follows it). `rust_alias.sty` was
renamed `rustalias.sty` (adds `\BoxStruct`, `\Deref`, `\DerefMut`) —
no content impact, macros are rendered as plain text/links as usual.

### 57. Tables moved from the appendix into the chapters, from `aa480d0`

Upstream dissolved `\chapter{Tables}` (13 subfiles) into the body text.
Ported one-to-one, each `{list-table}` keeping its `:name:` (so the
existing `{numref}` refs stay valid):

- `cargo_cmds` and `rust_apps` → `env_cargo.md` (with upstream's
  reworded "Most of them are replacement for standard Unix commands...").
- `macro_fct_list` → `macro_fct.md`; `bool_ops` → `bool.md` (logical
  table after the *Logical operators* intro, comparison table after the
  *Comparison operators* intro); `int_ops` → `int.md` (arithmetic, with
  its three footnotes) and `bitwise_intro.md` (bitwise, footnote *d*);
  `float_ops` → `float.md`; `array_methods` → `array.md`;
  `iter_methods` → `ranges.md`; `option_methods` → `option.md`;
  `slice_methods` and `str_methods` → `slices.md`; `string_methods` →
  `string.md`; `std_traits` → `traits.md`.
- Deleted the 13 appendix pages and `chap_tables.md`, and the *Tables*
  entry of `myst-toc.yml`. Consequently the `(chp-iter-methods)=` and
  `(chp-std-traits)=` anchors are gone: `for.md` and `traits.md` now use
  `{numref}` on the tables, as upstream now does. The local `index.md`
  no longer lists *Appendices > Tables*.
- The `:::{danger} In progress` banners of `array_methods` and
  `slice_methods`, the `TODO` banner of `std_traits` ("Show existing
  traits for primitive types") and the standalone `Return type` warning
  of `str_methods` (upstream folded its text into the *`str` methods*
  box) were not carried over, since upstream dropped them with the pages.
- New text: "...and *slice* for the full list" style links to the Rust
  docs (array, slice, str, String, Enum Option, Range, Iterator) —
  upstream's new `\Array`, `\Slice`, `\Str`, `\String`, `\Iterator`,
  `\Range`, `\EnumOption`, `\CmpModule`, `\OpsModule` macros are
  rendered as plain links; the *Traits* section gains the paragraph on
  the `cmp`/`ops` modules.
- Captions of the collection tables/figures (`Some methods of Vec`,
  `An example of a max heap`, ...) are now plain text without inline
  code, as upstream's captions no longer use link macros.
- Upstream typos not carried over: missing `\\` after the `du-dust`
  row of `\RustApps` (rows would merge in LaTeX; ported as separate
  rows) and `chain(other` without `)` (kept as `chain(other)`).

### 58. Error handling chapter written, Option moved under Error handling, Threading and Visitor pattern chapters added, from `e056a95`

Upstream's biggest single commit so far: a full rewrite of the
*Error handling* chapters, a reshuffle of where `Option` lives, a
reordered *File system* chapter, and two new one-page chapters
(*Threading*, *Design > Visitor pattern*). Most of the changed `.tex`
files (`array`, `bitwise_intro`, `bool`, `btreemap`, `btreeset`, `char`,
`coll_summary`, `env_cargo`, `float`, `hashmap`, `hashset`, `int`,
`int_repr`, `linked_list`, `macro_fct`, `macro_fct_list`, `print`,
`project_toml`, `ranges`, `slices`, `string`, `vec`, `vec_deque`,
`why_rust`) only touched LaTeX table formatting (`table`+`tblr` →
single `tblr[long, caption=.., label=..]`) and renamed labels
(`table:Foo`/`tab:Foo` → `tab:Foo`); these have no MyST-visible effect
(our `{list-table}` were already in that shape) and were not re-ported.
`traits.md`'s intro sentence ("almost any data type can implement a
trait: *structs*, *enums*, ...") became a bullet list, and its
`cmp`/`ops` paragraph now links "ops traits" instead of spelling out
"Traits" — both carried over.

**`Option` moves from `Syntax` to `Error handling`**: upstream splits
the old combined "Syntax IV - Option" chapter (`option`, `if_let`,
`while_let`) into `Error handling I - Option` (just `option.md`) and
`Syntax IV - If/let & while/let` (`if_let.md`, `while_let.md`), both
still inside the *Fundamentals* part, in the same place as before.
Renamed `chap_syntax_iv_option.md` → `chap_syntax_iv_if_while_let.md`
and added `chap_error_handling_i_option.md`. `option.md`'s intro drops
the Wikipedia "Option type" aside in favor of a direct link to the
`Option<T>` doc page, and its methods table grows substantially
(`and`, `and_then`, `cloned`, `copied`, `ok_or`, `ok_or_else`, `or`,
`or_else`, `transpose`, `unzip`, `xor`, `zip`; `map(v, f)` →
`map_or(v, f)`; `take(p)` → `take_if(p)`). Added anchor
`(chp-option)=` for upstream's `\label{chp:Option}` wanted by
`err_prop_auto.tex` (a label upstream references but still never
defines anywhere — we supply it since we have the natural target,
same as the `howto_sizes`/`chp:Word` case in item 56).

**`Error handling` chapter rewritten from scratch**: the old
`chap_error_handling_i.md` (`err_intro`, `err_unrec`, `err_rec`,
`result`, `question_mark` — all `Draft`/stub pages) is replaced by
three new chapters, renumbering the whole `Error handling` sequence
(global counter, same mechanism that numbers `Syntax I`..`IV` across
parts):

- **`Error handling II - Panic & Result`** (`chap_error_handling_ii_panic_result.md`,
  renamed from `chap_error_handling_i.md`): new `panic.md` (the
  `panic!()` macro, `unwrap()`/`expect()`/`unwrap_or()`/
  `unwrap_or_else()` on `Option`, disabling stack unwinding) and a
  fully rewritten `result.md` (anchor `(chp-result)=`, a
  `tab-result-methods` table, the `fact()`/`combination()` example as
  a `seq-start`/`cont`/`stop` sequence, a `map()` note, a `match`
  handling section, an `unwrap`/`expect` section reusing the `foo()`
  pattern, and a closing `TODO: Add exercise` banner).
- **`Error handling III - Propagation`** (new
  `chap_error_handling_iii_propagation.md`): new `err_prop_manual.md`
  (manual `match`-based propagation of a custom `MyError` enum through
  `fact()`/`combination()`, one `seq-start..stop` sequence) and new
  `err_prop_auto.md` (the same example rewritten with the `?`
  operator; replaces `question_mark.md`, which is deleted — its old
  `last_char_of_first_line` example is not carried over, upstream
  dropped it for this one).
- **`Error handling IV - Error trait`** (new
  `chap_error_handling_iv_error_trait.md`): new `error.md` (a custom
  `MyError` struct implementing `Debug`/`Display`/`Error`, one
  `seq-start..stop` sequence) and new `err_box.md` (`Box<dyn Error>`
  polymorphism over two different error types via the `?` operator in
  `read_floats()`/`do_stuff()`).

`err_intro.md`, `err_unrec.md`, `err_rec.md` and `question_mark.md` are
deleted. The old `chap_error_handling_ii.md` (`err_msg_alloc`,
`int_overflow`, in *Mastery*) is renamed `chap_error_handling_v.md`
(content unchanged) to reflect its new slot in the global numbering.

All seven new/rewritten pages' Rust cells were run against the real
`evcxr` kernel before porting (not guessed):
`panic.md`'s `"abcdef".find('h').unwrap()`/`.expect(...)` panic as
expected (`raises-exception`); the `fact()`/`combination()` sequences
in `result.md`, `err_prop_manual.md` and `err_prop_auto.md` all behave
as upstream describes (`combination(12, 15)` hits the forbidden
negative `fact(n-r)` call and returns `Err`); `error.md`'s `Display`/
`Error` impls and `err_box.md`'s `try_reserve`/`parse::<f32>()`
propagation both run cleanly.

**File system reordered, new `File` page**: children of
`chap_file_system.md` reordered to `path`, `pathbuf`, `osstr`,
`osstring`, `file` (new). `file.tex` is `err_rec.tex` renamed
(`git diff --find-renames` shows 57% similarity): it keeps `err_rec`'s
"check the error type"/"detailed version"/`?`-operator/one-liner
`disable`d snippets, drops its "Using unwrap and expect" subsection,
and appends `err_intro.tex`'s "returning an error from `main()`"
example (`err_intro.tex` itself is deleted, folded in here).
**Real upstream bug fixed while porting** `file.md`'s first (non-
disabled) example: `Err(error) => panic!(...)` binds the success value
to `f` (`Ok(file) => file`), but the following line calls
`file.read_to_string(...)` — `file` doesn't exist outside the `match`
arm, and `f` itself isn't declared `mut`. This fails to *compile*, not
just panic. Fixed to `let mut f = match ...` and `f.read_to_string(...)`;
verified against the kernel that it now panics as intended
(`File::open` on a nonexistent path) and documents it here rather than
silently diverging from upstream.

**New one-page chapters**: `Threading` (new `chap_threading.md`, in
*Mastery* before `Project II - Modules`, matching
`\chapter{Threading}` right before `\PrefixedChapter{Project}{Modules}`)
holds new `future.md` — two `TODO` stubs (`Future`, and
`(chp-poll)=`-anchored `Poll`, upstream's `\label{chp:Poll}`). `Design`
gains new `visitor_pattern.md` as a second child after
`builder_pattern.md` — anchor `(chp-visitor-pattern)=` for upstream's
`\label{chp:VisitorPattern}` (currently unreferenced) and
`(chp-control-flow)=` for `\label{chp:ControlFlow}` (referenced by
`err_prop_auto.md`), with a single `TODO` stub under `ControlFlow`.

**On merge**: the `Error handling` chapter numbering is a *global*
counter across `\PrefixedChapter{Error handling}{...}` occurrences
regardless of part — same as `Syntax I`..`IV`. If upstream inserts
another `Error handling`-prefixed chapter anywhere in the book, every
`chap_error_handling_*` file after that insertion point needs its
roman numeral (and title) bumped, mirroring what happened here to the
old `chap_error_handling_ii.md` → `chap_error_handling_v.md`.

### 59. Enums/Structs/Methods split and reshuffled, Match/if-let merged, from `803b3be`

A large "Corrections & precisions" commit. Three kinds of change mixed
together:

**Pure LaTeX table reformatting, no content change** (verified
byte-identical prose, `\var{}` → `\cod{}` only): `array`, `bitwise_intro`,
`bool`, `btreemap`, `btreeset`, `char`, `coll_summary`, `float`, `hashmap`,
`hashset`, `int`, `int_repr`, `linked_list`, `macro_fct`, `macro_fct_list`,
`print` (table only; see below for real print.md content), `project_toml`,
`ranges`, `slices`, `string`, `vec`, `vec_deque`, `why_rust` — not
re-ported, the MyST `{list-table}`s were already in that shape.

**`enum.md` split into `enum_type.md` + `tagged_union.md`** (matching
upstream's `enum.tex` → `enum_type.tex`/`tagged_union.tex` split), same
content, upstream's own typo "Tagger unions" → "Tagged unions" fixed.

**`struct.md` (483 lines, one file) split into 8 pages**, each upstream
section becoming its own subfile: `struct_intro.md` (just the
`# Introduction` prose), `regular_struct.md`, `tuple_struct.md`
(moved right after `regular_struct.md`, no longer trailing the whole
chapter), and — now under a brand new **`Functions II - Methods`**
chapter instead of the old **`Types IV - Methods`** — `methods.md`
(the `# Introduction` splitting static/instance methods),
`instance_methods.md`, `static_methods.md`, `builder_setters.md`,
`setter_methods.md`, and the pre-existing `enum_methods.md` (content
untouched, just relocated here). Verified byte-identical prose/code
throughout (just `\var{}` → `\cod{}`); our existing local fixes
(`year: i16 = 1949` type annotation, "application window", "next
section", etc.) were preserved across the split, not reverted.

**Chapter renumbering cascade** — since `Types IV - Methods` no longer
exists as a `Types`-prefixed chapter (it's now `Functions`-prefixed),
every subsequent `Types`-prefixed chapter shifts its roman numeral down
by one, and since the new `Functions II - Methods` is inserted before
the old `Functions II` (`memory_passing_value`/`closures`), that one
becomes `Functions III`:

| Old file (old title) | New file (new title) |
|---|---|
| `chap_types_v_structs.md` (Types V) | `chap_types_iv_structs.md` (Types IV) |
| `chap_types_vi_vec_string.md` (Types VI) | `chap_types_v_vec_string.md` (Types V) |
| `chap_types_vii_sequences.md` (Types VII) | `chap_types_vi_sequences.md` (Types VI) |
| `chap_types_viii_hashes.md` (Types VIII) | `chap_types_vii_hashes.md` (Types VII) |
| `chap_types_ix_trees.md` (Types IX) | `chap_types_viii_trees.md` (Types VIII) |
| `chap_types_iv_methods.md` (Types IV) | deleted — content now in `chap_functions_ii_methods.md` |
| `chap_functions_ii.md` (Functions II) | `chap_functions_iii.md` (Functions III) |

**`if_let.md`/`while_let.md` rewritten, merged with `match.md` into one
chapter**: `chap_syntax_iv_if_while_let.md` (its own chapter, right
after `Error handling I - Option`) is deleted; `if_let.md` and
`while_let.md` move into `chap_syntax_iii_match.md`, renamed
`chap_syntax_iii_if_let_match.md`, retitled "Syntax III - If/let, match
& co", ordered `if_let.md`, `while_let.md`, `match.md`. Both pages get
wholly new examples: `if_let.md` now uses a `Speed` tagged union
(`Miles`/`Km`/`Unknown`) across three sub-sections (plain `if/let`,
"Returned value", `let/else`); `while_let.md` now uses a `Measure`
tagged union (`Value`/`Nil`) driven by a `get_measure()` function, with
the infinite-loop warning now a plain `:::{danger}` box (was inline
text). Both pages' old `Option`-based examples and their exercises
("Multiple search in a string", "Iterating over results") move to a new
"Usage with if/let & co" section at the end of `option.md` — the
solutions (`sol_ctrl.md`) were untouched upstream, only the exercise
*text* moved, so no solution changes needed. All new Rust cells run
against the real kernel; `let mut i = 0;` needed an explicit
`let mut i: usize = 0;` (evcxr infers each top-level `let` from its own
statement, and `i` is only used as a `usize` argument two cells later).

**`match.md` reorganized**: "Missing cases" and "Using variables" move
from *after* the "Variable price" exercise to *before* it. "Using
variables"'s example changes from `match i { n if ... }` directly on the
loop variable to `match double(i) { n if ... }` (new `double()` helper
function, `n @ 0..5` → `n @ 0..7`, input array gains a `5`). New
"Handling floats" subsection added after it (float-range matching, then
`if`-guarded float matching), still before the exercise.

**`option.md` methods table expanded**: `and`, `and_then`, `cloned`,
`copied`, `ok_or`, `ok_or_else`, `or`, `or_else`, `transpose`, `unzip`,
`xor`, `zip` added; `map(v, f)` → `map_or(v, f)`; `take(p)` →
`take_if(p)`. Intro paragraph drops the Wikipedia "Option type" aside
for a direct doc link.

**`traits.md`**: "almost any data type can implement a trait: *structs*,
*enums*, ..." → a bullet list; the `cmp`/`ops` paragraph's "Traits"
link reworded to "ops traits" (upstream's new `\OpsTraits` macro).

**`print.md`**: new "Printing of simple objects"/"Printing of complex
objects" subsections; a new "named markers" example
(`{a} - {b}`, `b=12.34, a=789`) added next to the existing unnamed-markers
one; the old single-cell tuple pretty-print example becomes a
`seq-start`/`cont`/`stop` sequence (define the tuple, print with `{t:?}`,
then `{t:#?}`), replacing the old direct-to-`:#?` jump. Verified against
the kernel.

**`env_cargo.md`**: the "Initializing a project inside a Git repository"
subsection (manually `git init foo2` + `cargo init --bin foo2`) is
replaced — `cargo init --bin foo` in this environment's cargo version
already creates `.git`/`.gitignore` automatically, so the new text
instead runs `ls -a foo`, explains the auto-created `.git`/`.gitignore`,
and runs `pushd foo; git status` to show the untracked files. All
subsequent `foo2` references (`cargo build`, `cargo run --bin foo2`,
...) become plain `foo`, and the `pushd` that used to happen in the
"Building the project" section now happens here instead. Verified end
to end against a real `cargo init`/`git status` run in this environment.

**`syntax.md`** gains a new "Naming conventions" subsection with a
`tab-rust-naming` table. Upstream's own text references
`\autoref{chp:Naming}`, pointing at a `howto_naming.tex` file that
`main.tex` now also `\subfile{}`s. **CORRECTED in item 62**: this was
reported here as "the file does not exist, neither in this repo nor
in the `common` submodule" — wrong, same root cause as the
`howto_sizes.tex` case (item 56): a stale local `common/` checkout.
The dangling reference was ported without a link at the time; item 62
fixes it to a proper link.

**`fct_main.md`**'s "First program" exercise and `sol_ctrl.md`'s wording
("print the selected versions" → "prints the selected versions" in
`env_cargo.md`'s dependency exercise) get minor copy-edit/bullet-list
formatting, carried over.

**Appendices > How-tos reordered**: `howto_cargo_inst_crate.md`,
`howto_env_vars.md`, `howto_missing_tools.md`, `howto_path.md`
(alphabetical, matching upstream's new `main.tex` order — `howto_naming`
and `howto_sizes` still excluded, neither exists).

**Self-discovered defect, fixed where touched by this pass**: a
`{code-cell} rust` cell whose last (or only) statement is a bare
`print!()` with no trailing newline produces **no visible output at
all** in the rendered site — evcxr's stdout redirection only flushes on
a newline-producing write, and a cell's buffered-but-unflushed output is
silently dropped at cell end (does not leak into the next cell either;
verified with the real kernel). `for.md` already had three such cells
(pre-existing, unrelated to this upstream pass except one line);
`while_let.md`'s new `while/let` example and the `while/let`-on-`Option`
example newly added to `option.md` both have the same shape. Fixed all
three by appending a same-cell `println!();` after the loop (matching
the pattern `syntax.md` already used). **Not yet fixed**: the same
pattern also exists, untouched, in `closures.md`, `loop.md` (×2),
`sol_enum.md`, `sol_str.md`, `vec.md` (×2) — flagged for a follow-up
pass, out of scope here.

### 60. OsStr/OsString and Path/PathBuf merged and filled in, File system reclassified as I/O, Expertise part moved earlier, new Memory VI stub chapter, from `42ca04b`

**`osstr.md`** goes from a `Draft` stub to "OsStr & OsString" (merging
in `osstring.tex`'s content, which is deleted upstream): the
Rust-vs-OS string encoding differences, `tab-os-str`/`tab-os-string`
tables, and three `OsString` construction examples (`::from`, `.into()`,
`::new()` + `.push()`). **`path.md`** similarly goes from stub to
"Path & PathBuf" (merging in `pathbuf.tex`, also deleted upstream):
`tab-path`/`tab-path-buf` tables, no code examples upstream. Local
`pathbuf.md` and `osstring.md` are deleted (upstream drops the standalone
pages entirely, not just moves their content — confirmed via
`git show <sha>:osstring.tex` / `:pathbuf.tex` both failing "does not
exist"). All three new `OsString` cells run against the real kernel.

**File system reclassified under I/O, and renumbered**: the old
chapter-less `File system` chapter (`path`, `pathbuf`, `osstr`,
`osstring`, `file`) becomes `\PrefixedChapter{I/O}{File system}` with
only `osstr`+`path` as children (`pathbuf`/`osstring` gone, `file`
moved out — see next). Since this is the first new `I/O`-prefixed
chapter inserted before the pre-existing plain `\PrefixedChapter{I/O}{}`
(`io`/`args`/`logs`/`format_traits`), that one becomes "I/O III" (was
"I/O II"), and gains `file.md` as its second child (right after `io.md`).
Renamed `chap_file_system.md` → `chap_io_ii_file_system.md` (title
"I/O (ii) - File system"), `chap_io_ii.md` → `chap_io_iii.md` (title
"I/O (iii)").

**The `Expertise` part boundary moves much earlier**: upstream moves
`\part{Expertise}` from right before `Polymorphism V - Traits` (after
`Testing`) to right after `Memory IV - Accessing collections` (before
`Memory V - Pointers`/`box.md`). Concretely, `chap_memory_v_pointers.md`
(box), `chap_error_handling_ii_panic_result.md`,
`chap_error_handling_iii_propagation.md`,
`chap_error_handling_iv_error_trait.md`, `chap_io_ii_file_system.md`,
`chap_io_iii.md` and `chap_testing.md` all move from the *Proficiency*
part to the *Expertise* part in `myst-toc.yml` (ahead of
`chap_polymorphism_v_traits.md`, unchanged content/position otherwise).
No chapter numbering is affected by this (part boundaries are a
MyST/our-TOC-only concept; upstream's `\PrefixedChapter` counters are
global and don't reset per `\part`).

**New stub chapter "Memory VI - Pointers again"** (new
`chap_memory_vi_pointers_again.md`, in *Mastery*, right before
`Threading`): three new one-page `TODO` stubs, `cow.md`, `rc.md`,
`arc.md` (`Cow`, `Rc`, `Arc`).

### 61. `fs.md` (new, replaces `io.md`) and `file.md` rewritten, `path.md` gains real examples, I/O chapter split in three, from `aef71de`

**`io.md` deleted**, replaced by new **`fs.md`** ("File system functions"):
a `tab-file-system` table of `std::fs` module functions
(`copy`/`create_dir`/`read`/`write`/...), then a `seq-start..stop`
sequence covering writing a whole file (`std::fs::write`), reading it
back (`std::fs::read_to_string`), getting its size via
`file.metadata()?.len()`, checking existence (`exists()`),
`is_file()`/`is_dir()`, and creating folders
(`create_dir`/`create_dir_all`).

**`file.md` rewritten from scratch** (was a `TODO` stub with one
real example about recoverable errors, now a full "File" chapter):
`tab-file`/`tab-read`/`tab-seek`/`tab-write` tables for the `File`
struct and the `Read`/`Seek`/`io::Write` traits it implements; a
`seq-start..stop` sequence covering write mode (`File::create()`,
`File` object fields, a security-issue warning linking
[Bugs Rust Won't Catch](https://corrode.dev/blog/bugs-rust-wont-catch/#don-t-trust-a-path-across-two-syscalls)
— new `refs.bib` entry, inlined as a plain link per item 6's
convention), `OpenOptions` (with its own `tab-open-options` table), and
the `write!()`/`writeln!()` macros; a second `seq-start..stop` sequence
covering closing a file (drop-based), appending, read mode (with a
mutability-of-`file` warning), and the `BufRead` trait / `BufReader`
line-by-line reading (`tab-buf-read` table, with a
no-mutability-needed warning since the file is moved, not borrowed);
and finally a standalone example checking the `io::Error`/`io::ErrorKind`
returned by `std::fs` functions, opening-or-creating a file depending on
`ErrorKind::NotFound`. All of this (old `file.md`'s "returning an error
from `main()`" example, the "check the error type"/"detailed
version"/`?`-operator/one-liner `disable`d snippets) is gone, superseded
by the richer narrative above — nothing carried over verbatim.

**`path.md` gains real executable examples** after each of its two
tables: for `Path`, a `seq-start..stop` sequence (`Path::new()`,
`file_name()`, `extension()`, `file_stem()`, `with_extension()`, an
`is_empty()` warning comparing an empty path vs. a non-empty one); for
`PathBuf`, a continuing sequence (`PathBuf::new()`, `push()`,
`to_path_buf()`), plus a closing `TODO: Add exercise`. `path.md` gains
jupytext/kernelspec frontmatter (it had none, no code cells before).
`osstr.md`'s intro gains a parenthetical on which module `OsStr`/
`OsString` live in — **upstream says "part of `std::fs` module", which
is wrong** (confirmed via the `\href` targets already in the same
file: both are `std::ffi::OsStr`/`std::ffi::OsString`); ported as
"part of the `std::ffi` module" instead.

**Self-discovered hygiene issue, fixed**: `fs.md` and `file.md` are the
*first* pages in this whole port whose Rust cells actually touch the
real file system (`std::fs::write`, `File::create`, `create_dir`, ...).
Unlike bash-kernel pages, which already `cd $(mktemp -d)` via
`bash-setup.sh` (sourced in a `remove-cell`), there was no equivalent
isolation for the Rust kernel — verified directly that an evcxr kernel
with no such setup writes into whatever directory the Jupyter server
was launched from (i.e. `notebooks/`, polluting the repo on every
build). Fixed by adding, as the first statement of each page's
`remove-cell`/`:clear` setup, a `std::env::set_current_dir()` into a
freshly-created `std::env::temp_dir()` subdirectory. **Caveat found
while testing**: evcxr's `:clear` command resets the working directory
back to the kernel's launch directory (not just the compiled
variables/functions) — confirmed directly. `file.md` uses `:clear`
twice more (between its three independent `seq-start..stop` groups), so
the same `set_current_dir` snippet is repeated after each `:clear`,
not just once at the top of the page.

**I/O chapter split in three**: the old plain `\PrefixedChapter{I/O}{}`
(`io`, `file`, `args`, `logs`, `format_traits`) is replaced by `fs`/
`file` moving into the *same* chapter as `osstr`/`path`
(`\PrefixedChapter{I/O}{File system}`, our `chap_io_ii_file_system.md`,
now with 4 children), plus two new chapters: `\PrefixedChapter{I/O}
{Command line & logs}` (`args`, `logs` — new `chap_io_iii_cmdline_logs.md`,
title "I/O III - Command line & logs") and `\PrefixedChapter{I/O}
{Formatters}` (`format_traits` alone — new `chap_io_iv_formatters.md`,
title "I/O IV - Formatters"). The old `chap_io_iii.md` ("I/O III",
untitled) is deleted.

### 62. Retrofit: `howto_sizes.md` and `howto_naming.md` (the `common` submodule had never been updated)

Triggered by an explicit ask to pull the `common` submodule. Running
`git submodule update --remote common` moved the local checkout from
`5657a6f` (2026-09-29, already 5 commits behind even at the time of
item 59's port) to `100d708` — the pointer recorded by `42ca04b`
(item 60) was already `99ddad193f86e2e49ba0974506a3ffa3a659fdb3`
("Howto about naming conventions"), meaning **`howto_naming.tex` has
existed in `common` since before item 59 was written**, and
`howto_sizes.tex` has existed since before item 56 (it was *already
present* at `common`'s `0b00db2`, the pointer recorded by `961c19c` —
confirmed directly with `git show 0b00db2:texts/howto_sizes.tex`).
Both "does not exist" conclusions in items 56 and 59 were wrong,
caused by inspecting a submodule checkout that `git fetch`/`git log`
on the superproject alone does not update (corrected inline at both
items above).

New `howto_sizes.md` ("About memory and sizes"): a `Byte` subsection
(anchor `(chp-byte)=` for upstream's `\label{chp:Byte}`, currently
unreferenced) with the decimal/binary size-unit table split into two
`{list-table}`s (`tab-size-units-decimal`/`-binary`) rather than one
grouped-header table, matching how `bool_ops.md`'s logical/comparison
split was handled (MyST `{list-table}` has no native
support for upstream's spanning `\SetCell[c=4]{c}` header groups); and
a `Word` subsection (anchor `(chp-word)=` for `\label{chp:Word}` — the
target `box.md` has wanted since item 56).

New `howto_naming.md` ("Naming conventions", anchor `(chp-naming)=`
for `\label{chp:Naming}`): two tables, `tab-case-styles` (naming
styles: `CONSTANT_CASE`, `Train-Case`, `camelCase`, `PascalCase`,
`snake_case`, `kebab-case`) and `tab-semantic-styles` (Hungarian
notation, interface/type prefixes, boolean prefixes, action-based
function patterns, unit suffixes).

Both added to `chap_howto.md`'s children in `main.tex`'s `\subfile`
order: `howto_cargo_inst_crate`, `howto_env_vars`,
`howto_missing_tools`, `howto_naming`, `howto_path`, `howto_sizes`.

**Retrofitted the two dangling references** now that real targets
exist: `box.md`'s exercise ("Compute the size of this `struct` type.
A *word* is...") now reads "...See [Word](#chp-word) to learn about
what is a *word*." (dropping the inline definition), and "Size of a
Box" gains the trailing "See [Word](#chp-word) to know what is a
*word*." sentence upstream always had. `syntax.md`'s "Naming
conventions" intro now links `(see [Naming conventions](#chp-naming))`
(also fixes an unrelated upstream typo in the same sentence — a
dangling unbalanced parenthesis — by rephrasing rather than carrying
it over literally).


### 63. Threading chapter (`threading.md`, `thread_msg.md`, `thread_mem.md`, `refcell.md`, `sol_thread.md`), I/O pages marked `To review`, from `16895ff`

**New `Threading` chapter**, moved from *Mastery* (where it held only
the `future.md` stub) to *Expertise*, now sandwiched between
`chap_io_ii_file_system.md` and the new `chap_io_iii_cmdline_logs.md`
(matching `main.tex`'s new position, right after `fs`/`file`). Four
children in order: new `threading.md`, new `thread_msg.md`, new
`thread_mem.md` (a near-empty `To review` stub, "Shared memory", no
content upstream either), then the pre-existing `future.md` (unchanged,
just relocated).

**`threading.md`** (new): thread-vs-process intro with a real
JPEG figure (`media/thread_process_program.jpg`, copied from
upstream's new `img/Concepts-_Program_vs._Process_vs._Thread.jpg`,
anchor/`:name:` `fig-thread-exec`) and a `tab-thread-fcts` function
table, then five `seq-start..stop` sections: spawning a thread (and
why the printed text is lost — main thread exits first), waiting for
termination via `join()`, a thread's returned value, returning a
`Result` from a thread (custom `ThreadErr` type), and execution
ordering across 20 spawned threads (`move` closures).

**`thread_msg.md`** (new): MPSC channel messaging —
`tab-mpsc-fcts` function table, then three `seq-start..stop` sections:
an asynchronous `channel()` round-trip, a synchronous `sync_channel()`
example with a 2-message buffer and timestamps (demonstrates the
sender blocking once the buffer fills), and multiple senders via
`tx.clone()`. Closes with a "Rendez-vous" exercise, solved in new
`sol_thread.md` (two `sync_channel(0)` zero-buffer channels forcing
threads to hand off in lockstep, interleaving even/odd counts from 0
to 21).

**Two real evcxr quirks found and worked around while verifying every
cell against the kernel** (not guessed — all of `threading.md`,
`thread_msg.md` and `sol_thread.md`'s sequences were run end-to-end,
exactly as written, including every `:clear` boundary):
- A closure's return-type annotation using a **fully-qualified**
  trait-object bound (`Box<dyn std::error::Error + Send + Sync>`)
  breaks evcxr's variable-persistence analysis with an opaque
  `consider importing this trait` / `cannot find trait Error in this
  scope` error — even though the path is valid Rust. Fixed by always
  `use std::error::Error;` first and writing the bare `Box<dyn Error +
  Send + Sync>` (as a `type ThreadErr = ...` alias, which *does*
  persist correctly across cells once this is fixed).
- `let mut handles = Vec::new();` (no turbofish) and
  `let (tx, rx) = std::sync::mpsc::channel();` both fail with "type
  annotations needed" when the only usage that would pin down the
  type (`.push()`, `.send()`) lives in a *later, separate* cell —
  evcxr only infers from the same top-level compilation unit, it does
  not defer across cells the way it does for e.g. `HashMap::new()`
  followed by `.insert()` in-cell. Fixed with explicit types:
  `Vec<std::thread::JoinHandle<()>>` and `channel::<&str>()` /
  `sync_channel::<String>(2)` / `sync_channel::<bool>(0)` as needed.

**Repo-hygiene follow-through**: `threading.md`'s "Returning an error"
example reads `foo.txt` in read-only mode inside the spawned thread —
upstream's prose implies this succeeds, but nothing creates `foo.txt`
first on this page (upstream likely relies on it existing from an
earlier chapter in their single continuous document build, which our
per-page-kernel-isolation model, item 61, does not replicate). Added a
`remove-cell` that writes a placeholder `foo.txt` first, inside the
same temp-dir isolation pattern established in item 61 (and verified
the example now succeeds and prints the `File` object, rather than
silently panicking).

**New `refcell.md`** (`TODO` stub, "RefCell") added as a 4th child of
`chap_memory_vi_pointers_again.md`, after `arc.md` (matching
`main.tex`'s `\subfile{refcell}` placement).

**`osstr.md`, `path.md`, `fs.md`, `file.md` all gain a `To review`
banner** (upstream added bare `\TOREVIEW` to each of these four
already-existing pages in this commit, with no other content change).

**Solutions chapter reordered** to match `main.tex`'s new
(alphabetical) `\subfile` order: `sol_box`, `sol_cargo`, `sol_ctrl`,
`sol_enum`, `sol_fct`, `sol_gen`, `sol_int`, `sol_mem`, `sol_option`,
`sol_struct`, `sol_str`, `sol_thread`, `sol_var`, `sol_vec` — purely
cosmetic (solutions are addressed by label, not position), done for
consistency with upstream.

**Not ported** (cosmetic only, confirmed no content change):
`poly.md`'s intro sentence replaces a manual `\href` with upstream's
new `\polymorphism` macro — same link target, our existing markdown
link already matches.

### 64. Chapter about pointers: `deref.md`/`drop.md` (new), `rc.md`/`refcell.md`/`ref_cycles.md` filled in, new `Traits` chapter moved up, from `a2b0354`

**`Memory (v)` renamed "Pointers" → "Smart pointers"**
(`chap_memory_v_pointers.md`), gains `deref.md` and `drop.md` as new
children after `box.md`.

**`box.md`**: minor wording fix (`*unique pointer*` now emphasized),
plus a new `## Recursive type` subsection (anchor `chp-box-recursive`,
linked from the new `rc.md` exercise below) building a generic `List<T>`
`enum` via `Box<List<T>>`, with a `print()` method. The final `list.print()`
cell needed a trailing `println!();` to force a flush — `print!()`
without a trailing newline is not reliably flushed before the kernel
reports idle (the same long-known evcxr quirk already worked around
elsewhere, e.g. `sol_thread.md`).

**`boxed_trait.md`**: retitled "Use Box to store different objects in a
collection" → "Use Box to store traits in a collection" (its own
anchor/cross-reference in `box.md` updated to match), plus a new intro
paragraph. No code changes.

**`gen_struct.md`**: new `## Specialization` subsection
(`impl Point<f32> { fn distance_from_origin(...) }`, executable, doesn't
need the `num_traits` crate); `## Trait bound` section reworded with a
forward cross-reference to the new `chp-bound-gen-method` anchor in
`trait_bounds.md` (see below); exercise step 5 gains "(see `PrimInt`
methods)."

**`deref.md`** (new): the `Deref`/`DerefMut` traits — dereferencing a
`Box<i32>`, the `Deref` trait's shape (shown `skip-execution`/`disabled`,
it's an incomplete illustration, not real code), automatic `Deref`
coercion (`&Box<String>` → `&String` → `&str`), method access through
`Deref`, and `DerefMut` (`push_str()` on a `Box<String>`). Exercise
"Custom Box-like implementation" (`deref-impl`, solution in the new
`sol_pointers.md`, see below).

**`drop.md`** (new): the `Drop` trait — a `Foo` struct with a logging
`drop()`, automatic drop at end of scope vs. explicit `drop(y)` to
disable it early. Straightforward, no evcxr surprises.

**`ref.md`**: the old `## Type of a reference` subsection (which just
showed that printing a reference and then assigning to it doesn't type
check) is replaced by a new `## Dereferencing` subsection (anchor
`chp-deref-op`) that develops the point properly: a `16 == b` type
mismatch (`raises-exception`), then the fix `16 == *b`, an `:::{important}`
box on references-as-pointers, and the two-levels-deep `let c = &b;`
example (`b == *c`, `16 == **c`). A new `## The ref pattern` subsection
(anchor `chp-ref-pattern`) follows the existing "Passing a reference"
section: the `ref` keyword as an alternative to `&`, then `if let
Some(ref n) = a`/`if let Some(ref mut n) = b` demos. Also fixes a
longstanding typo, "If want to access" → "If we want to access" (in the
pre-existing "Passing a reference" section).

Every one of these new multi-step demos **relies on persisting a `&T`
reference to a local variable across cells (`b`, `c`), which evcxr
cannot do** ("contains a reference with a non-static lifetime so can't
be persisted") — the exact quirk already documented and worked around
in item 16 (*Wrap-in-brackets workaround for evcxr persistence*). Ported
each one the same way: a single `{ … }`-wrapped block per demo, with
`println!()` replacing the trailing boolean/reference expression. The
two reference-chain diagrams (`b`→`a`, then `c`→`b`→`a`) are plain
` ```text ` fenced diagrams (no `{figure}`/`{numref}`, matching the
existing convention in `trait_poly.md` for an inline ASCII diagram that
nothing else cross-references).

**`rc.md`** (new, was a bare `TODO` stub): `Rc` as a reference-counted
smart pointer — `strong_count()`/`clone()`/`drop()` walkthrough (owned
`Rc<i32>` values persist across cells fine, no wrap-in-braces needed
here, unlike `ref.md` above), a `tab-rc-methods` table, and exercise
"Shared lists" (`shared-lists`, solution in `sol_pointers.md`) with a
plain-text ASCII diagram of three lists sharing sub-lists via `Rc`.

**`refcell.md`** (new, was a bare `TODO` stub): the `RefCell` borrowing
rules, a `tab-refcell-methods` table, and a `Fib` memoization example
(`RefCell<Vec<u64>>` cache, `fib.get(50)` → `12586269025`, verified).
This example uses a **let-chain** (`if let Some(v) = cached && v != 0`),
confirmed to compile and run fine on the kernel's `rustc 1.98.1`.
Exercise "Prime numbers" (`prime-numbers`, solution in `sol_pointers.md`).

**`ref_cycles.md`** (new): reference cycles with `Rc<RefCell<...>>`.
Two demos: a *strong* cycle (`a`↔`b`, both ends `Rc`) that leaks even
after both variables are dropped (proven via a `Weak::upgrade()` check
before/after), then a *droppable* cycle built from a `Next<T>` enum
(`StrongLink`/`WeakLink`/`Nil`) with one strong link and one weak link,
which drops cleanly. **Caught and fixed an upstream wording bug** in the
droppable-cycle walkthrough: the prose said "we define `b` with a
*strong* reference on `a`" where the code uses `WeakLink(Rc::downgrade(&a))`
(weak), and "we change the termination of `a` into a *weak* reference on
`b`" where the code uses `StrongLink(Rc::clone(&b))` (strong) — the two
labels were swapped. Confirmed against the kernel: with the links as
coded (not as upstream's swapped prose describes), dropping `a` and `b`
does make the cycle collapse (`c.upgrade()` → `None`), matching the
section's own conclusion — so the *code* was right and only the prose
needed the two words swapped back. Fixed in the port; not reported
upstream (out of scope for this routine).

**`trait_bounds.md`**: complete rewrite from the old `DRAFT` stub.
`Media`/`Video` traits, a `Movie<'a>` struct, `impl Trait` arguments vs.
the equivalent generic form (`:::{important}` boxes showing the
generic equivalent as `skip-execution`/`disabled`, per item 15), a
`:::{warning}` on why two separate `impl Media` parameters don't let you
compare them (shown `disabled`, genuinely doesn't compile), multiple
trait bounds with `+`, returning `impl Trait` (`get_video()`), a
`FromTitle<'a>` trait used to work around the fact that a *generic*
`fn get_video<T: ...>() -> T` can't pick a concrete type, a `where`
clause example (`merge_videos`), and `## Bounding a generic method`
(anchor `chp-bound-gen-method`, linked from `gen_struct.md` above) with
a `num_traits::PrimInt`-bounded `Bag<T>::sum()` (`skip-execution`/
`disabled`, same as `gen_struct.md`'s pre-existing `num_traits` example
— the crate isn't available in this notebook's kernel).

Two evcxr quirks hit and fixed, both using the item-16 wrap-in-braces
pattern: `let movie3 = get_video(); info_media(&movie3);` fails to
persist `movie3` because its type is the opaque `impl Media + Video`
return type (fixed by wrapping both lines in a single `{ … }` block);
and upstream's own `:::{important}` box contains a *mix* of a
`[disable]`d snippet followed by several real `[cont]` cells
(`trait FromTitle`, its `impl`, `get_video_bis`, the typed `let movie3:
Movie = ...`) — rather than nest executable `{code-cell}` directives
inside an admonition (untested in this codebase, and a real execution
dependency besides), the admonition was closed right after the
`disabled` snippet and prose, and the four executable cells were moved
out as regular top-level content immediately following it. No content
lost, just flattened one level.

**`traits_in_fields.md`**: complete rewrite from the old `DRAFT` stub.
`Shape` trait, `Rectangle`, and a `Drawing<'a> { shape: &'a (dyn Shape +
'a) }` structure storing a trait object by reference with an explicit
lifetime. Exercise "Shapes drawing" (`shapes-drawing`, solution in the
new `sol_trait.md`). The final `Drawing` instantiation+draw needed the
same wrap-in-braces treatment (`Drawing` holds a `&'a` reference to a
local `rect`, which can't be persisted standalone).

**`sol_box.md` → `sol_pointers.md`** (renamed, matching upstream's
`sol_box.tex` → `sol_pointers.tex`): kept our existing (previously
corrected, see item 44/history) "Type size" solution's byte-count math
as-is — upstream's own copy of this solution still has the old,
already-superseded numbers, so overwriting would have reintroduced a
bug we'd already fixed. Added three new solutions: "Deref
implementation" (`deref-impl-solution`, a `MyBox<T>` tuple struct), and
"Shared lists" (`shared-lists-solution`, `Rc<List<T>>`),"Prime numbers"
(`prime-numbers-solution`, `RefCell<HashMap<u64, bool>>` cache). The
prime-numbers solution needed its `is_prime()`/`trial_division()`
methods **merged into one `impl` block/cell**: `is_prime()` calls
`Self::trial_division()`, but upstream's source shows them in
*separate* sequential code blocks with `is_prime()` first — that only
compiles in LaTeX (never executed) or inside a single real compilation
unit; across two separate evcxr cells, the earlier cell can't see a
method defined in a cell that hasn't run yet. Merged into one cell,
order of methods inside kept as upstream wrote it (`is_prime()` first,
`trial_division()` second) since that's valid once they're in the same
`impl` block.

**`sol_trait.md`** (new): "Shapes drawing" solution — `Circle` added
alongside `Rectangle`, `Drawing<'a> { shapes: Vec<&'a (dyn Shape + 'a)>
}`, `add_shape()`. Same wrap-in-braces treatment as the exercise.

**`vec.md`**: tiny wording fix, "Removes an element at a position `i`"
→ "at position `i`" (the `resize()` row already said "vector", not
upstream's old "queue" — already fixed in an earlier pass).

**`myst-toc.yml` restructuring** (Expertise part): `chap_polymorphism_v_traits.md`
(`traits_in_fields.md`/`boxed_trait.md`/`trait_bounds.md`) moved from
its old position (right before the `Mastery` part, after `chap_testing.md`)
to right after `chap_memory_v_pointers.md` (matching `main.tex`'s new
chapter order). New chapters, matching `main.tex`'s three new
`\PrefixedChapter{Memory}{...}` entries: `chap_memory_vi_ref_counters.md`
("Ref counters and cycles": `rc.md`/`refcell.md`/`ref_cycles.md`) between
`chap_io_ii_file_system.md` and `chap_threading.md`;
`chap_memory_vii_thread_safe.md` ("Thread safe ref counters": `arc.md`)
between `chap_threading.md` and `chap_io_iii_cmdline_logs.md`;
`chap_memory_viii_cow.md` ("Clone-on-write pointer": `cow.md`) between
`chap_testing.md` and the `Mastery` part. The old Mastery-part
`chap_memory_vi_pointers_again.md` ("Pointers again": `cow.md`/`rc.md`/
`arc.md`/`refcell.md`) is **removed entirely** (file deleted) — its four
children are exactly the ones redistributed to the three new chapters
above plus `cow.md`'s own new chapter. Since `Memory (v) Smart pointers`
stays the 5th `\PrefixedChapter{Memory}{...}` in `main.tex` and the
removed "Pointers again" would have been the 6th, the three brand new
chapters simply take over `vi`/`vii`/`viii` in its place — no other
`Memory`-numbered (or `Polymorphism`/`I/O`/`Error handling`-numbered)
chapter title needed to change, since none of them changed relative
order among same-prefix siblings. `chap_solutions.md`: `sol_box.md` →
`sol_pointers.md`, `sol_trait.md` added (matching `main.tex`'s
alphabetical `\subfile` order).

**Not ported** (cosmetic only, no prose depends on these): `rustalias.sty`
macro renames/additions (`\MoveKwd` → `\KwdMove`, new `\KwdRef`, `\Drop`,
`\Rc`, `\RefStruct`, `\RefCell`, `\RefMut`, `\Weak`) are LaTeX-internal
hyperlink macros; our port already hyperlinks these terms directly in
prose. `CHANGELOG.md` isn't mirrored in this repo (no `notebooks/CHANGELOG.md`
exists).

### 65. `thread_module.md` split out of `threading.md`, `arc.md`/`cow.md` relocated, from `94eb476`

**Upstream renamed `threading.tex` to `thread_module.tex`** (via a
plain `git mv`-equivalent — `git diff -M` confirms an 81%-similarity
rename), re-titled it "Thread module", and dropped the old generic
thread/process/concurrency-vs-parallelism intro (the first ~55 lines of
the old file) from it entirely. `main.tex` still has
`\subfile{threading}` right before the now-added `\subfile{thread_module}`
— **but `threading.tex` no longer exists anywhere in the tree** after
this commit (confirmed via `git ls-tree 94eb476`). This is an upstream
oversight: the commit's own title, "Make generic page about threading",
and the still-present `\subfile{threading}` line both show the clear
intent was to split the old overloaded `threading.tex` into (a) a slim
generic conceptual page and (b) a specifics page, but the first half
was simply deleted without ever being re-created as the new
`threading.tex` — upstream's own LaTeX build is presently broken on
this exact point (dangling `\subfile`). Treated as a bug to route
around, not a cue to delete content: kept `threading.md` holding
exactly the generic intro material upstream's diff removed (thread vs.
process, the `fig-thread-exec` figure, concurrent vs. parallel
programming — i.e. exactly the page the commit title promises), and
moved everything else (the `tab-thread-fcts` table and all five
`seq-start..stop` sections: spawning, waiting for termination, returned
values, returning an error, execution ordering) verbatim into a new
`thread_module.md`, inserted as `chap_threading.md`'s 2nd child, right
after `threading.md`. No Rust content changed — this is a pure
file/page split of already-verified material, so no new evcxr testing
was needed. `threading.md` no longer has any code cells, so its
jupytext/kernelspec frontmatter was dropped too, matching the existing
convention for code-free pages (e.g. `thread_mem.md`, `future.md`).

**`myst-toc.yml`**: `chap_memory_vii_thread_safe.md` (`arc.md`) and
`chap_memory_viii_cow.md` (`cow.md`) — both brand new in item 64 above —
are relocated to sit right after `chap_memory_vi_ref_counters.md` and
right before `chap_threading.md` (matching `main.tex`'s new order:
these two `\PrefixedChapter{Memory}{...}` chapters move from
after-Threading/after-Testing to directly after "Ref counters and
cycles"). Their `vii`/`viii` numerals are unchanged — this is only a
few-lines move within the same `Part`, not a change to Memory-chapter
relative order.

**`common` submodule** updated again, `2f63a0b` → `8dd21be` (the
pointer `94eb476` records) → further to `d038ef6` ("Add aliases", the
submodule's current remote tip at the time of this pass, confirmed an
ancestor-descendant of `8dd21be` via `git merge-base --is-ancestor`,
consistent with the "keep the submodule current" policy from item 62).
One intervening submodule commit, `fbf3d22` ("Add Mutex, Lock ,..."),
suggests upcoming upstream content for a future mutex/locking chapter —
nothing in `upstream-tex` references it yet, so no action needed this
pass; worth watching for on the next resumption.

### 66. `thread_mem.md` filled in (Sync, Mutex, locking, Arc shared access), `sol_thread.md` gains Dining philosophers solution, `thread_msg.md` gains Send section, `arc.md`/thread-safe-ref-counters chapter dropped, `cow.md` renumbered to (vii), from `ed3021b`

Confirms the mutex/locking content flagged as "upcoming" in item 65 —
the `fbf3d22` submodule commit was indeed a precursor to this.

**`thread_mem.md`** (was a bare `TOREVIEW` stub) is filled in with the
full "Shared memory" chapter: a `Sync` trait bullet list (mirrors the
`Send` list already in `thread_msg.md`), a `Mutexes` section with a
`tab-mutex-methods` table (upstream itself leaves most method
descriptions blank except `new(v)` — ported as-is, not invented), a
`:::{danger}` box on deadlock causes, a `Locking` section demoing
`Mutex::new()`/`lock()`/`Deref` (wrapped in a scope block to force the
guard's drop, verified against the kernel: `Mutex { data: 7,
poisoned: false, .. }` after release), a `:::{important}` box on RAII,
and a `Shared access` section (the classic "10 threads incrementing an
`Arc<Mutex<i32>>` counter" example from the Rust book). The
`let mut handles = vec![];` binding needed the same explicit
`Vec<std::thread::JoinHandle<()>>` type-annotation workaround already
used in `thread_module.md`'s "Execution ordering" section — plain
`vec![]` can't have its element type inferred across the evcxr
cell-persistence boundary. All cells verified end-to-end against the
real kernel (final `Result: 10` after 10 increments). The file gained
jupytext/kernelspec frontmatter since it now has code cells, matching
convention. Added a new 5-star exercise, "Dining philosophers
problem," `:label: dining-philosophers`, linking to a new
`sol_thread.md` solution.

**`sol_thread.md`** gains a "Dining philosophers problem" section
(`:::{solution} dining-philosophers`, `:label:
dining-philosophers-solution`). Upstream's LaTeX source builds the
`diner()` function across a dozen separate `\begin{minted}[cont,notag]`
fragments (each an incomplete partial statement, e.g. a single
unclosed `for i in 0..n {` line) — these are purely a LaTeX/PDF
cosmetic device (the `notag` option just suppresses the per-fragment
start/cont/stop corner badge in `common/newminted.sty`, it does not
mark a separate executable unit) and cannot map to separate evcxr
cells 1:1, since most fragments are not syntactically complete Rust on
their own. Ported as the project's established approach for this kind
of incremental-build narration: merged all `notag` fragments between
two real tagged boundaries into one `{code-cell}` (the complete
`diner()` function body), moved the per-fragment narration that used
to sit between fragments into one combined prose paragraph before the
cell, and kept only the comments that were genuinely already inside
upstream's Rust code (`// Total eaten`, `// Eat`, `// We got the two
chopsticks`, `// Nothing to eat, we leave`, `// Think`, etc.) rather
than inventing new ones. `fn print_res()` is its own real `[cont]` tag
in the LaTeX source, so it became its own separate `{code-cell}` as
well. Verified end-to-end: `diner(5, 500, 1)` (no-deadlock check, since
`try_lock()` is non-blocking) and `diner(5, 5, 1)` (each of the 5
philosophers eats exactly 1 bite) both ran correctly and fast (sub-
second, since the exercise's blocking-`lock()` naive version that can
actually deadlock is never executed — only upstream's fixed
`try_lock()`-based solution is).

**`thread_msg.md`** gains a one-sentence intro ("the `mpsc` module
provides methods to *pass ownership* of an object...") plus a new
`## Send` section (inserted between the `tab-mpsc-fcts` table and the
pre-existing "Asynchronous channel" section), mirroring the `Sync`
list added to `thread_mem.md` above. Prose only, no new code cells.

**`vec.tex`'s `\var{...}` → `\cod{...}` macro renames** (8 method
names in its methods table) are a purely cosmetic LaTeX distinction
(italic vs. code-styled inline text) that MyST's `vec.md` never had in
the first place — every entry in `tab-vec-methods` was already
rendered with backtick code formatting. No action needed; confirmed
no textual wording changed either (`remove(i)`'s description, the one
entry already flagged in a prior pass, is unchanged: "at position
`i`").

**`main.tex` / `myst-toc.yml`**: upstream entirely removes the
`\PrefixedChapter{Memory}{Thread safe ref counters}` /
`\subfile{arc}` pair — `arc.tex` itself still exists on disk (still
just a `\TODO{Explain Arc}` stub) but is no longer referenced from
`main.tex` anywhere; its content (explaining `Arc`) is superseded by
the fuller treatment inside the new `thread_mem.tex`'s "Shared access"
section. Mirrored by deleting both `chap_memory_vii_thread_safe.md`
and `arc.md` (`git rm`, not left as orphans — matches the item 64
precedent of deleting a chapter wrapper whose upstream chapter
disappeared). `\PrefixedChapter{Memory}{Clone-on-write pointer}` /
`cow.tex` also moves — from before the `Threading` chapter to *after*
it — and since it's now the **last** `Memory`-prefixed chapter in
`main.tex` (with "Thread safe ref counters" gone and nothing else
`Memory`-prefixed following it), its auto-numeral shifts from `(viii)`
to `(vii)`: `chap_memory_viii_cow.md` → `chap_memory_vii_cow.md`
(`git mv`), title updated to "Memory (vii) - Clone-on-write pointer".
`myst-toc.yml`'s `Expertise` part reordered to match: `chap_threading.md`
now sits directly after `chap_memory_vi_ref_counters.md`, and the
renamed `chap_memory_vii_cow.md` comes right after `chap_threading.md`,
before `chap_io_iii_cmdline_logs.md`.

**`rustalias.sty`** gains several new macros (`\RustProgLang`, `\Arc`,
`\Cell`, `\LockResult`, `\MutexGuard`, `\MutexStruct`, `\PoisonError`,
`\TryLockResult`) — pure LaTeX href shortcuts for terms now used in
`thread_mem.tex`, no MyST-side equivalent needed (we just write the
term + a markdown link directly, as always).

**`common` submodule** updated again, `d038ef6` → `058a11f` ("Add web
links", the submodule's current remote tip at the time of this pass),
confirmed to still have `c6e4e2f` (the pointer `ed3021b` records) as
an ancestor via `git merge-base --is-ancestor`.

### 67. New "I/O - Environment"/"I/O - Logging" chapters (`env.md`, `app_folders.md`, `tmp.md`, `env_vars.md`, `clap.md`, `exit.md`, `env_logger.md`), `args.md` moves to To review, `eu_alt.md` added to Introduction, `future.md`/`cow.md` chapters relocated to Mastery, from `e9b02bf`

**New pages, all `:::{warning} To review`** (upstream marks the whole
commit `\TOREVIEW`, not `\DRAFT`, even though three of them ship full
content):

- **`env.md`** ("Process environment"): intro bullets, a
  `tab-env-fcts` table (`std::env` functions), and three subsections —
  "Current working directory" (`current_dir()`/`set_current_dir()`,
  kernel-verified, a `seq-start`/`seq-stop` pair showing the directory
  actually changes), "Home directory" (`home_dir()` — deprecated in
  real `std` since 1.29 but still compiles/executes, verified), and
  "Temporary directory" (`temp_dir()`). Anchors `(chp-envvars)=` /
  `(chp-cmdlineargs)=` / `(chp-appfolders)=` / `(chp-tmp)=` referenced
  from this page are added to their respective target pages below.
- **`app_folders.md`** ("Application folders", anchor `(chp-appfolders)=`
  for upstream's `\label{chp:AppFolders}`): the `directories` crate's
  `ProjectDirs` struct, a `tab-project-dir-methods` table, "Initializing"
  plus one subsection per folder kind (Cache/Configuration/Data/
  Preference/Runtime/State), a `seq-start`→6×`seq-cont`→`seq-stop` chain
  all operating on one persisted `prj` binding. Needs a crate dependency
  the project had never used before (`evcxr`'s `:dep` directive) —
  confirmed network access to crates.io is available during
  `myst build --execute` (both locally and, implicitly, on GitHub
  Actions' own runners); the `:dep directories = "5"` line is hidden in
  its own `:tags: [remove-cell]` cell (same convention as
  `folder_mod.md`'s hidden `pushd`), since upstream's LaTeX prose never
  shows a `cargo add` step for it. `runtime_dir()`/`state_dir()`
  correctly return `None` when built on a non-Linux machine (matches
  upstream's own "only used on Linux platforms" callout — not an error).
  Upstream's `\namedsockets`/`\namedpipes` macros used in the Runtime
  folder prose don't actually exist anywhere in `common/` (an upstream
  typo/dangling macro); rendered as plain lowercase "named sockets"/
  "named pipes" text, matching the obvious intent.
- **`tmp.md`** ("Temporary files and folders", anchor `(chp-tmp)=` for
  `\label{chp:Tmp}`): the `tempfile` crate (new `:dep`, same hidden-cell
  convention), two `:::{important}` boxes, a `tab-tempfile-fcts` table,
  and 5 subsections (Temporary file, Temporary folder, Named temporary
  file, In-memory buffer backed by file system, The Builder structure)
  chained as one long `seq-start`→...→`seq-stop` sequence, plus a
  `tab-builder-methods` table and two more `:::{important}` boxes.
  Kernel-verified end-to-end (`tempfile()`, `tempdir()`,
  `TempDir::with_prefix/with_suffix`, `NamedTempFile::new/with_prefix/
  with_suffix`, `spooled_tempfile()`'s `is_rolled()` flipping
  `false`→`true` after the 16-byte buffer overflows, and the `Builder`
  producing 5 distinct `.tsv` tempfiles in a loop).
- **`env_vars.md`** ("Environment variables", anchor `(chp-envvars)=`
  for `\label{chp:EnvVars}`): a bare stub — upstream's own content here
  is 3 `\TODO{}` markers and nothing else (`var()`/`var_os()`/`vars()`/
  `vars_os()`, `join_paths()`, `split_paths()`), ported as one combined
  `:::{danger} TODO` bullet list, no code.
- **`clap.md`** ("clap crate"): one bash cell, `cargo add clap --features
  derive` (moved out of `args.md`, see below).
- **`exit.md`** ("Exit status", anchor `(chp-exit)=` for
  `\label{chp:Exit}`) and **`env_logger.md`** ("env_logger crate"): both
  pure title+banner stubs — upstream's own content is entirely
  LaTeX-commented-out placeholder prose (invisible in the PDF too), so
  there is nothing to port.

**`args.md`** gains anchor `(chp-cmdlineargs)=` (upstream's
`\label{chp:CmdLineArgs}`), readiness changes from `Draft` to `To
review`, a new `:::{danger} TODO` ("`args()` and `args_os()`.") right
after the banner, and loses its "Clap" subsection (moved verbatim to the
new `clap.md` above).

**`eu_alt.md`** ("EU alternatives") added as the last child of
`chap_introduction.md`, right after `resources.md`. From the `common`
submodule bump (`c6e4e2f` → `6ac37e6`, "Resolve 'Advertising about EU
alternatives'"): two images side by side in upstream's LaTeX (via
`minipage`), ported as two `:::{image}` blocks (`:align: left` /
`:align: right`, both `:width: 45%`) — `media/european-alternatives-
logo.svg` and `media/advertising_banner.png` copied in from the
submodule's `texts/`. All of upstream's `\EuAlt*`/`\Framasoft`/`\Frama*`/
`\Nuudel` href macros resolved to plain markdown links inline (no MyST
macro equivalent needed, as always).

**Chapter restructuring in `main.tex`**:

- The former "I/O (iii) - Command line & logs" chapter
  (`chap_io_iii_cmdline_logs.md`, children `args.md`/`logs.md`) is
  dissolved (`git rm`, matching the item 64/66 precedent for a chapter
  wrapper whose upstream chapter disappears) and replaced by two new
  chapters: **"I/O (iii) - Environment"** (new `chap_io_iii_environment.md`,
  children `env.md`/`app_folders.md`/`tmp.md`/`env_vars.md`/`args.md`/
  `clap.md`/`exit.md`) and **"I/O (iv) - Logging"** (new
  `chap_io_iv_logging.md`, children `logs.md`/`env_logger.md`). The
  pre-existing "I/O (iv) - Formatters" chapter shifts down one slot to
  **"I/O (v) - Formatters"** (`chap_io_iv_formatters.md` →
  `chap_io_v_formatters.md`, `git mv`, title updated) since it's the
  next `\PrefixedChapter{I/O}{...}` call after the two new ones.
- `future.md` is pulled out of the `chap_threading.md` chapter (which
  keeps `threading.md`/`thread_module.md`/`thread_msg.md`/`thread_mem.md`)
  and relocated, together with `cow.md` (previously its own chapter
  right after Threading in the Expertise part), into the **Mastery**
  part, both inserted right after `chap_project_ii_modules.md` and
  before `chap_bitwise_operations.md`: `chap_memory_vii_cow.md` first,
  then a new `chap_threading_ii_future.md` ("Threading (ii) - Future").
  Despite the big reshuffle, no roman numerals actually change for
  either prefix: `Memory`'s 7th `\PrefixedChapter{Memory}{...}` call is
  still `cow` wherever it sits (nothing `Memory`-prefixed is inserted
  between its old and new position), and `Threading`'s 2nd call is
  still `future` (it was already positioned after the 1st call in both
  the old and new document order).
- Upstream's actual `main.tex` has a transient, self-inflicted bug at
  this exact commit: it adds `\PrefixedChapter{Threading}{}` but forgets
  to delete the pre-existing `\chapter{Threading}` line right below it,
  so the literal source has two consecutive chapter headings (an empty
  one with zero subfiles, immediately followed by the real one). This
  produces no stable, buildable intermediate state worth modeling in
  MyST (there's nothing to even put a stub page behind for the empty
  heading), and upstream fixes it two commits later (`8bb6efc`, see
  below) by deleting both lines and replacing them with
  `\PrefixedChapter{Threading}{Bases}` in one shot — so `chap_threading.md`
  keeps its plain "Threading" title at this step and only becomes
  "Threading (i) - Bases" once that fix lands.
- `chap_environment.md`'s title changes from "Environment" to
  "Development environment" (`\chapter{Environment}` →
  `\chapter{Development environment}`, filename unchanged since it's
  not a `\PrefixedChapter`).

**`rustalias.sty`** macro reshuffle (new `\Directories`/`\ProjectDirs`/
`\Tempfile`/`\TempDir`/`\NamedTempFile`/`\SpooledTempFile`/
`\TempFileBuilder`/`\ModEnv`/`\ModCmp`/`\ModMpsc`/`\ModOps`/`\ModThread`
macros, `\ThreadMod`→`\ModThread` and `\MpscMod`→`\ModMpsc` renames
cascading into cosmetic-only edits in `thread_module.tex`/`thread_msg.tex`)
— pure LaTeX href-shortcut mechanism, no MyST-side action needed, as
with every prior macro-only rename in this project.

### 68. New "Types - Strings" chapter (`str_raw.md`, `str_bytes.md`, `utf8.md` move in), new `numbers.md`/`chr_encoding.md` in "Types - Base types", `chap_character_encoding.md`/`unicode.md` dropped, from `a922858`

**`chap_types_ii.md`** ("Types (ii)") loses its "Byte string" subsection
(moved out, see `str_bytes.md` below) and is retitled "Types (ii) -
Tuples & arrays" (upstream's `\PrefixedChapter{Types}{}` →
`\PrefixedChapter{Types}{Tuples \& arrays}`), keeping only
`tuple.md`/`array.md`/`coll_summary.md`.

**New chapter "Types (iii) - Strings"** (new `chap_types_iii_strings.md`,
inserted right after the above, matching the new
`\PrefixedChapter{Types}{Strings}` call), with 4 children:

- `str_literals.md` moves here unchanged in substance, but loses its
  "Raw string" subsection (see below) in addition to the "Byte string"
  one it already lost.
- **`str_raw.md`** (new, "Raw string"): verbatim copy of the subsection
  just removed from `str_literals.md`. Upstream genuinely duplicates
  this content across both files at this exact commit (confirmed: the
  *next* commit, `754b4e2`, is titled "Remove duplicate raw string" and
  removes it from `str_literals.tex` only) — ported faithfully as a
  temporary duplication now, to be cleaned up in the very next porting
  commit, matching upstream's own two-commit sequence exactly.
- **`str_bytes.md`** (new, "Byte string"): expanded from `str_literals.md`'s
  old subsection — upstream rewords "slice of bytes (`u8`)" into "a
  pure *slice of bytes* (i.e.: `&[u8]`)", otherwise identical code.
- **`utf8.md`** moves here from the now-dissolved "Character encoding"
  chapter (see below), and is substantially rewritten: title `UTF-8` →
  `UTF-8 encoding`, the `:::{danger} Draft` banner and all 5 TODO
  bullets are dropped entirely (upstream finalizes this page, no
  readiness banner at all now), and the example changes shape:
  the old "Compiler error" cell (actually a *runtime panic*, mislabeled)
  and the old separate "Runtime error (panic)" cell (`String::from` +
  same panic, pure duplication) collapse into **one** panic
  demonstration (kept as `:tags: [raises-exception]`, re-verified via
  the real kernel — `end byte index 1 is not a char boundary`), followed
  by a 3-cell `seq-start`/`seq-cont`/`seq-stop` chain showing the
  `get()`-based fix with `match`/`Some`/`None` (upstream switches from
  the old `if let Some(t) = ...` style to `match ... { Some/None }`,
  also now explicitly printing "Invalid slice." on the `None` branch
  for the `0..1` case instead of silently skipping it) — re-verified
  end-to-end (`0..1` → "Invalid slice.", `0..2` → `s[0..2]: С`).

**"Types (i)" chapter** (`chap_types_i.md`) retitled "Types (i) - Base
types" (`\PrefixedChapter{Types}{}` → `\PrefixedChapter{Types}{Base
types}`), gaining two new children:

- **`numbers.md`** (new, "Number systems", from the `common` submodule
  bump below): binary/octal/hexadecimal base explanations, 3 worked
  single-number tables (177 in binary, 12446 in octal, 993312446 in
  hex) plus one 16-column decimal/binary/octal/hex side-by-side
  conversion table. MyST's `{list-table}` has no spanning-header cells
  (unlike upstream's `\SetCell[c=N]{c}`), so the two-row spanning
  header ("Decimal" over 3 cols, "Binary" over 8, etc.) is flattened
  into one row of 16 already-qualified column labels (`Dec $10^2$`,
  `Bin $2^7$`, ... `Hex $16^0$` — same `tab-size-units-decimal`-style
  precedent as item 62), and upstream's vertically-spanning `⋮` ellipsis
  rows become ordinary rows of 16 `…` cells (matching the existing
  `int_repr.md` precedent for ellipsis rows, just repeated across every
  column since there's no row-spanning cell to carry a single `…`
  across 16 columns either).
- **`chr_encoding.md`** (new, "Character encoding", anchor
  `(chp-chr-enc)=`, inserted right before `char.md`): ASCII/Extended
  ASCII/Latin-1/Unicode/UTF-8 history, a `fig-usascii` figure (new
  `media/USASCII_code_chart.svg`, copied in from the submodule), and
  the "UTF-8 strings can be seen as..." bullet list that used to live
  (as bare `\TODO`s) in `unicode.tex`. This page inherits the
  `(chp-chr-enc)=` anchor that `unicode.md` used to carry — that anchor
  was itself a MyST-only addition from an earlier porting pass (no
  matching upstream `\label`), created solely to satisfy a cross-reference
  already present in `string.md` ("`...`see [Character encoding]
  (#chp-chr-enc)`"); moving it to `chr_encoding.md` keeps that link
  resolving to the page that now actually covers the topic, instead of
  a deleted file. Caught by the full-build link checker (`myst
  build --execute`, 0 unresolved refs) after an initial pass missed it
  (not found by `grep`-ing for `chap_character_encoding`/`unicode.md`/
  `ChrEnc`, since the anchor's own slug, `chp-chr-enc`, doesn't contain
  any of those strings) — a reminder to always rebuild-and-check rather
  than trust a text search alone for anchor fallout from a file deletion.

**`chap_character_encoding.md`** (the old "Character encoding" chapter,
children `unicode.md`/`utf8.md`) is dissolved (`git rm`, same precedent
as items 64/66/67): `unicode.md` is deleted outright (fully superseded
by `chr_encoding.md`'s real content), `utf8.md` moves into the new
"Types (iii) - Strings" chapter above.

**Types-prefix renumbering cascade**: since "Types - Strings" is a
brand new `\PrefixedChapter{Types}{...}` call inserted between "Tuples
& arrays" (2nd) and "Enums" (previously 3rd), every subsequent
`Types`-prefixed chapter shifts down one roman numeral: `chap_types_iii_enums.md`
→ `chap_types_iv_enums.md`, `chap_types_iv_structs.md` →
`chap_types_v_structs.md`, `chap_types_v_vec_string.md` →
`chap_types_vi_vec_string.md`, `chap_types_vi_sequences.md` →
`chap_types_vii_sequences.md`, `chap_types_vii_hashes.md` →
`chap_types_viii_hashes.md`, `chap_types_viii_trees.md` →
`chap_types_ix_trees.md` (6× `git mv` + title update, children
untouched). Build-verified: all 9 "Types"-prefixed chapters still get
sequential, LaTeX-matching chapter numbers (`6`, `8`, `9`, `13`, `15`,
`19`, `28`, `29`, `30` as MyST's own book-wide enumerators, following
whatever non-`Types` chapters fall between them — the roman numerals
inside each title are the ones that matter for LaTeX parity, and those
all match).

**`common` submodule** updated again, `c6e4e2f` → `e65f6dc` ("Resolve
'Unicode & UTF-8 chapter'"): besides `numbers.tex`/`chr_encoding.tex`/
`USASCII_code_chart.svg` (new, ported above), it also tweaks
`howto_sizes.tex`'s `tab-size-units` table (adds a `|` column separator
and 2 padding header cells, pure LaTeX border cosmetics) — no MyST
action, `howto_sizes.md` already renders this as two separate
`{list-table}`s (item 62) with no spanning border to begin with.

### 69. `str_literals.md` loses its temporarily-duplicated "Raw string" subsection, from `754b4e2`

As anticipated in item 68: upstream's own previous commit (`a922858`)
had left "Raw string" duplicated in both `str_literals.tex` and the new
`str_raw.tex`; this commit removes it from `str_literals.tex` only,
leaving `str_raw.tex` as its sole, permanent home. Mirrored by removing
the same subsection from `str_literals.md` (it already lives,
unchanged, in `str_raw.md` since item 68) — no other file references
it.

### 70. `chap_threading.md` retitled "Threading (i) - Bases" + renamed, `CourseVersion` 1.4.0 → 1.4.1, from `8bb6efc`

Despite its subject line, this commit also fixes the transient
double-chapter-heading bug flagged in item 67: the stray
`\PrefixedChapter{Threading}{}` + leftover `\chapter{Threading}` pair is
replaced in one shot by `\PrefixedChapter{Threading}{Bases}`. Mirrored
by retitling `chap_threading.md` to "Threading (i) - Bases" and
renaming it to `chap_threading_i_bases.md` (`git mv`, matching the
project's "empty suffix → plain filename, non-empty suffix → filename
carries the slug" convention — same as `chap_memory_vii_cow.md`/
`chap_threading_ii_future.md`). Children (`threading.md`/
`thread_module.md`/`thread_msg.md`/`thread_mem.md`) unchanged.
Build-verified: enumerator unchanged (`39`, same slot as the plain
"Threading" title held before).

`CourseVersion` bumps `1.4.0` → `1.4.1` in upstream's `main.tex` — no
MyST-side equivalent (the port has never tracked this value; `myst.yml`
has no version field tied to it), noted here only for the historical
record.
