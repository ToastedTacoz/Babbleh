local module = {}

-- Settings
-- 
-- Tweak these to not nuke your PC

local exhuastGeneration = true -- If it is false it will end based off chance (Buggy), and if true it will keep going, Until it has no more options.
local allowRepeats = true -- Why would you turn this off .-.
local isMaxLength = true
local isMinLength = true -- Like an Apendix, doesn't do much but is still good to have around.
local minLength = 3
local maxLength = 50

module.loaded = {{},{}}
module.data = {}
module.links = {}

local function printd(t,t2,t3,t4)
    --print(tostring(t),tostring(t2),tostring(t3),tostring(t4))
end

function module.strip(text)
    return string.gsub(string.lower(text),",%.%?%!%\"%'","") -- Puncuation is not reliable with other training bits!!
end

function module.split(text,s)
    local t = {}
    local c = ""
    
    local function add() table.insert(t,c) c = "" end
    
    for i=1,#text do
        local l = string.sub(text,i,i)
        
        if l == (s or " ") then
            add()
        else
            c = c .. l
        end
    end
    
    add()
    
    return t
end
    
function module.load(textBase,file)
    local text = module.strip(textBase)
    
    if #text > 0 then
        if (((not module.loaded[1][text]) or allowRepeats) and (((#text >= minLength) or (not isMinLength)) and ((#text <= maxLength) or (not isMaxLength)))) then
            if not file then
                local file = io.open("data.txt","a")
                
                file:write(text.."\n")
                file:close()
            end
            
            module.loaded[1][text] = true
            
            local split = module.split(text," ")
            
            for i,v in pairs(split) do
                local pvdt = module.data[v]
                local last = split[i-1]
                local add = {
                    ((i == 1) and 1 or 0),
                    ((i == #split) and 1 or 0)
                }
                
                module.loaded[2][v] = true
                
                printd(last,pvdt,v,i)
                
                if last ~= nil then
                    printd("adding link")
                    
                    if module.links[last] then
                        table.insert(module.links[last],v)
                    else
                        module.links[last] = {v}
                    end
                end
                
                if pvdt then
                    module.data[v] = {
                        ["End"] = pvdt.End + add[2],
                        ["Start"] = pvdt.Start + add[1],
                        ["Uses"] = pvdt.Uses + 1
                    }
                else
                    module.data[v] = {
                        ["End"] = add[2],
                        ["Start"] = add[1],
                        ["Uses"] = 1
                    }
                end
            end
        else
            printd("Rejected",text.."!!")
        end
    end
end

function module.generate()
    local r = ""
    local chances = {}
    local words = {}
    local tc = 0
    local l = ""
    
    local function find(t)
        for i,v in pairs(words) do
            if v == t then
                return i
            end
        end
        
        return -69
    end
    
    local function add(text)
        local Ptext = string.lower(text)
        
        if not ((find(Ptext) >= (#words - 3))) then -- stops loops ex. I am i am i am (From "am i" and "i am" looping)
            r = r .. text .. " "
            l = Ptext
            
            table.insert(words,Ptext)
        else
            printd("Failed",Ptext)
        end
    end
    
    for i,v in pairs(module.data) do
        local w = v.Start/v.Uses
        
        if not (w <= 0) then
            tc = tc + w
            
            table.insert(chances,{i,w})
        end
    end
    
    local f = 0
    
    if true then
        local ra = math.random()*tc
        local c = 0
        
        for i,v in pairs(chances) do
            c = c + v[2]
            
            if c >= ra then
                add((string.upper(string.sub(v[1],1,1)))..(string.sub(v[1],2,#v[1])))
                break
            end
        end
    else
        local r = chances[math.random(1,#chances)][1]
        
        add((string.upper(string.sub(r,1,1)))..(string.sub(r,2,#r)))
    end
    
    while true do
        if l then
            local words = module.links[l] or {}
            
            if #words >= 1 then
                local word = words[math.random(1,#words)]
                
                printd("Chose",word)
                
                add(word)
                
                local data = module.data[word]
                
                if (not exhuastGeneration) and (math.random() >= (data.uses / data.end)) then
                    break
                end
            else
                printd("CE1")
                
                break
            end
        else
            f = f + 1
            
            printd("E1")
            
            if f >= 2 then
                break
            end
        end
    end
    
    return r
end

function module.init()
    local text = io.open("data.txt","r"):read("*a")
    
    printd("Initializing to "..#text.." chars of data.")
    
    local split = module.split(text,"\n")
    
    printd("Compiling begining")
    printd(#split.." lines of data.")
    
    for i,v in pairs(split) do
        module.load(v,true)
    end
    
    printd("Compiled data!")
    printd("Compiled "..#module.data.." words.")
    printd(#module.links.." word links.")
end

return module