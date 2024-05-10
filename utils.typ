#let blend(..args) = {
  // Converts each color in ..args to hex values, and then to RGB values, and
  // then extracts the components of the RGB values.
  let colors = args
    .pos()
    .map(color => rgb(color.to-hex()).components(alpha: true))

  let result-color = colors.at(0)

  for color in colors.slice(1) {
    let (fg-r, fg-g, fg-b, fg-a) = color
    let (bg-r, bg-g, bg-b, bg-a) = result-color

    let new-r = fg-r * fg-a + bg-r * (100% - fg-a)
    let new-g = fg-g * fg-a + bg-g * (100% - fg-a)
    let new-b = fg-b * fg-a + bg-b * (100% - fg-a)

    result-color = (new-r, new-g, new-b, fg-a)
  }

  return rgb(..result-color)
}

// Converts the zero-indexed nth position of the Karnaugh map to its Gray code
// coordinate.
#let to-gray-code(n, grid-size) = {
  assert(grid-size == 4 or grid-size == 8 or grid-size == 16,
  message: "Please enter a grid size of 4, 8, or 16!")

  if grid-size == 8 {
    if n == 4 { return 6 }
    else if n == 5 { return 7 }
    else if n == 6 { return 4 }
    else if n == 7 { return 5 }
    else { return n }
  } else if grid-size == 16 {
    if n == 2 { return 3 }
    else if n == 3 { return 2 }
    else if n == 6 { return 7 }
    else if n == 7 { return 6 }
    else if n == 8 { return 12 }
    else if n == 9 { return 13 }
    else if n == 10 { return 15 }
    else if n == 11 { return 14 }
    else if n == 12 { return 8 }
    else if n == 13 { return 9 }
    else if n == 14 { return 11 }
    else if n == 15 { return 10 }
    else { return n }
  } else {
    return n
  }
}

#let gray-to-coordinate(n, grid-size) = {
  assert(grid-size == 4 or grid-size == 8 or grid-size == 16,
  message: "Please enter a grid size of 4, 8, or 16!")

  if grid-size == 8 {
    if n == 4 { return (0, 0) }
    else if n == 5 { return (1, 0) }
    else if n == 6 { return (0, 1) }
    else if n == 7 { return (1, 1) }
    else if n == 2 { return (0, 2) }
    else if n == 3 { return (1, 2) }
    else if n == 0 { return (0, 3) }
    else if n == 1 { return (1, 3) }
  }
  // TODO: other grid sizes.
}

#let zstack(
  alignment: top + left,
  ..args
) = style(styles => {
    let width = 0pt
    let height = 0pt
    for item in args.pos() {
        let size = measure(item.at(0), styles)
        width = calc.max(width, size.width)
        height = calc.max(height, size.height)
    }
    block(width: width, height: height, {
        for item in args.pos() {
            place(
              alignment,
              dx: item.at(1),
              dy: item.at(2),
              item.at(0)
            )
        }
    })
})