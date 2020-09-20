(fn test-simple []
  (async
   (output.notify "1")
   (let [[stdout stderr reason code] (await awful.spawn.easy_async_with_shell "sleep 2 && echo 2")]
     (output.notify (or stdout "failed")))))

(fn test-nested []
  (async
   (var thing
        (do
          (output.notify "1")
          (output.notify "2")
          (async
           (let [[stdout stderr reason code] (await awful.spawn.easy_async_with_shell "sleep 2 && echo 3")]
             stdout))))

   (output.notify (or thing "failed"))))

(fn test-nested-serial []
  (async
   (var thing
        (do
          (output.notify "1")
          (output.notify "2")
          (async
           (let [[stdout stderr reason code] (await awful.spawn.easy_async_with_shell "sleep 2 && echo 3")]
             stdout))
          (async
           (let [[stdout stderr reason code] (await awful.spawn.easy_async_with_shell "sleep 2 && echo 4")]
             stdout))))

   (output.notify (or thing "failed"))))

(fn test-nested-serial-return []
  (async
   (var thing
        (do
          (output.notify "1")
          (output.notify "2")
          (async
           (let [[stdout1 stderr1 reason1 code1] (await awful.spawn.easy_async_with_shell "sleep 2 && echo 4")
                 [nothin] (output.notify stdout1)
                 [stdout2 stderr2 reason2 code2] (await awful.spawn.easy_async_with_shell (.. "sleep 2 && echo 4 and " stdout1))]
             stdout2))))

   (output.notify (or thing "failed"))))
