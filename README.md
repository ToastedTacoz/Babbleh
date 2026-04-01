# Babbleh
A fun little text generator that uses training data.

## ***How to use***
First of all, training data is quite slim at start.<br><br>
With not much data *you* are **required** to add your own data.<br>
To add data type directly into the data.txt, or use the .load example down below.
### **Code Examples**
<br>
For example printing a generation goes like this.

``` lua
local module = require("generate.lua")

print(module.generate())
```
```
Console:
Marmaduke soup tomato man
```
<br>
If you need to load data it is very simple!

``` lua
local module = require("generate.lua")

module.load("Please help me")
```
<br>
Or if you need it not written in the file?

``` lua
local module = require("generate.lua")

module.load("Please help me",true)
```
<br>

Don't make it too long or too short, and especially ***NEVER*** make it a repeat nor clone!!
```
Console:
Rejected a!!
```
<br>

## ***v1.0.1 or up only!!!!!!!111***
<br>

<br>If your want it to be ***✨CUSTOM✨*** with mood data!?!?<br>

``` lua
local module = require("generate.lua")

module.generate({
    Diversity = 0.00 - 1.00,
    MoodMod = {
        ["angry"] = 924124
    }
})
```

<br>HOW 👏 THE 👏 HELLY 👏<br>

***The math is kinda cool??***<br>
``` lua
{2}  *  {52} = {104}
total({104}) = 104
chance = chance * (104 + 1) = 105
```
<br>

Diversity is like this<br>
``` lua
chanceBase = chanceBase ^ (diversity or 0.9)
```
<br>

This project is just a silly thing.<br><br>
It will obviously get more updates along with flexibility and bug fixes.
