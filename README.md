# Babbleh
A fun little text generator that uses training data.

## ***How to use***
First of all, training data is quite slim at start.<br><br>
With only 40 lines *you* are **required** to add your own data.<br>
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

Don't make it too long or too short, and especially ***NEVER*** make it a repeat nor clone!!
```
Console:
Rejected a!!
```

This project is just a silly thing.<br><br>
It will obviously get more updates along with flexibility and bug fixes.
