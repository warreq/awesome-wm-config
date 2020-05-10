(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local output (require "utils.output"))

(local widget-utils {})

(lambda widget-utils.buttonize [target on-click? ?props]
  "Attach ON-CLICK? callback and stylize TARGET as a button.

PROPS are possible overrides to styles defined in `beautiful.button_*`"
  (let [props (or ?props {})
        bg-hover (or props.bg-hover beautiful.button_bg_hover "#222")
        fg-hover (or props.fg-hover beautiful.button_fg_hover "#eee")
        bg-click (or props.bg-click beautiful.button_bg_click "#222")
        fg-click (or props.fg-click beautiful.button_fg_click "#eee")
        color-in-fn (fn [t key color]
                      (fn []
                        (when (~= (. t key) color)
                          (tset t (.. key :_backup) (. t key))
                          (tset t (.. :has_ key :_backup) true))
                        (tset t key color)))
        color-out-fn (fn [t key]
                       (fn []
                         (when (. t (.. :has_ key :_backup))
                           (tset t key (. t (.. key :_backup))))))]
    (: target :connect_signal :mouse::enter (color-in-fn target :bg bg-hover))
    (: target :connect_signal :mouse::enter (color-in-fn target :fg fg-hover))
    (: target :connect_signal :mouse::leave (color-out-fn target :bg))
    (: target :connect_signal :mouse::leave (color-out-fn target :fg))
    (: target :connect_signal :button::press (color-in-fn target :bg bg-click))
    (: target :connect_signal :button::press (color-in-fn target :fg fg-click))
    (: target :connect_signal :button::release (color-out-fn target :bg))
    (: target :connect_signal :button::release (color-out-fn target :fg))
    (when on-click?
      (: target :connect_signal :button::release on-click?))
        target))

(lambda widget-utils.popoverize [target popover-widget ?props]
  "Transform TARGET into a popover button which displays given POPOVER-WIDGET.

PROPS contains:
:preferred-positions -- priority array like [:bottom :right :left :top]
:preferred-anchors -- priority array like [:middle :back :front]
overrides to styles defined in `beautiful.button_*`"
  (let [props (or ?props {})
        ppos (or props.preferred-positions [:bottom :right :left :top])
        panc (or props.preferred-anchors [:middle :back :front])]
    (widget-utils.buttonize
     target
     (fn []
       (awful.placement.next_to
        popover-widget
        {:mode :geometry
         :preferred_positions ppos
         :preferred_anchors panc
         :geometry mouse.current_widget_geometry})
       (tset popover-widget :visible (not popover-widget.visible)))
     props)))

widget-utils
