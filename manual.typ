// Copyright 2024 Derek Chai.
// Use of this code is governed by a MIT license in the LICENSE.txt file.

#import "lib.typ": *

#let version = "1.1.0"

#let conf(doc) = {
  set page(
    paper: "us-letter",
    footer: context [
      *the `k-mapper` package* #version
      #h(1fr)
      #counter(page).display(
        "1 of 1",
        both: true,
      )
    ]
  )
  set par(first-line-indent: 1em)
  set text(size: 11pt)

  columns(1, doc)
}

#show: doc => conf(doc)

#set par(spacing: 1em, leading: 1em)
#show heading: set block(above: 2em, below: 1em)
#show "k-mapper": `k-mapper`
#show link: underline

= the k-mapper package #version

#v(2em)

#figure(
  grid(
    columns: (1fr, 1fr),
    karnaugh(
      16,
      x-label: $A B$,
      y-label: $C D$,
      manual-terms: (0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0),
      implicants: ((3, 6), (2, 10), (9, 11)),
    ),
    ```typst
    karnaugh(
      16,
      x-label: $A B$,
      y-label: $C D$,
      manual-terms: (
        0, 0, 1, 1, 0, 0, 1, 1, 
        0, 1, 1, 1, 0, 0, 1, 0
      ),
      implicants: ((3, 6), (2, 10), (9, 11)),
    )
    ```
  ),
  caption: [Example implementation and code of a Karnaugh map with `k-mapper`.],
  kind: "diagram",
  supplement: [Diagram]
)

#v(1em)

#columns(2)[
  == introduction

  k-mapper is a Typst package for adding customizable Karnaugh maps of 2~by~2, 2~by~4, and 4~by~4 grid sizes to your Typst projects.

  See the source code on the Github repository for the project #link("https://github.com/derekchai/k-mapper/tree/main")[here], and the changelog #link("https://github.com/derekchai/k-mapper/blob/698e8554ce67e3a61dd30319ab8f712a6a6b8daa/changelog.md")[here].

  == using `karnaugh()`
  The main function of this package is the `karnaugh()` function, which allows you to create and customize all sizes of Karnaugh maps. See the following pages for function arguments.

  === gray code position
  The position of implicants in k-mapper are declared via _Gray code position_. This is similar to Karnaugh map packages in LaTeX. 

  The Gray code position of a cell is determined from the coordinates of that cell with respect to the binary axis labels.

  The empty maps shown in @gray-code-positions show each cell's Gray code position. Note that the Gray code position for a cell differs depending on the Karnaugh map's grid size.

  Gray code position allows you to input minterms and maxterms using `manual-terms` simply by copying your truth table in that order. 

  #figure(
    grid(
      columns: (1fr, 1fr, 1fr),
      align: center + horizon,
      karnaugh(
        4,
        manual-terms: (0, 1, 2, 3)
      ),
      karnaugh(
        8,
        manual-terms: (0, 1, 2, 3, 4, 5, 6, 7)
      ),
      karnaugh(
        16,
        manual-terms: (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
        implicants: ((14, 14), ),
        colors: ((rgb(100, 100, 100, 100), ))
      )
    ),
    scope: "parent",
    placement: bottom,
    caption: [Gray Code positions for three sizes of Karnaugh maps.],
    kind: "diagram",
    supplement: [Diagram]
  )<gray-code-positions>
]

#colbreak()

