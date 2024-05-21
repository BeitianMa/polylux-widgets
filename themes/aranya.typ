// TODO:
// we dont allow content spillover to the next page now...

#import "../logic.typ"
#import "../utils/utils.typ"
#import "../utils/widgets-utils.typ": register-page-info
#import "../widgets/goto-button.typ": goto
#import "../widgets/progress-bubbles.typ": PAGE-TYPES, progress-bubbles-band

// colors
#let color-aranya-beach = rgb("#FEFCF5")
#let color-aranya-glow = rgb("#FBC884")
#let color-aranya-sunset = rgb("#D04E34")
#let color-aranya-sea = rgb("#31466F")
#let color-aranya-wood = rgb("#563D36")

#let color-aranya-deep-sea = color-aranya-sea.darken(30%)


// state variables
#let aranya-title = state("aranya-title", [])
#let logical-pagenums = state("logical-pagenums", ())
#let physical-pagenums = state("physical-pagenums", ())


// utils
#let aranya-backdrop = block.with(
  width: 100%,
  height: 100%,
  above: 0pt,
  below: 0pt,
  breakable: false
)

  
// elements
#let aranya-progress-bar = utils.polylux-progress( ratio => {
  grid(
    columns: (ratio * 100%, 1fr),
    aranya-backdrop(fill: color-aranya-sunset),
    aranya-backdrop(fill: color-aranya-glow)
  )
})

#let aranya-sect-band = {
  progress-bubbles-band(color-aranya-deep-sea, color-aranya-beach, height: 50%)
}

#let aranya-heading-band(title) = {
  show: aranya-backdrop.with(height:50%, fill: color-aranya-sea, inset: 1em)
  set align(horizon)
  set text(fill: color-aranya-beach, size: 1.2em)

  strong(title)
}

#let aranya-footer-band = {
  show: aranya-backdrop.with(fill: color-aranya-wood, inset: 1em)
  set align(horizon)
  set text(fill: color-aranya-beach, size: 0.75em)
  
  locate( loc => {
    let logic-slide-page = logic.logical-slide.at(loc).first()
    
    context [_#aranya-title.display()_ #h(1fr) $#logic-slide-page \/ #utils.last-slide-number$]
  } )
}


// page objectives and functions
#let aranya-theme(
  aspect-ratio: "16-9",
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    fill: color-aranya-beach,
    margin: 0em,
    header: none,
  )

  set text(font: "Georgia", weight: "light", size: 18pt)
  set strong(delta: 100)
  set par(justify: true)

  show math.equation.where(block: true) :it=>block(
    width: 100%,
    align(center, it)
  )

  body
}

#let title-slide(
  title: [],
  subtitle: none,
  author: none,
  date: none,
  extra: none,
) = {
  let content = {
    aranya-title.update(title)
    set text(fill: color-aranya-deep-sea)
    set align(center + horizon)
    block(width: 100%, inset: 2em,{
      stack(
        dir: ttb,
        text(size: 1.5em, strong(title)),
        if subtitle != none {
          linebreak()
          text(size: 1.3em, subtitle)
        }
      )
      
      line(length: 100%, stroke: 2pt + color-aranya-sunset)
      set text(size: .9em)
      if author != none {
        block(spacing: 1em, author)
      }
      if extra != none {
        block(spacing: 1em, extra)
      }
      linebreak()
      if date != none {
        block(spacing: 1em, date)
      }
    })
  }
  logic.polylux-slide(content)
}

#let slide(title: none, body) = {
  let header = {
    set align(top)
    if title != none {
      stack(
        dir: ttb,
        aranya-sect-band,
        aranya-heading-band(title))
    } else {
      [#aranya-sect-band]
    }
  }

  let footer = {
    set align(bottom)
    aranya-footer-band
  }

  set page(
    header: header,
    margin: (top: 4.8em, bottom: 1.6em),
    fill: color-aranya-beach,
    footer: footer
  )

  let content = {
    register-page-info(PAGE-TYPES.slide)
    show: align.with(horizon)
    show: pad.with(x: 2em, bottom: 1.2em)
    set text(fill: color-aranya-deep-sea)
    body 
  }
  logic.polylux-slide(content)
}

#let new-section-slide(name) = {
  let content = {
    utils.register-section(name)
    register-page-info(PAGE-TYPES.section)
    set align(center + horizon)
    set text(fill: color-aranya-wood, size: 1.5em)
    name
    show: pad.with(20%)
    block(height: 2pt, width: 100%, spacing: 0pt, aranya-progress-bar)
  }
  logic.polylux-slide(content)
}

#let focus-slide(body) = {
  set page(fill: color-aranya-sea, margin: 2em)
  set text(fill: color-aranya-beach, size: 1.5em)
  logic.polylux-slide(align(horizon + center, body))
}


// other utils
#let aranya-outline = {
  utils.polylux-outline(enum-args: (tight: false,))
}

#let alert = text.with(fill: color-aranya-sunset)

#let aranya-goto(page, dir: none) = {
  goto(page, dir: dir,
    font-color: color-aranya-sunset,
    stroke: color-aranya-wood,
    fill: color-aranya-glow
  )
}