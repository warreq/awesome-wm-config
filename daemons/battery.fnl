;; Provides signals --
;;   battery::capacity
;;   battery::status
;; Requires --
;;   upower

(local awful (require "awful"))
(local lume (require "vendor.lume"))
(local output (require "utils.output"))

(local listen-script "bash -c 'upower --monitor'")
(local capacity-script "bash -c 'cat /sys/class/power_supply/BAT*/capacity'")
(local status-script "upower -i '/org/freedesktop/UPower/devices/battery_BAT0'")

(lambda average-capacity [line-output]
  "Take a string of new-line delimited numbers and average them"
  (var t {})
  (each [l (: line-output :gmatch "([^\n]*)\n?")]
    (table.insert t (tonumber l)))
  (let [sum (lume.reduce t (fn [a b] (+ a b)))]
    (/ sum (# t))))

(lambda get-field [str key]
  (lume.trim (or (: str :match (.. key "(.-)\n")) "")))

(lambda get-capacity [callback]
  "Asynchronously get the averaged capacity of all connected batteries"
  (awful.spawn.easy_async capacity-script
                          (fn [out]
                            (let [capacity (average-capacity out)]
                              (callback capacity)))))

(lambda get-status [callback]
  "Asynchronously get the status of the first connected battery. 
Returns map with keys :time-to-empty, :state, :time-to-full"
(awful.spawn.easy_async status-script
                          (fn [out]
                            (let [state (get-field out "state:")
                                  toe (get-field out "time to empty:")
                                  tof (get-field out "time to full:")]
                              (callback {:state state
                                         :time-to-empty toe
                                         :time-to-full tof})))))

(fn emit []
  (get-capacity (fn [cap] (awesome.emit_signal "battery::percentage" cap)
  (get-status (fn [stats] (awesome.emit_signal "battery::status" stats))))))

(lambda listen [callback]
  (awful.spawn.with_line_callback listen-script {
                                                 :stdout callback
                                                 :stderr (fn [err] (output.notify err))
                                                 }))
  
(listen emit)
