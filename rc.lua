fennel = require("./fennel")
local searcher = fennel.makeSearcher({
  correlate = true,
  useMetadata = true
})
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
table.insert(package.loaders or package.searchers, searcher)
require("init") -- load ~/.config/awesome/init.fnl
