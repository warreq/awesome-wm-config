(local wibox (require "wibox"))
(local workspaces (require :features.workspaces))
(local { : notify } (require :api.lawful))
(require-macros :awesome-macros)

(local ws {})

(set ws.indicator
          (wibox.widget
           (/<
            :widget wibox.widget.imagebox
            :resize true
            :image (workspaces.get-icon workspaces.current))))

(awesome.connect_signal
 "workspaces::applied"
 (fn [sig]
   (notify.msg (.. "Changed to " sig " workspace."))
     (tset ws.indicator :image (workspaces.get-icon sig))))

ws
