--[[
============================================
           		F.O.S.K.
    	Lua-based PSP TEXT Input
    	  mrn at post dot cz
============================================

keymap = {
  "abcdefghi123+-/*=!",
  "jklmnopqr456'\"?()@",
  "stuvwxyz0789.,;[]_"
}

keymaps = {
  "ABCDEFGHI123~`^:%&",
  "JKLMNOPQR456|\\#{} ",
  "STUVWXYZ0789<>$   "
} 

--]]
keys1 = {
	{ "q","w","e","r","t","z","u","i","o",  "7","8","9",  "+","-","=", "~","`","'",  "\\","(",")", "Tab" ,"Find","End"},
	{ "a","s","d","f","g","h","j","k","l",  "4","5","6",  "/","*","%", "^","#","_",  "@","$","]",  "Del" ,"Next", "Home" },
	{ "y","x","c","v","b","n","m","p"," ",  "1","2","3",  "0",".",":", ";","?","!",  "&","","}",   "Back","NwLn","Ins"},
	}
keys2 = {
	{ "Q","W","E","R","T","Z","U","I","O",  "7","8","9",  "+","-","=", "~","`","'",  "|","(",")",  "Open","Save","Cut"},
	{ "A","S","D","F","G","H","J","K","L",  "4","5","6",  "/","*","%", "^","#","_",  ">","[","]",  "New", "Prnt","Copy"},
	{ "Y","X","C","V","B","N","M","P"," ",  "1","2","3",  "0",".",":", ";","?","!",  "<","{","}",  "Back","Xprt","Pste"},
	}

-- ==================== drawKeyboard ==================

function drawFOSK(firstkey, x, y) 

    ig = numVisLines * 8 +2
    screen:drawLine(1, ig, 480, ig, red)
	for yindex,line in keys do
		yk = 0
		w = 11	-- width of Normal keys (a..z, 0..9, etc.)
		ww = 25 -- width of Menu keys
		w2 = 0	-- width of the control keys (Print, Del,etc.)
		w3 = 0  -- only nr. 23 and so is shifted by extra 30 pixels
		h = 11
		for xindex,key in line do
			
			-- keeping the distance between the keyboard blocks --
			if xindex > 22 then w3 = w3 + ww
			elseif xindex > 21 then xoffs = 18
				w2 = w2 + ww -- here comes the Menu :)
			elseif xindex > 18 then xoffs = 13
			elseif xindex > 15 then xoffs = 12

			elseif xindex > 12 then xoffs = 11

			elseif xindex > 9 then xoffs = 7
			elseif xindex > 6 then xoffs = 2
			elseif xindex > 3 then xoffs = 1
			else 
				xoffs = 0
			end
			-- printing a button of the keyboard --
			x0 = xindex * w+w3 + 110 + xoffs
			y0 = yindex * h + 226 
			drawRect(x0, y0, w+w2, h)

			 -- if the first key has been pressed and we are printing the choosen character we highlight it--
			if xindex == x and yindex == y and firstkey == 1 then
				screen:fillRect(x0, y0, w+w2, h, color)
				foreground = Color.new(0, 0, 0)
				drawRect(x0-w-w2+1, y0-10, 3*(w+w2)-2, 3*h-1)
			else
				foreground = color
			end
			fgz = foreground	
			
			value = keys[yindex][xindex]
			if value == "s" or value == "g" or value == "k" or value == "5" or value == "S" or value == "G" or value == "K" or value == "*" or value == "#" or value == "[" or value == "Prnt" or value == "Next" then 						
				foreground = Color.new(255, 255, 255)
			else
				foreground = fgz
			end

			 -- PRINTING THE TEXT --
			screen:print(x0 + 3, y0 + 3, key, foreground)
			-- screen:print(1 + 3, 210 + 3, "firstkey="..tostring(firstkey), foreground)
			-- screen:print(1 + 3, 220 + 3, "x="..tostring(x), foreground)
			-- screen:print(1 + 3, 230 + 3, "Menu="..tostring(menu_called), foreground)
			-- screen:print(1 + 3, 240 + 3, "value="..value, foreground)
			-- screen:print(1, 240 + 3, "R~PgUp, L~PgDn", foreground)
			-- screen:print(1, 250 + 3, "Sel~Selct/Caps", foreground)
			-- screen:print(1, 260 + 3, "TxtInput v"..tostring(version), foreground)
            
			if firstkey == 0 or firstkey == 2 then
				-- screen:print(1 , 215, " 1. Press a button corresponding to one of the white chars:", foreground)
				screen:print(1 , 227, "                 <   ^   >    v        A   \t        X", foreground)
                drawRect(278, 227, 5, 5)
			else
				-- screen:print(1 , 227, " 2. Choose a char by moving Left, Up etc. or press 'Select'.", foreground)
			end		
            
		end -- yindex,line in keys do
	end -- 

