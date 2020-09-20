;; Functions for doing asynchronous IO
(local awful (require "awful"))
(local deferred (require "vendor.deferred"))

(local aio {})

(fn aio.shellout 
  ;; execute `cmd` in $SHELL and return a Promise
  [cmd]
  (var d (deferred.new))
  (awful.spawn.easy_async_with_shell
   cmd
   (fn 
     [stdout stderr exitreason exitcode]
     (if (= exitcode 0)
         (: d :resolve stdout)
         (: d :reject stderr))))
  d)

(fn aio.touch-file
  [path filename]
  (let [cmd (string.format "mkdir -p '%s' && touch '%s%s'" path path filename)]
    (aio.shellout cmd)))

(fn aio.read-file
  [path filename]
  (let [cmd (string.format "cat '%s%s'" path filename)]
    (-> (aio.touch-file path filename)
        (: :next (fn [_] (aio.shellout cmd))))))

(fn aio.reverse-lines
  [s]
  (let [c (string.format "printf '%s' | nl | sort -k 2 | sort -r | cut -f 2" s)]
    (aio.shellout c)))

(fn aio.kill-line
  [path filename str]
  (let [s (string.gsub str "^%s*(.-)%s*$" "%1") ; trim whitespace
        c (string.format "sed -i '/^%s$/d' '%s%s'" s path filename)]
    (aio.shellout c)))

(fn aio.append-file
  [path filename text]
  (let [cmd (string.format "printf '%s' >> '%s%s'" text path filename)]
    (-> (aio.touch-file path filename)
        (: :next (fn [_] (aio.shellout cmd))))))

(fn aio.write-file
  [path filename text]
  (let [cmd (string.format "printf '%s' > '%s%s'" text path filename)]
    (aio.shellout cmd)))

aio
