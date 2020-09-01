(fn async [...]
  "Transform inclosed expressions into a self-executing coroutine."
  `((coroutine.wrap (fn [] ,...))))

(fn await [func]
  "Transform function FUNC with last arg as a callback into a coroutine.
Yield the current coroutine, which will get resumed when FUNC returns.
Must be called within a coroutine."
  `(fn [...]
     (when (not= (type ,func) "function")
       (error (.. "await: Expected function, got " (type ,func))))
     (var co# nil)
     (let [len# (+ (select "#" ...) 1) ;; callback is left nil, so length++
           arg# [...]
           tv# (type (. arg# len#))]
       (when (not= tv# (type nil))
         (error (.. "await: Last arg (callback) should be nil, but got " tv#)))
       (tset arg# len# (fn [...]
                         (if (= co# nil)
                             (set co# [...])
                             (coroutine.resume co# ...))))
       (,func (table.unpack arg# 1 len#))
       (if (= co# nil)
           (do
             (set co# (coroutine.running))
             (coroutine.yield))
           (table.unpack co#)))))

{:async async
 :await await}