end -- fnct

-- ==================== readFOSK =====================

function readFOSK ()

    ch = ""
    cursorPrev = cursor
	pad = Controls.read()
	-- WAIT UNTIL THE KEY IS RELEASED (or PRESSED)--
	-- if pad ~= oldPad then -- but no analog joystick test availbale now! Therefore:
    if math.abs(pad:analogX() - oldPad:analogX())>30 
        or math.abs(pad:analogY() - oldPad:analogY())>30 
        or pad ~= oldPad then

	-- WRITE MODE - FIRST KEYPRESS --	
	if firstkey == 0 or firstkey == 2 then
		y = 2
		
		if pad:square() then	x = 14	firstkey = 1	end
		if pad:circle() then	x = 20	firstkey = 1	end
		if pad:triangle() then	x = 17	firstkey = 1	end
		if pad:cross() then	x = 23	menu_called = 1		firstkey = 1	end

		if pad:left() then	x = 2	firstkey = 1	end
		if pad:right() then	x = 8	firstkey = 1	end
		if pad:up() then	x = 5	firstkey = 1	end
		if pad:down() then	x = 11	firstkey = 1	end
	
		if pad:select() then	

            keybMode = keybMode +1
            if (textMode > 1) then -- in SaveAs, Find, etc  modes there is no cursor mode!
                if (keybMode>2) then keybMode=1 end
            else
                if (keybMode>3) then keybMode=1 end
            end
            keys = keys1
		
			-- caps = not (caps)
			-- if caps == true then
			--	keys = keys2
			-- else
			--	keys = keys1
			-- end
		end

        -- moving the cursor Up, Dwn, etc:
        if pad:analogX() < -100 then
            cursorLeft ()
        end

        if pad:analogX() > 100 then
            cursorRight ()
        end

        if pad:analogY() < -100 then
            cursorUp ()             
        end
        if pad:analogY() > 100 then
            cursorDown ()
        end

        if cursor > (linelen +1) then 
            cursor = linelen 
        end
	 -- WRITE MODE - SECOND KEYPRESS --

	else	-- if firstkey == 0 or firstkey == 2 then

		if pad:square() then	x = x - 1 	y = y - 1	firstkey = 2	end
		if pad:circle() then	x = x + 1	y = y + 1	firstkey = 2	end
		if pad:triangle() then	x = x + 1	y = y - 1	firstkey = 2	end
		if pad:cross() then     x = x - 1	y = y + 1	firstkey = 2	end

		if pad:left() then      x = x - 1	firstkey = 2 end
		if pad:right() then 	x = x + 1 	firstkey = 2 end
		if pad:up() then        y = y - 1 	firstkey = 2 end
		if pad:down() then      y = y + 1	firstkey = 2 end

		-- choosing the character in the middle --
		if pad:select() then	firstkey = 2	end

	end	--	of firstkey

		-- CHECK OF COORDINATE OVERFLOW --
			if y == 4 then y = 1 end
			if y == 0 then y = 3 end
			if x == 25 then x = 1 end
			if x == 0 then 	x = 24 end

		-- A KEY-KOMBINATION HAS BEEN SELECTED ?: 
		if firstkey == 2 then
			firstkey = 0
			value = keys[y][x]
		
		  -- MODIFYING THE STRING BASED ONT THE MENU ?
		  if menu_called ==1 then  
		   
		    menu_called = 0
           if (textMode == 1) then
		     -- TAB --
            if value == "Tab" then
                    if cursor < (string.len(text[linepos]) + 1) then
						text[linepos] = string.sub(text[linepos],1,cursor-1) .. "     " .. string.sub(text[linepos],cursor,string.len(text[linepos]))
					else
						text[linepos] = text[linepos] .. "     "
					end
                    cursor = cursor +5
		    end		

             -- DELETE --
		    if value == "Del" then
                if (textMode == 1) then delAndPull() end
		    end

            -- BackSPACE --
		    if value == "Back" then 
                moveBack() 
		    end

            -- NewLINE --
            if value == "NwLn" then
                addNewLine ()
                checkLines ()
            end

            -- TextVisible --
            if value == "Vsbl" then
                if (textVisivble==1) then
                    textVisivble=0
                else
                    textVisivble=1
                end
            end

            if value == "Home" then
                cursor = 1
            end

            if value == "End" then
                cursor = string.len(text[linepos])+1
            end

            -- NewFILE --
		    if value == "New" then
                makeNewFile()
                -- dispAscii () -- 
		    end

		    if value == "Open" then
                allowBrk = 0
                --filename, newcwd, sorting, types, select,scroll = browser(filetypes,newcwd,sorting,types, select,scroll) 
                --readTxtFile ()
                filename, newcwd, sorting, types, select,scroll = browser(filetypes,newcwd,sorting,types, select,scroll) 
                readTxtFile ()
                linepos = 1
                cursor = 1
                scrollx = 0
                scrolly = 0
                allowBrk = 1
                -- skipKeyPress -- DOES SEEM TO WORK
		    end

		    if value == "Prnt" then
                flnm= getTimeStr () -- filename made based on the date and time
                screen:save(flnm .. ".png")
                -- value = ""
		    end

    	    if value == "Save" then
                textMode = 2 -- input to "inpText" string
                textTyped = 0 -- now let's wait till the filename is typed
                keybMode = 1 -- switch to normal keyboard
                inpText = filename
                WaitAndSave = 1
		    end

    	    if value == "Xprt" then
                flnm= getTimeStr ()
                writeNote(("Note_"..flnm..".txt"))
                --writeTxtFile (newcmd,flnm)
		    end

            if value == "Find" then
                textMode = 2 -- input to "inpText" string
                textTyped = 0 -- now let's wait till the string is typed
                keybMode = 1 -- switch to normal keyboard 
                inpText = ""
                WaitAndFind = 1
                searchFromLine = 1
            end
            if value == "Next" then
                keybMode = 1    -- switch to normal keyboard                 
                WaitAndFind = 1 -- restart the search
            end

          else -- (textMode == 2)  -- the part below contains the functions for SaveAs, etc
       	    
            if value == "NwLn" then
                inpText = ""
                -- textMode = 1
                -- textTyped = 1 -- we were waiting for this moment, now we can Save, or display, or so
		    end

       	    if value == "Back" then
                    sl = string.len(inpText)
                    if sl > 0 then 
                        inpText = string.sub(inpText, 1, sl-1)
                    end
		    end

          end -- (textMode == 1 or..)   

			-- screen:print(1 + 3, 20 + 3, "Value="..value, foreground)
			
		  else -- .. OR TYPING (ADDING A NEW CHAR TO THE LINE)
                if (textMode == 1) then  -- text editing
                    if cursor < (string.len(text[linepos]) + 1) then
						text[linepos] = string.sub(text[linepos],1,cursor-1) .. value .. string.sub(text[linepos],cursor,string.len(text[linepos]))
					else
						text[linepos] = text[linepos] .. value
					end
                    cursor = cursor +1
                else  -- (textMode == 1)~ input string for Search, SaveAs, etc
                    inpText = inpText .. value
                end
            
		  end -- menu_called == 1

		end -- firstkey == 2

		--Moving the cursors PgUP ----
		if pad:r() then
            if textMode == 1 then PgUp()
            else -- we were in search mode
                textTyped = 1 -- we were waiting for this moment, now we can Save, or display, or so
                textMode = 1
            end
		end
        --Moving the cursors PgDn ----
        if pad:l() then
            if textMode == 1 then PgDwn()
            else -- we are in search mode
                WaitAndSave = 0 
                WaitAndFind = 0
                textMode = 1
            end
        end

		-- CHECK FOR ESCAPE --
		if pad:start() then
            if (allowBrk == 1) then brk = 1 end
		end
		oldPad = pad
	end
