#import "utils.typ": blend

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