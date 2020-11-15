(local pp (require "fennelview"))
(local lume (require "vendor.lume"))
(local {: concat : range : fill } (require "utils.oleander"))
(local m {})

(fn m.init-seller-matrix [n m]
  "Return an initialized N-by-M matrix for doing Seller's algorithm."
  (var matrix [])
  (for [i 1 n]
    (tset matrix i (fill 1 m 0))
    (tset (. matrix i) 1 (- i 1)))
  matrix)

(fn m.matrix-pp [matrix]
  "Print MATRIX out in rows and cols typical for displaying edit distance calcs"
  (for [i 1 (length matrix)]
    (for [j 1 (length (. matrix 1))]
      (io.write (. (. matrix i) j) " "))
    (io.write "\n")))

(fn m.levenshtein-dist [str-a str-b matrix i j]
  "Core levenshtein distance function.
Write the cost at position (I,J) in the given MATRIX for STR-A and STR-B"
  (let [sub-cost (if (= (str-a:byte (- i 1)) (str-b:byte (- j 1))) 0 1)
        del-dist (+ (. (. matrix (- i 1)) j) 1); deletion
        ins-dist (+ (. (. matrix i) (- j 1)) 1); insertion
        sub-dist (+ (. (. matrix (- i 1)) (- j 1)) sub-cost)
        dist (math.min del-dist ins-dist sub-dist)]; substitution
    (tset (. matrix i) j dist))
  matrix)

(fn m.levenshtein-col [str-a str-b matrix j]
  "Calculate the levenshtein distance between STR-A and STR-B on column J"
  (let [len-a (string.len str-a)]
    (for [i 2 (+ 1 len-a) 1]
      (m.levenshtein-dist str-a str-b matrix i j))
    matrix))

(lambda m.trie-insert [trie text item]
  (var walker trie)
  (for [i 1 (length text)]
    (let [c (text:sub i i)]
      (when (not (. walker.children c))
        (tset walker.children c {:children {} :candidates [] :depth 0}))
      (set walker.depth (math.max walker.depth (- (length text) (- i 1))))
      (set walker (. walker.children c))))
  (table.insert walker.candidates item))

(lambda m.init-search-trie [items ?trie]
  (var t (or ?trie {:candidates [] :children {} :depth 0}))
  (each [i c (ipairs items)]
    (m.trie-insert t c {:index i :value c}))
  t)

(fn m.compare-results [a b]
  "Compare A to B and return a numeric score.
If negative, A is better. If positive, B is better."
  (let [non-zero (fn [a] (~= a 0))]
    (if (non-zero (- b.score a.score)) ; score-diff
        (- b.score a.score)
        (non-zero (- a.hit.start b.hit.start)) ; earlier-match
        (- a.hit.start b.hit.start)
        (non-zero (- a.length-diff b.length-diff)) ; closer-length
        (- a.length-diff b.length-diff)
        (- a.index b.index)))) ; if nothing else, earlier insertion order wins

(fn m.result-comparator [a b]
  "Compare A to B and return a boolean value.
If true, A is better. If false, B is better."
  (> 0 (m.compare-results a b)))

(fn m.add-result [results result-map candidate score hit len]
  "Add CANDIDATE with SCORE, HIT and LEN to RESULTS and RESULT-MAP in a
normalized way."
  (local item {:value candidate.value
               :score score
               :hit hit
               :length-diff len
               :index candidate.index})
  (if (= nil (. result-map candidate.index))
      (do
        (tset result-map candidate.index (length results))
        (table.insert results item))
      (< (m.compare-results item (. results (. result-map candidate.index))) 0)
      (tset results (. result-map candidate.index) item)))

(fn m.should-continue [node term opts score-value end-value]
  (let [best-potential (math.min score-value (- end-value (+ 1 node.depth)))]
    (>= (- 1 (/ best-potential (length term))) opts.threshold)))

(fn m.back-track [matrix score-idx]
  "Walk back up MATRIX, returning the hit start and end from SCORE-IDX"
  (if (= 0 score-idx)
      {:start 0 :end 0}
      (do
        (var start score-idx)
        (for [i (- (length matrix) 2) 1 -1]
          (let [row (. matrix i)]
            (when (> start 1)
              (when (>= (. row start) (. row (- start 1)))
                (set start (- start 1))))))
        {:start (if (= start 1) 2 (- start 1))
         :end (- score-idx 1)})))

(fn m.search-recursively [trie term matrix results result-map opts]
  (var stack [])
  (each [c child (pairs trie.children)]
    (table.insert stack [child 2 c 0 (length term)]))

  (var acc [])
  (while (> (length stack) 0)
    (do
      (var [node len char start-idx start-value] (table.remove stack))
      (tset acc (- len 1) char)
      (while (> (length acc) (- len 1))
        (table.remove acc))

      (m.levenshtein-col term (table.concat acc) matrix len)

      ;; update best score and position
      (local end-idx len)
      (local end-value (-> matrix (. (length matrix) (. end-idx))))
      (var [score-idx score-value] [start-idx start-value])
      (when (< end-value start-value)
        (do
          (set score-idx end-idx)
          (set score-value end-value)))

      ;; populate result
      (when (> (length node.candidates) 0)
        (do
          (let [l (length term)
                score (- 1.0 (/ score-value l))]
            (when (>= score opts.threshold)
              (do
                (let [hit (m.back-track matrix score-idx)
                      ldiff (math.abs (- len (length term)))]
                  (each [_ cand (pairs node.candidates)]
                    (m.add-result results result-map cand score hit ldiff))))))))

      ;; push children onto stack to keep iterating
      (each [c child (pairs node.children)]
        (when (m.should-continue child term opts score-value end-value)
          (let [frame [child (+ 1 len) c score-idx score-value]]
            (table.insert stack frame)))))))

(lambda m.search [items term ?opts ?trie]
  "Fuzzy-search ITEMS for TERM with given options ?OPTS.
Returns a table with keys:
:results -- sequential table of items with keys:
    :hit   -- {:start :end} indices for matching portion of string
    :value -- provided text from ITEMS string table
    :index -- results's index in ITEMS table
    :score -- value from 0..1 scoring how close the result matches TERM
:trie -- the prefix-tree generated for performing the search

Possible ?OPTS:
    :threshold -- score (0..1) below which we discard results

If calling multiple times with same ITEMS, cache :trie and pass it as ?TRIE to
avoid recalculating the entire prefix-tree."
  (let [trie (or ?trie (m.init-search-trie items))
        defaults {:threshold .6}
        rows (+ (length term) 1)
        cols (+ trie.depth 1)
        matrix (m.init-seller-matrix rows cols)
        opts (concat defaults (or ?opts {}))]
    (var results [])
    (var result-map {})
    (when (or (>= opts.threshold 0)
              (= (length term) 0))
      (each [i cand (pairs trie.candidates)]
        (m.add-result
         results
         result-map
         cand
         0
         {:start 1 :end (length cand)}
         (length term))))

    (m.search-recursively trie term matrix results result-map opts)

    {:trie trie
     :results (lume.sort results m.result-comparator)}))

m
