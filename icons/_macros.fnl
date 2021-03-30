(local icon-macros {})

(fn icon-macros.deficon [name tbl-def]
  `(fn ,name [options#]
     (local xml# (require "utils.xml"))
     (let [width# (or (. options# :width) 24)
           height# (or (. options# :height) 24)
           viewBox# (or (. options# :viewBox) "0 0 24 24")
           fill# (or (. options# :fill) "none")
           shape-rendering# (or (. options# :shape-rendering) :auto)
           stroke-color# (or (. options# :stroke-color) "#fff")
           stroke-width# (or (. options# :stroke-width) 2)
           stroke-linecap# (or (. options# :stroke-linecap) :round)
           stroke-linejoin# (or (. options# :stroke-linejoin) :round)]
       ((. xml# :create-element) :svg
        {:xmlns "http://www.w3.org/2000/svg"
         :shape-rendering shape-rendering#
         :height height#
         :width width#
         :viewBox (or viewBox# (.. "0 0 " height# " " width#))
         :stroke-width stroke-width#
         :stroke stroke-color#
         :stroke-linecap stroke-linecap#
         :stroke-linejoin stroke-linejoin#
         :fill fill#}
        ,tbl-def))))

icon-macros
