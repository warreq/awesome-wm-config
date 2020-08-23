(local awful (require "awful"))
(local xresources (require "beautiful.xresources"))
(local dpi xresources.apply_dpi)
(local lume (require "vendor.lume"))
(local xml (require "utils.xml"))
(local oleander (require "utils.oleander"))
(local range oleander.range)

(local identicon {})

(fn bsd-checksum
  [str]
  "Simple checksum. Returns a 32-bit numeric hash of input STR"
  (var sum 0)
  (let [bytes [(string.byte str 1 -1)]]
    (each [_ value (ipairs bytes)]
      (set sum (+ (rshift sum 1) (lshift sum 31)))
      (set sum (+ sum value))
      (set sum (% sum 2147483647))) ; clamp to expected range
    sum))

(fn identicon.color-from-hash [hash]
  (math.randomseed hash)
  (let [r (math.random 0 255)
        g (math.random 0 255)
        b (math.random 0 255)]
    (.. "rgb(" r ", " g ", " b ")")))

(lambda generate-squares [hash squares square-length color]
  "Generate squares in a SQUARESxSQUARES grid"
  (var seq []) 
  (math.randomseed hash)
  (let [mirror (+ (/ squares 2) 1)
        l square-length]
    (for [i 0 (- mirror 1)]
      (for [j 0 (- squares 1)]
        (when (<= 0.5 (math.random))
          (let [x (* i l)
                y (* j l)
                x2 (* (- squares i 1) l)] ; x position reflected over center
            (table.insert
             seq
             [:rect {:x x :y y :width l :height l :fill color}])
            (when (~= i (- mirror 1)) ; no need to reflect the center column
                (table.insert
                 seq
                 [:rect {:x x2 :y y :width l :height l :fill color}])))))))
  seq)

(lambda identicon.generate-svg
  [str squares dimension ?color-list?]
  "Get SVG string for an identicon using seed STR.

 Use SQUARES to determine the resolution of the identicon (must be odd).
 Use DIMENSION as a size hint.
 If ?COLOR-LIST? is provided, restrict output to that palette"
  (let [hash (bsd-checksum str)
        size  (/ dimension squares)
        canvas (* squares size)
        mirror (+ (/ squares 2) 1)
        color (if ?color-list?
                  (. ?color-list? (+ (% hash (length ?color-list?)) 1))
                  (identicon.color-from-hash hash))]
    (xml.create-element
     :svg {:xmlns "http://www.w3.org/2000/svg"
           :shape-rendering :crispEdges ; turns off anti-aliasing
           :viewBox (.. "0 0 " canvas " " canvas)}
     (lume.concat [[:rect {:x 0 :y 0
                           :width canvas :height canvas
                           :stroke :none :fill :none}]]
                  (generate-squares hash squares size color)))))

(lambda identicon.create
  [str squares dimension ?color-list?]
  "Generate an identicon and return the filepath to the resulting SVG file.

 Use SQUARES to determine the resolution of the identicon (must be odd).
 Use DIMENSION as a size hint.
 If ?COLOR-LIST? is provided, restrict output to that palette"
  (let [svg-content (identicon.generate-svg str squares dimension ?color-list?)
        filename (.. str ".svg")
        filepath (.. (awful.util.get_cache_dir) "/" filename)
        file (io.open filepath "w")]
    (: file :write svg-content)
    (: file :close)
    filepath))

identicon
