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
commit:   eb55b74
subject:  Packaging / Project definition
date:     2026-09-21
```

Previously caught up to 7f1bd8d3f897165bf7c8d13be76c444e7e9ed0b5 (2026-09-20).

### Branch `109-collections`

Starting from `eb55b74` (tip of upstream `origin/main` at the time),
upstream opened a feature branch `origin/109-collections` that is
being ported here on a matching local branch `109-collections`
(branched off the `main` commit that ported `eb55b74`). The porting
routine (per-upstream-commit, `port of <sha>: <subject>` messages) is
identical; only the branch differs. When this branch is eventually
merged upstream, the corresponding local branch should be merged into
`main` here too (or rebased — ask the user which).

```
upstream: git@gitlab.com:cnrgh/teaching/rust-class.git
commit:   ada59fb
subject:  Write BTreeMap chapter
date:     2026-09-24
```

Previously caught up to a635d7c85f777a34268d3137ff076616eb479655 (2026-09-24).

**Note (2026-09-24):** the `myst-109-collections` bookmark in
`upstream-tex` had drifted ahead of what was actually ported on this
branch (it pointed at `ec77c0f`, 4 commits past the real last-ported
`8dae87a`) — reset to match reality before resuming. Kept the bookmark
(rather than removing it) since it's useful for noticing upstream
activity; just make sure it's moved *only* as each commit is actually
ported, not preemptively.

This is the last commit on the `myst` branch of upstream at the time of
this porting pass; `myst` and `origin/main` point to the same commit
(`eb55b74`), so the MyST port is fully caught up as of this pass.

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
| `table:VecMethods`     | `tab-vec-methods`    | `vec.md` (moved from `vec_methods.md`, item 46) |
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
