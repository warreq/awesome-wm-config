(local awful (require "awful"))
(local gears (require "gears"))
(local lume (require "vendor.lume"))
(local output (require "utils.output"))

(local interval 15)
(local ram-script
       "bash -c \"free | grep Mem | awk '{print $3/$2 * 100.0}'\"")

(lambda get-ram-usage [callback]
  (awful.spawn.easy_async ram-script
                          (fn [res]
                            (let [ram-used (tonumber res)]
                              (callback ram-used)))))

(fn emit []
  (get-ram-usage (fn [usage] (awesome.emit_signal "ram::usage" usage))))

(lambda listen [callback]
  (gears.timer {:autostart true
                :call_now true
                :timeout interval
                :callback callback}))

(listen emit)
