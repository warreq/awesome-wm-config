(local screen-utils {})

(fn screen-utils.screen-iter []
  "Return an iterator for enumerating the currently attached screens"
  (var i 0)
  (var n (: screen :count))
  (fn []
    (set i (+ i 1))
    (when (<= i n)
      (. screen i))))

(fn screen-utils.get-screens []
  "Return an array containing all current screens"
  (var ss [])
  (each [s (screen-utils.screen-iter)]
    (table.insert ss s))
  ss)

screen-utils
