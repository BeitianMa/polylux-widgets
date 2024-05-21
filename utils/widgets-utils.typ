#import "../logic.typ"
#import "../utils/utils.typ"


// state variables
#let page-info = state(
  "page-info",
  ( 
    page-physical-nums:(),
    page-logical-nums: (), 
    page-types: (),
  )
)

// utils
#let register-page-info(page-type) = locate( loc => {
  locate( loc => {
    page-info.update(info => {
      info.page-physical-nums.push(loc.page())
      info.page-logical-nums.push(logic.logical-slide.at(loc).first())
      info.page-types.push(page-type)
      
      info
    })}
  )}
)