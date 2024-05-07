// Copyright 2024 Derek Chai.
// Use of this code is governed by a MIT license in the LICENSE.txt file.

#let calculate_overlay_color(colors, alpha: 120) = {
  let r_sum = 0
  let g_sum = 0
  let b_sum = 0
  
  for color in colors {
    r_sum += color.at(0)
    g_sum += color.at(1)
    b_sum += color.at(2)
  }

  if colors.len() == 0 {
    return rgb(255, 255, 255, 0)
  }

  return rgb(
    calc.div-euclid(r_sum, colors.len()),
    calc.div-euclid(g_sum, colors.len()),
    calc.div-euclid(b_sum, colors.len()),
    alpha
  )
}

#let karnaugh_2_var(
  var1: [$A$], 
  var2: [$B$], 
  manual_terms: ($times$, "0", "0", "0"), 
  implicants: (), 
  cell_size: 20pt
) = {
  
  let stroke = 0.5pt
  let cell_colors = ((), (), (), ())
  let colors = ((255, 0, 0), (0, 255, 0), (0, 0, 255))

  for (index, implicant) in implicants.enumerate() {
    for cell in implicant {
      cell_colors.at(cell).push(colors.at(index))
    }
  }

  return table(
    columns: (auto, auto, cell_size, cell_size),
    rows: (cell_size),
    align: center + horizon, 
    stroke: none,
    
    [], [], table.cell(colspan: 2, var2), // Variable 2 label.
    [], [], [0], [1], // Variable 2 Gray code.
    table.hline(start: 2, stroke: stroke),
    table.cell(rowspan: 2, var1), // Variable 1 label.
    [0], // Variable 1 Gray code 0.
    table.vline(start: 2, stroke: stroke),
  
    table.cell(fill: calculate_overlay_color(cell_colors.at(0)))[#manual_terms.at(0)],
    table.cell(fill: calculate_overlay_color(cell_colors.at(1)))[#manual_terms.at(1)],
    
    table.vline(start: 2, stroke: stroke),
    [1], // Variable 1 Gray code 1.                
   
    table.cell(fill: calculate_overlay_color(cell_colors.at(2)))[#manual_terms.at(2)],
    table.cell(fill: calculate_overlay_color(cell_colors.at(3)))[#manual_terms.at(3)],
    
    table.hline(start: 2, stroke: stroke)
  )
}

#karnaugh_2_var(var1: [$Q$], manual_terms: ("1", $times.big$, "1", "0"), implicants: ((0, 1), ))