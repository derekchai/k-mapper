#import "utils.typ": *

#let karnaugh(
  grid-size,
  minterms: none, // TODO
  maxterms: none, // TODO
  manual-terms: none,
  implicants: (),
  horizontal-implicants: (),
  vertical-implicants: (),
  cell-size: 20pt,
  stroke-size: 0.5pt,
  alpha: 120,
  colors: (
    rgb(255, 0, 0, 100),
    rgb(0, 255, 0, 100),
    rgb(0, 0, 255, 100),
    rgb(0, 255, 255, 100),
    rgb(255, 0, 255, 100),
    rgb(255, 255, 0, 100),
  ),
  implicant-inset: 4pt,
  edge-implicant-overflow: 5pt,
  implicant-radius: 5pt
) = {
  let cell-terms
  let cell-total-size = cell-size // + stroke-size

  if manual-terms != none {
    cell-terms = manual-terms.map(x => to-gray-code(x, grid-size)) // TODO
  } 

  let columns-dict = (
    "4": (cell-size, cell-size),
    "8": (cell-size, cell-size),
    "16": (cell-size, cell-size, cell-size, cell-size),
  )

  let base = table(
    columns: columns-dict.at(str(grid-size)),
    rows: cell-size,
    align: center + horizon,
    stroke: stroke-size,

    ..cell-terms.map(term => [#term])
  )

  zstack(
    alignment: bottom + left,
    (base, 0pt, 0pt), 

    // Implicants.
    ..for (index, implicant) in implicants.enumerate() {
      let p1 = gray-to-coordinate(implicant.at(0), grid-size) 
      let p2 = gray-to-coordinate(implicant.at(1), grid-size)

      let bottom-left-point
      let top-right-point

      bottom-left-point = (calc.min(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      top-right-point = (calc.max(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))

      let dx = bottom-left-point.at(0) * cell-total-size
      let dy = bottom-left-point.at(1) * cell-total-size

      let width = (top-right-point.at(0) - bottom-left-point.at(0) + 1) * cell-size
      let height = (top-right-point.at(1) - bottom-left-point.at(1) + 1) * cell-size

      // Loop back on the colors array if there are more implicants than there
      // are colors.
      let color = colors.at(calc.rem-euclid(index, colors.len()))

      (
        (
          rect(
            stroke: color,
            fill: color,
            width: width - implicant-inset,
            height: height - implicant-inset,
            radius: implicant-radius
          ), dx + (implicant-inset / 2), -dy - (implicant-inset / 2)
        ),
      )
    }, // Implicants.

    // Horizontal implicants.
    ..for (index, implicant) in horizontal-implicants.enumerate() {
      let p1 = gray-to-coordinate(implicant.at(0), grid-size) 
      let p2 = gray-to-coordinate(implicant.at(1), grid-size)

      let bottom-left-point = (calc.min(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      let bottom-right-point = (calc.max(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      let top-right-point = (calc.max(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))

      let dx1 = bottom-left-point.at(0) * cell-total-size - edge-implicant-overflow
      let dx2 = bottom-right-point.at(0) * cell-total-size
      let dy = bottom-left-point.at(1) * cell-total-size
      // let dy2 = bottom-right-point.at(1) * cell-total-size

      let width = cell-size + edge-implicant-overflow
      let height = (top-right-point.at(1) - bottom-left-point.at(1) + 1) * cell-size

      // Loop back on the colors array if there are more implicants than there
      // are colors.
      let color = colors.at(calc.rem-euclid(index, colors.len()))

      (
        (
          rect(
            stroke: (
              top: color,
              right: color,
              bottom: color
            ),
            fill: color,
            width: width - implicant-inset,
            height: height - implicant-inset,
            radius: (right: implicant-radius)
          ), dx1 + (implicant-inset / 2), -dy - (implicant-inset / 2)
        ),
        (
          rect(
            stroke: (
              top: color,
              left: color,
              bottom: color
            ),
            fill: color,
            width: width - implicant-inset,
            height: height - implicant-inset,
            radius: (left: implicant-radius)
          ), dx2 + (implicant-inset / 2), -dy - (implicant-inset / 2)
        )
      )
    },
    
    // Vertical implicants.
    ..for (index, implicant) in vertical-implicants.enumerate() {
      let p1 = gray-to-coordinate(implicant.at(0), grid-size) 
      let p2 = gray-to-coordinate(implicant.at(1), grid-size)

      let bottom-left-point = (calc.min(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      let top-left-point = (calc.min(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))
      let top-right-point = (calc.max(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))

      let dx = bottom-left-point.at(0) * cell-total-size
      let dy1 = bottom-left-point.at(1) * cell-total-size - edge-implicant-overflow
      let dy2 = top-left-point.at(1) * cell-total-size

      let width = (top-right-point.at(0) - bottom-left-point.at(0) + 1) * cell-size
      let height = cell-size + edge-implicant-overflow

      // Loop back on the colors array if there are more implicants than there
      // are colors.
      let color = colors.at(calc.rem-euclid(index, colors.len()))

      (
        (
          rect(
            stroke: (
              left: color, 
              top: color,
              right: color
            ),
            fill: color,
            width: width - implicant-inset,
            height: height - implicant-inset,
            radius: (top: implicant-radius)
          ), dx + (implicant-inset / 2), -dy1 - (implicant-inset / 2)
        ),
        (
          rect(
            stroke: (
              left: color,
              bottom: color,
              right: color,
            ),
            fill: color,
            width: width - implicant-inset,
            height: height - implicant-inset,
            radius: (bottom: implicant-radius)
          ), dx + (implicant-inset / 2), -dy2 - (implicant-inset / 2)
        )
      )
    } // Vertical implicants.


  )
}

#karnaugh(
  8,
  manual-terms: (0, 1, 2, 3, 4, 5, 6, 7),
  implicants: ((0,0), (1,1), (2,2), (3,3), (4,4), (5,5), (6,6))
)

#karnaugh(
  16,
  manual-terms: (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
  implicants: ((0, 5), (3, 11), (5, 10), (8, 12))
)

#karnaugh(
  4,
  manual-terms: (0, 1, 2, 3),
  implicants: ((0, 1), (0, 2))
)

#karnaugh(
  16,
  manual-terms: (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
  horizontal-implicants: ((12, 10), (0, 2))
)

#karnaugh(
  16,
  manual-terms: (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
  vertical-implicants: ((0, 8), (3, 10))
)

[ABCDEF]aaabbbcdd