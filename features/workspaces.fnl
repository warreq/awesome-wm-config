(local awful (require "awful"))
(local lume (require "vendor.lume"))
(local tag-utils (require "utils.tags"))
(local screen-utils (require "utils.screens"))
(local output (require "utils.output"))
(local persistence (require "features.persistence"))

(local workspaces {})

(set workspaces.map {:default {:tags [] :selected []}})
(set workspaces.current :default)

(fn workspaces.get [?name]
  "Get the current workspace, or the workspace with name ?NAME"
  (let [name (or ?name workspaces.current)]
    (. workspaces.map name)))

(lambda workspaces.create [name]
  "Create a new workspace with name NAME, if it does not already exist"
  (when (not (workspaces.get name))
    (tset workspaces.map name {:tags [] :selected []})))

(lambda workspaces.attach-tag [tag ?client ?workspace]
  "Associate TAG with ?WORKSPACE or current workspace"
  (let [ws (workspaces.get ?workspace)]
    (when (not (lume.find (or ws.tags []) tag.name))
      (table.insert (. ws :tags) tag.name))
    (tset tag :workspace workspaces.current)))

(fn workspaces.save-selected-tags []
  "Find all selected tags across all screens and persist them"
  (var selection [])
  (each [scr (screen-utils.screen-iter)]
    (set selection
         (lume.concat selection
                      (lume.map (. scr :selected_tags) (fn [t] t.name)))))
  (let [selected-tags (. (. workspaces.map workspaces.current) :tags)
        filtered (lume.filter selection (fn [s] (lume.find selected-tags s)))]
    (tset (. workspaces.map workspaces.current) :selected filtered)))

(fn workspaces.restore-selected-tags []
  "Re-select the last known selected tags for the current workspace"
  (lume.each (. (. workspaces.map workspaces.current) :selected)
             (fn [name] (let [t (awful.tag.find_by_name nil name)]
                       (tset t :selected true)))))

(lambda workspaces.apply [?name]
  "Activate ?NAME or current workspace, deactivating tags not attached to it"
  (let [ws (or ?name workspaces.current)
        tags (root.tags)
        predicate (fn [t] (= t.workspace ws))
        active (lume.filter tags predicate)
        inactive (lume.reject tags predicate)]
    
    (awesome.emit_signal "workspaces::applying" ws)
    (workspaces.save-selected-tags)
    (set workspaces.current ws)
    (each [_ tag (ipairs active)]
      (tag-utils.activate tag))
    (each [_ tag (ipairs inactive)]
      (tag-utils.deactivate tag))
    ;; if there's no active tags on a screen, create one
    (each [scr (screen-utils.screen-iter)]
      (when (= (# (tag-utils.list-visible scr)) 0)
        (tag-utils.create scr nil {:workspace ws})))
    (workspaces.restore-selected-tags)
    (awesome.emit_signal "workspaces::applied" ws)))

(fn workspaces.save []
  "Return current state for persistence"
  {:current workspaces.current
   :map workspaces.map})

(lambda workspaces.load [state]
  "Restore contents of STATE and apply it"
  (set workspaces.current state.current)
  (set workspaces.map state.map)
  (let [lookup (lume.reduce
                (lume.keys workspaces.map)
                (fn [k]
                  (let [v (. workspaces.map k)]
                    (lume.map v.tags (fn [t] {t k}))))
                {})]
    (each [_ tag (ipairs (root.tags))]
      (workspaces.attach-tag tag nil (. lookup tag.name))))
  (workspaces.apply))

(fn workspaces.enable []
  (awesome.emit_signal "workspaces::init")
  (persistence.register "workspaces" workspaces.save workspaces.load)
  (awful.tag.attached_connect_signal nil "tagged" workspaces.attach-tag)
  ;; when initializing, walk all tags and claim any orphans with no workspace
  (each [_ tag (ipairs (root.tags))]
    (when (not tag.workspace) (workspaces.attach-tag tag))))

workspaces
