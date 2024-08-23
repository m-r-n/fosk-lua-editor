
============================================
           	F.O.S.K.
    	Lua-based PSP TEXT Input
    	  mrn at post dot cz
============================================

F.O.S.K. is a Fast On-Screen Keyboard-based text editor, 
requiring only two (!) keystrokes to enter any character. 

How does it work?
-----------------
The on-screen QWERTY keyboard is divided into 7 blocks, each one with a square shape, 
containing 3x3=9 on-screen buttons (therefore icon.png .) 
The first keystroke selects such a block, while the second one takes one of the nine chars inside the block. 
 - To move up/down/left/right inside the block .. the arrow keys are used
 - To move up-left .. square, down-left .. cross, down-right..circele, up-right .. triangle keys used.
 - To choose the mid char from the block .. the 'Select' key is used.

The keyboard has 3 MODES (1~normal, 2~CapsLock, 3~CursorMode), each one having its own spcial functions:
Mode1:  NORMAL MODE
----------------------
 - to type text at the cursor position proceed as described above ('How does it work?')
 - to scroll the text Up/Down use buttons R and L
 - Special functions in this mode:
    - Tab...Tabulator
    - Del...Delete from Right
    - Back..Delete to Left
    - Find.. Find a string
    - Next.. Find Next (as F3)
    - NwLn..add a New Line
    - Copy..not implemented yet
    - Cut...not implemented yet
    - Pste..not implemented yet

Mode2: CAPS LOCK 
----------------------
 - Special functions in this mode:
    - Open..Open another text file (should be of length at least 3 lines)
    - NewF..Make a new file
    - Clse..not implemented yet
    - Save..Save the file we just edited
    - Prnt..Print the screen immediately to a file with a filename extracted from date like "1_00.15.34.png" 
    - Xprt..Save the text immediately to a file with a filename extracted from date: "Note_1_00.05.38.txt"
    - Repl.. not implemented yet
    - Ins... not implemented yet

Mode3: CURSOR MODE
----------------------
 - Special functions in this mode:
    - Move cursor Up, Left, Down, Right (Arrow keys)
    - Move 5 characters Up, Left, Down, Right (Triangle, Square, Circle, Cross)
    - PageUp/PageDown (button L and R)

To switch inbetween the 3 modes press "Select"
To Exit F.O.S.K. press "Select".

Features:
-----------------
- entering ANY character by only TWO KEYSTROKES
- QWERTY (QWERTZ) keyboard layout
- based on a 7x9 char template with CapsLock Function
- NewFile, SaveAs, Find, FindNext, ScrollBar, etc atted.

Installation:
-------------
Copy this 'F.O.S.K.' dir into your 'psp/game/luaplayer/Applications/' directory.
If you still do not have luaplayer installed, go to 'luaplayer.org' and grab it.
(Further nice Lua apps downloadable at pspLua.com .)

Known bugs:
-----------
see changelog.txt

Note for developers:
--------------------
..hope you know how to edit LUA-scripts "online" on your PC while staying connected to the PSP.
(This let you keep running LUA PLAYER without deactivating and re-activating the USB mode.
If your L button would not invoke 'DiskMode' of Luaplayer, or you do not want to restart your script 
everytime, the only thing you need to do is to start any LUA  app with the 'System.usbDiskModeActivate()'
command inside, then exit this app, and stay in Lowser(the player environment). 
Now you can edit your code on the PC, but can not save files from Lua scripts before deactivating USB. 
For more info go to the luaplayer website, or post your question.)

Credits:
--------
LUA FileBrowser 0.1 by mikehaggar99(at)gmail(dot)com

Linux-Note:
------------
on Ubuntu I need to close lua apps on the PSP BEFORE editing them on the PC
to be able to save the code onto the MS, otherwise the file gets lost from the MemStick!!! 

Hope, you like this TextInput design, and will use it for future Dictionaries, Notepads, 
messaging and other apps.
You can find the EASY-TO-READ ROUTINES you'll need in 'readFOSK.lua' and 'kbrdfnct.lua'
Just do not forget about the credits and to inform about your apps!!!
For last changes see 'changelog.txt'

Gooooooooood Luck!
mrn at post dot cz




