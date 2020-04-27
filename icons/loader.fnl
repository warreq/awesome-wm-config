(local awful (require "awful"))

(local icon-loader {})

(lambda icon-loader.load [module name ?options]
  (let [iconpkg (require (.. "icons." module))
        icon-fn (. iconpkg name)
        opts (or ?options {})
        svg-content (icon-fn opts)
        filename (.. module "-" name "-" (os.time) ".svg")
        filepath (.. (awful.util.get_cache_dir) "/" filename)
        file (io.open filepath "w")]
    (: file :write svg-content)
    (: file :close)
    filepath))

icon-loader
