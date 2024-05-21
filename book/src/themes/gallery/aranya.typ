#import "../../../../polylux.typ": *
#import themes.aranya: *

#show: aranya-theme

#title-slide(
  author: "Beitian Ma",
  title: "A Widgets Gallery Based on Aranya Theme",
  date: "9 May, 2024",
  extra: [Some extra information here...]
)

#slide(title: "Contents")[
  #aranya-outline
]

#new-section-slide("The First Section")

#slide(title: "Available Space")[
  #block(
    width: 100%,
    height: 100%,
    fill: color-aranya-glow,
  )
]

#slide(title: "Texts")[
  #lorem(50)

  - #lorem(15)

  - #lorem(30)
]

#new-section-slide("The Very Very Long Second Section")

#slide(title: "Images")[
  #side-by-side[
    #figure(image("aranya-landscape.png"), caption: "A landscape")
  ][
    - #lorem(15)

    - #lorem(30)
  ]
]

#slide(title: "Math Equations")[
  - #uncover((1, 2), mode: "transparent")[
      Formulas are always centered
      $ frak(R)(integral_E f dif mu) = integral_E u^+ dif mu = 0 $
      even if the text line does not take 100% width.
    ]
  
  - #uncover((2), mode: "transparent")[
      Commands like `#pause` and `#uncover`
      $ union.big_(n in NN) {x in X: |x-alpha|<=r-1/n}. $
      do not create a new bubbles on the progress bubbles band. 
    ]
]

#new-section-slide("The Last Section")

#slide(title: "Links")[
  Titles and bubbles in the progress bubbles band are clickable and will take you to the corresponding slide.

  Go to (the last subpage of) page 8 by clicking #aranya-goto(8, dir:"forward") !
]

#focus-slide[
  #text(font: "Constantia")[_Thanks for Listening!_]
]
