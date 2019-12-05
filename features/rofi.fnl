;; Functions for interacting with Rofi
;; https://github.com/davatorium/rofi
(local awful (require "awful"))
(local deferred (require "vendor.deferred"))
(local aio (require "utils.aio"))

(local rofi {})

(fn rofi.prompt
  [prompt input]
  (let [cmd (string.format "printf '%s' | rofi -dmenu -p '%s'" input prompt)]
    (aio.shellout cmd)))

(fn rofi.hist-prompt
  [prompt histfile]
  (let [cachedir (awful.util.get_cache_dir)]
    (var hist "")
    (var result nil)
    (-> (aio.read-file cachedir histfile)
        (: :next (fn [vals]
                   (set hist vals)
                   (: (deferred.new) :resolve vals)))
        (: :next (fn [v] (aio.reverse-lines v)))
        (: :next (fn [items] (rofi.prompt prompt items)))
        (: :next (fn [res]
                   (set result res)
                   (aio.kill-line cachedir histfile res)))
        (: :next (fn [_] (aio.append-file cachedir histfile result)))
        (: :next
           (fn [_] (: (deferred.new) :resolve result))
           (fn [err] (error err))))))

rofi
