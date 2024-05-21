// realise progress bubbles bond which is broadly used in beamer templates
// this project depends on polylux https://github.com/andreasKroepelin/polylux
// a beamer example with this widget see: https://github.com/LSYS/beamerTemplate

#import "../logic.typ"
#import "../utils/utils.typ"
#import "../utils/widgets-utils.typ": page-info

// global variable
#let PAGE-TYPES = (slide: "Slide", section: "Section")


// utils
#let parse-page-info(page-info) = {
  let zipped-page-info = page-info.page-physical-nums.zip(
    page-info.page-logical-nums,
    page-info.page-types)
  
  let all-sect-pages = zipped-page-info.filter(
    pages => pages.last() == PAGE-TYPES.section) // U R Here!

  let sect-divided-pages = zipped-page-info.map(
    pages => if pages.last() == PAGE-TYPES.slide { pages 
    } else { (PAGE-TYPES.section,) * 3 })
  
  let splited-logical-pages = sect-divided-pages.map(
    pages => pages.at(1)
  )
  .split(PAGE-TYPES.section)
  .slice(1) // we don't need the slides before the first section
  .map(pages => pages.dedup())
  
  let logical-pagenums-each-sect = splited-logical-pages.map(pages => pages.len())
  
  (
    splited-logical-pages: splited-logical-pages,
    logical-pagenums-each-sect: logical-pagenums-each-sect,
    number-of-sects: logical-pagenums-each-sect.len(),
    physical-to-logical: page-info.page-physical-nums.zip(page-info.page-logical-nums),
    
    all-sect-pages: zipped-page-info.filter(pages => pages.last() == PAGE-TYPES.section).map(pages => pages.first()),
    
    all-bubble-pages: splited-logical-pages.map(pages => pages.map(page => zipped-page-info.dedup(key: pages => pages.at(1)).find(pages => pages.at(1) == page).first())),
  )
}

#let spit-bubbles(num, link-pages, color, radius, spacing, current-loc: none) = {
  let bubble = circle(radius: 4pt, stroke: color)
  let current-bubble = circle(radius: 4pt, stroke: color, fill: color)
  
  let bubbles-arr = range(num).map(i => {
    if i == current-loc {
      current-bubble
    } else {
      bubble
    }
  })
  .zip(
    link-pages.map(
      page => (page: page, x: 0pt, y: 0pt)
    )
  )
  .map(
    pair => {link(pair.last(), pair.first())}
  )

  stack(dir: ltr, spacing: 3pt, ..bubbles-arr)
}

#let measure-cell-content(names-arr, bubbles-arr) = {
  let name-len-arr = names-arr.map(name => measure(name).width.pt())
  let bubble-len-arr = bubbles-arr.map(bubble => measure(bubble).width.pt())

  name-len-arr.zip(bubble-len-arr).map(pair => {
    calc.max(..pair)
  })
}

#let find-current-bubble(page-logical-num, splited-logical-pages, logical-pagenums-each-sect) = {
  let accu-logical-pagenums = range(1, logical-pagenums-each-sect.len() + 1).map(i => {
    logical-pagenums-each-sect.slice(0, i).sum()
  })
  
  let current-bubble-index = splited-logical-pages.flatten().position(index => index == page-logical-num)

  let current-sect-index = if current-bubble-index == none {
    -1
  } else {
    accu-logical-pagenums.position(num => num - 1 >= current-bubble-index)
  }

  let current-bubble-within-sect = if current-sect-index == -1 {
    none
  } else if current-sect-index == 0 {
      current-bubble-index
  } else {
    current-bubble-index - accu-logical-pagenums.at(current-sect-index - 1)
  }
  
  let current-bubble = range(logical-pagenums-each-sect.len()).map(i => {
    if i == current-sect-index {
      current-bubble-within-sect
    } else {
      none
    }
  })
  
  current-bubble
}


// progress bubbles band
#let progress-bubbles-band(fill, font-color, font-size: 0.8em, height: 100%, bubble-radius: 4pt, bubble-spacing: 3pt) = {
  show: block.with(
    width: 100%,
    height: height,
    above: 0pt,
    below: 0pt,
    fill: fill,
    breakable: false
  )
  set align(horizon)
  set text(fill: font-color, size: font-size)
  
  locate( loc => {
    let parsed-info = parse-page-info(page-info.final(loc))

    let page-logical-num = {
      parsed-info.physical-to-logical.find(pair => pair.first() == loc.page()).last()
    }

    let current-bubble = {
      find-current-bubble(page-logical-num, parsed-info.splited-logical-pages, parsed-info.logical-pagenums-each-sect)
    }

    let sect-names = utils.sections-state.final(loc).map(
      section => {section.body}
    )
    .zip(
      parsed-info.all-sect-pages.map(
        page => (page: page, x: 0pt, y: 0pt)
      )
    )
    .map(
      pair => {link(pair.last(), pair.first())}
    )
    
    let sect-bubbles = parsed-info.logical-pagenums-each-sect
    .zip(parsed-info.all-bubble-pages, current-bubble)
    .map(
      pages => {spit-bubbles(pages.first(), pages.at(1), font-color, bubble-radius, bubble-spacing, current-loc: pages.last())}
    )

    let cell-space-frac = measure-cell-content(sect-names, sect-bubbles).map(frac => frac * 1fr)

    show table.cell: it => {
      if it.y == 0 {
        set text(font-color)
        strong(it)
      } else {
        it
      }
    }
  
    table(
      stroke: fill,
      fill: fill,
      columns: cell-space-frac,
      rows:0.8em,
      align: center + horizon,
      inset: 10pt,
      row-gutter:3pt,
      table.header(
        ..sect-names
      ),
      ..sect-bubbles,
    )
  })
}