# Why choose Rust?

Among the world (see {numref}`fig-popularity`), and particularly inside the
research community, Rust is gaining popularity. Being a language,
like C, primarily targeted to system programming, it offers great performance
on which is added an excellent memory checking layer, and takes advantage of a
*high level of acceptability* by the computer system teams when passing
from research to production.

```{figure} ../img/pypl_rust_python_julia_r.png
:name: fig-popularity
:alt: Popularity of Python, R, Julia and Rust
:width: 100%

Comparison of popularity of Python, R, Julia and Rust
([PYPL](https://pypl.github.io/PYPL.html)).
```

These are already some good reasons to choose Rust as a language, but not
enough.
Some generic questions
([Perkel 2025](http://dx.doi.org/10.1038/d41586-025-01241-6))
are more interesting:

- How does Rust compare to the main languages used in the scientific
  community?
- How is its ecosystem (community & packages) in general and in a specific
  research field?

Rust is already well identified as a possible replacement for Python
([Perkel 2020](http://dx.doi.org/10.1038/d41586-020-03382-2))
in the scientific community.
Being already used by companies
([Rust use cases](https://kruschecompany.com/rust-programming-language-use-cases/)),
Rust is a well developed language for all aspects around computer systems.
With its own strength, it compares well with other langagues
([Rust vs Alternatives](https://kruschecompany.com/rust-vs-alternatives/)).
The Rust community, while not as developed in size as main languages like R
or Python, is quite active, and we have found it fairly easy to find an
answer on common issues related to the language itself or its main packages.
Numerous packages exist to solve standard programming problems, and many are
created each day as seen in {numref}`fig-nbpkgs`.

```{figure} ../img/Perkel_2020_nb_pkgs.png
:name: fig-nbpkgs
:alt: Number of packages over time for R, Python and Rust
:width: 50%

Number of packages over time for R, Python and Rust
([Perkel 2020](http://dx.doi.org/10.1038/d41586-020-03382-2)).
```

However it may be not as easy to develop a scientific application in a
specific field. It would be a long task to look at available packages for all
possible scientific fields, but we have looked at the packages available in
the biology field for Rust and other languages (see
{numref}`tab-biopkgs`). While Rust does not propose as many
packages as R or Python, it is already well developed and should allow to
develop applications in the field quite comfortably.
In comparison, Julia, while an excellent language, designed by and for the
research community, perfectly adapter for the biology field
([Roesch et al. 2023](http://dx.doi.org/10.1038/s41592-023-01832-z)),
does not seem to attract as much attention as Rust.

```{list-table} Rough number of biology related packages for Rust and some concurrent languages
:name: tab-biopkgs
:header-rows: 1
:align: center

* - Language
  - Number of bio packages
* - Python [^a]
  - 5610
* - R [^b]
  - \>3000
* - Rust [^c]
  - 1105
* - Julia [^d]
  - 258
```

[^a]: Obtained by searching the text "bio biology" inside the
      [official package repository](https://pypi.org/).
[^b]: Obtained from the [Bioconductor](https://www.bioconductor.org/) site.
[^c]: Obtained from the Biology category inside the unofficial package
      repository [lib.rs](https://lib.rs/).
[^d]: Obtained by searching the text "bio" inside the
      [JuliaHub](https://juliahub.com/ui/Packages) database.
