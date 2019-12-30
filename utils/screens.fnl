(global screen-utils {})

(fn screen-utils.screen-iter []
  "Return an iterator for enumerating the currently attached screens"
  (var i 0)
  (var n (: screen :count))
  (fn []
    (set i (+ i 1))
    (when (<= i n)
      (. screen i))))

screen-utils
