(local awm-macs {})

(fn awm-macs./< [...]
  (let [tbl {}]
    (var skip 0)
    (each [i v (ipairs [...])]
      (when (~= i skip)
        (let [tv (type v)]
          (match tv
                 "string" (do
                            (set skip (+ i 1))
                            (tset tbl v (. [...] skip)))
                 "table"  (table.insert tbl v)
                 _        (error (.. tv " key literal in mixed table"))))))
    tbl))

awm-macs
