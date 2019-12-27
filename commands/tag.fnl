;; Functions meant to be called interactively on tags
(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local xresources (require "beautiful.xresources"))
(local dpi xresources.apply_dpi)
(local lume (require "vendor.lume"))
(local tags (require "utils.tags"))
(local output (require "utils.output"))

(local gap-step 4)

(local tagcmd {})

(lambda tagcmd.layout-fn [layout]
  "Return a 0-arity function which changes the layout of current tag to LAYOUT"
  (fn []
    (let [s (awful.screen.focused)
          ct s.selected_tag]
      (tset ct :layout layout))))

(fn tagcmd.go-right []
  "Unmap current tag and map next tag, creating a new tag if none exists"
  (tags.view-next (awful.screen.focused)))

(fn tagcmd.go-left []
  "Unmap current tag and map previous tag"
  (tags.view-prev (awful.screen.focused)))

(fn tagcmd.inc-gap []
  "Grow the gap between clients"
  (let [s (awful.screen.focused)
        ct s.selected_tag]
    (tset ct :gap (+ gap-step ct.gap))))

(fn tagcmd.dec-gap []
  "Shrink the gap between clients"
  (let [s (awful.screen.focused)
        ct s.selected_tag
        cgap (- ct.gap gap-step)]
    (tset ct :gap (if (> cgap 0) cgap 0))))

(fn tagcmd.inc-masters []
  "Increase the number of windows that share the master area"  
  (awful.tag.incnmaster 1))

(fn tagcmd.dec-masters []
  "Decrease the number of windows that share the master area"  
  (awful.tag.incnmaster -1))

(fn tagcmd.inc-master-width []
  "Increase the master width factor, if the layout permits" 
  (awful.tag.incmwfact 0.05))

(fn tagcmd.dec-master-width []
  "Decrease the master width factor, if the layout permits" 
  (awful.tag.incmwfact -0.05))

(fn tagcmd.inc-cols []
  "Increase the number of columns, if the layout permits"
  (let [s (awful.screen.focused)
        ct s.selected_tag]
    (tset ct :column_count (+ 1 ct.column_count))))

(fn tagcmd.dec-cols []
  "Decrease the number of columns, if the layout permits"
  (let [s (awful.screen.focused)
        ct s.selected_tag]
    (tset ct :column_count (- ct.column_count 1))))

(fn tagcmd.toggle-fill-policy []
  "Toggle size fill policy for master client(s)"
  (let [s (awful.screen.focused)
        ct s.selected_tag]
    (awful.tag.togglemfpol ct)))

tagcmd
