;; Oleander is a dumping bed for various algorithms, functions and other little
;; flowers too precious to leave strewn about this garden.

(local m {})

(fn m.require? [...]
  "Optionally require a module, returning nil if it could not be resolved."
  (let [(ok mod) (pcall require ...)]
    (if ok mod nil)))

(lambda m.range
  [start end ?step]
  "Create a sequential table from START to END, with a stride of ?STEP or 1"
  (local s (if (= ?step nil) 1 ?step)) 
  (var seq [])
  (for [i start end s]
    (table.insert seq i))
  seq)

(lambda m.fill
  [start end value]
  "Create a table with keys from START to END where each value is VALUE"
  (var seq [])
  (for [i start end]
    (table.insert seq i value))
  seq)

;; try to 'polyfill' the best available bitwise operators
(local bit (m.require? "bitop"))
(local blshift (when bit bit.lshift))
(local brshift (when bit bit.rshift))
(local llshift (when (>= _G._VERSION "Lua 5.3") _G.lshift))
(local lrshift (when (>= _G._VERSION "Lua 5.3") _G.rshift))

(fn shim-lshift [n bits]
  (* (math.floor n) (^ 2 bits)))

(fn shim-rshift [n bits]
  (math.floor (/ (math.floor n) (^ 2 bits))))

(set m.lshift (or llshift blshift shim-lshift))
(set m.rshift (or lrshift brshift shim-rshift))

(fn m.bsd-checksum
  [str]
  "Simple checksum. Returns a 32-bit numeric hash of input STR."
  (var sum 0)
  (let [bytes [(string.byte str 1 -1)]]
    (each [_ value (ipairs bytes)]
      (set sum (+ (m.rshift sum 1) (m.lshift sum 31)))
      (set sum (+ sum value))
      (set sum (% sum 2147483647))) ; clamp to expected range
    sum))

(fn m.concat [...]
  "Concatenate all tables into a new table."
  (let [ret []]
    (for [i 1 (select "#" ...) 1]
      (local t (select i ...))
      (let [tv (type t)]
        (if (= tv :table)
            (do
              (each [k v (pairs t)]
                (if (= (type k) "number")
                    (table.insert ret v)
                    (tset ret k v))))
            (error (.. "Expected table, got " tv)))))
    ret))

m
