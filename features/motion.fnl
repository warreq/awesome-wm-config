(local lume (require "lume"))
;[:g my.gap.function "gaps" "misc section"]

(fn parse
  [_ _ _ sequence]
  (let [tokens (lume.split (: sequence :gsub "%D" " %1 "))]
