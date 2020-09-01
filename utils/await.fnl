(fn await [func]
  (fn [...]
    (var co nil)
    (local arg [...])
    (local len (+ (select "#" ...) 1))
    (tset arg len (fn [...]
                    (if (= co nil)
                        (set co [...])
                        (coroutine.resume co ...))))
    (func (table.unpack arg 1 len))
    (if (= co nil)
        (do
          (set co (coroutine.running))
          (coroutine.yield))
        (table.unpack co))))



await
