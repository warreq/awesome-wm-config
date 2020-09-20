;   ██                                                    
; ░░████░░                                                
; ▒▒  ▒▒████                                            ▒▒
;   ██    ██████▒▒                                      ██
;     ██████░░▒▒████████▓▓░░                          ▓▓▒▒
;   ██  ▒▒████████████████████                ▒▒▓▓░░████▒▒
;   ░░████  ██████████████████              ██████████████
;       ████████████████████████          ██████████████  
;     ▒▒░░  ████████████████████        ██████████████▒▒  
;       ████████████████████████░░    ▒▒██████████████    
;               ██████████████████    ██████████████      
;               ░░██████████████████████████              
;                 ░░████████████████████████              
;                   ██████████████████████████            
;                     ▒▒████████████████████████          
;                         ██████████████████████░░        
;                           ████████████    ██▓▓▒▒        
;                         ▒▒██████████        ████        
;                         ██████████          ░░▒▒        
;                     ▒▒████████    ▒▒                    
;                     ██████████  ▓▓░░██░░▒▒              
;                       ████████  ▒▒▒▒                    
;                       ▒▒████▒▒                          
;                       ░░██▓▓                            
;                         ██                              

;; “You see, a witch has to have a familiar, some little animal like a cat or
;; toad. He helps her somehow. When the witch dies the familiar is supposed to
;; die too, but sometimes it doesn't.”
;; -- Henry Kuttner, “Before I Wake”

(local awful (require "awful"))
(local lume (require "vendor.lume"))
(local input (require "utils.input"))
(local persistence (require "features.persistence"))
(local {: ext : geo} (require "api.lawful"))
(local {: concat } (require "utils.oleander"))

(local fam {})

(set fam.default-config {
                         :placement :left
                         :screen-ratio 0.33
                         })

(set fam.collection {})

(lambda tag-familiar [conf]
  "Return a function for capturing a familiar's window ID after it has mapped"
  (lambda [client]
    (tset fam.collection
          (.. "" client.window)
          (lume.merge conf {:wid client.window}))))

(lambda axis-from-dir [dir]
  (match dir
    :left :vertical
    :right :vertical
    :top :horizontal
    :bottom :horizontal
    _ (error (.. "Unknown direction '"
                 dir
                 "': expected top, left, right or bottom"))))

(lambda gen-placement [conf]
  "Generate a placement function based on a familiar's config"
  (fn [c]
    (let [axis (axis-from-dir conf.placement)
          p (+ geo.scale
               (. geo conf.placement)
               (. geo (.. "maximize_" axis "ly")))]
      (p c {:to_percent conf.screen-ratio :honor_workarea false}))))

(lambda summon-familiar [conf]
  "Summon familiar with configuration CONF"
  (let [placement (gen-placement conf)
        (pid snid) (ext.spawn conf.command
                          {
                           :is_familiar true
                           :familiar_name conf.name
                           :floating true
                           :ontop true
                           :sticky true
                           :placement placement
                           :border_width 0
                           :skip_taskbar true
                           :hidden false
                           :size_hints_honor false
                           :requests_no_titlebar true
                           :titlebars_enabled false}
                          (tag-familiar conf)
                          )]
    nil))

(lambda find-familiar [name]
  "Enumerate current clients and return the familiar named NAME"
  ((awful.client.iterate (fn [c] (= c.familiar_name name)))))

(lambda find-or-summon-familiar [conf]
  "Find familiar named CONF.NAME, summoning it if it does not exist"
  (let [f (find-familiar conf.name)]
    (or f (summon-familiar conf))))

(lambda toggle-familiar [conf]
  "Call or dismiss familiar named CONF.NAME"
  (let [f (find-or-summon-familiar conf)]
    (when f
      (tset f :hidden (not f.hidden))
      (when (not f.hidden)
        (: f :emit_signal "request::activate")))))

(fn fam.save []
  "Return current state for persistence"
  {:collection fam.collection})

(lambda fam.load [state]
  "Restore contents of STATE and apply it"
  (set fam.collection (or state.collection fam.collection))
  (each [_ c (ipairs (client.get))]
    (let [wid (.. "" c.window)]
    (when (. fam.collection wid)
      (let [conf (. fam.collection wid)
            placement (gen-placement conf)]
      (tset c :familiar_name conf.name)
      (tset c :is_familiar true)
      (tset c :border_width 0)
      (tset c :ontop true)
      (tset c :sticky true)
      (tset c :hidden true)
      (awful.titlebar.hide c)
      (placement c))))))

(persistence.register "familiars" fam.save fam.load)

(lambda fam.def [conf]
"Define a familiar with properties map CONF.

CONF has properties --
:name         -- every familiar deserves a unique and fitting name
:key          -- key for summoning familiar, in form [[MODIFIERS] KEY-CODE]
:command      -- command to execute, along with any arguments
:screen-ratio -- 0 < decimal < 1 representing how much of the screen it covers
:placement    -- portion of screen (left, right, top, bottom) it calls home"
  (let [category "familiars"
        description (.. "⏼ " conf.name " visible")
        merge-conf (lume.merge fam.default-config conf)
        toggle-fn (fn [] (toggle-familiar merge-conf))
        [mods key] conf.key
        binding (input.keybind category mods key toggle-fn description)]
    (root.keys (concat (root.keys) binding))))

fam.def
