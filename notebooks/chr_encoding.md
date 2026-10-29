(chp-chr-enc)=
# Character encoding

:::{warning} To review
:class: readiness-toreview

:::

For a computer a character string is only a series of numbers. We give
it a special meaning by associating it with an *encoding* (i.e.: a
correspondence table between numbers and characters). To render a
string on screen or paper, we use a
[Computer font](https://en.wikipedia.org/wiki/Computer_font).

The [ASCII](https://en.wikipedia.org/wiki/ASCII) (American Standard
Code for Information Interchange) is a widespread characters & controls
code, used in every computer today. As seen in {numref}`fig-usascii`,
it is a 7-bit encoding that defines 128 symbols and control codes.

:::{figure} media/USASCII_code_chart.svg
:name: fig-usascii
:alt: 7-bit ASCII table

7-bit ASCII table
:::

The main drawback of the ASCII is that it is US-centric. That is why
[Extended ASCII](https://en.wikipedia.org/wiki/Extended_ASCII)
encodings, like [Latin-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1),
had been developped, using the remaining 128 values on a 8-bit value.
However, each language defining its own encoding on values from `0x80`
to `0xff`, reading a pure text file (i.e.: without encoding information)
could lead to decoding errors (i.e.: using an encoding for another).
Moreover, 128 symbols were not enough for many languages outside Europe
and America.

As a consequence [Unicode](https://en.wikipedia.org/wiki/Unicode) was
developped. It is compatible with ASCII and Latin-1, and extend the
encoding with additional
[code points](https://en.wikipedia.org/wiki/Code_point) starting at
number `0x0100`. Unicode version 18.0 defines more than 300,000
characters.

Unicode may be encoded in various formats: UTF-8, UTF-16, UTF-32. UTF-8
and UTF-16 are variable-length encoding, using possibly multiple values
to encode a character. For instance any non-Latin-1 character is
encoded with at least two bytes in UTF-8. UTF-32 is a fixed-length
encoding.

UTF-8 strings can be either seen as:

- Byte arrays (how they are stored internally).
- List of Unicode scalar values. No resolution of
  [Diacritics](https://en.wikipedia.org/wiki/Combining_character)
  (e.g.: `` `e `` stays as-is).
- List of
  [Grapheme Clusters](<https://en.wikipedia.org/wiki/Universal_Character_Set_characters#Characters,_grapheme_clusters_and_glyphs>).
  Diacritics are resolved (e.g.: `` `e `` becomes `è`).
