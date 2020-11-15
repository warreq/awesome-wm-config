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

(local {: ext : geo : notify} (require :api.lawful))
(local pp (require :fennelview))
(import-macros {: async : await } :utils.async)
(local {: concat } (require :utils.oleander))
(local xresources (require :beautiful.xresources))
(local awful (require :awful))
(local dpi xresources.apply_dpi)
(local wibox (require :wibox))
(local xml (require :utils.xml))
(local pango xml.create-element)
(local hotfuzz (require :utils.hotfuzz))
(local persistence (require :features.persistence))
(local input (require :utils.input))
(local lume (require :vendor.lume))

(local empty-completion-widget
       {:layout wibox.layout.flex.vertical
        :spacing (dpi 2)})

(local empty-section-widget
       {:layout wibox.layout.fixed.horizontal})

(var history {})

(fn save-history []
  history)

(fn load-history [map]
  (set history map))

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
                              :spacing (dpi 16)
                              1 empty-section-widget ; header
                              2 {:layout wibox.layout.fixed.horizontal
                                 :spacing (dpi 16)
                                 1 empty-section-widget ; prompt
                                 2 (wibox.widget.textbox "")}
                              3 {:widget wibox.widget.separator
                                 :thickness 2
                                 :forced_height 2}
                              4 empty-completion-widget
                              5 empty-section-widget}})})) ; footer

(fn broombox-init [scr conf broomkey]

  (local broombox (broom-ui scr conf))
  (tset scr broomkey broombox)
  (set broombox.key broomkey)

  (set broombox.selection 1)
  (set broombox.opt-cache [])
  (set broombox.options [])

  (fn broombox.get-header-widget []
    (-> broombox
        (. :widget)
        (: :get_children)
        (. 1)
        (: :get_children)
        (. 1)))

  (fn broombox.get-footer-widget []
    (-> broombox
        (. :widget)
        (: :get_children)
        (. 1)
        (: :get_children)
        (. 5)))

  (fn broombox.get-prompt-widget []
    (-> broombox
        (. :widget)
        (: :get_children)
        (. 1)
        (: :get_children)
        (. 2)
        (: :get_children)
        (. 1)))

  (fn broombox.get-text-widget []
    (-> broombox
        (. :widget)
        (: :get_children)
        (. 1)
        (: :get_children)
        (. 2)
        (: :get_children)
        (. 2)))

  (fn broombox.get-completion-widget []
    (-> broombox
        (. :widget)
        (: :get_children)
        (. 1)
        (: :get_children)
        (. 4)))

  (fn broombox.save-history []
    (var hist (or (. history broombox.key) []))
    (let [sel (-> broombox.options (. broombox.selection) (. :value))
          existing (lume.filter hist (fn [x] (= x sel)))]
      (when (~= nil sel)
        (when (~= nil existing)
          (lume.remove hist sel))
        (table.insert hist 1 sel))
      (tset history broombox.key hist)))

  (fn broombox.open []
    (set broombox.visible true)
    (set broombox.ontop true))

  (fn broombox.close []
    (set broombox.visible false)
    (tset (broombox.get-text-widget) :markup ""))

  (fn broombox.generate-option-markup [content selected? ?hit]
    (let [hit (or ?hit {:start 0 :end 0})
          nohit? (and (= 0 hit.start) (= 0 hit.end))
          pre (if nohit? content (content:sub 1 (- hit.start 1)))
          mid (if nohit? "" (content:sub hit.start hit.end))
          suf (if nohit? "" (content:sub (+ 1 hit.end) (length content)))]
      (pango :span
             {:foreground (if selected? "white" "gray")}
             pre [:span {:foreground "red"} mid] suf)))

  (fn broombox.template-options []
    (var compl-widget (broombox.get-completion-widget))
    (var widgets [])
    (each [i v (ipairs (lume.slice broombox.options 0 conf.max-displayed))]
      (let [{: value : hit } v
            selected? (= i broombox.selection)
            markup (broombox.generate-option-markup value selected? hit)]
        (table.insert
         widgets
         i
         (conf.option-template {:value value
                                :selected? selected?
                                :hit hit
                                :markup markup}))))
    (compl-widget:set_children (concat empty-completion-widget widgets)))

  (fn broombox.render-section [f text w]
    (let [selection (. broombox.options broombox.selection)
          contents (match (type f)
                     "function" (f text selection)
                     _          {:widget wibox.widget.textbox :markup (or f "")})]
      (when w
        (w:set_children (concat empty-section-widget [contents])))))

  (fn broombox.render-sections [text]
    (let [widgets [{:widget (broombox.get-prompt-widget) :tmpl conf.prompt}
                   {:widget (broombox.get-header-widget) :tmpl conf.header}
                   {:widget (broombox.get-footer-widget) :tmpl conf.footer}]]
      (each [_ {: widget : tmpl} (ipairs widgets)]
        (broombox.render-section tmpl text widget))))

  (fn broombox.filter-options [txt]
    (var compl-widget (broombox.get-completion-widget))
    (if (or (not txt) (= txt ""))
        (do
          (tset history broombox.key (or (. history broombox.key) []))
          (set broombox.options (lume.map (. history broombox.key) (fn [x] {:value x}))))
        (let [fuzconf {:threshold (or conf.threshold 0.6)}
              fuzz (hotfuzz.search broombox.opt-cache txt fuzconf broombox.trie)
              {: trie : results } fuzz
              opts (lume.first results conf.max-displayed)]
          (set broombox.trie trie)
          (set broombox.options opts)))
    (do
      (if (> (# broombox.options) 0)
          (do
            (when (< broombox.selection 1)
              (set broombox.selection 1))
            (broombox.template-options))
          (compl-widget:set_children []))))

    (tset scr broomkey broombox)
    (. scr broomkey))


(fn defbroom [conf]
  "Define a broom with properties map CONF.

CONF has properties --
:name
:key
:prompt
:header
:footer
:placement
:option-generator
:option-template
:max-displayed
:threshold
:on-select
:on-cancel
:on-change
:on-return
:on-shift-return
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
          (b.filter-options)
          (b.render-sections "")
          (b.open)
          (awful.prompt.run
           {
            :changed_callback
            (fn [cmd]
              (b.render-sections cmd)
              (b.filter-options cmd))
            :done_callback b.close
            :hooks
            [
             [[] :Return
              (fn [cmd]
                (let [value (or
                             (-> b.options (. b.selection) (. :value))
                             cmd
                             "")]
                  (conf.on-return value cmd)
                  (b.save-history)
                  (b.close)))]
             [[:Shift] :Return
              (fn [cmd]
                (let [value (or
                             (-> b.options (. b.selection) (. :value))
                             cmd
                             "")
                      ;; fire on-return if no on-shift-return
                      handler (or conf.on-shift-return conf.on-return)]
                  (handler value cmd)
                  (b.save-history)
                  (b.close)))]]
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
                  nil ; leave open for hooks
                  (= key :BackSpace)
                  (set b.selection 1)
                  (string.match key "[a-zA-Z0-9]{1}")
                  (set b.selection 1)))
            :prompt ""
            :textbox (b.get-text-widget)}))))

     (let [category "brooms"
           description conf.name
           run-fn (fn []
                    (async ; just in case user-supplied generators are async
                     (let [scr (awful.screen.focused)]
                       ((. scr broom-screen-key :run)))))
           [mods key] conf.key
           binding (input.keybind category mods key run-fn description)]
       (root.keys (concat (root.keys) binding))))))

(persistence.register "brooms" save-history load-history true)

defbroom
