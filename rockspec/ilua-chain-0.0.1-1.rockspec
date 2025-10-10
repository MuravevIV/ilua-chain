package = "ilua-stream"
version = "0.0.1-1"

source = {
  url = "git://github.com/MuravevIV/ilua-stream.git",
  tag = "v0.0.1"
}

description = {
  summary = "Collection Extensions for Lua",
  homepage = "https://github.com/MuravevIV/ilua-stream",
  license = "MIT/X11",
  maintainer = "ilya.yarn@gmail.com",
  detailed = [[
    TODO!
  ]]
}

build = {
  type = "builtin",
  modules = {
    ["ilua.stream"] = "stream.lua",
  },
  copy_directories = { "doc", "tests" }
}
