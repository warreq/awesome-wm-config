(local t (require "vendor.lunatest"))
(local pp (require "fennelview"))
(local xml (require "utils.xml"))
(local lume (require "vendor.lume"))

(local m {})

(fn m.test-create-empty-element []
  (let [result (xml.create-element :span)]
    (t.assert_equal "<span></span>" result)))

(fn m.test-create-simple-element []
  (let [result (xml.create-element :span {} "hello world")]
    (t.assert_equal "<span>hello world</span>" result)))

(fn m.test-create-multiple-child-element []
  (let [result (xml.create-element :span {} "rain" "bow")]
    (t.assert_equal "<span>rainbow</span>" result)))

(fn m.test-create-element-with-attributes []
  (let [result (xml.create-element :span {:foreground :red} "hello world")]
    (t.assert_equal "<span foreground=\"red\">hello world</span>" result)))

(fn m.test-create-nested-element []
  (let [result (xml.create-element
                :span {:text :big}
                [[:div {} "l. 1"]
                 [:span {} [:div {} "l. 2"]]
                 [:span {} [[:div {} "l. 3a"]
                            [:span {} "l. 3b"]]]])]
    (t.assert_equal
     "<span text=\"big\"><div>l. 1</div><span><div>l. 2</div></span><span><div>l. 3a</div><span>l. 3b</span></span></span>"
     result)))

m
