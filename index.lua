--[[
============================================
           		F.O.S.K.
    	Lua-based PSP TEXT Input
    	  mrn at post dot cz
============================================
--]]

-- ============ External keybrd Fnctions ================

dofile("./kbrdfnct.lua")
dofile("./browser.lua")
dofile("./readFosk.lua")

-- ==================== Main Code =====================
version = 0.16 -- .. PgUp/Down added
version = 0.17 -- .. cursor added
version = 0.18 -- .. typing corrected
version = 0195 -- .. cursor movement ok
version = 0.20 -- .. Save works!!!
version = 0.21 -- .. ttf font trials .. really slow if reprinting at 1/60
version = 0.22 -- .. square printed as Rect, ttf vs. Standard font switchable
version = 0233 -- .. additional string input mode for SaveAs, Search, 
version = 0235 -- .. find fixed, cursorPrev added
version = 0236 -- .. Analog Scrolling
version = 0240 -- .. analog scrolling slowed down by wait, bug in "Back"

firstkey = 0; --0.. zero keys pressed (after flipping the screen), 1..first key pressed, 2..character choosen
oldPad = Controls.read()
x = 1
y = 1
keys = keys1
line = ">"
caps = false
lastNumber = 0
deleteOnKey = true
lastOperation = ""
value = ""
number = 0
menu_called = 0
brk = 0             -- Brake has been pressed ('Start') while typing
allowBrk = 1        -- we do allow to act Start as Brake, however deacivate it when browsing files !!

-- variables from the textReader:
filetypes = {}
filetypes[1]=".txt"
filetypes[2]=".lua"
filetypes[3]=".c"
filetypes[4]=".cpp"
filetypes[5]=".htm"
filetypes[6]=".html"
filetypes[7]="."
filetypes[8]=".dic"
filetypes[9]=".bla"


filetypes2 = {}
filetypes2[1]=".mod"
filetypes2[2]=".xm"
filetypes2[3]=".it"

colors = {}
colors[1] = {Color.new(0, 0, 0),Color.new(0, 0, 192),Color.new(255, 255, 255)}
colors[2] = {Color.new(255, 255, 255),Color.new(255, 255, 255),Color.new(0, 0, 0)}
colors[3] = {Color.new(0, 192, 0),Color.new(0, 192, 0),Color.new(0, 128, 0)}

-- variables from the textreader
newcwd = "ms0:/"
sorting=0
types=0
select=1
scroll=0
palette=1 

-- cursor positions
cursor = 1      -- initial x ccord of the cursor
cursorPrev = 1  -- initial x ccord of the cursor, needed for blit4ttf
linepos = 1     -- initial y ccord of the cursos
linelen = 1     -- length of the actual line
insert = 0      -- insert/overwrite mode
keybMode = 3        -- 1~normal, 2~CapsLock, 3~CursorMode
textMode = 1        -- 1~textEdit, 2~string query (SaveAs, Search, Replace, etc)
WaitAndSave = 0 	-- this boolean tells the infinite loop to save the file after the filename was typed
WaitAndFind = 0 	-- this boolean tells the infinite loop to search a string after it has been typed
searchFromLine = 1
textTyped = 0
wait = 0

numVisLines = 27    -- num of text lines visible
nMaxchar = 60       -- num of chars visible in a single line

dispMode = 0        -- taken from the text reader (disp the line num before the line..?)

starty=0        -- lines shifted when displaying the text
startx=0        -- lines shifted when displaying the text
cross=0
mode1=0
mode2=0
exit2=false
textVisivble = 1    -- to print or not to print? (zb. bug in NewLine => PgDwn does not workx!)
k = numVisLines -- to make it global before using in a funct.

inpText = "a"
ch = ""
text = {}
text[1] = "ready >"

filename, newcwd, sorting, types, select,scroll = browser(filetypes,newcwd,sorting,types, select,scroll) 
readTxtFile ()
pad = Controls.read()
firstkey = 0      -- keyboard reinitialization HM!
-- ------------------- origFonts..... -----------
charWidth = 8
charHeight = 8
lastChar =  math.ceil(480/charWidth)-6   -- max num of chars we can disp w/o scrolling
-- ------------------- trueTypeFonts..? -----------
trueType = false
monoSpaced = Font.createMonoSpaced()
monoFontSize = 9
monoSpaced:setPixelSizes(0, monoFontSize)

