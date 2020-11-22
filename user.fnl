(local icon-loader (require "icons.loader"))

(local user {})

(set user.avatar
  (icon-loader.load :shtwzrd :avatar8bit {
                                          :viewBox "0 -0.5 8 8"
                                          :height 8
                                          :width 8
                                          :stroke-width 1
                                          :stroke-linecap :none
                                          :stroke-linejoin :none
                                          :shape-rendering :crispEdges}))

user
