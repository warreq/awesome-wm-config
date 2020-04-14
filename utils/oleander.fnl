;; A module of common FP functions

(local m {})

(lambda m.range
  [start end ?step]
  "Create a sequential table from START to END, with a stride of ?STEP or 1"
  (local s (if (= ?step nil) 1 ?step)) 
  (var seq [])
  (for [i start end s]
    (table.insert seq i))
  seq)

m
