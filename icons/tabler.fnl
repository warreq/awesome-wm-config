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

(deficon tabler.terminal
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d "M8 9l3 3l-3 3"}]
          [:line {:x1 13 :y1 15 :x2 16 :y2 15}]
          [:rect {:x 3 :y 4 :width 18 :height 16 :rx 2}]])

(local battery-path
       (.. "M6 7h11a2 2 0 0 1 2 2v.5a0.5 .5 0 0 0 .5 .5a0.5 .5 0 0 1 .5"
           " .5v3a0.5 .5 0 0 1 -.5 .5a0.5 .5 0 0 0 -.5 .5v.5a2 2 0 0 1 -2"
           " 2h-11a2 2 0 0 1 -2 -2v-6a2 2 0 0 1 2 -2"))

(deficon tabler.battery-empty
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d battery-path}]])

(deficon tabler.battery-low
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d battery-path}]
          [:line {:x1 7 :y1 10 :x2 7 :y2 14}]])

(deficon tabler.battery-mid
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d battery-path}]
          [:line {:x1 7 :y1 10 :x2 7 :y2 14}]
          [:line {:x1 10 :y1 10 :x2 10 :y2 14}]])

(deficon tabler.battery-high
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d battery-path}]
          [:line {:x1 7 :y1 10 :x2 7 :y2 14}]
          [:line {:x1 10 :y1 10 :x2 10 :y2 14}]
          [:line {:x1 13 :y1 10 :x2 13 :y2 14}]])

(deficon tabler.battery-full
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d battery-path}]
          [:line {:x1 7 :y1 10 :x2 7 :y2 14}]
          [:line {:x1 10 :y1 10 :x2 10 :y2 14}]
          [:line {:x1 13 :y1 10 :x2 13 :y2 14}]
          [:line {:x1 16 :y1 10 :x2 16 :y2 14}]])

(deficon tabler.battery-charging
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d (..
                      "M16 7h1a2 2 0 0 1 2 2v.5a0.5 .5 0 0 0 .5 .5a0.5 .5 0 0"
                      " 1 .5 .5v3a0.5 .5 0 0 1 -.5 .5a0.5 .5 0 0 0 -.5 .5v.5a2"
                      " 2 0 0 1 -2 2h-2")}]
          [:path {:d "M8 7h-2a2 2 0 0 0 -2 2v6a2 2 0 0 0 2 2h1"}]
          [:path {:d "M12 8l-2 4h3l-2 4"}]])

(deficon tabler.battery-disabled
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d (..
                      "M11 7h6a2 2 0 0 1 2 2v.5a0.5 .5 0 0 0 .5 .5a0.5 .5"
                      " 0 0 1 .5 .5v3a0.5 .5 0 0 1 -.5 .5a0.5 .5 0 0 0"
                      " -.5 .5v.5m-2 2h-11a2 2 0 0 1 -2 -2v-6a2 2 0 0 1 2 -2h1"
                      )}]
          [:line {:x1 3 :y1 3 :x2 21 :y2 21}]])

(local speaker-path
       (.. "M6 15h-2a1 1 0 0 1 -1 -1v-4a1 1 0 0 1 1 -1h2l3.5 -4.5a0.8"
           " .8 0 0 1 1.5 .5v14a0.8 .8 0 0 1 -1.5 .5l-3.5 -4.5"))

(deficon tabler.volume-low
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d speaker-path }]
          [:path {:d "M15 8a5 5 0 0 1 0 8"}]])

(deficon tabler.volume-high
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d speaker-path }]
          [:path {:d "M15 8a5 5 0 0 1 0 8"}]
          [:path {:d "M17.7 5a9 9 0 0 1 0 14"}]])

(deficon tabler.volume-muted
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d speaker-path }]
          [:path {:d "M16 10l4 4m0 -4l-4 4"}]])

(deficon tabler.wifi-low
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d "M9.172 15.172a4 4 0 0 1 5.656 0" }]
          [:line {:x1 12 :y1 18 :x2 12.01 :y2 18}]])

(deficon tabler.wifi-mid
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d "M9.172 15.172a4 4 0 0 1 5.656 0" }]
          [:path {:d "M6.343 12.343a8 8 0 0 1 11.314 0" }]
          [:line {:x1 12 :y1 18 :x2 12.01 :y2 18}]])

(deficon tabler.wifi-high
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d "M9.172 15.172a4 4 0 0 1 5.656 0" }]
          [:path {:d "M6.343 12.343a8 8 0 0 1 11.314 0" }]
          [:path {:d "M3.515 9.515c4.686 -4.687 12.284 -4.687 17 0" }]
          [:line {:x1 12 :y1 18 :x2 12.01 :y2 18}]])

(deficon tabler.wifi-disabled
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:path {:d "M9.172 15.172a4 4 0 0 1 5.656 0" }]
          [:path {:d "M6.343 12.343a7.963 7.963 0 0 1 3.864 -2.14m4.163 .155a7.965 7.965 0 0 1 3.287 2" }]
          [:path {:d "M3.515 9.515a12 12 0 0 1 3.544 -2.455m3.101 -.92a12 12 0 0 1 10.325 3.374" }]
          [:line {:x1 12 :y1 18 :x2 12.01 :y2 18}]
          [:line {:x1 3 :y1 3 :x2 21 :y2 21}]])

(deficon tabler.desktop
         [[:path {:stroke :none :fill :none :d "M0 0h24v24H0z"}]
          [:rect {:x 3 :y 4 :width 18 :height 12 :rx 1}]
          [:line {:x1 7 :y1 20 :x2 17 :y2 20}]
          [:line {:x1 9 :y1 16 :x2 9 :y2 20}]
          [:line {:x1 15 :y1 16 :x2 15 :y2 20}]])

tabler
