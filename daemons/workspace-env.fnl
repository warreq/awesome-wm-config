(local workspaces (require :features.workspaces))
(local { : notify : ext } (require :api.lawful))
(import-macros {: async : await} :utils.async)

(fn inject-bash-workspace-env []
  (with-open [bashrc (io.open (.. (os.getenv "HOME") "/.bashrc") :a+)]
    (let [source-line "source ~/.cache/awesome/wsenv"
          content (bashrc:read "*all")]
      (when (not (string.match content source-line))
        (bashrc:write source-line)))))

(fn prepare-firefox-profile [workspace-name]
  (let [config-path (.. (os.getenv "HOME") "/.config/firefox")
        profile-path (.. (os.getenv "HOME") "/.mozilla/firefox/" workspace-name)]
    (ext.shellout (.. "firefox -CreateProfile \"" workspace-name " " profile-path "\""))))
;    (ext.shellout (.. "ln -f -s " config-path "/* " profile-path))))

(fn spawn-workspace-daemons [workspace-name]
  (prepare-firefox-profile workspace-name)
  (when (not (= workspace-name :default))
    (do
      (ext.shellout (.. "emacs --daemon=" workspace-name)))))

(fn generate-bash-aliases [workspace-name]
  (let [filepath (.. (os.getenv "HOME") "/.cache/awesome" "/wsenv")
        lines (if (= workspace-name :default)
                  [(.. "alias emacsclient='emacsclient -c'")
                   (.. "alias e='emacsclient'")
                   (.. "alias firefox='firefox -new-instance -P " workspace-name "'")]
                  [(.. "alias emacsclient='emacsclient -c -s " workspace-name "'")
                   (.. "alias e='emacsclient'")
                   (.. "alias firefox='firefox -new-instance -P " workspace-name "'")]
                  )]
    (with-open [outfile (io.open filepath :w)]
      (outfile:write
       (table.concat lines "\n")))))

(awesome.connect_signal
 "startup"
 (fn []
   (async
    (inject-bash-workspace-env))))

(awesome.connect_signal
 "workspaces::applied"
 (fn [workspace-name]
   (async
    (doto workspace-name
      (spawn-workspace-daemons)
      (generate-bash-aliases)))))
