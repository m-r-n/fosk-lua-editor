--[[
===================================================
LUA TextReader 0.2 by mikehaggar99(at)gmail(dot)com
===================================================
]]

dofile("./browser.lua")

filetypes = {}

filetypes[1]=".txt"
filetypes[2]=".lua"
filetypes[3]=".c"
filetypes[4]=".cpp"
filetypes[5]=".htm"
filetypes[6]=".html"

filetypes2 = {}

filetypes2[1]=".mod"
filetypes2[2]=".xm"
filetypes2[3]=".it"

color = {}

color[1] = {Color.new(0, 0, 0),Color.new(0, 0, 192),Color.new(255, 255, 255)}
color[2] = {Color.new(255, 255, 255),Color.new(255, 255, 255),Color.new(0, 0, 0)}
color[3] = {Color.new(0, 192, 0),Color.new(0, 192, 0),Color.new(0, 128, 0)}

newcwd = "ms0:/"
sorting=0
types=0
select=1
scroll=0
palette=1


function textreader(directory,filename)
	text = {}
	keep = {0,0,0}

	file = io.open(string.format("%s%s",directory,filename),"r")

	screen:clear(Color.new(0, 0, 0))

	i=1
	start=0
	startx=0
	cross=0
	mode1=0
	mode2=0
	exit2=false

	line=file:read("*l")

	while line~=nil do
		text[i]=line
		i=i+1
		line=file:read("*l")
	end

	if i>35 then
		k=35
	else
		k=i
	end

	while exit2==false do
		pad = Controls.read()
		if pad:select() then
			exit2=true
		end
		if pad:cross() then
			cross=10
		elseif pad:circle() then
			cross=34
		else
			cross=1
		end

		if pad:square() then
			if Music.playing() then
				Music.stop()
			end
			fileid,filepath = browser(filetypes2,"ms0:/psp/music",1,0,1,0)
			if fileid==false then
			else
				olddir=System.currentDirectory()
				System.currentDirectory(filepath)
				Music.playFile(fileid, loop)
				System.currentDirectory(olddir)
			end
		end

		if pad:down() then
				start=start+cross
				if i<k+start then
					start=i-k
				end
		elseif pad:up() then
				start=start-cross
				if start<0 then
					start=0
				end
		end

		if pad:right() then
				startx=startx+cross
		elseif pad:left() then
				startx=startx-cross
				if startx<0 then
					startx=0
				end
		end

		if pad:l() then
			if keep[1]==0 then
				mode1=math.mod(mode1+1,2)
			end
			keep[1]=math.mod(keep[1]+1,4)
		elseif pad:r() then
			if keep[2]==0 then
				mode2=math.mod(mode2+1,2)
			end
			keep[2]=math.mod(keep[2]+1,4)
		elseif pad:triangle() then
			if keep[3]==0 then
				palette=math.mod(palette,3)+1
			end
			keep[3]=math.mod(keep[3]+1,4)
		else
			keep={0,0,0}
		end

		screen:clear(color[1][palette])

		for j = 1,k-1 do
			if mode2==0 then
				screen:print(0, 8*(j-1), string.format("%s",string.sub(text[j+start],startx,(string.len(text[j+start])-mode1))), color[2][palette])
			else
				screen:print(0, 8*(j-1), string.format("%04d",j+start), color[3][palette])
				screen:print(36, 8*(j-1), string.format("%s",string.sub(text[j+start],startx,(string.len(text[j+start])-mode1))), color[2][palette])
			end
		end

		screen.waitVblankStart()
		screen.flip()
		screen.waitVblankStart(3)

	end
end

while true do
	filename, newcwd, sorting, types, select,scroll = browser(filetypes,newcwd,sorting,types, select,scroll)
	if filename==false then
		if Music.playing() then
			Music.stop()
		end
		break
	else
		textreader(newcwd,filename)
	end
end
