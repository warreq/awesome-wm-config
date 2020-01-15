;; Keyboard & Mouse bindings declarations -- all in one place
(local awful (require "awful"))
(local gears (require "gears"))
(local hotkeys_popup (require "awful.hotkeys_popup"))
(local lume (require "vendor.lume"))
(local input (require "utils.input"))
(local pa (require "utils.pulseaudio"))
(local wincmd (require "commands.window"))
(local tagcmd (require "commands.tag"))
(local workspacecmd (require "commands.workspace"))
(local defhydra (require "features.hydra"))
(local output (require "utils.output"))
(local notify output.notify)

(local layouts awful.layout.suit)

(local window-hydra
       (defhydra {:name "Windows 🐲" :take-counts true :key [[:mod] :w] }
                 ["Movement"
                  [:h wincmd.move-left "move left"]
                  [:j wincmd.move-down "move down"]
                  [:k wincmd.move-up "move up"]
                  [:l wincmd.move-right "move right"]
                  [:c wincmd.cycle-clockwise "cycle clockwise"]
                  [:C wincmd.cycle-counter-clockwise "cycle counter-clockwise"]
                  [:Left wincmd.transfer-to-prev-tag "to previous tag" {:exit true}]
                  [:Right wincmd.transfer-to-next-tag "to next tag" {:exit true}]]
                 ["Snap"
                  [:H wincmd.snap-left "snap to left edge"]
                  [:J wincmd.snap-bottom "snap to bottom edge"]
                  [:K wincmd.snap-top "snap to top edge"]
                  [:L wincmd.snap-right "snap to right edge"]
                  [:Y wincmd.snap-top-left-corner "snap to top left"]
                  [:U wincmd.snap-top-right-corner "snap to top right"]
                  [:N wincmd.snap-bottom-left-corner "snap to bottom left"]
                  [:B wincmd.snap-bottom-right-corner "snap to bottom right"]]
                 ["Toggle"
                  [:space wincmd.toggle-floating "⏼ floating"]
                  [:s wincmd.toggle-sticky "⏼ sticky"]
                  [:f wincmd.toggle-fullscreen "⏼ fullscreen" {:exit true}]]))

(local tag-hydra
       (defhydra {:name "Tags 🐲" :take-counts true :key [[:mod] :t] }
                 ["Layout"
                  [:space (tagcmd.layout-fn layouts.floating) "floating"]
                  [:= (tagcmd.layout-fn layouts.fair) "fair"]
                  [:/ (tagcmd.layout-fn layouts.fair.horizontal) "fairv"]
                  [:t (tagcmd.layout-fn layouts.tile) "tile"]
                  [:s (tagcmd.layout-fn layouts.spiral) "spiral"]
                  [:S (tagcmd.layout-fn layouts.spiral.dwindle) "dwindle"]
                  [:f (tagcmd.layout-fn layouts.max) "max"]
                  [:F (tagcmd.layout-fn layouts.max.fullscreen) "fullscreen"]
                  [:+ (tagcmd.layout-fn layouts.magnifier) "magnifier"]]
                 ["Spacing"
                  [:c tagcmd.inc-cols "add column"]
                  [:C tagcmd.dec-cols "remove column"]
                  [:m tagcmd.inc-masters "increase masters"]
                  [:M tagcmd.dec-masters "decrease masters"]
                  [:j tagcmd.dec-master-width "shrink master area"]
                  [:k tagcmd.inc-master-width "grow master area"]
                  [:p tagcmd.toggle-fill-policy "⏼ fill policy"]
                  [:g tagcmd.inc-gap "increase gaps"]
                  [:G tagcmd.dec-gap "decrease gaps"]]
                 ["Transfer"
                  [:q tagcmd.destroy-current "destroy" {:exit true}] 
                  [:h (fn [] (output.notify "TODO")) "move to screen left"]
                  [:l (fn [] (output.notify "TODO")) "move to screen right"]]))

(local
 bindings
 {
  :global-keys
  (gears.table.join

   (input.key-group
    "awesome"
    [[:mod] :s hotkeys_popup.show_help "show help"]
    [[:mod :shift] :r awesome.restart "reload config"]
    )

   (input.key-group
    "exec"
    [[:mod] :space (fn [] (awful.util.spawn "rofi -show run")) "app launcher"]
    [[:mod] :Return (fn [] (awful.spawn "alacritty")) "open terminal"]
    [[] :XF86AudioMute pa.toggle-muted "⏼ audio muted"]
    [[] :XF86AudioMicMute pa.toggle-mic-mute "⏼ mic muted"]
    [[] :XF86AudioRaiseVolume (fn [] (pa.adjust-volume 5)) "raise volume"]
    [[] :XF86AudioLowerVolume (fn [] (pa.adjust-volume -5)) "lower volume"]
    )

   (input.key-group
    "tags"
    [[:mod :shift] :l tagcmd.go-right "switch to next tag"]
    [[:mod :shift] :h tagcmd.go-left "switch to previous tag"]
    )
   tag-hydra

   (input.key-group
    "workspaces"
    [[:mod] :n workspacecmd.prompt "create workspace"]
    )

   (input.key-group
    "client"
    [[:mod] :h (fn [] (awful.client.focus.bydirection :left)) "focus left"]
    [[:mod] :j (fn [] (awful.client.focus.bydirection :down)) "focus down"]
    [[:mod] :k (fn [] (awful.client.focus.bydirection :up)) "focus up"]
    [[:mod] :l (fn [] (awful.client.focus.bydirection :right)) "focus right"]
    [[:mod] :n (fn [] (awful.client.focus.byidx 1)) "focus next"]
    [[:mod] :p (fn [] (awful.client.focus.byidx -1)) "focus previous"]
    [[:mod :shift] :j (fn [] (awful.client.swap.byidx 1)) "swap next with previous"]
    [[:mod :shift] :k (fn [] (awful.client.swap.byidx -1)) "swap next with previous"]
    ) 
   window-hydra
   )


  :client-keys
  (gears.table.join
   (input.key-group
    "client"
    [[:mod] :n wincmd.minimize "minimize"]
    [[:mod] :t wincmd.toggle-ontop "⏼ keep on top"]
    [[:mod] :m wincmd.toggle-maximized "⏼ maximize"]
    [[:mod] :f wincmd.toggle-fullscreen "⏼ fullscreen"]
    [[:mod :ctrl] :space awful.client.floating.toggle "⏼ floating"]
    [[:mod :ctrl] :Return wincmd.move-to-master "move to master"]
    [[:mod :ctrl] :m wincmd.toggle-maximize-vertical "⏼ max vertically"]
    [[:mod :shift] :m wincmd.toggle-maximize-horizontal "⏼ max horizontally"]
    [[:mod :shift] :c wincmd.close "close"]
    ))

  :client-buttons
  (gears.table.join
   (input.mousebind [] input.left-click client.mouse-raise)
   (input.mousebind [:mod] input.left-click client.mouse-drag-move)
   (input.mousebind [:mod] input.right-click client.mouse-drag-resize)
   )
  })

bindings
