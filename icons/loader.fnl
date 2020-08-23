(local awful (require "awful"))
(local json (require "vendor.json"))
(local oleander (require "utils.oleander"))

(local icon-loader {})

(lambda icon-loader.load [module name ?options]
  (let [iconpkg (require (.. "icons." module))
        icon-fn (. iconpkg name)
        opts (or ?options {})
        opt-hash (oleander.bsd-checksum (json.encode opts))
        filename (.. module "-" name "-" opt-hash ".svg")
        filepath (.. (awful.util.get_cache_dir) "/" filename)
        exists (io.open filepath :r)]
    (if (= exists nil)
        (with-open [outfile (io.open filepath :w)]
          (outfile:write (icon-fn opts)))
        (exists:close))
    filepath))

icon-loader
