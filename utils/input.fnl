(local awful (require "awful"))
(local lume (require "vendor.lume"))
(local unpack (or table.unpack _G.unpack))

(var input {})

;; X11 Mouse Buttons
(set input.left-click 1)
(set input.middle-click 2)
(set input.right-click 3)
(set input.scroll-up 4)
(set input.scroll-down 5)
(set input.scroll-left 6)
(set input.scroll-right 7)
(set input.thumb-back-click 8)
(set input.thumb-next-click 9)

(set input.modkey "Mod4")

(set input.modifiers
     {:mod input.modkey
      :shift "Shift"
      :ctrl "Control"
      :alt "Alt"})

(fn input.map-mods
  ;; convert short modifier names to ones Awesome/X11 understands
  [mods]
  (-> mods 
      (lume.map (partial . input.modifiers))))

(fn input.keybind
  ;; describe a keybinding and assign it to a group
  [group mods key-code fun desc]
  (awful.key (input.map-mods mods) key-code fun {:description desc :group group}))

(fn input.mousebind
  ;; describe a mouse button binding, short-modifier-aware
  [mods btn-code fun]
  (awful.button (input.map-mods mods) btn-code fun))

(fn input.key-group
  ;; Given a group name, and any additional number of arguments shaped as follows:
  ;;     [[MODIFIERS] KEY-CODE FUNCTION DESCRIPTION]
  ;; return an `awful.key` for each additional argument (multi-valued return)
  [group ...]
  (let [map-key-group (partial input.keybind group)]
    (-> [...]
        (lume.map (fn [k] (map-key-group (unpack k))))
        (lume.reduce (fn [a b] (lume.concat a b)) [])
        (values))))

input
