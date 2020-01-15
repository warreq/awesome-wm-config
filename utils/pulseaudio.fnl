;; a set of helper functions for interacting with PulseAudio
;; requires: pactl
(local awful (require "awful"))

(local pa {})

(set
 pa.get-volume-script
 "pactl list sinks | grep -m1 'Volume:' | awk '{print $5}' | cut -d '%' -f1")

(set
 pa.get-muted-script
 "pactl list sinks | grep -m 1 'Mute:' | awk '{printf \"%s\", $2}'")

(set
 pa.get-mic-muted-script
 "pactl list sources | grep -m 1 'Mute:' | awk '{printf \"%s\", $2}'")

(set
 pa.volume-listener-script
 "bash -c 'pactl subscribe 2> /dev/null | grep --line-buffered \"sink\"'")

(set
 pa.mic-listener-script
 "bash -c 'pactl subscribe 2> /dev/null | grep --line-buffered \"source\"'")

(set
 pa.kill-listeners-script
 "ps x | grep \"pactl subscribe\" | grep -v grep | awk '{print $1}' | xargs kill")

(lambda pa.toggle-muted-script-tmpl [?sink]
  (let [sink (or ?sink "@DEFAULT_SINK@")]
  (.. "pactl set-sink-mute " sink " toggle")))

(lambda pa.toggle-mute-mic-script-tmpl [?source]
  (let [source (or ?source "@DEFAULT_SOURCE@")]
  (.. "pactl set-source-mute " source " toggle")))

(lambda pa.adjust-volume-script-tmpl [amount ?sink]
  (let [sink (or ?sink "@DEFAULT_SINK@")
        sign (if (> amount 0) "+" "")]
    (.. "pactl set-sink-volume " sink " " sign amount "%")))
  
(lambda pa.adjust-volume [step ?callback]
  (let [cmd (pa.adjust-volume-script-tmpl step)
        cb (or ?callback (fn [] nil))] 
  (awful.spawn.easy_async_with_shell cmd cb)))

(lambda pa.toggle-muted [?sink ?callback]
  (let [cmd (pa.toggle-muted-script-tmpl ?sink) 
        cb (or ?callback (fn [] nil))] 
  (awful.spawn.easy_async_with_shell cmd cb)))

(lambda pa.toggle-mic-mute [?source ?callback]
  (let [cmd (pa.toggle-mute-mic-script-tmpl ?source) 
        cb (or ?callback (fn [] nil))] 
  (awful.spawn.easy_async_with_shell cmd cb)))

(lambda pa.get-volume [?callback]
  (let [cb (or ?callback (fn [] nil))] 
    (awful.spawn.easy_async_with_shell pa.get-volume-script cb)))

pa
