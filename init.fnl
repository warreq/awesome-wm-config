(global gears (require "gears"))
(global awful (require "awful"))
(require "awful.autofocus")
(global wibox (require "wibox"))
(global beautiful (require "beautiful"))
(global xresources (require "beautiful.xresources"))
(global naughty (require "naughty"))
(global menubar (require "menubar"))
(global hotkeys_popup (require "awful.hotkeys_popup"))
(require-macros :awesome-macros)
(global lume (require "vendor.lume"))

(global dpi xresources.apply_dpi)

(local output (require "utils.output"))
(local notify output.notify)
(local tag-utils (require "utils.tags"))

(local theme-dir (.. (os.getenv "HOME") "/.config/awesome/themes/"))
(local theme-name "dracula")
(local theme (require (.. "themes." theme-name ".theme")))

(beautiful.init theme)

(global rofi (require "features.rofi"))

(global input (require "utils.input"))
(global keybindings (require "keybindings"))
(global rules (require "rules"))
(local persistence (require "features.persistence"))
(local workspaces (require "features.workspaces"))
(local wallpaper (require "features.wallpaper"))

;; Error handling
;; Check if awesome encountered an error during startup and fell back to
;; another config (This code will only ever execute for the fallback config)
(local err_preset { :timeout 0 :bg "#000000" :fg "#ff0000" :max_height 1080 })
(when awesome.startup_errors
  (naughty.notify {:preset err_preset
                   :title "Oops, there were errors during startup!"
                   :text awesome.startup_errors}))

;; Handle runtime errors after startup
(do
  (var in_error false)
  (awesome.connect_signal
   "debug::error"
   (fn [err]
     ;; Make sure we don't go into an endless error loop
     (when (not in_error)
       (set in_error true)
       (naughty.notify {:preset err_preset
                        :title "Oops, an error happened!"
                        :text (tostring err)})
       (set in_error false)))))

;; Utils


(fn range
  [start end ?step]
  (local s (if (= ?step nil) 1 ?step)) 
  (var seq [])
  (for [i start end s]
    (table.insert seq i))
  seq)

;; Variable definitions

;; This is used later as the default terminal and editor to run.
(var terminal "xterm")
(var editor (or (os.getenv "EDITOR") "emacs"))
(var editor_cmd editor)

;; Menu
;; Create a launcher widget and a main menu
(global myawesomemenu [ 
                       [ "hotkeys" (fn [] (hotkeys_popup.show_help nil (awful.screen.focused))) ]
                       [ "manual" (.. terminal " -e man awesome") ]
                       [ "edit config" (.. editor_cmd " " awesome.conffile) ]
                       [ "restart" awesome.restart ]
                       [ "quit" (fn [] (awesome.quit)) ]])

(global mymainmenu (awful.menu {:items [
                                        [ "awesome" myawesomemenu beautiful.awesome_icon ]
                                        [ "open terminal" terminal ]]}))

(global mylauncher (awful.widget.launcher {:image beautiful.awesome_icon
                                           :menu mymainmenu }))

;; Menubar configuration
(set menubar.utils.terminal terminal) ;; Set the terminal for applications that require it

;; Wibar
;; Create a textclock widget

(local my-textclock
       (wibox.widget (/<
                      :layout wibox.layout.fixed.horizontal
                      (/<
                       :id "my-textclock"
                       :widget wibox.widget.textclock
                       :timezone "Europe/Copenhagen")
                      )))

(fn search-hierarchy-for-widget
  [hierarchy widget acc]
  (let [children (: hierarchy :get_children)]
    (when (= widget (: hierarchy :get_widget))
      (table.insert acc hierarchy))
    (each [_ h (ipairs children)]
      (search-hierarchy-for-widget h widget acc))))

(fn find-hierarchy-for-widget-in-wibox 
  [wibox widget]
  (let [hierarchy wibox._drawable._widget_hierarchy]
    (when hierarchy
      (do
        (local acc []) ;; init with an empty result accumulator
        (search-hierarchy-for-widget hierarchy widget acc)
        acc))))

