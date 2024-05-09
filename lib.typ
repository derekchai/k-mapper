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

== Test 

Test

#int(4.3)

#blend(rgb(255, 0, 0, 120), rgb(0, 255, 0, 120))

#let a = rgb(255, 0, 0, 120)
#let b = rgb(0, 255, 0, 120)

#stack(
  box(width: 30pt, height: 30pt, fill: a),
  box(width: 30pt, height: 30pt, fill: blend(a, b)),
  box(width: 30pt, height: 30pt, fill: b),
)