(local awful (require "awful"))
(local json (require "vendor.json"))
(local lume (require "vendor.lume"))
(local output (require "utils.output"))

(local persistence {})

(local signame "persistence::")
(local cachedir (awful.util.get_cache_dir))
(local statefile "state.json")

(local subscribers [])

(fn read-file [path filename]
  (let [f (io.open (.. path "/" filename) "r")]
    (: f :read "*all")))

(fn write-file [path filename content]
  (let [f (io.open (.. path "/" filename) "w")]
    (: f :write content)))

(fn persistence.register [name save on-load]
  ""
  (table.insert subscribers {:name name :save save :on-load on-load}))

(fn save-all []
  (var new-state {})
  (awesome.emit_signal (.. signame "saving"))
  (each [_ sub (ipairs subscribers)]
    (awesome.emit_signal (.. signame sub.name "::" "saving"))
    (tset new-state sub.name (sub.save))
    (awesome.emit_signal (.. signame sub.name "::" "saved")))
  (write-file cachedir statefile (json.encode new-state))
  (awesome.emit_signal (.. signame "saved")))

(fn persistence.load-all []
  (awesome.emit_signal (.. signame "loading"))
  (let [file (read-file cachedir statefile)
        s (json.decode file)]
    (when s
      (each [_ sub (ipairs subscribers)]
        (when (. s sub.name)
          (awesome.emit_signal
           (.. signame sub.name "::" "loading"))
          (sub.on-load (. s sub.name))
          (awesome.emit_signal
           (.. signame sub.name "::" "loaded")))))
    (awesome.emit_signal (.. signame "loaded"))))

(fn layout-name [layout]
  (let [tv (type layout)]
    (match tv
      "function" (. (layout) :name)
      "table" layout.name
      _ (error (.. "Layout should be a function or table, got " tv)))))

(fn save-tags []
  (let [current-tags (root.tags)]
    (lume.map
     current-tags
     (fn [t] {
              :name t.name
              :selected t.selected
              :activated t.activated
              :index t.index
              :screen-index t.screen.index
              :master-width-factor t.master_width_factor
              :layout (layout-name t.layout)
              :volatile t.volatile
              :gap t.gap
              :gap-single-client t.gap_single_client
              :master-fill-policy t.master_fill_policy
              :master-count t.master_count
              :icon t.icon
              :column-count t.column_count
              :window-ids (lume.map (: t :clients) (fn [c] c.window))
              }))))

(fn screen-iter []
  (var i 0)
  (var n (: screen :count))
  (fn []
    (set i (+ i 1))
    (when (<= i n)
      (. screen i))))

(fn get-screens []
  (var ss [])
  (each [s (screen-iter)]
    (table.insert ss s))
  ss)

(fn load-tags [map]
  (let [screens (get-screens)
        clients (client.get)]
    (each [_ t (pairs map)]
      (let [scr (or (. screens t.screen-index) screen.primary)
            lay (-> awful.layout.layouts
                    (lume.filter (fn [l] (= l.name t.layout)))
                    (lume.first))]
    (local tag (awful.tag.add
       t.name
       {
        :selected t.selected
        :activated t.activated
        :index t.index
        :screen scr 
        :master_width_factor t.master-width-factor
        :layout lay 
        :volatile t.volatile
        :gap t.gap
        :gap_single_client t.gap-single-client
        :master_fill_policy t.master-fill-policy
        :master_count t.master-count
        :icon t.icon
        :column_count t.column-count
        }))
    (each [_ client (ipairs clients)]
      (when (lume.filter t.window-ids (fn [wid] (= wid client.window)))
        (: client :toggle_tag tag)))))))

(persistence.register "tags" save-tags load-tags)

;; functions for registering specific state as persisted
;; serialize them to json 
;; restore them on startup 
;; dispatch restored data via signals 
;; helper function for registering cb that uses the right signal 
;; function for informing when registered state has changed? 

(fn persistence.enable []
  (awesome.connect_signal "exit" (fn [restart?] (when restart? (save-all))))
  (awesome.connect_signal "startup" (fn [] (persistence.load-all))))

persistence
