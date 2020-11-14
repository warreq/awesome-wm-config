;; Functions meant to be called interactively on a window (client)
(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local xresources (require "beautiful.xresources"))
(local tagutils (require "utils.tags"))
(local dpi xresources.apply_dpi)

(local default-step 16)

(local snap-settings {
                      :honor_workarea true
                      :margins (+ beautiful.screen_margin
                                  beautiful.useless_gap)
                      :to_percent 0.5 })

(local wincmd {})

(lambda wincmd.move [win coord step]
  "Move WIN in x or y COORD by dpi-adjusted STEP"
  (tset win coord (+ (. win coord) (dpi step))))

(lambda wincmd.move-left [?win]
  "Move WIN or currently focused client to the left.
 If floating, translates on the x-axis; if tiled, swaps with left neighbor"
  (let [c (or ?win client.focus)]
    (if c.floating
        (wincmd.move c :x (* default-step -1))
        (awful.client.swap.bydirection :left))))

(lambda wincmd.move-right [?win]
  "Move WIN or currently focused client to the right.
 If floating, translates on the x-axis; if tiled, swaps with right neighbor"
  (let [c (or ?win client.focus)]
    (if c.floating
        (wincmd.move c :x default-step)
        (awful.client.swap.bydirection :right))))

(lambda wincmd.move-up [?win]
  "Move WIN or currently focused client upwards.
 If floating, translates on the y-axis; if tiled, swaps with upper neighbor"
  (let [c (or ?win client.focus)]
    (if c.floating
        (wincmd.move c :y (* default-step -1))
        (awful.client.swap.bydirection :up))))

(lambda wincmd.move-down [?win]
  "Move WIN or currently focused client downwards.
 If floating, translates on the y-axis; if tiled, swaps with lower neighbor"
  (let [c (or ?win client.focus)]
    (if c.floating
        (wincmd.move c :y default-step)
        (awful.client.swap.bydirection :down))))

(fn wincmd.snap-left [win]
  "Snap WIN or currently focused client to left-hand half of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.left
             awful.placement.maximize_vertically)]
    (f c snap-settings)))

(fn wincmd.snap-right [win]
  "Snap WIN or currently focused client to right-hand half of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.right
             awful.placement.maximize_vertically)]
    (f c snap-settings)))

(fn wincmd.snap-top [win]
  "Snap WIN or currently focused client to upper half of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.top
             awful.placement.maximize_horizontally)]
    (f c snap-settings)))

(fn wincmd.snap-bottom [win]
  "Snap WIN or currently focused client to lower half of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.bottom
             awful.placement.maximize_horizontally)]
    (f c snap-settings)))

(fn wincmd.snap-top-left-corner [win]
  "Snap WIN or currently focused client to top left corner of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.top_left)]
    (f c snap-settings)))

(fn wincmd.snap-top-right-corner [win]
  "Snap WIN or currently focused client to top right corner of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.top_right)]
    (f c snap-settings)))

(fn wincmd.snap-bottom-left-corner [win]
  "Snap WIN or currently focused client to bottom left corner of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.bottom_left)]
    (f c snap-settings)))

(fn wincmd.snap-bottom-right-corner [win]
  "Snap WIN or currently focused client to bottom right corner of the screen"
  (let [c (or win client.focus)
        f (+ awful.placement.scale
             awful.placement.bottom_right)]
    (f c snap-settings)))

(fn wincmd.mouse-raise [win]
  "Raise WIN or currently focused client to the top of the stack"
  (let [c (or win client.focus)]
    (: c :emit_signal "request::activate" "mouse_click" {:raise true})))

(fn wincmd.toggle-floating [win]
  "Set WIN or currently focused client to floating mode"
  (let [c (or win client.focus)]
    (set c.floating (not c.floating))
    (wincmd.mouse-raise c)))

(fn wincmd.toggle-fullscreen [win]
  "Set WIN or currently focused client to fullscreen"
  (let [c (or win client.focus)]
    (set c.fullscreen (not c.fullscreen))
    (: c :raise)))

(fn wincmd.toggle-ontop [win]
  "Set WIN or currently focused client to always-on-top"
  (let [c (or win client.focus)]
    (set c.ontop (not c.ontop))))

(fn wincmd.minimize [win]
  "Minimize WIN or currently focused client"
  (let [c (or win client.focus)]
    (set c.minimized true)))

(fn wincmd.toggle-maximize [win]
  "Minimize WIN or currently focused client"
  (let [c (or win client.focus)]
    (set c.maximized (not c.maximized))
    (: c :raise)))

(fn wincmd.toggle-maximize-vertical [win]
  "Vertically maximize WIN or currently focused client"
  (let [c (or win client.focus)]
    (set c.maximized_vertical (not c.maximized_vertical))
    (: c :raise)))

(fn wincmd.toggle-maximize-horizontal [win]
  "Horizontally maximize WIN or currently focused client"
  (let [c (or win client.focus)]
    (set c.maximized_horizontal (not c.maximized_horizontal))
    (: c :raise)))

(lambda wincmd.toggle-sticky [?win]
  "Toggle whether or not the window is displayed on all tags"
  (let [c (or ?win client.focus)]
    (tset c :sticky (not (. c :sticky)))))

(fn wincmd.close [win]
  "Kill WIN or currently focused client"
  (let [c (or win client.focus)]
    (: c :kill)))

(fn wincmd.cycle-clockwise []
  "Cycle the tiled clients in current tag clockwise"
    (awful.client.cycle))

(fn wincmd.cycle-counter-clockwise []
  "Cycle the tiled clients in current tag counter-clockwise"
    (awful.client.cycle true))

(fn wincmd.move-to-master [win]
  "Move WIN or currently focused client into the master area of current layout"
  (let [c (or win client.focus)]
    (: c :swap (awful.client.getmaster))))

(fn wincmd.mouse-drag-move [win]
  "Activate WIN or currently focused client for dragging via mouse"
  (let [c (or win client.focus)]
    (wincmd.mouse-raise c)
    (awful.mouse.client.move c)))

(fn wincmd.mouse-drag-resize [win]
  "Activate WIN or currently focused client for resizing via mouse"
  (let [c (or win client.focus)]
    (wincmd.mouse-raise c)
    (awful.mouse.client.resize c)))

(fn wincmd.transfer-to-next-tag [win]
  "Move WIN or currently focused client to the next tag"
  (let [c (or win client.focus)
        nt (tagutils.get-next)]
    (: c :move_to_tag nt)
    (tset nt :selected false)))

(fn wincmd.transfer-to-prev-tag [win]
  "Move WIN or currently focused client to the previous tag"
  (let [c (or win client.focus)
        pt (tagutils.get-prev)]
    (: c :move_to_tag pt)))

wincmd
