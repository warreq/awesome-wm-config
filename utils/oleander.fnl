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

(fn m.bsd-checksum
  [str]
  "Simple checksum. Returns a 32-bit numeric hash of input STR"
  (var sum 0)
  (let [bytes [(string.byte str 1 -1)]]
    (each [_ value (ipairs bytes)]
      (set sum (+ (rshift sum 1) (lshift sum 31)))
      (set sum (+ sum value))
      (set sum (% sum 2147483647))) ; clamp to expected range
    sum))

m
