(local wibox (require "wibox"))
(local awful (require "awful"))
(local icon-loader (require "icons.loader"))
(local layout-icons (require "icons.layouts"))
(local widget-utils (require "utils.widgets"))

(local ls {})

(set ls.on-click
     (fn []
       (awful.layout.inc 1 (awful.screen.focused) awful.layout.layouts)
       (tset ls.switcher :image (icon-loader.load :layouts (awful.layout.getname)))))

(set ls.switcher
        (widget-utils.buttonize
         (wibox.widget {:widget wibox.widget.imagebox
                        :image (icon-loader.load :layouts (awful.layout.getname))})
         ls.on-click))

ls
