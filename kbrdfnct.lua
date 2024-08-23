--[[
============================================
           		F.O.S.K.
    	Lua-based PSP TEXT Input
    	  mrn at post dot cz
============================================
--]]
nice_color = Color.new(200, 200, 100)
red   = Color.new(255, 0, 0);
green = Color.new(0, 255, 0);
blue  = Color.new(0, 0, 255);
white = Color.new(255, 255, 255);
black = Color.new(0, 0, 0);

color = Color.new(200, 200, 100)

-- ==================== drawRect =====================

function drawRect(x0, y0, w, h)
	screen:drawLine(x0, y0, x0+w, y0, color)
	screen:drawLine(x0, y0, x0, y0+h, color)
	screen:drawLine(x0+w, y0, x0+w, y0+h, color)
	screen:drawLine(x0+w, y0+h, x0, y0+h, color)
end

-- ==================== getTimeStr =====================

function getTimeStr ()
	time = os.time()
	dateString = os.date("%c", time)
	-- screen:print(2, 200, dateString, color)
	dateFields = os.date("*t", time)
	
	-- How Do We the Day?
	--daysOfWeek = {Mon, Tue, Wed, Thu, Fri, Sat, Sun}
	--today = daysOfWeek[dateFields.wday]

	hour = dateFields.hour
	if hour < 10 then
		hour = "0" .. hour
	end

	min = dateFields.min
	if min < 10 then
		min = "0" .. min
	end

	sec = dateFields.sec
	if sec < 10 then
		sec = "0" .. sec
	end
    -- screen:fontPrint(monoSpaced, 10, 200, "Above is the proportional font and this is the mono-spaced", cyan)
    
    if trueType == true then
        screen:fontPrint(monoSpaced, 2, 220+monoFontSize, hour .. ":" .. min .. ":" .. sec, color)
    else
        screen:print(2, 220, hour .. ":" .. min .. ":" .. sec, color)
    end
	return tostring(dateFields.wday.."_"..hour  ..".".. min  .."."..sec)
end

-- ==================== dispQuery =========================
function dispQuery (xx, yy, title, inpText)
       
    drawRect (xx,yy, 400, 29)
    drawRect (xx+3,yy+13, 394, 13)                                    
                    
    if trueType == true then
        screen:fontPrint(monoSpaced, xx+3, yy+3+ monoFontSize, title, white)
        screen:fontPrint(monoSpaced, xx+8, yy+14+ monoFontSize, inpText, white)
    else 
        screen:print(xx+3, yy+3 , title, color)
        screen:print(xx+135, yy+3 , "  R~Enter, L~Esc, NwLn~New Entry", color)
        screen:print(xx+8, yy+16 , inpText, white)
    end
               
end -- fnct

-- ==================== dispTxt =========================
function dispTxt ()
    		for j = 1,k do
            tx = j+starty
       
            startx = math.max(0,(cursor-lastChar))

                if (tx > 0)and (tx<numlines) then
                    -- monoFontSize
                    
                    if trueType == true then
                       screen:fontPrint(monoSpaced,0, 8*(j-1) + 10+ monoFontSize, string.sub(text[tx],startx,(string.len(text[tx]))), white)
                    else 
                        -- the following is buggy since LuaPlayar 0.15
                        -- screen:print(0, 8*(j-1), string.format("%s",string.sub(text[tx],startx,(string.len(text[tx])-mode1))), colors[2][1])
                        screen:print(0, 8*(j-1), string.sub(text[tx],startx,(string.len(text[tx]))), white)
                    end
                end
		end
end -- fnct

-- ==================== dispScrollY =========================
function dispScrollY()
    
    SHeight = 10 -- siraaly!!
    SHeight = 6 + 200 * numVisLines /math.max(numlines, numVisLines)
    posX = 475 + 1
    posY = 3 + (210 - SHeight)* starty / numlines
    
    screen:fillRect(475, 1, 5,210 , blue)
    screen:fillRect(posX, posY, 3, SHeight, color)

end -- fnct
-- ==================== dispCursor ======================
function dispCursor (linepos, cursor, insert)
    -- starty ~ linesshifted
    yc = (linepos -starty-1)* charHeight
    xc = (cursor-startx) * charWidth - 7
    if insert == 0 then
        screen:drawLine(xc,   yc, xc,   yc+8, red)
        screen:drawLine(xc-1, yc, xc-1, yc+8, red)
    else
        --	EZ A CSEL:			screen:fillRect(x0, y0, w+w2, h, color)
		--		foreground = Color.new(0, 0, 0)
		--		drawRect(x0-w-w2+1, y0-10, 3*(w+w2)-2, 3*h-1)
    end    

end -- of fnct

