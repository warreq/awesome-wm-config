(local awful (require "awful"))
(local pa (require "utils.pulseaudio"))
(local {: notify } (require :api.lawful))

(fn get-volume [?callback]
  (let [cb (or ?callback (fn [] nil))]
    (awful.spawn.easy_async_with_shell pa.get-volume-script cb)))

(fn get-muted [?callback]
  (let [cb (or ?callback (fn [] nil))]
    (awful.spawn.easy_async_with_shell pa.get-muted-script cb)))

(fn get-mic-muted [?callback]
  (let [cb (or ?callback (fn [] nil))]
    (awful.spawn.easy_async_with_shell pa.get-mic-muted-script cb)))

(fn emit-output-data []
  (get-volume (fn [vol]
                (awesome.emit_signal
                 "pulseaudio::output::volume"
                 (tonumber vol))))
  (get-muted (fn [muted?]
               (awesome.emit_signal
                "pulseaudio::output::muted"
                (if (string.find muted? "no") false true)))))

(fn emit-input-data []
  (get-mic-muted (fn [muted?]
               (awesome.emit_signal
                "pulseaudio::input::muted"
                (if (string.find muted? "no") false true)))))

(lambda listen-volume [callback]
  (awful.spawn.with_line_callback pa.volume-listener-script
                                  {
                                   :stdout callback
                                   :stderr (fn [err] (notify.error err))
                                   }))

(lambda listen-mic [callback]
  (awful.spawn.with_line_callback pa.mic-listener-script
                                  {
                                   :stdout callback
                                   :stderr (fn [err] (notify.error err))
                                   }))

;; run once on start-up to push out an initial value  
(emit-output-data)
(emit-input-data)

;; find any orphaned listeners and kill them before spawning a new one
(awful.spawn.easy_async_with_shell
 pa.kill-listeners-script
 (fn []
   (listen-volume emit-output-data)
   (listen-mic emit-input-data)))
