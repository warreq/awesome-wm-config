(local t (require "vendor.lunatest"))
(local pp (require "fennelview"))
(local hotfuzz (require "utils.hotfuzz"))
(local lume (require "vendor.lume"))

(local m {})

(fn m.test-seller-matrix []
  (let [result-matrix (hotfuzz.init-seller-matrix 3 3)
        expected-matrix [[0 0 0] [1 0 0] [2 0 0]]]
    (t.assert_equal (pp expected-matrix) (pp result-matrix))))

(fn m.test-core-levenshtein []
  (let [expect [[[0 0 0 0 0 0 0 0] [1 1 1 1 1 1 1 1] [2 2 1 2 2 1 2 2] [3 3 2 1 2 2 2 3] [4 4 3 2 1 2 3 3] [5 5 4 3 2 2 3 4] [6 6 5 4 3 3 2 3]]]
        inputs [["kitten" "sitting"]]]
    (each [i p (ipairs inputs)]
      (let [[term cand] p]
        (var mat (hotfuzz.init-seller-matrix (+ 1 (length term)) (+ 1 (length cand))))
        (for [n 2 (+ 1 (length term))]
          (for [m 2 (+ 1 (length cand))]
            (hotfuzz.levenshtein-dist term cand mat n m)))
        (t.assert_equal (pp (. expect i)) (pp mat))))))

(fn m.test-init-search-trie []
  (let [trie (hotfuzz.init-search-trie ["ha" "hat" "cat"])
        expected {:candidates {} :children {:c {:candidates {} :children {:a {:candidates {} :children {:t {:candidates [{:index 3 :value "cat"}] :children {} :depth 0}} :depth 1}} :depth 2} :h {:candidates {} :children {:a {:candidates [{:index 1 :value "ha"}] :children {:t {:candidates [{:index 2 :value "hat"}] :children {} :depth 0}} :depth 1}} :depth 2}} :depth 3}]
    (t.assert_equal (pp expected) (pp trie))))

(fn m.test-compare-results []
  (let [perfect {:score 1 :hit {:start 0} :length-diff 0 :index 0}
        good-score {:score .9  :hit {:start 3} :length-diff 3 :index 1}
        good-hit {:score .6 :hit {:start 0} :length-diff 3 :index 2}
        good-len {:score .6 :hit {:start 3} :length-diff 0 :index 3}
        awful {:score .6 :hit {:start 3} :length-diff 3 :index 4}
        even-worse {:score .6 :hit {:start 3} :length-diff 3 :index 5}]
    (t.assert_lt 0 (hotfuzz.compare-results perfect good-score) "perfect match")
    (t.assert_gt 0 (hotfuzz.compare-results good-score perfect) "can't beat perfect")
    (t.assert_lt 0 (hotfuzz.compare-results good-score good-hit) "score > hit")
    (t.assert_lt 0 (hotfuzz.compare-results good-hit good-len) "hit > length")
    (t.assert_lt 0 (hotfuzz.compare-results good-len awful) "length > nothing")
    (t.assert_lt 0 (hotfuzz.compare-results awful even-worse) "index final deciding factor")))

(fn m.test-add-result []
  (let [candidate {:value "cat" :index 1}
        hit {:start 0}
        score 1
        len 2
        expected {:hit hit :length-diff len :score score :value candidate.value :index candidate.index}]
    (var results [])
    (var result-map {})
    (hotfuzz.add-result results result-map candidate score hit len)
    (t.assert_equal 1 (length results))
    (t.assert_equal 1 (length result-map))
    (t.assert_equal (pp [expected]) (pp results))))

(fn m.test-search-order []
  "search should return values in expected order (perfect match first)"
  (let [search-candidates ["rat" "matt" "cat" "catepillar" "bobcat"]
        search-results (. (hotfuzz.search search-candidates "cat") :results)
        expected-order ["cat" "catepillar" "bobcat" "rat" "matt"]
        resulting-order (lume.map search-results (fn [x] x.value))]
    (t.assert_equal (pp expected-order) (pp resulting-order))))

(fn m.test-search-threshold []
  "candidate `space` should be excluded from results for scoring too low"
  (let [search-candidates ["moon" "moonman" "moonpie" "space"]
        search-results (hotfuzz.search search-candidates "moo")]
    (t.assert_equal 3 (length search-results.results))))

(fn m.test-search-hit []
  "result should return a hit that gives offset and length of the match"
  (let [search-candidates ["witch's broom" "moon-witch"]
        results (. (hotfuzz.search search-candidates "witch") :results)
        broom-hit (-> results (lume.filter (fn [x] (= x.value "witch's broom"))) (lume.first))
        moon-hit (-> results (lume.filter (fn [x] (= x.value "moon-witch"))) (lume.first))]
    (t.assert_equal "witch" (string.sub "moon-witch" moon-hit.hit.start moon-hit.hit.end))
    (t.assert_equal "witch" (string.sub "witch's broom" broom-hit.hit.start broom-hit.hit.end))))

(fn m.test-search-hit-single-char []
  "result should return a hit that gives offset and length of the match, no off-by-one errors"
  (let [search-candidates ["awesome" "something" "default" "set" "ime" "ton"]
        results (. (hotfuzz.search search-candidates "some" {:threshold 0.0}) :results)
        awesome-hit (-> results (lume.filter (fn [x] (= x.value "awesome"))) (lume.first))
        set-hit (-> results (lume.filter (fn [x] (= x.value "set"))) (lume.first))
        ime-hit (-> results (lume.filter (fn [x] (= x.value "ime"))) (lume.first))
        ton-hit (-> results (lume.filter (fn [x] (= x.value "ton"))) (lume.first))
        something-hit (-> results (lume.filter (fn [x] (= x.value "something"))) (lume.first))
        default-hit (-> results (lume.filter (fn [x] (= x.value "default"))) (lume.first))]
    (t.assert_equal "some" (string.sub "something" something-hit.hit.start something-hit.hit.end))
    (t.assert_equal "some" (string.sub "awesome" awesome-hit.hit.start awesome-hit.hit.end))
    (t.assert_equal "me" (string.sub "ime" ime-hit.hit.start ime-hit.hit.end))
    (t.assert_equal "e" (string.sub "set" set-hit.hit.start set-hit.hit.end))
    (t.assert_equal "o" (string.sub "ton" ton-hit.hit.start ton-hit.hit.end))
    (t.assert_equal "e" (string.sub "default" default-hit.hit.start default-hit.hit.end))))

m
