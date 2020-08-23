(local wibox (require "wibox"))
(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local icon-loader (require "icons.loader"))
(local layout-icons (require "icons.layouts"))
(local widget-utils (require "utils.widgets"))

(local ls {})

(set ls.reset
     (fn []
       (let [img (icon-loader.load
                  :layouts
                  (awful.layout.getname)
                  {:stroke-color beautiful.fg})]
         (tset ls.switcher :image img))))

(set ls.on-click
     (fn []
       (awful.layout.inc 1 (awful.screen.focused) awful.layout.layouts)
       (ls.reset)))

(set ls.on-hover-in
     (fn []
       (let [img (icon-loader.load
                  :layouts
                  (awful.layout.getname)
                  {:stroke-color beautiful.base6})]
         (tset ls.switcher :image img))))

(set ls.switcher
     (widget-utils.buttonize
      (wibox.widget {:widget wibox.widget.imagebox})
      ls.on-click
      {:on-hover-in ls.on-hover-in
       :on-hover-out ls.reset}))

(awful.tag.attached_connect_signal nil "property::layout" ls.reset)
(awful.tag.attached_connect_signal nil "property::selected" ls.reset)

(awesome.connect_signal "persistence::loaded" ls.reset)

ls
