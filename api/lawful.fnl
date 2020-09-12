(local awful (require :awful))
(local naughty (require :naughty))
(local gears (require :gears))
(local dump gears.debug.dump_return)
(local join gears.table.join)
(local unpack (or table.unpack _G.unpack))
(import-macros {: async : await} :utils.async)

(var lawful {:io {}
             :notify {}})

(lambda lawful.notify.msg [message ?args]
  (let [args (or ?args {})
        tv (type message)]
    (match tv
      :string (naughty.notify (join args {:text message}))
      :nil (naughty.notify (join args {:text "nil"}))
      _ (naughty.notify (join args {:text (dump message)})))))

(lambda lawful.notify.info [message ?timeout]
  (lawful.notify.msg message {:timeout (or ?timeout 10)}))

(fn lawful.notify.error [message]
  (let [err-preset {:timeout 0 :bg "#000000" :fg "#ff0000" :max_height 1080}]
    (lawful.notify.msg message err-preset)))

(lambda lawful.io.shellout [cmd]
  (async
   (let [[out err reason code] (await awful.spawn.easy_async_with_shell cmd)]
     {:stdout out
      :stderr err
      :reason reason
      :code code})))

(lambda lawful.io.shellout! [cmd]
  (let [{: stdout : stderr : code} (lawful.io.shellout cmd)]
    (if (= code 0)
        stdout
        (lawful.notify.error stderr))))

lawful
