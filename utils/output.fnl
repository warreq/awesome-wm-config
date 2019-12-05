(local naughty (require "naughty"))
(local gears (require "gears"))

(local output {})

(lambda output.notify [text ?timeout]
  (naughty.notify {:text text :timeout (or ?timeout 10)}))

(fn output.dump [x timeout]
  (output.notify (gears.debug.dump_return (or x "nil")) (or timeout 10)))

output
