;; Not functional yet
;; Waiting for gears.history API
;; https://www.reddit.com/r/awesomewm/comments/ams2gt/keygrabber_example_in_documentation/

(local awful (require "awful"))
(local input (require "utils.input"))

(local bindings
       [
;        [[:Mod1       ] :Tab awful.client.focus.history.select_previous ]
;        [[:Mod1 :Shift] :Tab awful.client.focus.history.select_next ]
        ])

(local alt-tab-config
       {
        :keybindings bindings
        :stop_key :Mod1
        :stop_event :release
        :start_callback awful.client.focus.history.disable_tracking
        :stop_callback awful.client.focus.history.enable_tracking
        :export_keybindings true
        })

(local grabber-fn (awful.keygrabber alt-tab-config))

(input.keybind "client" [:alt :shift] :Tab grabber-fn "cycle focus backward")

(local
 alt-tab
  (input.keybind "client" [:alt] :Tab grabber-fn "cycle focus forward"))

 
alt-tab
