(local wibox (require "wibox"))
(local awful (require "awful"))
(local identicon (require "utils.identicon"))
(require-macros :awesome-macros)

(local ws {})

(set ws.svg (identicon.generate-svg (.. (os.time)) 7 32))

(let [f (io.open (.. (awful.util.get_cache_dir)  "/" "testing3.svg") "w")]
  (: f :write ws.svg)
  (: f :close))

(set ws.indicator
       (wibox.widget (/<
                      :widget wibox.widget.imagebox
                      :resize true
                      :image (.. (awful.util.get_cache_dir)  "/" "testing3.svg")
                      )))

(awesome.connect_signal "workspaces::applied"
                        (fn [sig]
                          (tset ws.indicator :markup (.. "<b>" sig "</b>"))))

ws
