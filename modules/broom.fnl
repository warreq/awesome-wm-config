;;                                 _.--""""--._
;;                               .'       /\   '.
;;                              / ^V^   _/__\_   \
;;                             /        ///'}     \
;;                             | ___    /` \      |
;;                             |-=-I>==(  \=\==== |
;;                             \ ```    >  >      /
;;                              \       \ /      /
;;                               '._     `    _.'
;;                                  '--....--'  jgs
;;
;; An autocomplete prompt that can fly you to where you need, because it knows
;; where you've been.
;;
;; Similar to programs like `rofi` or `Synapse`, but built into the wm for
;; maximum integration and customization.
;;
;; use persistence to store last X choices at top
;;
(local {: ext : geo : notify} (require :api.lawful))
(import-macros {: async : await } :utils.async)
(local {: concat } (require :utils.oleander))
(local xresources (require :beautiful.xresources))
(local awful (require :awful))
(local dpi xresources.apply_dpi)
(local wibox (require :wibox))
(local xml (require :utils.xml))
(local input (require :utils.input))
(local pango xml.create-elements)
(local lume (require :vendor.lume))

(local empty-completion-widget
       {:layout wibox.layout.flex.vertical
;        13 {:widget wibox.widget.textbox :text "lol sukker"}
;        14 {:widget wibox.widget.textbox :text "show me ur moves"}})
        })

(fn broom-ui [scr conf]
  (awful.popup
   {:placement conf.placement
    :visible false
    :border_width 2
    :border_color "#ffffff"
    :widget (wibox.widget {:margins (dpi 16)
                           :widget wibox.container.margin
                           1 {:forced_height (/ scr.geometry.height 3)
                              :forced_width (/ scr.geometry.width 3)
                              :layout wibox.layout.fixed.vertical
                              1 (wibox.widget.textbox "")
                              2 empty-completion-widget}})}))

(fn broombox-init [scr conf broomkey]

  (local broombox (broom-ui scr conf))
  (tset scr broomkey broombox)
  (set broombox.key broomkey)

  (set broombox.selection 1)
  (set broombox.opt-cache [])
  (set broombox.options [])

  (fn broombox.get-prompt-widget []
    (-> broombox
        (. :widget)
        (: :get_children)
        (. 1)
        (: :get_children)
        (. 1)))

  (fn broombox.get-completion-widget []
    (-> broombox
        (. :widget)
        (: :get_children)
        (. 1)
        (: :get_children)
        (. 2)))

  (fn broombox.open []
    (set broombox.visible true)
    (set broombox.ontop true))

  (fn broombox.close []
    (set broombox.visible false)
    (tset (broombox.get-prompt-widget) :markup ""))

  (fn broombox.template-options []
    (var compl-widget (broombox.get-completion-widget))
    (var widgets [])
    (each [i v (ipairs (lume.slice broombox.options 0 conf.max-displayed))]
      (table.insert
       widgets
       i
       (conf.option-template v (= i broombox.selection))))
    (compl-widget:set_children (concat empty-completion-widget widgets)))

  (fn broombox.filter-options [txt]
    (if (not txt)
        (do
          ;; TODO: empty text should cause display of history
          (set broombox.options (lume.slice broombox.opt-cache 0 conf.max-displayed))
          (broombox.template-options))
        ;; TODO: replace dumb filter fn with levenshtein distance
        (let [opts (lume.filter broombox.opt-cache (fn [o] (string.find o txt)))]
          (notify.info (# opts))
          (var compl-widget (broombox.get-completion-widget))
          (set broombox.options opts)
          (do
            (if (> (# broombox.options) 0)
                (do
                  (when (< broombox.selection 1)
                    (set broombox.selection 1))
                  (broombox.template-options))
                (compl-widget:set_children []))))))
  (tset scr broomkey broombox)
  (. scr broomkey))

(fn defbroom [conf]
  "Define a broom with properties map CONF.

CONF has properties --
:name
:key
:prompt
:placement
:option-generator
:option-template
:max-displayed
:on-select
:on-cancel
:on-change
:hooks
"
  (awesome.connect_signal
   :startup
   (fn []
     ;; TODO: Sanitize name to always be a valid table field name
     (local broom-screen-key (.. "broom_" conf.name))
     (awful.screen.connect_for_each_screen
      (fn [s]
        (local b (broombox-init s conf broom-screen-key))

        (fn b.run [self]
          (set b.opt-cache (conf.option-generator))
          (set b.options b.opt-cache)
          (b.filter-options)
          (b.open)
          (awful.prompt.run
           {
            :changed_callback
            (fn [cmd]
              (b.filter-options cmd))
            :done_callback b.close
            :hooks
            (conf.hooks b.close)
            :keypressed_callback
            (fn [mod key cmd]
              (if (= key :Up)
                  (when (> b.selection 0)
                  ;; TODO: Handle scrolling more of the option cache
                    (set b.selection (- b.selection 1)))
                  (= key :Down)
                  ;; TODO: Handle scrolling more of the option cache
                  (when (< b.selection (# b.options))
                    (set b.selection (+ b.selection 1)))
                  (= key :Return)
                  nil ; leave open for caller-supplied hooks
                  (= key :BackSpace)
                  (set b.selection 1)
                  (string.match key "[a-zA-Z0-9]{1}")
                  (set b.selection 1)))
            :prompt conf.prompt
            :textbox (b.get-prompt-widget)}))))

     (let [category "brooms"
           description conf.name
           run-fn (fn []
                    (async ; just in case user-supplied generators are async
                     (let [scr (awful.screen.focused)]
                       ((. scr broom-screen-key :run)))))
           [mods key] conf.key
           binding (input.keybind category mods key run-fn description)]
       (root.keys (concat (root.keys) binding))))))

defbroom