-- ==================== moveCursor ======================
function moveCursor()
        ig = numVisLines * 8 +2
        screen:drawLine(1, ig, 480, ig, red)
        screen:print(118, 230, "|   L~Page Up  |   R~PageDwn  | F.O.S.K 0."..tostring(version), color)
        screen:print(118, 238, "|              |              |", color)
        screen:print(118, 246, "|   ^   Up     |   A   5xUp   |", color)
        screen:print(118, 254, "| <   > L,R    |    \t  5xL,R  |    ", color)
        screen:print(118, 262, "|   v   Down   |   X   5xDown |     Mode Exit", color)
        drawRect(259, 255, 5, 5)

    pad = Controls.read()
	-- WAIT UNTIL THE KEY IS RELEASED (or PRESSED)--
	-- if pad ~= oldPad then -- but no analog joystick test availbale now! Therefore:
    if math.abs(pad:analogX() - oldPad:analogX())>30 
        or math.abs(pad:analogY() - oldPad:analogY())>30 
        or pad ~= oldPad then

        cursorPrev = cursor
        -- changing the keyboard mode
		if pad:select() then	
            keybMode = keybMode +1
            if (keybMode>3) then keybMode=1 end
		end

		--Moving the cursors PgUP ----
		if pad:r() then
            PgUp()
   		end
        --Moving the cursors PgDn ----
        if pad:l() then
            PgDwn()
        end

		--if pad:analogX() > 100 then
          --  PgDwn ()
		--end
		--if pad:analogX() < -100 then 
        --    PgUp ()
        --end

        -- moving the cursor Up, Dwn, etc:
        if pad:left() or pad:analogX() < -100 then
            cursorLeft ()
        end

        if pad:right() or pad:analogX() > 100 then
            cursorRight ()
        end

        if pad:up() or pad:analogY() < -100 then
            cursorUp ()             
        end
        if pad:down() or pad:analogY() > 100 then
            cursorDown ()
        end
        if cursor > (linelen +1) then 
            cursor = linelen 
        end
        
        -- moving the cursor 5x (Up, Dwn, etc):
        if pad:triangle() then
            linepos = linepos -5
            -- now it could be also 0, ie the order of the next two lines is important!
            if linepos < starty then starty = linepos-1 end -- 3. FELtoltuk a lathato reszt a kurzorral
            if linepos < 1 then linepos = 1 end     
            
        end
        if pad:cross() then
            if linepos < numlines-5 then linepos = linepos + 5 
            else linepos = numlines-1 end
            if linepos > (starty+numVisLines) then starty = (linepos - numVisLines) end 
            -- 4.LEltoltuk a lathato reszt a kurzorral
        end

        if pad:square() then
            if cursor > (5) then                    
                cursor = cursor - 5
            else cursor = 1
            end
        end

        if pad:circle() then 
            if cursor < (linelen -3) then                    
                cursor = cursor + 5
            else cursor = linelen + 1
            end
        end

        

        -- final check: the cursor must be no further than the end of line

        if linepos > numlines then linepos = numlines end
        if (cursor > string.len(text[linepos]) + 1) then
            cursor = string.len(text[linepos]) + 1
        end

        -- final check: the y-scrolling should be pozitive!
        if (starty < 0) then 
            starty = 0
        end

		-- CHECK FOR ESCAPE --
		if pad:start() then
            if (allowBrk == 1) then brk = 1 end
		end
		oldPad = pad
    end
end -- of fnct

-- ==================== PgDwn () =====================
function PgDwn ()
    starty=starty-numVisLines -- number of visible lines
    if starty<0 then starty=0 end
    if (linepos-starty) > numVisLines then linepos = linepos - numVisLines end
end

-- ==================== PgUp () =====================
function PgUp ()
  if false then -- 'R' Acts as PrintScreen
      flnm= getTimeStr () -- filename made based on the date and time
      screen:save(flnm .. ".png")   
  else
    if linepos < numlines - 1 then  -- linepos-szal mar ugyis feltoltuk a kepet
		starty=starty+numVisLines
		if numlines<k+starty then starty=numlines-k-1 end
        if (linepos-starty) <1 then linepos = linepos + numVisLines end
        if linepos > (starty+numVisLines) then starty = (linepos - numVisLines) end -- 4.The visible part has been shifted down with the cursor
    end
        if starty<0  then starty=0 end -- kell!!
  end
end

-- ==================== readTxtFile =====================
function readTxtFile ()
	text = {}
	keep = {0,0,0}

	file = io.open(string.format("%s%s",newcwd,filename),"r")
	numlines = 1
	line=file:read("*l")

	while line~=nil do
		text[numlines]=line
		numlines = numlines + 1
		line = file:read("*l")
	end
    checkLines ()
end

-- ==================== checkLines =====================
function checkLines ()
	if numlines > numVisLines then
		k= numVisLines  -- talan nem kell a -1c
	else
		k= numlines -- talan nem kell a -1
	end
end -- fnct