-- ==================== Main Loop =====================

while true do
     
	-- UPDATING THE SCREEN EVERY 1/60 SEC --
	screen:clear()
    
            if (keybMode == 1) then
                keys = keys1
            else -- keybMode == 2
                keys = keys2
            end

    if (keybMode<3) then
        drawFOSK(firstkey, x, y)
        readFOSK ()
    else                -- keybMode == 3
         moveCursor()
    end                 -- if (keybMode<3)

    -- print Clock --
	flnm= getTimeStr ()
    linelen = string.len(text[linepos])
    
    -- print Battery Life --
    battLife = System.powerGetBatteryLifePercent()
    if      battLife > 80 then DCColor = green
    elseif  battLife > 50 then DCColor = color
    elseif  battLife > 20 then DCColor = white
    else DCColor = red
    end

    -- variable check
    -- screen:print(1 , 222, "keybMode="..keybMode, color)
	-- 
    -- screen:print(180, 222, "firstkey="..firstkey, color)
    -- screen:print(380, 222, "firstk="..firstkey, color)

    if trueType == true then
        screen:fontPrint(monoSpaced,70 ,220+ monoFontSize, "Accu:"..battLife.."%", DCColor)
        screen:fontPrint(monoSpaced,1 ,230+ monoFontSize, "starty="..starty, color)
        screen:fontPrint(monoSpaced,1, 238+ monoFontSize, "linepos = "..linepos, color)
        screen:fontPrint(monoSpaced,1, 246+ monoFontSize, "cursor  = "..cursor, color)
        screen:fontPrint(monoSpaced,1, 254+ monoFontSize, "linelen = "..linelen, color)
        screen:fontPrint(monoSpaced,1, 262+ monoFontSize, "numlines= "..numlines, color)
    else

     -- screen:print(1 ,200, "WaitAndFind:"..WaitAndFind, DCColor)
     -- screen:print(1 ,210, "WaitAndSave:"..WaitAndSave, DCColor)  
        if trueType == true then screen:print(1, 238, "trueType:", color) end
        screen:print(70 ,220, "DC:"..battLife.."%", DCColor)

        screen:print(1, 230, "stickX:"..pad:analogX().." Y:"..pad:analogY(), white)

        -- screen:print(1, 238, "F:"..filename, color)
        -- screen:print(1, 229, "TM:"..textMode, white )
        -- screen:print(1, 246, "Dir:"..newcwd, color)
        -- screen:print(1, 254, "linelen = "..linelen, color)
        screen:print(1, 246, "num.lin="..numlines, color)
        -- screen:print(1,  262, "xP="..cursorPrev, color)        
        screen:print(1 ,254, "sy="..starty, color)
        screen:print(1 ,262, "sx="..startx, color)

        screen:print(60, 262, "x="..cursor, color)        
        screen:print(60, 254, "y="..linepos, color)
    end

    if (brk == 1) then
		break
	end

    if (textVisivble==1) and (textMode == 1) then
        dispTxt ()
        dispScrollY()
        dispCursor (linepos, cursor, insert)
    end
    
    --------- no text display, but "inputQuery" -------------
    if (textMode == 2) then -- SaveAs, Find, etc.
        if (WaitAndSave == 1) then 
            dispQuery (30, 130, "Save As..?", inpText)
        elseif (WaitAndFind == 1) then
            dispQuery (30, 130, "Find..?", inpText)
        end
    end

    -- we are waiting till the filename is typed then saving the file
    if (WaitAndSave == 1) and (textTyped == 1) then  
        filename = inpText
        -- writeTxtFile (newcmd,filename)
        writeNote(newcwd .. filename)
        WaitAndSave = 0
    end

    -- we are waiting till the string is typed then Searching the string
    if (WaitAndFind == 1) and (textTyped == 1) then  
        findText = inpText
        findString(findText, 1)
        WaitAndFind = 0
    end
 
	screen.waitVblankStart(wait)   -- >0 beacause of the analog stick
    if wait > 3 then wait = 0 end
	screen.flip()
end
