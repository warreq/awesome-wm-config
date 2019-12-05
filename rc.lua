fennel = require("fennel")
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)
require("init") -- load ~/.config/awesome/init.fnl
