#import "utils.typ": *

== Test 

Test

#blend(rgb(255, 0, 0, 120), rgb(0, 255, 0, 120))

#let a = rgb(255, 0, 0, 120)
#let b = rgb(0, 255, 0, 120)
#let c = rgb(0, 0, 255, 120)

#grid(
  columns: 2,
  [#box(width: 30pt, height: 30pt, fill: a)], [],
  [#box(width: 30pt, height: 30pt, fill: blend(a, b))], [#box(width: 30pt, height: 30pt, fill: b)],
  [], [#box(width: 30pt, height: 30pt, fill: blend(c, b))],
  [], [#box(width: 30pt, height: 30pt, fill: c)],
  rect(
    width: 30pt, height: 30pt,
    fill: a,
    stroke: rgb(255, 0, 0, 255), 
    radius: 10pt
  )
)

#let karnaugh-skeleton(
  minterms: none, // TODO
  maxterms: none, // TODO
  manual-terms: none,
  implicants: (),
  cell-size: 20pt,
  stroke-size: 0.5pt,
  alpha: 120
) = {
  let cell-terms
  let cell-total-size = cell-size + stroke-size

  if manual-terms != none {
    cell-terms = manual-terms.map(x => to-gray-code(x, 8)) // TODO
  } 

  let base = table(
    columns: (cell-size, cell-size),
    rows: cell-size,
    align: center + horizon,
    stroke: stroke-size,

    ..cell-terms.map(term => [#term])
  )

  zstack(
    alignment: bottom + left,
    (base, 0pt, 0pt), 
    (square(
      stroke: red + 0.5pt,
      fill: rgb(255, 0, 0, 120)
    ), 0pt, 0pt)
  )

  for implicant in implicants {
    [#gray-to-coordinate(implicant, 8)]
  }
}

#karnaugh-skeleton(
  manual-terms: (0, 1, 2, 3, 4, 5, 6, 7),
  implicants: (6, 3)
)