(chp-naming)=
# Naming conventions

:::{warning} To review
:class: readiness-toreview

:::

## Case-based naming styles

:::{list-table} Case-based naming styles
:name: tab-case-styles
:header-rows: 1
:align: center

* - Naming style
  - Description
  - Used for
  - Examples
* - `CONSTANT_CASE`
  - All uppercase letters with words separated by underscores (`_`).
  - Global constants, environment variables, and configuration flags
    across C, Java, Rust, and Python.
  - `MAX_TIMEOUT`, `DEFAULT_PORT_NUMBER`.
* - `Train-Case`
  - Capitalized words separated by hyphens (`-`).
  - HTTP headers and specialized configuration keys.
  - `Content-Type`, `Cache-Control`.
* - `camelCase`
  - First word starts with a lowercase letter; every subsequent word
    starts with an uppercase letter with no spaces or symbols.
  - Variables, functions, and methods in Java and C#.
  - `firstName`, `getUserData`.
* - `PascalCase`
  - Every word—including the first word—starts with an uppercase
    letter.
  - Classes, structures, interfaces, enums, and constructors across
    C#, Java, Rust and Python.
  - `FirstName`, `UserProfile`.
* - `snake_case`
  - All lowercase letters with words separated by underscores (`_`).
  - Variables and functions in Python, Ruby, Rust and PHP.
  - `first_name`, `calculate_total_price`.
* - `kebab-case`
  - All lowercase letters with words separated by hyphens (`-`).
  - CSS class/ID names, URLs, HTML attributes, and file/folder names.
  - `user-profile-card`, `main-content`.
:::

## Semantic styles

:::{list-table} Semantic styles
:name: tab-semantic-styles
:header-rows: 1
:align: center

* - Naming style
  - Description
  - Examples
* - Hungarian notation
  - Prefixes an identifier with a short code indicating its data
    type or intended purpose.
  - `sUserName` for a string, `iCount` for an integer.
* - Interface & type prefixes
  - Prefixing interface names with an `I` or generic parameters with
    a `T`.
  - `IUserService`, `TKey`, `TValue`.
* - Boolean prefixes
  - Prefixing boolean variables or predicate functions with words
    like `is` or `has`.
  - `isUserActive`, `hasPermission`.
* - Action-based function patterns
  - Prefixing function names using a set of verb patterns like
    `get`/`find` for retrieving data, `set` for assigning values,
    `create`/`read`/`update`/`delete` for CRUD system, etc.
  - `getFirstName()`, `set_mode()`.
* - Unit suffixes
  - Appending measurement units to variable names to prevent
    ambiguity.
  - `timeoutMs`, `delaySeconds`, `fileSizeMb`.
:::