(local workspace-indicator
       (wibox.widget (/<
                      :widget wibox.widget.textbox
                      :align :center
                      :markup ""
                      )))



(local my-calendar
       (awful.popup (/<
                     :shape gears.shape.infobubble
                     :minimum_height 200 
                     :maximum_height 200 
                     :minimum_width 250
                     :maximum_width 250
                     :ontop true
                     :visible false
                     :widget (/<
                              (wibox.widget
                               {:widget wibox.widget.calendar.month
                                :date (os.date "*t")
                                :week_numbers true
                                :long_weekdays false
                                :spacing 1})
                              :margins 20
                              :widget wibox.container.margin
                              ))))


(: my-textclock :connect_signal "button::release"
   (fn []
     (doto my-calendar
       (tset :x (- (. mouse.current_widget_geometry :x) 200))
       (tset :y 20)
       (tset :visible (not (. my-calendar :visible))))))


;; Create a wibox for each screen and add it
(local taglist_buttons
       (gears.table.join
        (awful.button [] 1 (fn [t] (: t :view_only)))
        (awful.button [ input.modkey ] 1 (fn [t] (when client.focus (: client.focus :move_to_tag t))))
        (awful.button [] 3 awful.tag.viewtoggle)
        (awful.button [ input.modkey ] 3 (fn [t] (when client.focus (: client.focus :toggle_tag t))))
        (awful.button [] 4 (fn [t] (awful.tag.viewnext t.screen)))
        (awful.button [] 5 (fn [t] (awful.tag.viewprev t.screen)))))

(local tasklist_buttons
       (gears.table.join
        (awful.button [] 1 (fn [c]
                             (if (= c client.focus)
                                 (set c.minimized true)
                                 (: c :emit_signal
                                    "request::activate"
                                    "tasklist"
                                    {:raise true}
                                    ))))
        (awful.button [] 3 (fn [] (awful.menu.client_list {:theme {:width 250 }})))
        (awful.button [] 4 (fn [] (awful.client.focus.byidx 1)))
        (awful.button [] 5 (fn [] (awful.client.focus.byidx -1)))))

;; Table of layouts to cover with awful.layout.inc, order matters.
(set awful.layout.layouts [
                           awful.layout.suit.fair
                           awful.layout.suit.floating
                           awful.layout.suit.tile
                           awful.layout.suit.tile.left
                           awful.layout.suit.tile.bottom
                           awful.layout.suit.tile.top
                           ;; awful.layout.suit.fair.horizontal
                           awful.layout.suit.spiral
                           awful.layout.suit.spiral.dwindle
                           awful.layout.suit.max
                           ;; awful.layout.suit.max.fullscreen
                           awful.layout.suit.magnifier
                           ;; awful.layout.suit.corner.nw
                           ;; awful.layout.suit.corner.ne
                           ;; awful.layout.suit.corner.sw
                           ;; awful.layout.suit.corner.se
                           ])

(awful.screen.connect_for_each_screen
 (fn [s]
   ;; Create a promptbox for each screen
   (set s.mypromptbox (awful.widget.prompt))
   ;; Create an imagebox widget which will contain an icon indicating which layout we're using.
   ;; We need one layoutbox per screen.
   (set s.mylayoutbox (awful.widget.layoutbox s))
   (: s.mylayoutbox :buttons (gears.table.join
                              (awful.button [] 1 (fn [] (awful.layout.inc 1 s awful.layout.layouts)))
                              (awful.button [] 3 (fn [] (awful.layout.inc -1 s)))
                              (awful.button [] 4 (fn [] (awful.layout.inc 1 s)))
                              (awful.button [] 5 (fn [] (awful.layout.inc -1 s)))))
   ;; Create a taglist widget
   (set s.mytaglist (awful.widget.taglist {
                                           :screen s
                                           :filter awful.widget.taglist.filter.all
                                           :buttons taglist_buttons
                                           }))

   ;; Create a tasklist widget
   (set s.mytasklist (awful.widget.tasklist {
                                             :screen s
                                             :filter awful.widget.tasklist.filter.currenttags
                                             :buttons tasklist_buttons
                                             }))

   ;; Create the wibox
   (set s.mywibox (awful.wibar { :position "top" :screen s }))

   ;; Add widgets to the wibox
   (: s.mywibox :setup (/< 
                        :layout wibox.layout.align.horizontal
                        (/< ;; Left widgets
                         :layout wibox.layout.fixed.horizontal
                         mylauncher
                         (/<
                          :widget wibox.container.margin
                          :margins 4
                          workspace-indicator)
                         s.mytaglist)
                        s.mytasklist ;; Middle widget
                        (/< ;; Right widgets
                         :layout wibox.layout.fixed.horizontal
                         (wibox.widget.systray)
                         my-textclock
                         s.mylayoutbox)))))


