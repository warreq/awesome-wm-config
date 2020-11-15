(local wibox (require "wibox"))
(local awful (require "awful"))
(local identicon (require "utils.identicon"))
(local workspaces (require :features.workspaces))
(local { : notify } (require :api.lawful))
(require-macros :awesome-macros)

(local ws {})

(set ws.indicator
          (wibox.widget
           (/<
            :widget wibox.widget.imagebox
            :resize true
            :image (.. (awful.util.get_cache_dir)  "/" workspaces.current)
            )))

(awesome.connect_signal
 "workspaces::applied"
 (fn [sig]
   (notify.msg (.. "Changed to " sig " workspace."))
   (let [f (io.open (.. (awful.util.get_cache_dir)  "/" sig) "w")
         icon (identicon.generate-svg sig 7 32)]
     (: f :write icon)
     (: f :close)
     (tset ws.indicator :image (.. (awful.util.get_cache_dir)  "/" sig)))))

ws
