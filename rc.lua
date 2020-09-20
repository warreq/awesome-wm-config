-- force load vendored fennel file instead of any system fennel
originalPath = package.path
package.path = ".config/awesome/?.lua"
fennel = require("fennel")
-- and revert to original package.path
package.path = originalPath

fennel.path = fennel.path .. ";.config/awesome/?.fnl;.config/awesome/?/init.fnl"

searcher = fennel.makeSearcher({
  correlate = true,
  useMetadata = true
})

table.insert(package.loaders or package.searchers, searcher)
require("init") -- load ~/.config/awesome/init.fnl
