(local awful (require "awful"))
(local gears (require "gears"))
(local lume (require "vendor.lume"))

(local interval 3)
(local cpu-script
       "bash -c 'vmstat 1 2 | tail -1 | tr -s [:blank:] | cut -d \" \" -f16'")

(lambda get-cpu [callback]
  (awful.spawn.easy_async cpu-script
                          (fn [res]
                            (let [sanitized (lume.trim res)
                                  cpu-idle (tonumber sanitized)
                                  cpu-used (- 100 (or cpu-idle 0))]
                              (callback cpu-used)))))

(fn emit []
  (get-cpu (fn [usage] (awesome.emit_signal "cpu::usage" usage))))

(lambda listen [callback]
  (gears.timer {:autostart true
                :call_now true
                :timeout interval
                :callback callback}))

(listen emit)
