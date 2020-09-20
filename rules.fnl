(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local keybindings (require "keybindings"))

(local
 rules
 [
  ;; All clients will match this rule.
  {
   :rule { }
   :properties {
                :border_width beautiful.border_width
                :border_color beautiful.border_normal
                :focus awful.client.focus.filter
                :raise true
                :size_hints_honor false
                :keys keybindings.client-keys
                :buttons keybindings.client-buttons
                :screen awful.screen.preferred
                }
   }

  ;; Floating clients.
  {
   :rule_any {
              :instance [
                         "DTA" ;; Firefox addon DownThemAll.
                         "copyq" ;; Includes session name in class.
                         "pinentry"
                         ] 
              :class [
                      "Arandr"
                      "Blueman-manager"
                      "Gpick"
                      "Kruler"
                      "MessageWin" ;; kalarm.
                      "Sxiv"
                      "Tor Browser" ;; Needs a fixed window size to avoid fingerprinting by screen size.
                      "Wpa_gui"
                      "veromix"
                      "xtightvncviewer"
                      ]
              ;; Note that the name property shown in xprop might be set slightly after creation of the client
              ;; and the name shown there might not match defined rules here.
              :name [
                     "Event Tester"  ;; xev
                     ]
              :role [
                     "AlarmWindow" ;; Thunderbird's calendar.
                     "ConfigManager" ;; Thunderbird's about:config.
                     "pop-up" ;; e.g. Google Chrome's (detached) Developer Tools.
                     ]
              }
   :properties {:floating true }}

  ;; Add titlebars to normal clients and dialogs
  {
   :rule_any {:type [ "normal" "dialog" ] }
   :properties {:titlebars_enabled true }
   }

  {
   :rule_any {:role [ "PictureInPicture" ] }
   :properties {
                :placement awful.placement.bottom_right
                }
   }
  {
   :rule_any {:name ["*Minibuf-0*"]}
   :properties {
                :placement awful.placement.bottom_left
                :height 20
                :width 1920
                :floating true
                :honor_padding true
                :honor_workarea true
                :requests_no_titlebar true
                :titlebars_enabled false
                }
   }

  ;; Set Firefox to always map on the tag named "2" on screen 1.
  ;; { :rule { :class "Firefox" }
  ;;   :properties { :screen 1 :tag "2" } }
  ])

rules
