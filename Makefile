SHELL := /bin/bash

awesome_lib_path := /usr/local/share/awesome/lib/?.lua;/usr/local/share/awesome/lib/?/init.lua
awesome_local_path := $(shell echo "${HOME}/.config/awesome") 
lua_path := "$(shell lua -e 'print(package.path)');$(awesome_lib_path);$(awesome_local_path)"
$(info $(lua_path))

test:
	LUA_PATH=${lua_path} ./fennel-0.8.1 --correlate --metadata test/init.fnl

.PHONY: test
