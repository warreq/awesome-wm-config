(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))

(local wallpaper {})

(lambda wallpaper.set [s]
  (when beautiful.wallpaper
    (var wallpaper beautiful.wallpaper)
    ;; If wallpaper is a function, call it with the screen
    (when (= (type wallpaper) "function")
      (set wallpaper (wallpaper s)))
    ;; workaround memleak when called frequently eg. by a timer
    ;; https://github.com/awesomeWM/awesome/issues/2858
    (collectgarbage "step" 4000)
    (gears.wallpaper.maximized wallpaper s true)))

(fn wallpaper.enable []
  (awful.screen.connect_for_each_screen wallpaper.set)
  ;; Reset wallpaper when a screen's geometry changes (eg. resolution change)
  (screen.connect_signal "property::geometry" wallpaper.set))

wallpaper