-- ==================== writeTxtFile =====================
function writeTxtFile (newcmd,filename)

    --this version does not seem to work :(
    -- based on the texteditor from PSPWin
    
	if string.len(filename) > 0 then

					savefile = ""
					savefile = newcwd .."/".. filename

					fulltext = ""
					for count = 1, (numlines-5) do
						text[count],num = string.gsub(text[count], "     ",string.char(9))
						fulltext = fulltext..text[count].."\n"
					end

	file = io.open(savefile, "w")
	if file then
		file:write(text)
		file:close()
	end
   end -- string.len
end --fnct

-- ==================== WriteNote =====================
function writeNote(flnm)
  file = io.open(flnm, "w")
  if file then

    for count = 1, (numlines-1) do
		file:write(text[count],"\n" )
    end
		file:close()
  end
end
-- ==================== ReadNote =====================
function readNote()
	file = io.open(noteFile, "r")
	if file then
		high = file:read("*n") -- n?
		file:close()
	end
end

-- ====================  makeNewFile  =====================
function makeNewFile()
    cursorPrev = cursor
                text = {}
                text[1] = "ready >"
                text[2] = ""
                text[3] = "" -- what happens if we load a file with a length of 1 or 2 lines?
                linepos = 1
                
                numlines = 3
                startx = 0
                starty = 0
                filename = "Untitled_.txt"
                cursor = 9
end

-- ==================== findString  =====================

function findString(findText)
    cursorPrev = cursor
   --  for count = 1, (numlines-5) do
   --     text[count],num = string.gsub(text[count], "     ",string.char(9))
	--	fulltext = fulltext..text[count].."\n"
    --end
        if findtext ~= "" then
                    findfirst = nil
					findlast = nil
					findline = searchFromLine
                    -- searching the first occurance --
					findfirst, findlast = string.find(string.lower(text[findline]), string.lower(findText), cursor)
					findline = linepos + 1
                    -- searching the next occurance --
					while findfirst == nil and findline < numlines do
						findfirst, findlast = string.find(string.lower(text[findline]), string.lower(findText))
						findline = findline + 1
					end
 
                   -- setting the cursor position --
                    if findlast ~= nil then
						cursor = findlast+1
						linepos = findline-1
                        searchFromLine = linepos -- for the next search
                        -- highLighting the NEXT result
						mark1 = { findfirst, linepos }
						mark2 = { findlast+1, linepos }

						-- check for necessery X-scrolling
                        if cursor > nMaxchar then
							startx = 5 - cursor
						else
							startx = 0
						end

						-- check for necessery Y-scrolling
                        while (linepos -starty) > numVisLines do
                            starty = starty + numVisLines
                        end
                        -- final check of ScrollDown .)
                        if starty > numlines then starty = numlines - 3 end 
    			end
        end
end
-- ==================== skipKeyPress =====================
function skipKeyPress ()
	oldPad = pad
	-- WAIT UNTIL THE ANOTHER KEY IS PRESSED
	while pad == oldPad do -- amig ervenyes, hogy..
        pad = Controls.read()
	 -- oldPad = pad
	end
    oldPad = pad
end -- fnct
-- ==================== dispAscii   =====================
function dispAscii ()
    cursorPrev = cursor
    for ay = 1,10 do
        text[2*ay-1]=".."
        text[2*ay]= ay.."."
        for ax=1,25 do
            text[2*ay] = text[2*ay]..string.char((ay-1)*25 + ax).." "
        end
    end
    text[21]=""
    linepos = 1
    numlines = 21
    startx = 0
    starty = 0
    cursor = 1
    trueType = true
end -- fnct

-- ====================  cursorUp  =====================
function cursorUp ()
    linepos = linepos -1
    -- now it could be also 0, ie the order of the next two lines is important!
    if linepos < starty then starty = linepos-1 end -- 3. FELtoltuk a lathato reszt a kurzorral
    if linepos < 1 then linepos = 1 end   
    wait = 10
end
-- ====================  cursorDown  =====================
function cursorDown ()
    if linepos < numlines-1 then linepos = linepos + 1 end
    if linepos > (starty+numVisLines) then starty = (linepos - numVisLines) end -- 4.LEltoltuk a lathato reszt a kurzorral
    wait = 10
end
-- ====================  cursorLeft  =====================
function cursorLeft ()
    cursor = cursor -1
    if cursor < 1 then                          -- 1. a sor elejere ert
        cursor = 1 
        if linepos > 1 then                     -- ..de nem tart meg az ELSO sornal
            linepos = linepos-1 
            cursor = string.len(text[linepos]) + 1
        end
    end
    wait = 10
end
-- ====================  cursorRight  =====================
function cursorRight ()
    cursor = cursor +1
    if cursor > (linelen +1) then                    -- 2.a sor vegere ert..
        cursor = linelen 
        if linepos < (starty+numVisLines) then   -- ..de nem tart meg az utolso sornal
            linepos = linepos + 1
            cursor = 1
        end
    end
    wait = 10
end
-- ====================    =====================
-- ====================    =====================
-- ====================    =====================
-- ====================    =====================
