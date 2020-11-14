;; Functions meant to be called interactively on tags
(local workspaces (require "features.workspaces"))

(local workspacecmd {})

(fn workspacecmd.prompt []
  "Prompt to name a new workspace, then switch to it"
;  (: (rofi.hist-prompt "new workspace" "workspaces")
;     :next (fn [res]
;             (workspaces.create res)
;             (workspaces.apply res))))
)

workspacecmd
