(local {: map : reduce} (require :vendor.lume))
(local unpack (or table.unpack _G.unpack))

;; hiccup-inspired library for creating XML from Fennel tables 
(local xml {})

(fn xml.escape
  [str]
  "Substitute XML special characters with their escape sequences."
  (-> (or str "")
      (string.gsub "&" "&amp;")
      (string.gsub "<" "&lt;")
      (string.gsub ">" "&gt;")
      (string.gsub "\"" "&quot;")))

(fn xml.format-attr
  [key value]
  "Transform key-value pair into pair of attribute-value strings."
  (match value
    true [key "true"]
    false [key "false"]
    nil nil
    _ [key (xml.escape value)]))

(fn xml.render-attrs
  [attrs]
  "Turn a map into a string of XML attributes."
  (var str "")
  (when attrs
    (each [attr value (pairs attrs)]
      (let [[k v] (xml.format-attr attr value)]
        (when k
          (set str (.. str " " k "=\"" v "\""))))))
  str)

(lambda xml.create-element
  [tag ?attrs ...]
  "Render TAG with attributes ?ATTRS and restargs as children."
  (..
   "<" tag (xml.render-attrs ?attrs) ">"
   (-> (if (= ... nil) [""] [...])
       (map
        (fn [v]
          (match (type v)
            "table" (let [ftv (type (. v 1))]
                      (match ftv
                        "string" (let [[t a c] v] (xml.create-element t a c))
                        "table"  (-> v
                                     (map (fn [tbl]
                                            (let [[t a c] tbl]
                                              (xml.create-element t a c))))
                                     (reduce (fn [a b] (.. a b)) ""))
                        nil      ""
                        _        (error
                                  (..
                                   "Found " ftv ", expected string or table"))))
            _       (or v ""))))
       (reduce (fn [a b] (.. a b))))
   "</" tag ">"))

xml
