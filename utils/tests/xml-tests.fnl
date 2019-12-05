(notify (xml.create-element :span))
(notify (xml.create-element :spann {}))
(notify (xml.create-element :b {:howdy true}))
(notify (xml.create-element :span {:text :big} "Howdy &"))
(notify (xml.create-element :span {:text :big} [:span {} "Howdy &"]))
(notify (xml.create-element :span {:text :big}
                            [[:div {} "l. 1"]
                             [:span {} [:div {} "l. 2"]]
                             [:span {} [[:div {} "l. 3a"]
                                        [:span {} "l. 3b"]]]]))
(notify (xml.create-elements [:span {:text :big} [:span {} "Howdy &"]]))
(notify (xml.create-elements [:span {:text :big} [[:span {} "Howdy &"] [:span {} "Howdy &"]]]))
(notify (xml.create-elements [:span {:text :big} [:span {} "Howdy &"]]
                             [:span {:text :big} [:span {} "Pardner &"]]))
