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

(require "patches.fix-snid")
(local awful (require "awful"))
(local lume (require "vendor.lume"))
(local gears (require "gears"))
(local input (require "utils.input"))
(local output (require "utils.output"))

(local fam {})

(set fam.default-config {
                         :placement :left
                         })

(set fam.spawnbuf {})

(lambda spawn [cmd props ?cb]
  "Spawn application with CMD and set PROPS on resulting client. 
Execute callback ?CB if provided, passing the client as the only argument.
This is similar to `awful.spawn`, but without the callback bug observed in v4.3-530"
  (let [(pid snid) (awesome.spawn cmd true)]
    (when snid
      (tset fam.spawnbuf snid [props ?cb]))
    (values pid snid)))

;; this signal connection is for use with `spawn` --
;; it correlates the snid in the buffer and applies the properties to respective client
(client.connect_signal
 "manage"
 (fn [c]
   (when c.startup_id
     (let [snid c.startup_id
           snid-data (. fam.spawnbuf snid)]
       (when snid-data
         (let [props (. snid-data 1)
               ?cb (. snid-data 2)]
           (each [k v (pairs props)]
             (tset c k v))
           (when ?cb
             (?cb c))
           (tset fam.spawnbuf snid nil)))))))

(lambda summon-familiar2 [conf]
  (let [(pid snid) (spawn conf.command
                          {
                           :is_familiar true
                           :familiar_name conf.name
                           :floating true
                           :sticky true
                           :width conf.width
                           :placement conf.placement
                           :skip_taskbar true
                           :hidden false
                           :size_hints_honor false
                           :requests_no_titlebar true
                           :titlebars_enabled false}
                          )]
    nil))

(lambda summon-familiar [conf]
  (let [pid (awful.spawn conf.command
               {
                :is_familiar true
                :familiar_name conf.name
               :floating true
               :sticky true
               :width conf.width
               :placement conf.placement
               :skip_taskbar true
               :hidden false
               :size_hints_honor false
               :requests_no_titlebar true
               :titlebars_enabled false}
              )]
  nil))

(lambda find-familiar [name]
  ((awful.client.iterate (fn [c] (= c.familiar_name name)))))

(lambda find-or-summon-familiar [conf]
  (let [f (find-familiar conf.name)]
    (or f (summon-familiar2 conf))))

(lambda toggle-familiar [conf]
  (let [f (find-or-summon-familiar conf)]
    (when f
      (tset f :hidden (not f.hidden)))))

;(deffamiliar {:name "terminal"
;              :key "[[:mod] :t]"
;              :command "xterm"
;              :width 80
;              :height 1
;              :placement awful.placement.left})

(lambda fam.def [conf]
  (let [category "familiars"
        description (.. "⏼ " conf.name " visible")
        merge-conf (lume.merge fam.default-config conf)
        toggle-fn (fn [] (toggle-familiar merge-conf))
        [mods key] conf.key
        binding (input.keybind category mods key toggle-fn description)]
    (root.keys (gears.table.join (root.keys) binding))))


fam.def
