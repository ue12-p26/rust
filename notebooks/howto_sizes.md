# About memory and sizes

:::{warning} To review
:class: readiness-toreview

:::

(chp-byte)=
## Byte

A *byte* (or *octet*) is a memory unit made of *8 bits*.

It is used, for instance, to measure the sizes of files or
transmitted data. Be careful, however, since two systems coexist to
express those sizes: the *decimal* system and the *binary* system.
See {numref}`tab-size-units-decimal` and {numref}`tab-size-units-binary`.

:::{list-table} Size measurement units (decimal)
:name: tab-size-units-decimal
:header-rows: 1
:align: center

* - Value
  - Unit
  - Fullname
* - $1000$ ($10^3$)
  - kB
  - kilobyte
* - $1000^2$ ($10^6$)
  - MB
  - megabyte
* - $1000^3$ ($10^9$)
  - GB
  - gigabyte
* - $1000^4$ ($10^{12}$)
  - TB
  - terabyte
* - $1000^5$ ($10^{15}$)
  - PB
  - petabyte
:::

:::{list-table} Size measurement units (binary)
:name: tab-size-units-binary
:header-rows: 1
:align: center

* - Value
  - Unit
  - Fullname
* - $1024$ ($2^{10}$)
  - KiB
  - kibibyte
* - $1024^2$ ($2^{20}$)
  - MiB
  - mebibyte
* - $1024^3$ ($2^{30}$)
  - GiB
  - gibibyte
* - $1024^4$ ($2^{40}$)
  - TiB
  - tebibyte
* - $1024^5$ ($2^{50}$)
  - PiB
  - pebibyte
:::

(chp-word)=
## Word

A *word* is the natural unit of data handled by an architecture
(virtual or physical). On a 64-bit architecture a word is 64 bits
(i.e: 8 bytes), on a 32-bit architecture a word is 32 bits (i.e.: 4
bytes).

A *word* is the needed memory to store an integer that spans the
entire memory addressing range. It is thus used to store *pointers*
and memory *sizes* (array sizes, object sizes, ...).