end -- fnct

-- ==================== moveBack ==================

function moveBack()
               cursorPrev = cursor
               if cursor > 1 then  -- we stay in this line ie. there is space to move to left INSIDE THE LINE
                    if cursor -1 < (string.len(text[linepos]) ) then
						text[linepos] = string.sub(text[linepos],1,cursor-2) .. string.sub(text[linepos],cursor ,string.len(text[linepos]))
					else
						text[linepos] = string.sub(text[linepos], 1, cursor -2)
					end
                    cursor = cursor - 1

                else -- JUMP TO PREVIOUS LINE 
                    if linepos > 1 then
                        -- jump up to prev. line
                       linepos = linepos -1
                       cursor = string.len(text[linepos])+1
                       -- now it could be also 0, ie the order of the next two lines is important!
                       if linepos < starty then starty = linepos-1 
                        end -- 3. FELtoltuk a lathato reszt a kurzorral
                        
                        -- pulling up the line where the cursor was
                        text[linepos] = text[linepos] .. text[linepos+1]
                        -- pulling up the rest of the text
                        count = linepos+2
                    	while count < (numlines)  do
                            text[count] = text[count+1]
                            count = count + 1
                        end
                    text[numlines] = {}
                    numlines = numlines -1  -- kivettuk az utolso sort
                    else linepos = 1
                        -- there was no prev. line to jump to 
                    end -- linepos > 1

                end -- cursor > 1 
