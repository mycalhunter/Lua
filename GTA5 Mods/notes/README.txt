## REQUIREMENTS:
⋅⋅* [UI Resource](https://github.com/mycalhunter/Lua/tree/master/GTA5%20Mods/notes)

### Client.lua
1. Line 46: Change 'notespot' table data to fit where/what/who you need

ie.
local notespot = {
  {x = 667.0, y = 562.71, z = 129.05, type = "weed", author = "J. Dough"},
  {x = 664.49, y = 564.69, z = 129.05, type = "cocaine", author = "Schno Flake"}
}

### Script.js
1. Line 46: Change .noteImg background image's to fit notespot table data

ie.
if (item.spotType == "weed") {
  $(".noteImg").css("background-image", "url('images/weed_dealer.jpg')");
} else if (item.spotType == "cocaine") {
  $(".noteImg").css("background-image", "url('images/cocaine_dealer.jpg')");
} else {
  $(".noteImg").css("background-image", "url('images/nothing.png')");
}