(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local lume (require "vendor.lume"))

(local tags {})

(lambda tags.view-next [scr?]
  "Unmap current tag and map next tag, creating a new tag if none exists"
  (let [s (or scr? (awful.screen.focused))
        ct (. (awful.screen.focused) :selected_tag)
        nt (lume.filter s.tags (fn [t] (= t.index (+ 1 ct.index))))]
    (when (= (# nt) 0)
      (awful.tag.add "▪" {:screen s
                          :layout ct.layout
                          :gap beautiful.useless_gap
                          :volatile true}))
    (when (= (# (: ct :clients)) 0)
      (: ct :delete))
    (awful.tag.viewnext s)))

(lambda tags.view-prev [scr?]
  "Unmap current tag and map previous tag. When on first tag, cyle to last"
  (let [s (or scr? (awful.screen.focused))
        ct (. (awful.screen.focused) :selected_tag)]
    (when (= (# (: ct :clients)) 0)
      (: ct :delete))
    (awful.tag.viewprev s)))

(fn tags.get-or-create
  [scr tag-prop]
  (let [{:pos pos :workspace workspace} tag-prop
        tag-by-props (lume.filter scr.tags (fn [t]
                                             (and
                                              (= t.pos pos)
                                              (= t.workspace workspace))))]
    (if (= (# tag-by-props) 0)
        (awful.tag.add pos {:layout (. awful.layout.layouts 1)
                            :screen scr
                            :pos pos
                            :workspace workspace })
        (. tag-by-props 1))))

(fn tags.get-by-prop
  [key value ?invert]
  (lume.filter (root.tags) (fn [t] (if ?invert
                                       (~= (. t key) value))
                             (= (. t key) value))))

tags
