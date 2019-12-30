HUD Compass [hud_compass]
-------------------------

A Minetest mod to optionally place a HUD compass and 24-hour clock on the screen.

By David G (kestral246)

![HUD Compass Screenshot](screenshot.png "hud_compass")

How to enable
-------------

This mod defaults to not displaying compass and clock. To enable, use the chat command:

	"/compass" -> By default this places a compass and clock in the bottom right corner of the screen.

Repeated use of this command will toggle the display of the compass and clock off and on.

**New:** When given with an argument, the position of the compass and clock can be changed. This is particularly useful with Android clients, where the bottom right corner of the screen has the jump button.

	"/compass 1" -> top right corner
	"/compass 2" -> bottom right corner
	"/compass 3" -> bottom left corner
	"/compass 4" -> top left corner

In addition:

	"/compass 0" -> forces compass off.

Local mod storage is used to maintain the state and position of hud_compass display between sessions, per user.


Licenses
--------
Source code

> The MIT License (MIT)

Media (textures)

> Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)

> (Textures were copied from my realcompass mod, which were originally based on the textures created by tacotexmex for the ccompass mod.)
 







