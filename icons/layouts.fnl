(require-macros :icons._macros)

(local layouts {})

(deficon layouts.tile
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 4 :width 4 :height 16 :stroke-width 1}]
          [:rect {:x 10 :y 4 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 16 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 4 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 16 :width 4 :height 4 :stroke-width 1}]])

(deficon layouts.tilebottom
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 4 :width 16 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 16 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 16 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 16 :width 4 :height 4 :stroke-width 1}]])

(deficon layouts.tiletop
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 16 :width 16 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 4 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 4 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 4 :width 4 :height 4 :stroke-width 1}]])

(deficon layouts.tileleft
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 4 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 16 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 4 :width 4 :height 16 :stroke-width 1}]
          [:rect {:x 10 :y 4 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 10 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 16 :width 4 :height 4 :stroke-width 1}]])

(deficon layouts.spiral
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 4 :width 8 :height 16 :stroke-width 1}]
          [:rect {:x 14 :y 4 :width 8 :height 8 :stroke-width 1}]
          [:rect {:x 18 :y 14 :width 4 :height 6 :stroke-width 1}]
          [:rect {:x 14 :y 18 :width 2 :height 2 :stroke-width 1}]
          [:rect {:x 14 :y 14 :width 2 :height 2 :stroke-width 1}]])

(deficon layouts.dwindle
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 4 :width 8 :height 16 :stroke-width 1}]
          [:rect {:x 14 :y 4 :width 8 :height 8 :stroke-width 1}]
          [:rect {:x 14 :y 14 :width 4 :height 6 :stroke-width 1}]
          [:rect {:x 20 :y 18 :width 2 :height 2 :stroke-width 1}]
          [:rect {:x 20 :y 14 :width 2 :height 2 :stroke-width 1}]])

(deficon layouts.max
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:polygon {:points "12,4 10,6 14,6"}]
          [:polygon {:points "12,20 10,18 14,18"}]
          [:polygon {:points "4,12 6,10 6,14"}]
          [:polygon {:points "20,12 18,10 18,14"}]])

(deficon layouts.fullscreen
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:polygon {:points "12,4 10,6 14,6"}]
          [:polygon {:points "12,20 10,18 14,18"}]
          [:polygon {:points "4,12 6,10 6,14"}]
          [:polygon {:points "20,12 18,10 18,14"}]])

(deficon layouts.magnifier
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 6 :y 6 :width 12 :height 12}]
          [:line {:x1 12 :y1 4 :x2 12 :y2 6}]
          [:line {:x1 12 :y1 18 :x2 12 :y2 20}]
          [:line {:x1 4 :y1 12 :x2 6 :y2 12}]
          [:line {:x1 18 :y1 12 :x2 20 :y2 12}]])

(deficon layouts.fairv
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 4 :width 8 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 10 :width 8 :height 4 :stroke-width 1}]
          [:rect {:x 4 :y 16 :width 8 :height 4 :stroke-width 1}]
          [:rect {:x 14 :y 4 :width 8 :height 4 :stroke-width 1}]
          [:rect {:x 14 :y 10 :width 8 :height 4 :stroke-width 1}]
          [:rect {:x 14 :y 16 :width 8 :height 4 :stroke-width 1}]])

(deficon layouts.fairh
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 4 :y 4 :width 4 :height 8 :stroke-width 1}]
          [:rect {:x 10 :y 4 :width 4 :height 8 :stroke-width 1}]
          [:rect {:x 16 :y 4 :width 4 :height 8 :stroke-width 1}]
          [:rect {:x 4 :y 14 :width 4 :height 8 :stroke-width 1}]
          [:rect {:x 10 :y 14 :width 4 :height 8 :stroke-width 1}]
          [:rect {:x 16 :y 14 :width 4 :height 8 :stroke-width 1}]])

(deficon layouts.floating
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 2 :y 2 :width 16 :height 12 :stroke-width 1}]
          [:line {:x1 6 :y1 14 :x2 6 :y2 20 :stroke-width 1}]
          [:line {:x1 6 :y1 20 :x2 22 :y2 20 :stroke-width 1}]
          [:line {:x1 22 :y1 20 :x2 22 :y2 8 :stroke-width 1}]
          [:line {:x1 22 :y1 8 :x2 18 :y2 8 :stroke-width 1}]])

(deficon layouts.cornernw
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 2 :y 2 :width 14 :height 14 :stroke-width 1}]
          [:rect {:x 18 :y 2 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 18 :y 10 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 18 :y 18 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 18 :width 6 :height 4 :stroke-width 1}]
          [:rect {:x 2 :y 18 :width 6 :height 4 :stroke-width 1}]])

(deficon layouts.cornersw
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 2 :y 8 :width 14 :height 14 :stroke-width 1}]
          [:rect {:x 18 :y 10 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 18 :y 17 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 18 :y 2 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 10 :y 2 :width 6 :height 4 :stroke-width 1}]
          [:rect {:x 2 :y 2 :width 6 :height 4 :stroke-width 1}]])

(deficon layouts.cornerse
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 8 :y 8 :width 14 :height 14 :stroke-width 1}]
          [:rect {:x 2 :y 10 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 2 :y 17 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 2 :y 2 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 8 :y 2 :width 6 :height 4 :stroke-width 1}]
          [:rect {:x 16 :y 2 :width 6 :height 4 :stroke-width 1}]])

(deficon layouts.cornerne
         [[:path {:stroke :none :d "M0 0h24v24H0z"}]
          [:rect {:x 8 :y 2 :width 14 :height 14 :stroke-width 1}]
          [:rect {:x 2 :y 2 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 2 :y 10 :width 4 :height 5 :stroke-width 1}]
          [:rect {:x 18 :y 18 :width 4 :height 4 :stroke-width 1}]
          [:rect {:x 10 :y 18 :width 6 :height 4 :stroke-width 1}]
          [:rect {:x 2 :y 18 :width 6 :height 4 :stroke-width 1}]])

layouts
