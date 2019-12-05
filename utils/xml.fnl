(local lume (require "vendor.lume"))

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
  [tag ?attrs ?content]
  "Render TAG with attributes ?ATTRS and ?CONTENT as children."
  (.. "<" tag (xml.render-attrs ?attrs) ">"
      (match (type ?content)
        "table" (let [ftv (type (. ?content 1))]
                  (match ftv
                    "string" (let [[t a c] ?content] (xml.create-element t a c))
                    "table"  (-> ?content
                                 (lume.map (fn [tbl]
                                             (let [[t a c] tbl]
                                               (xml.create-element t a c))))
                                 (lume.reduce (fn [a b] (.. a b)) ""))
                    nil      ""
                    _        (error (.. "Found " ftv ", expected string or table"))))
        _       (or ?content ""))
      "</" tag ">"))

(fn xml.create-elements [...]
  "Render any number of XML elements using `xml.create-element`."
  (-> [...]
      (lume.map (fn [tbl]
                  (let [[t a c] tbl]
                    (xml.create-element t a c))))
      (lume.reduce (fn [a b] (.. a b)) "")))

xml