;; Mouse bindings
(root.buttons (gears.table.join
               (awful.button [ ] 3 (fn [] (: mymainmenu :toggle)))
               (awful.button [ ] 4 awful.tag.viewnext)
               (awful.button [ ] 5 awful.tag.viewprev)))


;; Set keys
(root.keys keybindings.global-keys)

;; Rules to apply to new clients (through the "manage" signal)
(set awful.rules.rules rules)

;; Signals
;; Signal function to execute when a new client appears.
(client.connect_signal
 "manage"
 (fn [c]
   ;; Set the windows at the slave,
   ;; i.e. put it at the end of others instead of setting it master.
   ;; (when (not awesome.startup) (awful.client.setslave c))

   (when (and awesome.startup
              (not c.size_hints.user_position)
              (not c.size_hints.program_position))
     ;; Prevent clients from being unreachable after screen count changes.
     (awful.placement.no_offscreen c))))

;; Add a titlebar if titlebars_enabled is set to true in the rules.
(client.connect_signal
 "request::titlebars"
 (fn [c]
   ;; buttons for the titlebar
   (let [buttons (gears.table.join
                  (awful.button [] 1 (fn []
                                       (: c :emit_signal "request::activate" "titlebar" {:raise true})
                                       (awful.mouse.client.move c)))
                  (awful.button [] 3 (fn []
                                       (: c :emit_signal "request::activate" "titlebar" {:raise true})
                                       (awful.mouse.client.resize c))))
         titlebar (awful.titlebar c)]
     (: titlebar :setup (/<
                         (/< ;; Left
                          (awful.titlebar.widget.iconwidget c)
                          :buttons buttons
                          :layout wibox.layout.fixed.horizontal)
                         (/< ;; Middle
                          (/< ;; Title
                           :align "center"
                           :widget (awful.titlebar.widget.titlewidget c))
                          :buttons buttons
                          :layout wibox.layout.flex.horizontal)
                         (/< ;; Right
                          (awful.titlebar.widget.floatingbutton  c)
                          (awful.titlebar.widget.maximizedbutton c)
                          (awful.titlebar.widget.stickybutton    c)
                          (awful.titlebar.widget.ontopbutton     c)
                          (awful.titlebar.widget.closebutton     c)
                          :layout (wibox.layout.fixed.horizontal))
                         :layout wibox.layout.align.horizontal)))))

;; Enable sloppy focus, so that focus follows mouse.
(client.connect_signal "mouse::enter"
                       (fn [c]
                         (: c :emit_signal "request::activate"  "mouse_enter" {:raise false})))

(client.connect_signal "focus" (fn [c] (set c.border_color beautiful.border_focus)))
(client.connect_signal "unfocus" (fn [c] (set c.border_color beautiful.border_normal)))

(wallpaper.enable)
(workspaces.enable)
(persistence.enable)

(awesome.connect_signal "workspaces::applied"
                        (fn [sig]
                          (tset workspace-indicator :markup (.. "<b>" sig "</b>"))))

(awesome.connect_signal
 "startup"
 (fn []
   (awful.screen.connect_for_each_screen
    (fn [s]
      (when (= (# (tag-utils.list-visible s)) 0)
        (awful.tag.add (os.clock) {:pos 1
                                   :screen s
                                   :selected true
                                   :hide false
                                   :layout (. awful.layout.layouts 1)}))))))
