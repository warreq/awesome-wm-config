(local t (require "vendor.lunatest"))
(local pp (require "fennelview"))
(local icon-loader (require "icons.loader"))
(local tabler-icons (require "icons.tabler"))

(local m {})

(fn m.test-can-load-icon []
  (let [tabler-grid (icon-loader.load :tabler :grid {:viewBox "0 0 24 24"})]
    ; can we load an icon without getting exceptions?
    (t.assert_equal 1 1)))

m
