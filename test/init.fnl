(local t (require "vendor.lunatest"))

(t.suite :test.hotfuzz)
(t.suite :test.xml)

(t.run)
