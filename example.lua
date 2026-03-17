local module = require("generate")

module.init() -- Loads data.txt

module.load("loop") -- Forever load
module.load("loop",true) -- Temporary load

-- After you've ran these you will find "rejected loop!!"
-- Because of my (massive) intellect
-- I added an anti-repeat system

print(module.generate())
