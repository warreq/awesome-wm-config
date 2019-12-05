(fn persist [])
(fn load [])

(fn register []
  awesome.connect_signal("workspaces::init")
  awesome.emit_signal("workspaces::init"))
