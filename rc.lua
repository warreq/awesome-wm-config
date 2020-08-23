local fennel = require("./fennel")
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
fennel.makeSearcher({
  correlate = true,
  useMetadata = true
})
table.insert(package.loaders or package.searchers, fennel.searcher)
require("init") -- load ~/.config/awesome/init.fnl
