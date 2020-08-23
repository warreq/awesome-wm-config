(require-macros :icons._macros)

(local tabler {})

(deficon tabler.box
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:polyline {:points "12 3 20 7.5 20 16.5 12 21 4 16.5 4 7.5 12 3"}]
          [:line {:x1 12 :y1 12 :x2 20 :y2 7.5}]
          [:line {:x1 12 :y1 12 :x2 12 :y2 21}]
          [:line {:x1 12 :y1 12 :x2 4 :y2 7.5}]])

(deficon tabler.grid
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:circle {:cx 5 :cy 5 :r 1}]
          [:circle {:cx 12 :cy 5 :r 1}]
          [:circle {:cx 19 :cy 5 :r 1}]
          [:circle {:cx 5 :cy 12 :r 1}]
          [:circle {:cx 12 :cy 12 :r 1}]
          [:circle {:cx 19 :cy 12 :r 1}]
          [:circle {:cx 5 :cy 19 :r 1}]
          [:circle {:cx 12 :cy 19 :r 1}]
          [:circle {:cx 19 :cy 19 :r 1}]])

tabler
