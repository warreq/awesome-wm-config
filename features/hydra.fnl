;HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHWX0KWHHKONHHHHHHHHHHHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHWNNXK0OO00kolOWKokWHHHHHHHHHHHHHHHHHHHHHH
;HHHHHHHHHHHNkccdkOxoox0XX0kkXHHHHHHHHNKKOxl;..... .;oc,xNHHHHHHHHHHHHHHHHHHHHH
;HHHHHHHHHHHO;.    ........,xNHHHHHHHW0o:,.             .;xKWHHHHHHHHHHHHHHHHHH
;HHHHHHHHHHHWXKOd;.        ..,cxKNWWKo.      .;dkkxl;.   .',oXHHHHHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHNk:.,loo:.    .cONNOd'      :XHHHHHNx.  .,'.oNHHHHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHHNXNHHHWXo.    ;xXH0'      ;KHHHHHHX:      .;xKWHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHHHHHHHHHHWo    .lOWk.       :KWHHHHN0kxol:'   'kHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHHHHHHHHHHWd.    'kW0,...     .o0NWWKkOXWHWXk;.,OHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHHHHHHHHHHXc    .;kHWkcodc.     .';loc'',:cldkOXWHHHHHHHHHHHHH
;HHHHHHHHHHHWWWHHHHHHHHHHHWx.    .dNHHW0kOOl,.             .'''ck0KXWHHHHHHHHHH
;HHHHHHHHHHHWKxOWN00KNHHHH0,   ..;0HHHHNX0xl;.        .'.   ..   ...lXHHHHHHHHH
;HHHHHHHHHHHH0,'c'.,:okKWWd.   ;x0WHHHNkl;.    .,'    .dKo.  .';;;..,0HHHHHHHHH
;HHHHHHHHHHWK:        .;kNo    oWHHHHXd'     .c0NK:    '0N0kOKNWWKkk0WHHHHHHHHH
;HHHHHHHHHWk;.  .cc,    'dl.   lNHHHWXx'     lNHHHk.   .xHHWXOxxkccXHHHHHHHHHHH
;HHHHHHHHHX:..  cNHX:   .lx'   'OWHHHNl      :XHHHO.   .dWKd;..   .cKWHHHHHHHHH
;HHHHHHHHXo. .;o0WHX:    ,0x.   .xNHHN:       ,kWWo    .kKl.   ..   ,dXHHHHHHHH
;HHHHHHHWx..c0WHHHNd.   .cKWx.    ;xXWx,,;.    .cl.    .xd.  .oNX:  ..dWHHHHHHH
;HHHHHHHHXxxNHHHHHO.   ,xKWHW0c.    'coolkO,           ,kc   .xWWKdl,..lKHHHHHH
;HHHHHHHHHHHHHHHHHk.   ,0HHHHHWOl.     ..'c;           lXo.   .kWHHHWO:cKHHHHHH
;HHHHHHHHHHHHHHHHHK;    ;kXWHHHHWXo.                  '0HKx:.  '0HHHHHWWHHHHHHH
;HHHHHHHHHHHHHHHHHWO,     .;coxkO0x.                 .xWHHNd.  '0HHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHHHKl.          .                  .dKKOdc.  .dWHHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHWWHW0l'.                          ....    .;OWHHHHHHHHHHHHHHH
;HHHHHHHHHHHHHHWOl;;o0Xk,                                  .;OXXNWHHWK00XWHHHHH
;HHHHHHWXXWNOkKOl.   .',.                                   .'..,cdkkccl:dWHHHH
;HHHHHHNxdko;,:c:,''''''''''''''''''''''''''''''''''''''''''''''''',::cc:xWHHHH

;(defhydra {:name "Gaps 🐙🦖🐊🦕🦎🐉🐲" :key [[:mod] :g] }
;          ["Size"
;           [:j gaps.dec "smaller"]
;           [:k gaps.inc "bigger" ]]
;          ["Toggle"
;           [:t gaps.toggle "on/off" {:exit true}]])

(local awful (require "awful"))
(local wibox (require "wibox"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local xresources (require "beautiful.xresources"))
(local dpi xresources.apply_dpi)
(local input (require "utils.input"))
(local lume (require "vendor.lume"))
(local xml (require "utils.xml"))
(local output (require "utils.output"))
(local pango xml.create-elements)

(fn conf [s] (. (beautiful.get) s))

(require-macros :awesome-macros)

(local style
       {
        :fg_color (or (conf :hydra_fg) (conf :fg_normal) "#fff")
        :bg_color (or (conf :hydra_bg) (conf :bg_dark) "#000")
        :key_color (or (conf :hydra_key_color) (conf :xcolor6) "#fff")
        :term_key_color (or (conf :hydra_term_key_color) (conf :xcolor1) "#fff")
        :border_color (or (conf :hydra_border_color) (conf :xcolor0) "#fff")
        :border_width (or (conf :hydra_border_width) (conf :border_width 0))
        :font (or (conf :hydra_font) beautiful.font)
        :shape (or (conf :hydra_shape) gears.shape.rectangle)
        :placement (or (conf :hydra_placement)
                       (fn [d] (+ (awful.placement.bottom
                                   d {:margins (or
                                                (conf :hydra_popup_margin)
                                                (dpi 32))})
                                   awful.placement.center_horizontal)))
        })

(local key input.keybind)

(fn flatten-knot [head-knot]
  (let [knot (lume.first head-knot)
        heads (lume.slice head-knot 2)]
    (lume.map heads (fn [h]
                      (let [props (if (> (# h) 3)
                                      (lume.merge (. h 4) {:knot knot})
                                      {:knot knot})]
                        [(. h 1) (. h 2) (. h 3) props])))))

(fn flatten-knots [head-knots]
  (-> head-knots
      (lume.map (fn [hk] (flatten-knot hk)))
      (lume.reduce (fn [a b] (lume.concat a b)))))

(lambda as-grabber-binding [key-def ?description]
  "Convert a key definition like [[MODS] KEYCODE FUNCTION] to the format
keygrabber API expects."
  (let [[mods key ?fn] key-def]
    [(input.map-mods mods) key (if (~= nil ?fn) ?fn (fn [] nil)) ?description])) 

(fn head-color [head]
  "Determine the color of HEAD based on its properties"
  (if (. (or (. head 4) {}) :exit)
      style.term_key_color
      style.key_color))

(fn hydra-title-bar [body]
  (pango
   [:span {:size :xx-large :stretch :ultraexpanded :foreground style.fg_color}
    body.name]))

(fn head-knot-template [head-knot]
  (let [title (. head-knot 1)
        heads (lume.slice head-knot 2)
        letters (-> heads
                    (lume.map (fn [h]
                                (pango [:span {:foreground (head-color h)}
                                        (.. (. h 1) ". ")]
                                       [:span {}
                                        (.. (. h 3) "\n")])))
                    (lume.reduce (fn [a b] (.. a b))))]
    (.. (pango [:span {:variant :smallcaps} title]) "\n\n" letters)))

(fn create-hydra-ui [body head-knots]
  "Take the hydra BODY and generate an informative modal widget, where
each HEAD-KNOT is rendered into a named column with all heads listed."
  (let [cols (lume.map
              head-knots
              (fn [h]
                (/<
                 :widget wibox.widget.textbox
                 :markup (head-knot-template h)
                 :align :left
                 :valign :top
                 )))
        grid (gears.table.join
              {:layout wibox.layout.grid
               :forced_num_rows 1
               :forced_num_columns (# head-knots)
               :orientation :horizontal
               :spacing 10
               :expand true
               :homogeneous true}
              cols)
        content {:layout wibox.layout.grid
                 :forced_num_rows 2
                 :forced_num_columns 1
                 :orientation :vertical
                 :expand true
                 1 {:widget wibox.widget.textbox
                    :markup (hydra-title-bar body)
                    :align :left
                    :valign :center}
                 2 grid
                 }]
    (wibox.widget
     (/<
      :widget wibox.container.margin
      :margins 20
      content))))

(fn display-handler [ui]
  (awful.popup (/< 
                :widget ui
                :ontop true
                :visible true
                :screen (awful.screen.focused)
                :bg style.bg_color
                :fg style.fg_color
                :border_width style.border_width
                :border_color style.border_color
                :placement style.placement
                :shape style.shape)))

(lambda keypress-handler [key allowed-keys count? fn-map prop-map num-buf]
  "A count-aware handler for invoking keypresses.

Check ALLOWED-KEYS for KEY, invoke KEY in FN-MAP n times based on the
count tracked in NUM-BUF, unless COUNT? is false, and optionally
terminate the keygrabber if the :exit prop in PROP-MAP for KEY is true

RETURN the resulting state of the NUM-BUF."
  (let [key (match key
              " " "space" ; space not sent as keysym ???
              _   key)] 
    (if (lume.find allowed-keys key)
        (if (and count? (lume.find [:0 :1 :2 :3 :4 :5 :6 :7 :8 :9] key))
            (.. num-buf key)
            (do
              (let [number (tonumber num-buf)
                    count (if (= nil number) 1 number)]
                (for [i 1 count]
                  ((. fn-map key))
                  (when (. (. prop-map key) :exit)
                    (: awful.keygrabber.current_instance :stop)))
                "")))
        (do
          (: awful.keygrabber.current_instance :stop)
          ""))))


(fn defhydra [body ...]
"Define a hydra with properties map BODY, with any HEAD-KNOTS proceding.

BODY has properties --
:key         -- KEY for summoning hydra, in form [[MODIFIERS] KEY-CODE]
:take-counts -- use numbers as count for following command, default true
:timeout     -- seconds inactive before hydra unsummons, default never
:category    -- for categorising under `hotkeys_popup`
:name        -- for display purposes
:icon        -- for display purposes

A HEAD-KNOT is of the form [CATEGORY-NAME [HEAD] [HEAD] ...] 

A HEAD is of the form [KEY COMMAND DESCRIPTION PROPERTY-MAP]
e.g.,
[:f awful.client.floating.toggle \"toggle floating\" {:exit true}]

PROPERTY-MAP has properties --
:exit -- if true, slays hydra on keypress. Default false."
  (var num-buf "")
  (var popup nil)
  (let [head-knots [...]
        heads (flatten-knots head-knots)
        head-keys (lume.map heads (fn [h] (. h 1)))
        count?  (if (= nil body.take-counts) true body.take-counts)
        allowed-keys (if count? 
                         (lume.concat [:1 :2 :3 :4 :5 :6 :7 :8 :9 :0] head-keys)
                         head-keys)
        fun-map (-> heads
                    (lume.map (fn [h] {(. h 1) (. h 2)}))
                    (lume.reduce (fn [a b] (lume.merge a b))))
        prop-map (-> heads
                     (lume.map (fn [h] {(. h 1) (. h 4)}))
                     (lume.reduce (fn [a b] (lume.merge a b))))
        ui (create-hydra-ui body head-knots)
        root-binding (as-grabber-binding body.key (.. "🐲 " body.name))
        config {
                :timeout body.timeout
                :export_keybindings false
                :mask_modkeys true
                :start_callback
                (fn [] (set popup (display-handler ui)))
                :stop_callback
                (fn [] (tset popup :visible false))
                :keypressed_callback
                (fn [_ _ key _]
                  (set num-buf
                       (keypress-handler
                        key allowed-keys count? fun-map prop-map num-buf)))
                }
        [mods key] body.key
        category (or body.category "hydra")
        description (.. "🐍 " body.name)
        grabber-fn (awful.keygrabber config)]
        (input.keybind category mods key grabber-fn description)))

defhydra
