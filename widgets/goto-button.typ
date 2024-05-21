#import "../utils/widgets-utils.typ": page-info, register-page-info

#let parse-page-info(page-info) = {
  let zipped-page-info = page-info.page-physical-nums.zip(
    page-info.page-logical-nums)
  
  let logical-to-last-physical = zipped-page-info.rev().dedup(key: pages => pages.at(1))

  logical-to-last-physical
}

#let goto(logical-page, dir: none, font-color: black, stroke: none, fill: none) = {
  let symbol = if dir == "forward" {
    math.triangle.filled.small.r
  } else if dir == "backward" {
    math.triangle.filled.small.l
  } else {
    none
  }

  locate( loc => {
    let logical-to-last-physical = parse-page-info(page-info.final(loc))

    let physical-page = logical-to-last-physical.find(pages => pages.at(1) == logical-page).first()

    link((page: physical-page, x: 0pt, y: 0pt), 
        box(stroke: stroke, fill: fill, radius: 5pt, inset: 3pt, baseline: 20%)[
        #text(font-color)[$#symbol cal(P) #logical-page$ ]
    ])
  })
}