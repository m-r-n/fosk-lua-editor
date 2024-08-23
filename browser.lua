--[[
====================================================
LUA FileBrowser 0.1 by mikehaggar99(at)gmail(dot)com
====================================================
]]

function browser(filetypes,newcwd,sorting,types,select,scroll)
	if string.sub(newcwd,-1)~="/" then
		newcwd=string.format("%s/",newcwd)
	end

	dir = {}

	dir = System.listDirectory(newcwd)
	if sorting==1 then
		table.sort(dir, function (a, b) return string.lower(a.name) < string.lower(b.name) end)
	end
	
	exit=false

	error=math.mod(types,2)+2
	if types < 0 then
		error = 2
	end

	keep = {0,0,0,0}

    oldPad = 0345
	while exit==false do
		pad = Controls.read()
    -- mm
	-- WAIT UNTIL THE KEY IS RELEASED (or PRESSED)--
       if pad ~= oldPad then


		if pad:start() then
			exit=true
		end
		if pad:up() then
			if select < 2 then
				select = 1
			else
				select=select-1
			end
			if (scroll > 0 and select <= scroll) then
				scroll = scroll-1
			end
			error=0
		elseif pad:left() then
			if select < 2 then
				select = 1
			else
				select=select-10
				if select < 1 then
					select=1
				end
			end
			if (scroll > 0 and select <= scroll) then
				scroll = scroll-10
				if scroll < 0 then
					scroll=0
				end
			end
			error=0
		elseif pad:down() then
			if select > table.getn(dir)-1 then
				select = table.getn(dir)
			else
				select=select+1
			end
			if (select > 31) and (scroll < table.getn(dir)-31) then
				scroll = scroll+1
			end
			error=0
		elseif pad:right() then
			if select > table.getn(dir)-10 then
				select = table.getn(dir)
			else
				select=select+10
			end
			if (select > 31) and (scroll < table.getn(dir)-31) then
				scroll = scroll+10
				if scroll > table.getn(dir)-31 then
					scroll = table.getn(dir)-31
				end
			end
			error=0
		elseif pad:triangle() then
			if keep[1]==0 then
				if newcwd~="ms0:/" then
					olddir=string.gsub(string.gsub(newcwd, string.gsub(newcwd, "/[^%/]-/$", "/"),""),"/","")
					newcwd=string.gsub(newcwd, "/[^%/]-/$", "/")
					dir = System.listDirectory(newcwd)
					if sorting==1 then
						table.sort(dir, function (a, b) return string.lower(a.name) < string.lower(b.name) end)
					end
					select=1
					for i=1,table.getn(dir) do
						if string.lower(dir[i].name)==string.lower(olddir) then
							select=i
						end
					end
					scroll=select-31
					if scroll<0 then
						scroll=0
					end
					error=0
				end
			end
			keep[1]=math.mod(keep[1]+1,4)
		elseif pad:cross() then
			if keep[2]==0 then
				if dir[select].name=="." then
					error=0
				elseif dir[select].directory==false then
					mega=false
					for i=1,table.getn(filetypes) do
						if string.lower(filetypes[i])==string.lower(string.sub(dir[select].name,string.len(dir[select].name)-string.len(filetypes[i])+1)) or types==1 then
							mega=true
						end
					end
					if mega==false then
						error=1
					else
						return dir[select].name,newcwd,sorting,types,select,scroll
					end
				elseif dir[select].name==".." then
					olddir=string.gsub(string.gsub(newcwd, string.gsub(newcwd, "/[^%/]-/$", "/"),""),"/","")
					newcwd=string.gsub(newcwd, "/[^%/]-/$", "/")
					dir = System.listDirectory(newcwd)
					if sorting==1 then
						table.sort(dir, function (a, b) return string.lower(a.name) < string.lower(b.name) end)
					end
					select=1
					for i=1,table.getn(dir) do
						if string.lower(dir[i].name)==string.lower(olddir) then
							select=i
						end
					end
					scroll=select-31
					if scroll<0 then
						scroll=0
					end
					error=0
				else
					newcwd=string.format("%s%s/",newcwd,dir[select].name)
					select=1
					scroll=0
					error=0
					dir = System.listDirectory(newcwd)
					if sorting==1 then
						table.sort(dir, function (a, b) return string.lower(a.name) < string.lower(b.name) end)
					end
				end
			end
			keep[2]=math.mod(keep[2]+1,4)
		elseif pad:r() then
			if keep[3]==0 then
				if types<0 then
					error=2
				else
					types=math.mod(types+1,2)
					error=types+2
				end
			end
			keep[3]=math.mod(keep[3]+1,4)
		elseif pad:l() then
			if keep[4]==0 then
				sorting=math.mod(sorting+1,2)
				error=sorting+4
				dir = System.listDirectory(newcwd)
				if sorting==1 then
					table.sort(dir, function (a, b) return string.lower(a.name) < string.lower(b.name) end)
				end
			end
			keep[4]=math.mod(keep[4]+1,4)
		else
			keep = {0,0,0,0}
		end
	
		screen:clear(Color.new(0, 0, 0))
	
		for i=1,table.getn(dir) do
			if i==select then
				textcolor=Color.new(0, 196, 0)
			elseif dir[i].directory then
				textcolor=Color.new(255, 255, 0)
			else
				textcolor=Color.new(255, 255, 255)
			end
	
			if i-scroll <= 31 and i-scroll > 0 then
				if dir[i].directory then
					screen:print(0, 8*(i-scroll)+4, dir[i].name.."/", textcolor)
				else
					screen:print(0, 8*(i-scroll)+4, dir[i].name, textcolor)
				end
			end
		end
	
		if error==1 then
			screen:print(0, 264, "This file type is not supported", Color.new(255, 255, 255))
		elseif error==2 then
			newstring="Open: "
			for i=1,table.getn(filetypes) do
				newstring=string.format("%s*%s ",newstring,filetypes[i])
			end
			screen:print(0, 264, newstring, Color.new(255, 255, 255))
		elseif error==3 then
			screen:print(0, 264, "Open: *.*", Color.new(255, 255, 255))
		elseif error==4 then
			screen:print(0, 264, "Sort by date", Color.new(255, 255, 255))
		elseif error==5 then
			screen:print(0, 264, "Sort by name", Color.new(255, 255, 255))
		end
	
		screen:print(0, 0, newcwd, Color.new(255, 255, 255))
		screen:drawLine(0, 9, 480, 9, Color.new(196, 0, 0))
		screen:drawLine(0, 262, 480, 262, Color.new(196, 0, 0))
		screen.waitVblankStart()
		screen.flip()
		screen.waitVblankStart(3)

    -- mm
    oldPad = pad
	end  -- if oldpad
	end  -- while ..?
	return false
end
