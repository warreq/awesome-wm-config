(local json (require "vendor.json"))
(local oleander (require "utils.oleander"))
(local {: notify : ext : fs } (require :api.lawful))

(local icon-loader {})

(set icon-loader.cachedir (fs.icon-dir))
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
    (ext.shellout (.. "mkdir " icon-loader.cachedir " || true"))
    (tset icon-loader :initialized true))
  (loader module name ?options))

(fn icon-loader.clear-cache []
  (ext.shellout (.. "rm " icon-loader.cachedir "*.svg"))
  (tset icon-loader :initialized false))

icon-loader