=== function arguments
#table(
  columns: (auto, auto, 1fr, auto),
  stroke: none,
  inset: 10pt,

  table.header([*name*], [*default*], [*description*], [*example values*]),

  [*`grid-size`*\ `int`], [required], [The size of the Karnaugh map's grid. This value can be only `4` (2~by~2), `8` (2~by~4), or `16` (4~by~4). Any other values will throw an error.], [```
  4

  8

  16```],

  [*`x-label`*\ `content`], [```typst $$```], [The label (usually a variable name) to go on the top (x-axis) of the Karnaugh map.], [```typst 
  $A$

  [foo]```],

  [*`y-label`*\ `content`], [```typst $$```], [The label (usually a variable name) to go on the left (y-axis) of the Karnaugh map.], [```typst 
  $B$

  [bar]```],

  [#strike(stroke: 1pt)[*`minterms`*]\ `(int)`\ `none`], [```typst none```], [(Deprecated; use `manual-terms`) #strike[The `array` of Gray code positions#footnote[See p. 1.]<gcp> where at that position is a minterm (`0`).
  
  Mutually exclusive with `maxterms` and `manual-terms`.]], [```typst 
  (3, 4, 6)

  (1, )
  ```],

  [#strike(stroke: 1pt)[*`maxterms`*]\ `(int)`\ `none`], [```typst none```], [(Deprecated; use `manual-terms` #strike[The array of Gray code positions@gcp where at that position is a maxterm (`1`).
  
  Mutually exclusive with `minterms` and `manual-terms`.]], [```typst 
  (0, 1, 2, 3, 
    5, 11, 12

  (7, )```],

  [*`manual-terms`*\ `(content)`\ `none`], [```typst none```], [The `array` of `content` in each cell in order of Gray-code position@gcp. The length of this `array` _must_ equal the `grid-size`.

  Mutually exclusive with `minterms` and `maxterms`.], [```typst 
  // Grid-size 4
  (0, "X", 1, 1)
  ```],

  [*`implicants`*\ `((int, int), )`], [```typst ()```], [An `array` where each element is an `array` of two `int`s, where each `int` is a Gray code position@gcp corner of a _rectangular_ implicant.], [```typst 
  ((0, 3), (1, 1))

  ((0, 2), )```],

  [*`horizontal
  -implicants`*\ `((int, int), )`], [```typst ()```], [An `array` where each element is an `array` of two `int`s, where each `int` is a Gray code position@gcp corner of a _horizontal split_ implicant --- that is, one which wraps around the vertical edges of the Karnaugh map.], [```typst 
  // Grid-size 16
  ((0, 6), (8, 10))```],

  [*`vertical
  -implicants`*\ `((int, int), )`], [```typst ()```], [An `array` where each element is an `array` of two `int`s, where each `int` is a Gray code position@gcp corner of a _vertical split_ implicant --- that is, one which wraps around the horizontal edges of the Karnaugh map.], [```typst 
  // Grid-size 8
  ((0, 4), )
  
  // Grid-size 16
  ((0, 9), (2, 10))```],

  [*`corner
  -implicants`*\ `bool`], [```typst false```], [A `bool` which indicates whether the Karnaugh map contains a `corner split` implicant --- that is, one which wraps around both vertical and horizontal edges of the Karnaugh map.], [```typst 
  true```],

  [*`cell-size`*\ `length`], [```typst 20pt```], [The size of an individual cell in the Karnaugh map.], [```typst 
  1cm
  ```],

  [*`stroke-width`*\ `length`], [```typst 0.5pt```], [The stroke width of the Karnaugh map grid.], [```typst 
  0.2pt
  ```],

  [*`colors`*\ `(color)`], [array of: \ red \ green \ blue \ cyan \ magenta \ yellow], [An array of RGBA `color`s to be used in displaying implicants. The first implicant uses the first `color` in the array, the second implicant the second color, etc. If there are more implicants than there are colors, each subsequent implicant will use the least recently used color (i.e. it wraps around).
  
  By default, all `color`s in `colors` have alpha values of `100`.], [```typst 
  // Grayscale K-map
  (rgb(
    200, 200, 200, 100
  ), )
  ```],

  [*`implicant-inset`*\ `length`], [```typst 2pt```], [The inset of implicants within each cell.], [```typst 
  3pt
  ```],

  [*`edge-implicant
  -overflow`*\ `length`], [```typst 5pt```], [How much _split implicants_ (horizontal, vertical, corner) overflow the bounds of the grid.], [```typst 
  2mm
  ```],

  [*`implicant-radius`*\ `length`], [```typst 5pt```], [The corner radius of implicants.], [```typst 
  3mm
  ```],

  [*`implicant-stroke
  -transparentize`*\ `ratio`], [```typst #-100%```], [The ratio to transparentize the stroke color of implicants by. If set to `0%`, the stroke color of implicants are the same as the fill color, darked by the factor set in `implicant-stroke-darken` (`60%` by default). Negative values mean the stroke color becomes more opaque.], [```typst 
  -50%
  ```],

  [*`implicant-stroke
  -darken`*\ `ratio`], [```typst 60%```], [The ratio to darken the stroke color of implicants by.], [```typst 
  100%
  ```],


  [*`implicant-stroke
  -width`*\ `length`], [```typst 0.5pt```], [The stroke width of implicants.], [```typst 
  1pt
  ```],
)

=== deprecation of `minterms` and `maxterms`
These two function parameters have been deprecated as I mixed up minterms and maxterms when initially writing this package. Rather than rename and risk breaking changes, I have decided to deprecate them and encourage the use of `manual-terms` instead.

Thank you to Moch. Nafkhan Alzamzami (`nafkhanzam`) on GitHub for pointing out this issue.

== examples
#grid(
  columns: (auto, 1fr),
  align: (right, left),
  gutter: 20pt,

  karnaugh(
    4,
    manual-terms: (0, 1, 1, 1),
    implicants: ((1, 3), (2, 3)),
    colors: (rgb(100, 100, 100, 100), )
  ),

  [```typst
  // Grayscale Karnaugh map
  #karnaugh(
    4,
    manual-terms: (0, 1, 1, 1),
    implicants: ((1, 3), (2, 3)),
    colors: (rgb(100, 100, 100, 100), ) // <-
  )
  ```],
  
  karnaugh(
    8,
    x-label: $C$,
    y-label: $A B$,
    manual-terms: (0, 1, 0, 0, 0, "X", 1, 1),
    implicants: ((6, 7), ),
    vertical-implicants: ((1, 5), )
  ),

  [```typst
  #karnaugh(
    8,
    x-label: $C$,
    y-label: $A B$,
    manual-terms: (0, 1, 0, 0, 0, "X", 1, 1),
    implicants: ((6, 7), ),
    vertical-implicants: ((1, 5), )
  )
  ```],

  karnaugh(
    16,
    x-label: $C D$,
    y-label: $A B$,
    manual-terms: (1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1),
    implicants: ((5, 15), ),
    corner-implicants: true
  ),

  [```typst
  #karnaugh(
    16,
    x-label: $C D$,
    y-label: $A B$,
    manual-terms: (
      1, 0, 1, 0, 0, 1, 0, 1, 
      1, 0, 1, 0, 0, 1, 0, 1
    ),
    implicants: ((5, 15), ),
    corner-implicants: true
  )
  ```],

  karnaugh(
    8,
    manual-terms: (0, 1, 2, 3, 4, 5, 6, 7),
    implicants: ((0, 0), (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7)),
  ),

  [```typst
  #karnaugh(
    8,
    manual-terms: (0, 1, 2, 3, 4, 5, 6, 7),
    implicants: (
      (0, 0), (1, 1), (2, 2), (3, 3), 
      (4, 4), (5, 5), (6, 6), (7, 7)
    )
  )
  ```],

  karnaugh(
    16,
    x-label: $C D$,
    y-label: $A B$,
    manual-terms: (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
    implicants: ((5, 7), (5, 13), (15, 15)),
    vertical-implicants: ((1, 11), ),
    horizontal-implicants: ((4, 14), ),
    corner-implicants: true,
  ),

  [```typst
  #karnaugh(
    16,
    x-label: $C D$,
    y-label: $A B$,
    manual-terms: (
      0, 1, 2, 3, 4, 5, 6, 7, 8, 
      9, 10, 11, 12, 13, 14, 15
    ),
    implicants: ((5, 7), (5, 13), (15, 15)),
    vertical-implicants: ((1, 11), ),
    horizontal-implicants: ((4, 14), ),
    corner-implicants: true,
  )
  ```],

  karnaugh(
    8,
    x-label: $C$,
    y-label: $A B$,
    manual-terms: (0, 1, 2, 3, 4, 5, 6, 7),
    implicants: ((0, 3), (2, 7)),
    horizontal-implicants: ((4, 5), ),
    colors: (rgb(255, 255, 255, 0), ),
    implicant-stroke-width: 1pt
  ),

  [```typst
  // No fill Karnaugh map
  #karnaugh(
    8,
    x-label: $C$,
    y-label: $A B$,
    manual-terms: (0, 1, 2, 3, 4, 5, 6, 7),
    implicants: ((0, 3), (2, 7)),
    horizontal-implicants: ((4, 5), ),
    colors: (rgb(255, 255, 255, 0), ),
    implicant-stroke-width: 1pt
  )
  ```]
)