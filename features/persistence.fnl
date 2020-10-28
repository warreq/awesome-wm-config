(local awful (require "awful"))
(local json (require "vendor.json"))
(local lume (require "vendor.lume"))
(local screen-utils (require "utils.screens"))
(local { : notify} (require :api.lawful))

(local persistence {})

(local signame "persistence::")
(local cachedir (awful.util.get_cache_dir))
(local statefile "state.json")
(local permafile "persisted.json")

(local subscribers [])

;; initialize as disabled
(set persistence.enabled false)

(lambda write-file [path filename content]
  (let [f (io.open (.. path "/" filename) "w")]
    (: f :write content)
    (: f :close)))

(lambda read-file [path filename]
  (match (io.open (.. path "/" filename) "r")
    [nil err] (do (write-file path filename "{}")
                  (match (io.open (.. path "/" filename) "r")
                    [nil err] (notify.err err)
                    f (: f :read "*all")))
    f (: f :read "*all")))

(lambda delete-file [path filename]
  (os.remove (.. path filename))) 

(lambda persistence.register [name save on-load ?persist-across-reboot?]
  "Register hooks for saving and loading state"
  (table.insert subscribers {:name name
                             :save save
                             :on-load on-load
                             :perma ?persist-across-reboot?}))

(fn persistence.save-all []
  (var new-state {})
  (var new-perma {})
  (awesome.emit_signal (.. signame "saving"))
  (each [_ sub (ipairs subscribers)]
    (let [s (if sub.perma new-perma new-state)]
      (awesome.emit_signal (.. signame sub.name "::" "saving"))
      (tset s sub.name (sub.save))
      (awesome.emit_signal (.. signame sub.name "::" "saved"))))
  (when persistence.enabled
    (write-file cachedir statefile (json.encode new-state))
    (write-file cachedir permafile (json.encode new-perma)))
  (awesome.emit_signal (.. signame "saved")))

(fn persistence.load-all []
  (awesome.emit_signal (.. signame "loading"))
  (let [state-file (read-file cachedir statefile)
        perma-file (read-file cachedir permafile)
        s (if persistence.enabled
              (if state-file (json.decode state-file) {})
              {})
        p (if persistence.enabled
              (if perma-file (json.decode perma-file) {})
              {})]
    (each [_ sub (ipairs subscribers)]
      (let [data (if sub.perma p s)]
        (when data
          (awesome.emit_signal
           (.. signame sub.name "::" "loading"))
          (sub.on-load (or (. data sub.name) {}))
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

(fn load-tags [map]
  (let [screens (screen-utils.get-screens)
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
                     :hide t.hide
                     :index t.index
                     :screen scr 
                     :master_width_factor t.master-width-factor
                     :layout lay 
                     :volatile t.volatile
                     :gap_single_client t.gap-single-client
                     :master_fill_policy t.master-fill-policy
                     :master_count t.master-count
                     :icon t.icon
                     :column_count t.column-count
                     }))
        (each [_ c (ipairs clients)]
          (when (lume.match t.window-ids (fn [wid] (= wid c.window)))
            (: c :move_to_tag tag)))))))

(persistence.register "tags" save-tags load-tags)

(fn persistence.enable []
  (set persistence.enabled true))

;; other features can depend on persistence's signals,
;; even if persistence is not enabled
(awesome.connect_signal
 "exit"
 (fn [restart?]
   (if restart?
       (persistence.save-all)
       (persistence.delete-file cachedir statefile))))

(awesome.connect_signal "startup" (fn [] (persistence.load-all)))

persistence