end -- fnct

-- ==================== delAndPull ==================
 -- BUGGY; REALLY BUGGY; THE SAME ROUTINE WAS OK IN =0.20; BUT BUGGY 111
function delAndPull()
                cursorPrev = cursor
                -- we stay in this line ie. there is sthng to pull from the RIGHT SIDE of THis LINE
                if (cursor < string.len(text[linepos])+1) then  -- we stay in this line ie. there is sthng to delete from right
                    if cursor -1 < (string.len(text[linepos]) ) then
						text[linepos] = string.sub(text[linepos],1,cursor-1) .. string.sub(text[linepos],cursor +1 ,string.len(text[linepos]))
					else
						text[linepos] = string.sub(text[linepos], 1, cursor -1)
					end
                    cursor = cursor

                else -- todo: jump down to next line

                    if linepos < numlines then
                       -- jump up to prev. line
                       -- linepos = linepos -1
                       -- cursor = string.len(text[linepos])+1
                       -- now it could be also 0, ie the order of the next two lines is important!
                       -- if linepos < starty then starty = linepos-1 
                       -- end -- 3. FELtoltuk a lathato reszt a kurzorral
                        
                        -- pulling up the line below the cursor 
                        text[linepos] = text[linepos] .. text[linepos+1]
                        -- pulling up the rest of the text
                        if linepos+1 < numlines then
                            count = linepos+1
                        else
                            count = linepos -- talan nem is kell, mert alatta tesztelem
                        end
                    	while count < (numlines)  do
                            text[count] = text[count+1]
                            count = count + 1
                        end
                    text[numlines] = {}
                    numlines = numlines -1  -- kivettuk az utolso sort
                    else linepos = numlines
                        -- there was no prev. line to jump to 
                    end -- linepos < numlines

                end -- cursor < string.len(text[linepos])+1) 
end -- fnct


-- ==================== addNewLine =====================

function addNewLine ()
                cursorPrev = cursor
                -- is the cursor at the end of the document?
				if linepos == numlines then
					-- table.setn(text, n + 1)
                    -- are we at the end of the line?
					if cursor < string.len(text[linepos]) + 1 then
						text[linepos+1] = string.sub(text[linepos], cursor, string.len(text[linepos]))
						if cursor > 1 then
                            text[linepos] = string.sub(text[linepos],1,cursor-1)
                        else text[linepos] = " "
                        cursor = 2
                        end
					else
						text[linepos+1] = " "
					end
					linepos = linepos + 1
                    numlines = numlines +1
					cursor = 1
				end

				if linepos < numlines then
					-- table.setn(text, numlines + 1)
					numlines = numlines + 1
					count = numlines + 1            -- really?
					while count > linepos do
						text[count] = text[count - 1]
						count = count - 1
					end
                    -- are we at the end of the line?
					if cursor < string.len(text[linepos]) + 1 then
						text[linepos+1] = string.sub(text[linepos], cursor, string.len(text[linepos]))
                        if cursor > 1 then
                            text[linepos] = string.sub(text[linepos],1,cursor-1)
                        else text[linepos] = " "
                        cursor = 2
                        end
					else
						text[linepos+1] = " "
                        cursor = 2
					end
					linepos = linepos + 1
                    if linepos > (starty+numVisLines) then starty = (linepos - numVisLines) end -- 4.LEltoltuk a lathato reszt a kurzorral
                    -- 
					cursor = 1
				end
				-- if linepos + scrolly > minlines then
					-- scrolly = scrolly - 1
				-- end
end 
