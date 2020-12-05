(local workspaces (require :features.workspaces))
(local { : notify : ext } (require :api.lawful))
(import-macros {: async : await} :utils.async)

(fn inject-bash-workspace-env []
  (with-open [bashrc (io.open (.. (os.getenv "HOME") "/.bashrc") :a+)]
    (let [source-line "source ~/.cache/awesome/wsenv"
          content (bashrc:read "*all")]
      (when (not (string.match content source-line))
        (bashrc:write source-line)))))

(fn spawn-workspace-daemons [workspace-name]
  (when (not (= workspace-name :default))
    (do
      (ext.shellout (.. "firefox -CreateProfile " workspace-name))
      (ext.shellout (.. "emacs --daemon=" workspace-name)))))

(fn generate-bash-aliases [workspace-name]
  (let [filepath (.. (os.getenv "HOME") "/.cache/awesome" "/wsenv")
        lines (if (= workspace-name :default)
                  [(.. "alias e='emacsclient -c'")
                   (.. "alias ff='firefox'")]
                  [(.. "alias e='emacsclient -c -s " workspace-name "'")
                   (.. "alias ff='firefox -new-instance -P " workspace-name "'")]
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
