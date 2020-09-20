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

(fn m.init-matrix [n m ?v]
  "Return an initialized N-by-M matrix where each element is ?V.
Default initialization value is 0."
  (var matrix [])
  (let [v (if ?v ?v 0)]
    (for [i 0 n 1]
      (tset matrix i [])
      (tset (. matrix i) v i))
    (for [j 0 m 1]
      (tset (. matrix v) j j))
    matrix))

(fn m.levenshtein [str-a str-b]
  "Calculate the levenshtein distance between STR-A and STR-B"
  (let [len-a (string.len str-a)
        len-b (string.len str-b)]
    (var matrix (m.init-matrix len-a len-b))

    (for [i 1 len-a 1]
      (for [j 1 len-b 1]
        (let [sub-cost (if (= (str-a:byte i) (str-b:byte j)) 0 2)
              del-dist (+ (. (. matrix (- i 1)) j) 1); deletion
              ins-dist (+ (. (. matrix i) (- j 1)) 1); insertion
              sub-dist (+ (. (. matrix (- i 1)) (- j 1)) sub-cost)]; substitution
          (tset (. matrix i) j (math.min del-dist ins-dist sub-dist)))))

    (. (. matrix len-a) len-b)))

(fn m.min-edit-distance [str-a str-b ?algorithm]
  "Find minimum edit distance of STR-A and STR-B via provided ?ALGORITHM.
If no algorithm is provided, defaults to levenshtein distance."
  (let [len-a (string.len str-a)
        len-b (string.len str-b)
        algorithm (or ?algorithm m.levenshtein)]

    ;; short-circuit to save time
    (if (= len-a 0)
        len-a

        (= len-b 0)
        len-b

        (= str-a str-b)
        0

        (algorithm str-a str-b))))

m
