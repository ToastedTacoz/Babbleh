local module = {}

-- Settings
-- 
-- Tweak these to not nuke your PC

local exhuastGeneration = true -- If it is false it will end based off chance (buggy), and if true it will keep going, until it has no more options.
local allowRepeats = false -- Why would you turn this on .-.
local isMaxLength = true
local isMinLength = true -- Like an Apendix, doesn't do much but is still good to have around.
local minLength = 3
local maxLength = 50

module.loaded = {
    ["Words"] = {},
    ["Sentences"] = {}
}
module.data = {} -- Gives data for words to do chance pulls for start and ends
module.links = {} -- Allows chain generation

local function printd(t,t2,t3,t4)
    print(tostring(t or "")..tostring(t2 or "")..tostring(t3 or "")..tostring(t4 or "").."\n")
end

local function capitalizeFirst(v)
    return (string.upper(string.sub(v,1,1)))..(string.sub(v,2,#v))
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
        if (((not module.loaded["Sentences"][text]) or allowRepeats) and (((#text >= minLength) or (not isMinLength)) and ((#text <= maxLength) or (not isMaxLength)))) then
            if not file then
                local file = io.open("data.txt","a")
                
                file:write(text.."\n")
                file:close()
            end
            
            module.loaded["Sentences"][text] = true
            
            local split = module.split(text," ")
            
            for i,v in pairs(split) do
                local pvdt = module.data[v]
                local last = split[i-1]
                local add = {
                    ["Start"] = ((i == 1) and 1 or 0),
                    ["End"] = ((i == #split) and 1 or 0)
                }
                
                module.loaded["Words"][v] = true
                
                --printd("Previous : "..(last or "nil").."\nData : "..(tostring(pvdt) or "").."\nAdded : "..v.."\nIndex : "..tostring(i))
                
                if last ~= nil then
                    if module.links[last] then
                        table.insert(module.links[last],v)
                    else
                        module.links[last] = {v}
                    end
                end
                
                if pvdt then
                    module.data[v] = {
                        ["End"] = pvdt.End + add.End,
                        ["Start"] = pvdt.Start + add.Start,
                        ["Uses"] = pvdt.Uses + 1
                    }
                else
                    module.data[v] = {
                        ["End"] = add.End,
                        ["Start"] = add.Start,
                        ["Uses"] = 1
                    }
                end
            end
        else
            printd("Rejected ",text.."!!")
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
        
        return -math.huge
    end
    
    local function add(text)
        local Ptext = string.lower(text)
        
        if not ((find(Ptext) >= (#words - 3))) then -- stops loops ex. I am i am i am (From "am i" and "i am" looping)
            r = r .. text .. " "
            l = Ptext
            
            table.insert(words,Ptext)
        else
            printd("Failed ",Ptext)
        end
    end
    
    for i,v in pairs(module.data) do
        local w = v.Start/v.Uses
        
        if not (w <= 0) then
            tc = tc + w
            
            table.insert(chances,{["Word"] = i,["Chance"] = w})
        end
    end
    
    local f = 0
    
    if true then
        local ra = math.random()*tc
        local c = 0
        
        for i,v in pairs(chances) do
            c = c + v["Chance"]
            
            if c >= ra then
                add(capitalizeFirst(v["Word"]))
                break
            end
        end
    else
        local r = chances[math.random(1,#chances)]
        
        add(capitalizeFirst(r["Word"]))
    end
    
    while true do
        if l then
            local linkWords = module.links[l] or {}
            
            if #linkWords > 0 then
                local word = linkWords[math.random(1,#linkWords)]
                
                --printd("Chose ",word)
                
                printd("Previous : "..(l or "nil"),"\nNew : "..word,"\nIndex : "..tostring(#words),"\nTotal : "..(l or "").." "..word)
                
                add(word)
                
                local data = module.data[word]
                
                if (not exhuastGeneration) and (math.random() >= (data.Uses / data.End)) then
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
    printd(tostring(#split-1).." lines of data.")
    
    for i,v in pairs(split) do
        module.load(v,true)
    end
    
    printd("Compiled data!")
    printd("Compiled "..#module.data.." words.")
    printd(#module.links.." word links.")
end

return module
