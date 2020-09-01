(local awful (require "awful"))
(local json (require "vendor.json"))
(local oleander (require "utils.oleander"))

(local icon-loader {})

(set icon-loader.cachedir (.. (awful.util.get_cache_dir) "/icons/"))
(tset icon-loader :initialized false)

(lambda loader [module name ?options]
    (let [iconpkg (require (.. "icons." module))
          icon-fn (. iconpkg name)
          opts (or ?options {})
          opt-hash (oleander.bsd-checksum (json.encode opts))
          filename (.. module "-" name "-" opt-hash ".svg")
          filepath (.. icon-loader.cachedir filename)
          exists (io.open filepath :r)]
      (if (= exists nil)
          (with-open [outfile (io.open filepath :w)]
            (outfile:write (icon-fn opts)))
          (exists:close))
      filepath))

(lambda icon-loader.load [module name ?options]
  (when (not icon-loader.initialized)
    (awful.spawn.with_shell (.. "mkdir " icon-loader.cachedir " || true"))
    (tset icon-loader :initialized true))
  (loader module name ?options))

(fn icon-loader.clear-cache []
  (awful.spawn.with_shell (.. "rm " icon-loader.cachedir "*.svg")
                          true
                          (fn [] (tset icon-loader :initialized false))))

icon-loader
