local screen
local coroutines = {}
local function shutdown()
	Beep()
	for i, v in pairs(coroutines) do
		coroutine.close(v)
	end
	if screen ~= nil then
		screen:ClearElements()
	end
	TriggerPort(2)
end
local function ReturnError(errorcode, errortype)
	print("An error has occured")
	if screen ~= nil then
		screen:ClearElements()
		screen:CreateElement("Frame", {
			Size = UDim2.fromOffset(800, 450);
			Position = UDim2.fromOffset(0,0);
			BackgroundColor3 = Color3.fromRGB(115, 185, 255);
			BorderSizePixel = 0;
			ZIndex = 10;
		})
		screen:CreateElement("TextLabel", {
			Size = UDim2.fromOffset(25, 50);
			Position = UDim2.fromOffset(50, 50);
			BackgroundTransparency = 1;
			Text = ":[";
			TextColor3 = Color3.fromRGB(255,255,255);
			TextScaled = true;
			ZIndex = 10;
		})
		screen:CreateElement("TextLabel", {
			Size = UDim2.fromOffset(700, 75);
			Position = UDim2.fromOffset(50, 150);
			BackgroundTransparency = 1;
			Text = "Whoops, the creator messed up and will probably fix this in 5 minutes, I'll just make you wait a few seconds for no reason, then I'll shutdown for you.";
			TextColor3 = Color3.fromRGB(255,255,255);
			TextScaled = true;
			TextWrapped = true;
			TextXAlignment = Enum.TextXAlignment.Left;
			ZIndex = 10;
		})
		screen:CreateElement("TextLabel",{
			Size = UDim2.fromOffset(800, 25);
			Position = UDim2.fromOffset(50, 250);
			Text = errorcode;
			BackgroundTransparency = 1;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextScaled = true;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Top;
			ZIndex = 10;
		})
		local complete = screen:CreateElement("TextLabel",{
			Size = UDim2.fromOffset(200, 25);
			Text = "0% Complete";
			BackgroundTransparency = 1;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			Position = UDim2.fromOffset(50, 300);
			TextXAlignment = Enum.TextXAlignment.Left;
			TextScaled = true;
			ZIndex = 10;
		})
		screen:CreateElement("TextLabel",{
			Size = UDim2.fromOffset(700, 25);
			Text = "Error code: " .. errortype;
			BackgroundTransparency = 1;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			Position = UDim2.fromOffset(50, 375);
			TextXAlignment = Enum.TextXAlignment.Left;
			TextScaled = true;
			ZIndex = 10;
		})
		for i = 0, 5, 1 do
			complete:ChangeProperties({Text = tostring(i * 20) .. "% Complete"})
			wait(1)
		end
		shutdown()
	end
	print(errorcode)
end
local success, errorcode = pcall(function()
	local componentsToFind = {"Keyboard", "Modem", "Microphone", "Speaker", "Disk"}
	local availableComponents = {}
	local iconAmount = 0
	local rom
	local brazil
	local startmenustatus = false
	local canspawnsettings = true
	local disks
	local disksdetected
	local mounteddisks = {}
	local outAmount = 0
	local voicecommands = true
	local connections = {}
	local function xConnect(part, eventname, func, ID)
		if availableComponents[part] ~= nil then
			if connections[part] == nil then
				connections[part] = {}
			end
			if connections[part][eventname] == nil then
				connections[part][eventname] = {}
				availableComponents[part]:Connect(eventname, function(a, b, c, d, e, f)
					for i, v in pairs(connections[part][eventname]) do
						v(a, b, c, d, e, f)
					end
				end)
			end
			connections[part][eventname][ID] = func
		else	
			error("attempted to connect to event " .. eventname .. " of nil component " .. part)
		end
	end
	local cursormoved = {}
	local function screenCursorMoved(func)
		cursormoved[#cursormoved + 1] = func
	end
	local function CreateSelfTestOutput(text, position, color)
		if color == nil then
			color = Color3.fromRGB(255,255,255)
		end
		screen:CreateElement("TextLabel", {
			Position = position;
			Size = UDim2.fromOffset(800, 25);
			Text = text;
			TextScaled = true;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextColor3 = color;
			BorderSizePixel = 0;
			BackgroundTransparency = 1
		})
		outAmount = outAmount + 1
	end
	local function ifNotNilThenSetToThatElseDont(checkWhat, setIfNil)
		if checkWhat ~= nil then
			return checkWhat
		else
			return setIfNil
		end
	end
	local function find(tableToSearch, dataToFind)
		local found = false
		local keyIn
		for i, v in pairs(tableToSearch) do
			if v == dataToFind then
				found = true
				keyIn = i
			end
		end
		return found, keyIn
	end
	local function InitializeROM()
		rom:Write("PuterLibrary", {
			AddWindowElement = function(Window, Element, ElementProperties)
				local element = screen:CreateElement(Element, ElementProperties)
				Window:AddChild(element)
				return element
			end;
			AddElement = function(Parent, Element, Properties)
				local element = screen:CreateElement(Element, Properties)
				Parent:AddChild(element)
				return element
			end;
			PlayAudio = function(audioInputted, Speaker)
				Speaker:Configure({Audio = audioInputted})
				Speaker:Trigger()
			end;
			CreateWindow = function(x, y, temptitle, tempbackgrndcolor, temptitlebarcolor, temptextcolor, overrideX, overrideY)
				local backgrndcolor = ifNotNilThenSetToThatElseDont(tempbackgrndcolor, Color3.fromHex("#646464"))
				local title = ifNotNilThenSetToThatElseDont(temptitle, "App")
				local titlebarcolor = ifNotNilThenSetToThatElseDont(temptitlebarcolor, Color3.fromHex("#000000"))
				local textcolor = ifNotNilThenSetToThatElseDont(temptextcolor, Color3.fromHex("#FFFFFF"))
				--basically sets the backgroundcolor of the window, if nil then it leaves the variable alone
				--centers the window if the override positions are nil
				local posx = ifNotNilThenSetToThatElseDont(overrideX, (800 - x) / 2)
				local posy = ifNotNilThenSetToThatElseDont(overrideY, (450 - y) / 2 - 36)
				local titlebar = screen:CreateElement("TextButton", {
					Size = UDim2.fromOffset(x - 50, 25);
					Position = UDim2.fromOffset(posx, posy);
					Text = title;
					TextColor3 = textcolor;
					BackgroundColor3 = titlebarcolor;
					BorderSizePixel = 0;
					TextScaled = true;
					AutoButtonColor = false;
					ZIndex = 3;
				})
				local closebutton = screen:CreateElement("TextButton", {
					Position = UDim2.fromOffset(x - 25, 0);
					Size = UDim2.fromOffset(25, 25);
					Text = "X";
					TextColor3 = Color3.fromRGB(0,0,0);
					BackgroundColor3 = Color3.fromRGB(255,0,0);
					TextScaled = true;
					BorderSizePixel = 0;
					ZIndex = 3;
				})
				local minimizeButton = screen:CreateElement("TextButton", {
					Position = UDim2.fromOffset(x - 50, 0);
					Size = UDim2.fromOffset(25, 25);
					Text = "-";
					TextColor3 = Color3.fromRGB(0,0,0);
					BackgroundColor3 = Color3.fromRGB(99, 99, 99);
					TextScaled = true;
					BorderSizePixel = 0;
					ZIndex = 3;
				})
				local windowframeContainerContainer = screen:CreateElement("Frame", {
					Size = UDim2.fromOffset(x, y);
					Position = UDim2.fromOffset(0, 25);
					BorderSizePixel = 0;
					BackgroundColor3 = backgrndcolor;
					ZIndex = 3;
					ClipsDescendants = true;
					BackgroundTransparency = 1;
				}) 
				local windowframeContainer = screen:CreateElement("TextButton", {
					Size = UDim2.fromOffset(x, y);
					Position = UDim2.fromOffset(0, 0);
					BorderSizePixel = 0;
					BackgroundColor3 = backgrndcolor;
					ZIndex = 3;
					ClipsDescendants = true;
					BackgroundTransparency = 1;
					TextTransparency = 1;
				}) 
				local windowframe = screen:CreateElement("Frame", {
					Size = UDim2.fromOffset(x, y);
					Position = UDim2.fromOffset(0, 0);
					BorderSizePixel = 0;
					BackgroundColor3 = backgrndcolor;
					ZIndex = 3;
					ClipsDescendants = true;
				})
				windowframeContainerContainer:AddChild(windowframeContainer)
				windowframeContainer:AddChild(windowframe)
				titlebar:AddChild(closebutton)
				titlebar:AddChild(minimizeButton)
				titlebar:AddChild(windowframeContainerContainer)
				local minimized = false
				minimizeButton.MouseButton1Click:Connect(function()
					if minimized == false then
						minimizeButton:ChangeProperties({Text = "+"})
						windowframeContainer:ChangeProperties({Position = UDim2.fromOffset(0, -y)})
						minimized = true
					else
						minimizeButton:ChangeProperties({Text = "-"})
						windowframeContainer:ChangeProperties({Position = UDim2.fromOffset(0, 0)})
						minimized = false
					end
				end)
				closebutton.MouseButton1Click:Connect(function()
					titlebar:Destroy()
				end)
				local offsetX
				local offsetY
				local dragging
				titlebar.MouseButton1Down:Connect(function(x, y)
					offsetX = posx - x
					offsetY = posy - y
					dragging = true
					titlebar:ChangeProperties({ZIndex = 4})
					titlebar:ChangeProperties({ZIndex = 3})
					if string.sub(tostring(offsetX), 1, 1) ~= "-" then
						print("buhhh?")
						print(tostring(offsetX))
					end
					if string.sub(tostring(offsetY), 1, 1) ~= "-" then
						print("buhhh???")
						print(tostring(offsetY))
					end
				end)
				titlebar.MouseButton1Up:Connect(function()
					dragging = false
					offsetX = nil
					offsetY = nil
				end)
				screenCursorMoved(function(cursor)
					if dragging == true then
						posx = cursor.X + offsetX
						posy = cursor.Y + offsetY
						titlebar:ChangeProperties({Position = UDim2.fromOffset(posx, posy)})
					end
				end)
				return windowframe, closebutton, titlebar
			end;
		})
	end
	local function createwOSboot()
		screen:CreateElement("TextLabel", {
			Position = UDim2.fromOffset(350, 225);
			Size = UDim2.fromOffset(100, 50);
			Text = "wOS";
			TextScaled = true;
			TextColor3 = Color3.fromRGB(130, 204, 158);
			BackgroundTransparency = 1
		})
		for i = 0, 1, 1 do
			screen:CreateElement("Frame", {
				Position = UDim2.fromOffset(350, 220 + i * 60);
				Size = UDim2.fromOffset(100, 5);
				BackgroundColor3 = Color3.fromRGB(130, 204, 158);
			})
		end
		screen:CreateElement("TextLabel", {
			Position = UDim2.fromOffset(0, 295);
			Size = UDim2.fromOffset(800, 25);
			Text = "Starting...";
			BackgroundTransparency = 1;
			TextScaled = true;
			TextColor3 = Color3.fromRGB(255,255,255);
		})
	end
	local function InitializeDesktop()
		-- Initialize the desktop (i guess)
		screen:ClearElements()
		local wallpaper = "http://www.roblox.com/asset/?id=1369437447"
		local tempwallpaper
		local storage = availableComponents["storage"]
		if storage ~= nil then
			tempwallpaper = storage:Read("Wallpaper") -- Read the wallpaper (huhh??? idk if its an id)
		end
		if tempwallpaper ~= nil then -- i knew it was an id. anyways this just checks if the temp wallpaper is something, and not nil.
			wallpaper = "http://www.roblox.com/asset/?id=" .. tostring(tempwallpaper)
		end
		-- Start painting the wallpaper
		brazil = screen:CreateElement("Frame", {
			Size = UDim2.fromOffset(800, 450);
			ZIndex = 1
		})
		local explorerApp = screen:CreateElement("TextButton", {
			Position = UDim2.fromOffset(15, 15);
			Size = UDim2.fromOffset(100, 100);
			Text = "Explorer";
			TextScaled = true;
			ZIndex = 3
		})
		local chatApp = screen:CreateElement("TextButton", {
			Position = UDim2.fromOffset(15, 130);
			Size = UDim2.fromOffset(100, 100);
			Text = "Chat";
			TextScaled = true;
			ZIndex = 3
		})
		local diskUtilApp = screen:CreateElement("TextButton", {
			Position = UDim2.fromOffset(15, 245);
			Size = UDim2.fromOffset(100, 100);
			Text = "Disk Utility";
			TextScaled = true;
			ZIndex = 3
		})
		local lagOMeterApp = screen:CreateElement("TextButton", {
			Position = UDim2.fromOffset(130, 15);
			Size = UDim2.fromOffset(100, 100);
			Text = "Lag O'Meter";
			TextScaled = true;
			ZIndex = 3
		})
		local musicApp = screen:CreateElement("TextButton", {
			Position = UDim2.fromOffset(130, 130);
			Size = UDim2.fromOffset(100, 100);
			Text = "Music Player";
			TextScaled = true;
			ZIndex = 3
		})
		iconAmount = iconAmount + 5
		local background = screen:CreateElement("ImageLabel", {
			BorderSizePixel = 0;
			Image = wallpaper;
			Size = UDim2.fromOffset(800, 450);
			ZIndex = 2;
		})
		-- Paint the task bar
		local taskbar = screen:CreateElement("Frame", {
			Position = UDim2.fromOffset(0, 400);
			Size = UDim2.fromOffset(800, 50);
			BackgroundTransparency = 0.3;
			BorderSizePixel = 0;
			ZIndex = 5;
		})
		-- Paint the startbutton
		local startbutton = screen:CreateElement("TextButton", {
			Size = UDim2.fromOffset(50, 50);
			Text = "W";
			BackgroundTransparency = 0.45;
			TextColor3 = Color3.fromRGB(130, 204, 158);
			TextScaled = true;
			ZIndex = 5;
			BackgroundColor3 = Color3.fromRGB(0,0,0);
			BorderSizePixel = 0;
		})
		-- Paint the startmenu
		local startmenu = screen:CreateElement("Frame", {
			BorderSizePixel = 0;
			BackgroundTransparency = 0.3;
			ZIndex = 4;
			Position = UDim2.fromOffset(0, -250);
			Size = UDim2.fromOffset(200, 250);
			BackgroundColor3 = Color3.fromRGB(0,0,0)
		})
		-- Paint the shutdown button
		local shutdownbutton = screen:CreateElement("TextButton", {
			ZIndex = 5;
			Text = "Shutdown";
			TextScaled = true;
			BorderSizePixel = 0;
			Position = UDim2.fromOffset(10, 220);
			Size = UDim2.fromOffset(75, 20);
		})
		-- Paint the restart button
		local restartbutton = screen:CreateElement("TextButton", {
			ZIndex = 5;
			Text = "Restart";
			TextScaled = true;
			BorderSizePixel = 0;
			Position = UDim2.fromOffset(115, 220);
			Size = UDim2.fromOffset(75, 20);
		})
		-- Paint the settings button
		local settingsbutton = screen:CreateElement("TextButton", {
			Position = UDim2.fromOffset(10, 10);
			Size = UDim2.fromOffset(180, 40);
			Text = "Settings";
			TextScaled = true;
			ZIndex = 5
		})
		-- Paint the test button
		local terminal = screen:CreateElement("TextButton", {
			Position = UDim2.fromOffset(10, 60);
			Size = UDim2.fromOffset(180, 40);
			Text = "Terminal";
			TextScaled = true;
			ZIndex = 5
		})
		-- Add all of these items to their specific locations
		background:AddChild(taskbar)
		background:AddChild(explorerApp)
		background:AddChild(chatApp)
		background:AddChild(diskUtilApp)
		background:AddChild(lagOMeterApp)
		background:AddChild(musicApp)
		taskbar:AddChild(startbutton)
		brazil:AddChild(startmenu)
		startmenu:AddChild(shutdownbutton)
		startmenu:AddChild(restartbutton)
		startmenu:AddChild(settingsbutton)
		startmenu:AddChild(terminal)
		-- Assign the start button to open up the start menu
		startbutton.MouseButton1Click:Connect(function()
			if startmenustatus == true then
				brazil:AddChild(startmenu)
				startmenustatus = false
			else
				startbutton:AddChild(startmenu)
				startmenustatus = true
			end
		end)
		-- Return all of these items
		return taskbar, startmenu, startbutton, shutdownbutton, restartbutton, settingsbutton, terminal, background, explorerApp, chatApp, diskUtilApp, lagOMeterApp, musicApp
	end
	local powerCheck
	powerCheck = coroutine.create(function()
		if GetPartFromPort(1, "Instrument") ~= nil then
			while true do
				wait(0.25)
				if tonumber(GetPartFromPort(1, "Instrument"):GetReading(4)) <= 500 then
					screen:ClearElements()
					screen:CreateElement("Frame", {
						BorderSizePixel = 0;
						Size = UDim2.fromOffset(800, 450);
						BackgroundColor3 = Color3.fromRGB(0,0,0);
					})
					screen:CreateElement("TextLabel", {
						Position = UDim2.fromOffset(350, 225);
						Size = UDim2.fromOffset(100, 50);
						Text = "wOS";
						TextScaled = true;
						TextColor3 = Color3.fromRGB(130, 204, 158);
						BackgroundTransparency = 1
					})
					for i = 0, 1, 1 do
						screen:CreateElement("Frame", {
							Position = UDim2.fromOffset(350, 220 + i * 60);
							Size = UDim2.fromOffset(100, 5);
							BackgroundColor3 = Color3.fromRGB(130, 204, 158);
						})
					end
					CreateSelfTestOutput("Error: Insufficient power", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,0,0))
					CreateSelfTestOutput("Error: Shutting down...", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,0,0))
					wait(3)
					coroutine.close(powerCheck)
					screen:ClearElements()
					shutdown()
				end
			end
		else
			CreateSelfTestOutput("Warning: Can't detect power stored", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,255,0))
		end
	end)
	coroutines[#coroutines + 1] = powerCheck
	coroutine.resume(powerCheck)
	local function tableRepilicate(tableToCopy)
		local newTable = {}
		for i, v in pairs(tableToCopy) do
			newTable[i] = v
		end
		return newTable
	end
	-- Continue the init process

	-- Set some variables (for self testing)
	local importantselftest1passed = false
	local importantselftest2passed = false
	local loadBarRoutine
	-- Get the touch screen
	screen = GetPartFromPort(1, "TouchScreen")
	-- Check if the screen is actually existing
	if screen ~= nil then
		-- We succeeded (hooray but not yet)
		availableComponents["screen"] = screen
		screen:Connect("CursorMoved", function(cursor)
			for i, v in pairs(cursormoved) do
				v(cursor)
			end
		end)
		screen:ClearElements()
		screen:CreateElement("Frame", {
			BorderSizePixel = 0;
			Size = UDim2.fromOffset(800, 450);
			BackgroundColor3 = Color3.fromRGB(0,0,0);
		})
		createwOSboot()
		loadBarRoutine = coroutine.create(function()
			local loadingbar = screen:CreateElement("Frame", {
				Size = UDim2.fromOffset(75, 15);
				Position = UDim2.fromOffset(0, 5);
				BackgroundColor3 = Color3.fromRGB(255,255,255);
				BorderSizePixel = 0;
			})
			local loadFrameOut = screen:CreateElement("Frame", {
				Size = UDim2.fromOffset(210, 27);
				Position = UDim2.fromOffset(295, 333);
				BorderSizePixel = 3;
				BackgroundColor3 = Color3.fromRGB(0,0,0);
				ClipsDescendants = true;
				BorderColor3 = Color3.fromRGB(255,255,255);
			})
			local loadFrameIn = screen:CreateElement("Frame", {
				Size = UDim2.fromOffset(200, 25);
				Position = UDim2.fromOffset(5, 1);
				BorderSizePixel = 5;
				BackgroundColor3 = Color3.fromRGB(0,0,0);
				ClipsDescendants = true;
				BorderColor3 = Color3.fromRGB(0,0,0);
			})
			loadFrameOut:AddChild(loadFrameIn)
			loadFrameIn:AddChild(loadingbar)
			while true do
				for i = -75, 200, 25 do
					loadingbar:ChangeProperties({Position = UDim2.fromOffset(i, 5)})
					wait(0.25)
				end
			end
		end)
		coroutines[#coroutines + 1] = loadBarRoutine
		coroutine.resume(loadBarRoutine)
		-- set the variable that the screen check is fine
		importantselftest1passed = true
	else
		screen = GetPartFromPort(1, "Screen")
		if screen ~= nil then
			screen:ClearElements()
			screen:CreateElement("Frame", {
				BorderSizePixel = 0;
				Size = UDim2.fromOffset(800, 450);
				BackgroundColor3 = Color3.fromRGB(0,0,0);
			})
			createwOSboot()
			CreateSelfTestOutput("Error: Bad screen (Must be a TouchScreen)", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,0,0))
			CreateSelfTestOutput("Error: Can't boot!", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,0,0))
		end
	end
	-- Detect the rom and check if it exists
	rom = GetPartFromPort(6, "Disk")
	if rom ~= nil then
		InitializeROM()
		importantselftest2passed = true
	else
		Beep()
		wait(0.5)
		Beep()
		wait(0.5)
		Beep()
		CreateSelfTestOutput("Error: ROM Disk not found on port 6", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,0,0))
		CreateSelfTestOutput("Error: Can't boot!", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,0,0))
	end
	--this thing executes if the ROM disk and the TouchScreen are detected
	if importantselftest1passed == true and importantselftest2passed then
		wait(1)
		for i, v in pairs(componentsToFind) do
			if v == "Disk" then
				local storage = GetPartFromPort(8, v)
				if storage ~= nil then
					if storage:Read("voicecommands") == "false" then
						voicecommands = false
					else
						voicecommands = true
					end
					availableComponents["storage"] = storage
					if availableComponents["modem"] ~= nil then
						availableComponents["modem"]:Configure({NetworkID = storage:Read("ModemID")})
					end
				else
					CreateSelfTestOutput("Warning: Storage disk not found", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,255,0))
				end
			else
				if GetPartFromPort(1, v) ~= nil then
					availableComponents[string.lower(v)] = GetPartFromPort(1, v)
				else
					CreateSelfTestOutput("Warning: " .. v .. " not found", UDim2.fromOffset(10, outAmount * 25 + 10), Color3.fromRGB(255,255,0))
				end
			end
			wait(1)
		end
		local storage = availableComponents["storage"]
		local speaker = availableComponents["speaker"]
		local modem = availableComponents["modem"]
		local keyboard = availableComponents["keyboard"]
		local mic = availableComponents["microphone"]
		disks = GetPartsFromPort(1, "Disk")
		local diskamount = 0
		for i, disk in pairs(disks) do
			if disk ~= nil then
				disksdetected = true
				diskamount = i
				mounteddisks[i] = disk
			end
		end
		CreateSelfTestOutput("Disks detected: " .. tostring(diskamount), UDim2.fromOffset(10, outAmount * 25 + 10))
		wait(1)
		outAmount = 0
		coroutine.close(loadBarRoutine)
		Beep()
		-- this funny thing does funny defining with the InitializeDesktop() function
		local taskbar, startmenu, startbutton, shutdownbutton, restartbutton, settingsbutton, test, background, explorerApp, chatApp, diskUtilApp, lagOMeterApp, musicApp = InitializeDesktop()
		local puter = {
			AddWindowElement = function(Window, Element, ElementProperties)
				local element = screen:CreateElement(Element, ElementProperties)
				Window:AddChild(element)
				return element
			end;
			AddElement = function(Parent, Element, Properties)
				local element = screen:CreateElement(Element, Properties)
				Parent:AddChild(element)
				return element
			end;
			PlayAudio = function(audioInputted, Speaker)
				Speaker:Configure({Audio = audioInputted})
				Speaker:Trigger()
			end;
			CreateWindow = function(x, y, temptitle, tempbackgrndcolor, temptitlebarcolor, temptextcolor, overrideX, overrideY)
				local backgrndcolor = ifNotNilThenSetToThatElseDont(tempbackgrndcolor, Color3.fromHex("#646464"))
				local title = ifNotNilThenSetToThatElseDont(temptitle, "App")
				local titlebarcolor = ifNotNilThenSetToThatElseDont(temptitlebarcolor, Color3.fromHex("#000000"))
				local textcolor = ifNotNilThenSetToThatElseDont(temptextcolor, Color3.fromHex("#FFFFFF"))
				--basically sets the backgroundcolor of the window, if nil then it leaves the variable alone
				--centers the window if the override positions are nil
				local posx = ifNotNilThenSetToThatElseDont(overrideX, (800 - x) / 2)
				local posy = ifNotNilThenSetToThatElseDont(overrideY, (450 - y) / 2 - 36)
				local titlebar = screen:CreateElement("TextButton", {
					Size = UDim2.fromOffset(x - 50, 25);
					Position = UDim2.fromOffset(posx, posy);
					Text = title;
					TextColor3 = textcolor;
					BackgroundColor3 = titlebarcolor;
					BorderSizePixel = 0;
					TextScaled = true;
					AutoButtonColor = false;
					ZIndex = 3;
				})
				local closebutton = screen:CreateElement("TextButton", {
					Position = UDim2.fromOffset(x - 25, 0);
					Size = UDim2.fromOffset(25, 25);
					Text = "X";
					TextColor3 = Color3.fromRGB(0,0,0);
					BackgroundColor3 = Color3.fromRGB(255,0,0);
					TextScaled = true;
					BorderSizePixel = 0;
					ZIndex = 3;
				})
				local minimizeButton = screen:CreateElement("TextButton", {
					Position = UDim2.fromOffset(x - 50, 0);
					Size = UDim2.fromOffset(25, 25);
					Text = "-";
					TextColor3 = Color3.fromRGB(0,0,0);
					BackgroundColor3 = Color3.fromRGB(99, 99, 99);
					TextScaled = true;
					BorderSizePixel = 0;
					ZIndex = 3;
				})
				local windowframeContainerContainer = screen:CreateElement("Frame", {
					Size = UDim2.fromOffset(x, y);
					Position = UDim2.fromOffset(0, 25);
					BorderSizePixel = 0;
					BackgroundColor3 = backgrndcolor;
					ZIndex = 3;
					ClipsDescendants = true;
					BackgroundTransparency = 1;
				}) 
				local windowframeContainer = screen:CreateElement("TextButton", {
					Size = UDim2.fromOffset(x, y);
					Position = UDim2.fromOffset(0, 0);
					BorderSizePixel = 0;
					BackgroundColor3 = backgrndcolor;
					ZIndex = 3;
					ClipsDescendants = true;
					BackgroundTransparency = 1;
					TextTransparency = 1;
				}) 
				local windowframe = screen:CreateElement("Frame", {
					Size = UDim2.fromOffset(x, y);
					Position = UDim2.fromOffset(0, 0);
					BorderSizePixel = 0;
					BackgroundColor3 = backgrndcolor;
					ZIndex = 3;
					ClipsDescendants = true;
				})
				windowframeContainerContainer:AddChild(windowframeContainer)
				windowframeContainer:AddChild(windowframe)
				titlebar:AddChild(closebutton)
				titlebar:AddChild(minimizeButton)
				titlebar:AddChild(windowframeContainerContainer)
				local minimized = false
				minimizeButton.MouseButton1Click:Connect(function()
					if minimized == false then
						minimizeButton:ChangeProperties({Text = "+"})
						windowframeContainer:ChangeProperties({Position = UDim2.fromOffset(0, -y)})
						minimized = true
					else
						minimizeButton:ChangeProperties({Text = "-"})
						windowframeContainer:ChangeProperties({Position = UDim2.fromOffset(0, 0)})
						minimized = false
					end
				end)
				closebutton.MouseButton1Click:Connect(function()
					titlebar:Destroy()
				end)
				local offsetX
				local offsetY
				local dragging
				titlebar.MouseButton1Down:Connect(function(x, y)
					offsetX = posx - x
					offsetY = posy - y
					dragging = true
					titlebar:ChangeProperties({ZIndex = 4})
					titlebar:ChangeProperties({ZIndex = 3})
					if string.sub(tostring(offsetX), 1, 1) ~= "-" then
						print("buhhh?")
						print(tostring(offsetX))
					end
					if string.sub(tostring(offsetY), 1, 1) ~= "-" then
						print("buhhh???")
						print(tostring(offsetY))
					end
				end)
				titlebar.MouseButton1Up:Connect(function()
					dragging = false
					offsetX = nil
					offsetY = nil
				end)
				screenCursorMoved(function(cursor)
					if dragging == true then
						posx = cursor.X + offsetX
						posy = cursor.Y + offsetY
						titlebar:ChangeProperties({Position = UDim2.fromOffset(posx, posy)})
					end
				end)
				return windowframe, closebutton, titlebar
			end;
		}
		local filesystem = {
			createDirectory = function(path, disk)
				print(path)
				if string.sub(path, 1, 1) ~= "/" then
					path = "/" .. path
				end
				if string.sub(path, #path, #path) ~= "/" then
					path = path .. "/"
				end
				disk:Write(path, "t:folder")
				print(path)
			end;
			scanPath = function(path, disk)
				local buffer1 = {}
				local buffer2 = {}
				local buffer3 = {}
				if string.sub(path, #path, #path) ~= "/" then
					path = path .. "/"
				end
				for i, v in pairs(disk:ReadEntireDisk()) do
					if string.sub(i, 1, #path) == path and v ~= nil then
						buffer1[#buffer1 + 1] = string.sub(i, #path + 1, #i)
					end
				end
				for i, v in pairs(buffer1) do
					local added = false
					for i = 1, #v, 1 do
						if string.sub(v, i, i) == "/" and added == false then
							added = true
							if buffer2[string.sub(v, 1, i - 1)] == nil then
								buffer2[string.sub(v, 1, i - 1)] = true
							end
						elseif i == #v and added == false then
							added = true
							if buffer2[string.sub(v, 1, i)] == nil then
								buffer2[string.sub(v, 1, i)] = true
							end
						end
					end
				end
				for i, v in pairs(buffer2) do
					buffer3[#buffer3 + 1] = i
				end
				return buffer3
			end;
			write = function(path, filename, data, disk)
				if string.sub(path, 1, 1) ~= "/" then
					path = "/" .. path
				end
				if string.sub(path, #path, #path) ~= "/" then
					path = path .. "/"
				end
				local badName = false
				for i = 1, #filename, 1 do
					if string.sub(filename, i, i) == "/" then
						badName = true
					end
				end
				if badName == false then
					if disk:Read(path) == "t:folder" then
						disk:Write(path .. filename, data)
						return true, path .. filename
					else
						return false, "not a folder"
					end
				else
					return false, "bad character in name"
				end
			end;
			read = function(path, disk)
				return disk:Read(path)
			end;
		}
		for i, v in pairs(mounteddisks) do
			v:Write("/", "t:folder")
		end
		if mounteddisks[1] ~= nil then
			filesystem.write("/", "DestroyBot", "t:lua/https://gist.github.com/0mori1/912fade7db01d73d4dbff7b287627e73/raw/7fca2440fb964c491a6ab86151c23ba69cf1105d/destroybot.lua", mounteddisks[1])
		end
		local function errorPopup(errorMessage)
			local window, closebutton, titlebar = puter.CreateWindow(250, 150, "Error", Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0), Color3.fromRGB(255,0,0))
			puter.AddWindowElement(window, "TextLabel", {
				Size = UDim2.fromOffset(250, 150);
				Position = UDim2.fromOffset(0,0);
				BorderSizePixel = 0;
				BackgroundTransparency = 1;
				TextColor3 = Color3.fromRGB(255,0,0);
				TextScaled = true;
				Text = errorMessage
			})
		end
		local function popup(message)
			local window, closebutton, titlebar = puter.CreateWindow(250, 150, "Info", Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0), Color3.fromRGB(255,0,0))
			puter.AddWindowElement(window, "TextLabel", {
				Size = UDim2.fromOffset(250, 150);
				Position = UDim2.fromOffset(0,0);
				BorderSizePixel = 0;
				BackgroundTransparency = 1;
				TextColor3 = Color3.fromRGB(255,255,255);
				TextScaled = true;
				Text = message
			})
			return titlebar
		end
		local recorded = {}
		local recordedtext = {}
		local recording = false
		local recordingtext = false
		local displayingallmsgs = false
		local displayingalltextmsgs = false
		local displayingimg = false
		local playingvideo = false
		local canopenlagometer = true
		local canopenmusic = true
		local function luastop(polysilicon)
			polysilicon:Configure({PolysiliconMode = 1})
			TriggerPort(6)
		end
		local function luarun(codetorun, terminalmicrocontroller, polysilicon)
			if terminalmicrocontroller ~= nil and polysilicon ~= nil then
				luastop(polysilicon)
				terminalmicrocontroller:Configure({Code = codetorun})
				polysilicon:Configure({PolysiliconMode = 0})
				wait(0.5)
				TriggerPort(6)
				popup:Destroy()
				print(codetorun)
			end
		end
		local specialCharactersIn = {
			["%0"] = "/";
			["%1"] = ",";
			["%2"] = "%";
		}
		local specialCharactersOut = {
			["/"] = "%0";
			[","] = "%1";
			["%"] = "%2";
		}
		local function decodeRawMusicList(raw)
			local musicList = {}
			--example of an output:
			--{
			--	[1] = {
			--		["name"] = "example"
			--		["id"] = "000000001"
			--	}
			--}
			local name
			local id
			local dataPos = 1
			local readState = nil
			local parsedData = ""
			local skip = 0
			local yes, no = pcall(function()
				for i = 1, #raw, 1 do
					if skip <= 0 then
						print("not skipping")
						if string.sub(raw, i, i) == "%" and specialCharactersIn[string.sub(raw, i, i + 1)] ~= nil then
							parsedData = parsedData .. specialCharactersIn[string.sub(raw, i, i + 1)]
							skip = 1
							print("setting skip to 1")
						elseif string.sub(raw, i, i) == "/" then
							name = parsedData
							parsedData = ""
							dataPos = i + 1
						elseif string.sub(raw, i, i) == "," then
							id = parsedData
							parsedData = ""
							dataPos = i + 1
							musicList[#musicList + 1] = {["name"] = name, ["id"] = id}
						else
							parsedData = parsedData .. string.sub(raw, i, i)
						end
					else
						skip = skip - 1
						print("skipped")
						print(tostring(skip))
					end
				end
			end)
			if yes == false then
				print(no)
				print("WAAAAAAAAAAAAAAAAAA")
			end
			return musicList
		end
		local function encodeMusicList(musicList)
			local encoded = ""
			for i, v in pairs(musicList) do
				if v ~= nil then
					for i2, v2 in pairs(v) do
						for i = 1, #v2, 1 do
							if specialCharactersOut[string.sub(v2, i, i)] ~= nil then
								encoded = encoded .. specialCharactersOut[string.sub(v2, i, i)]
							else
								encoded = encoded .. string.sub(v2, i, i)
							end
						end
						if i2 ~= "id" then
							encoded = encoded .. "/"
						end
					end
					encoded = encoded .. ","
				end
			end
			return encoded
		end
		local checkBlacklist = {
			["Hail12Pink"] = "no perms for me, no perms for you, 12pink, no forgiveness.";
		}
		local function check(text, plr, polysilicon, terminalmicrocontroller, terminalout)
			if checkBlacklist[plr] == nil then
				if string.sub(text, 1, 7) == "lua run" then
					luarun(string.sub(text, 9, #text), terminalmicrocontroller, polysilicon)
				elseif string.sub(text, 1, 8) == "lua stop" then
					luastop(polysilicon)
				elseif text == "shutdown" or text == "die" then
					shutdown()
				elseif text == "restart" then
					screen:ClearElements()
					for i, v in pairs(coroutines) do
						coroutine.close(v)
					end
					TriggerPort(3)
				elseif text == "record" then
					recording = true
				elseif text == "stop recording" then
					recording = false
				elseif string.sub(text, 1, 12) == "setwallpaper" then
					local image = tostring(string.sub(text, 14, #text))
					if storage ~= nil then
						storage:Write("Wallpaper", image)
					end
					background:ChangeProperties({Image = "http://www.roblox.com/asset/?id=" .. image})
				elseif string.sub(text, 1, 21) == "play recorded message" then
					local message = recorded[tonumber(string.sub(text, 23, #text))]
					terminalout(tostring(message))
				elseif string.sub(text, 1, 17) == "play all messages" then
					if displayingallmsgs == false then
						local frame, closebutton = puter.CreateWindow(500, 225, "All Messages")
						displayingallmsgs = true
						closebutton.MouseButton1Click:Connect(function()
							displayingallmsgs = false
						end)
						local scrollingframe = puter.AddWindowElement(frame, "ScrollingFrame", {
							ScrollBarThickness = 6;
							Size = UDim2.fromOffset(500, 225);
						})
						for i, message in pairs(recorded) do
							local textlabel = puter.AddWindowElement(frame, "TextLabel", {
								Size = UDim2.fromOffset(494, 50);
								Position = UDim2.fromOffset(0, (i - 1) * 50);
								Text = message;
								TextScaled = true;
							})
							scrollingframe:ChangeProperties({CanvasSize = UDim2.fromOffset(0, i * 50)})
							scrollingframe:AddChild(textlabel)
							print(message)
						end
					end
				elseif text == "clear recorded" then
					recorded = {}
				elseif string.sub(text, 1, 10) == "play audio" then
					if speaker ~= nil then
						speaker:Configure({Pitch = 1})
						puter.PlayAudio(string.sub(text, 12, #text), speaker)
					end
				elseif string.sub(text, 1, 13) == "display image" then
					local image = string.sub(text, 15, #text)
					if displayingimg == false then
						local frame, closebutton = puter.CreateWindow(400, 250, "ImageViewer")
						closebutton.MouseButton1Click:Connect(function()
							displayingimg = false
						end)
						displayingimg = true
						puter.AddWindowElement(frame , "ImageLabel", {
							Image = "http://www.roblox.com/asset/?id=" .. image;
							Size = UDim2.fromOffset(400, 225);
						})
						local setwallpaper = puter.AddWindowElement(frame, "TextButton", {
							Size = UDim2.fromOffset(400, 25);
							Position = UDim2.fromOffset(0, 225);
							Text = "Set As Wallpaper";
							TextColor3 = Color3.fromHex("#FFFFFF");
							BackgroundColor3 = Color3.fromHex("#000000");
							TextScaled = true;
						})
						setwallpaper.MouseButton1Click:Connect(function()
							if storage ~= nil then
								storage:Write("Wallpaper", image)
							end
							background:ChangeProperties({Image = "http://www.roblox.com/asset/?id=" .. image})
						end)
					end
				elseif string.sub(text, 1, 10) == "setmodemid" then
					if storage ~= nil then
						storage:Write("ModemID", string.sub(text, 12, #text))
					end
					if modem ~= nil then
						modem:Configure({NetworkID = string.sub(text, 12, #text)})
					end
				elseif text == "record text" then
					recordingtext = true
				elseif text == "stop recording text" then
					recordingtext = false
				elseif string.sub(text, 1, 26) == "play recorded text message" then
					local message = recordedtext[tonumber(string.sub(text, 28, #text))]
					terminalout(tostring(message))
				elseif string.sub(text, 1, 22) == "play all text messages" then
					if displayingallmsgs == false then
						local frame, closebutton = puter.CreateWindow(500, 225, "All Text Messages")
						displayingallmsgs = true
						closebutton.MouseButton1Click:Connect(function()
							displayingallmsgs = false
						end)
						local scrollingframe = puter.AddWindowElement(frame, "ScrollingFrame", {
							ScrollBarThickness = 6;
							Size = UDim2.fromOffset(500, 225);
						})
						for i, message in pairs(recordedtext) do
							local textlabel = puter.AddWindowElement(frame, "TextLabel", {
								Size = UDim2.fromOffset(494, 50);
								Position = UDim2.fromOffset(0, (i - 1) * 50);
								Text = message;
								TextScaled = true;
							})
							scrollingframe:ChangeProperties({CanvasSize = UDim2.fromOffset(0, i * 50)})
							scrollingframe:AddChild(textlabel)
							print(message)
						end
					end
				elseif text == "clear recorded text" then
					recordedtext = {}
				elseif string.sub(text, 1, 9) == "set pitch" then
					if speaker ~= nil then
						local pitch = string.sub(text, 11, #text)
						speaker:Configure({Pitch = pitch})
						speaker:Trigger()
					end
				elseif string.sub(text, 1, 8) == "disk run" then
					if GetPartFromPort(4, "Disk") ~= nil then
						if GetPartFromPort(4, "Disk"):Read(string.sub(text, 10, #text)) ~= nil then
							luastop(polysilicon)
							luarun(GetPartFromPort(4, "Disk"):Read(string.sub(text, 10, #text)), terminalmicrocontroller, polysilicon)
						else
							return true, "could not find data on specified key"
						end
					else
						return true, "please insert a disk"
					end
				elseif string.sub(text, 1, 10) == "play video" then
					local image = string.sub(text, 12, #text)
					local playing = false
					if playingvideo == false then
						local frame, closebutton = puter.CreateWindow(400, 225, "Video Player")
						local video = puter.AddWindowElement(frame, "VideoFrame", {
							Video = "http://www.roblox.com/asset/?id=" .. image;
							Size = UDim2.fromOffset(400, 225);
							Playing = true;
							Looped = true;
							Volume = 100
						})
					end
				elseif text == "reset" then
					storage:ClearDisk()
				elseif text == "crash" then
					ReturnError("Manual Crash", "MANUAL_CRASH")
				else
					return true, "no such command"
				end
			else
				return true, checkBlacklist[plr]
			end
		end
		local knownFileTypes = {
			["lua"] = function(code)
				luarun(code, GetPartFromPort(6, "Microcontroller"), GetPartFromPort(6, "Polysilicon"))
			end;
			["image"] = function(imageID)
				check("display image " .. imageID, "explorer.exe", GetPartFromPort(6, "Microcontroller"), GetPartFromPort(6, "Polysilicon"), function() end)
			end;
			["audio"] = function(audioID)
				puter.PlayAudio(audioID, speaker)
			end;
			["video"] = function(videoID)
				check("play video " .. videoID, "explorer.exe", GetPartFromPort(6, "Microcontroller"), GetPartFromPort(6, "Polysilicon"), function() end)
			end;
		}
		local fileTypeNames = {
			["lua"] = "Lua Script";
			["image"] = "Image";
			["audio"] = "Audio";
			["video"] = "Video";
			["folder"] = "Folder"
		}
		local function typeParser(input)
			if input == "t:folder" then
				return "folder", input, "t:folder"
			elseif string.sub(input, 1, 2) == "t:" then
				for i = 1, #input, 1 do
					if string.sub(input, i, i) == "/" then
						if knownFileTypes[string.sub(input, 3, i - 1)] ~= nil or string.sub(input, 3, i - 1) == "folder" then
							print(string.sub(input, 1, i - 1))
							return string.sub(input, 3, i - 1), string.sub(input, i + 1, #input), string.sub(input, 1, i - 1)
						else
							print(string.sub(input, 1, i - 1))
							print("i dont recognize this")
							return "Unknown", string.sub(input, i + 1, #input), string.sub(input, 1, i - 1)
						end
					end
				end
			else
				print("theres no header")
				return "Unknown", input, "unknown"
			end
		end
		local function lagometer()
			if canopenlagometer == true then
				canopenlagometer = false
				local window, closebutton = puter.CreateWindow(400, 225, "Lag O'Meter", Color3.fromRGB(0,0,0))
				local currentFPS = puter.AddWindowElement(window, "TextLabel", {
					Size = UDim2.fromOffset(50, 50);
					Position = UDim2.fromOffset(350, 0);
					TextColor3 = Color3.fromRGB(255,255,255);
					BackgroundTransparency = 1;
					TextScaled = true;
					Text = "N/A";
				})
				local lagHistoryFrame = puter.AddWindowElement(window, "Frame", {
					Size = UDim2.fromOffset(350, 85);
					Position = UDim2.fromOffset(0, 140);
					BackgroundColor3 = Color3.fromRGB(0,0,0);
					BorderSizePixel = 0;
				})
				local lag = {}
				local function addFramerate(framerate)
					if #lag <= 13 then
						lag[#lag + 1] = framerate
					elseif #lag >= 14 then
						for i, v in pairs(lag) do
							if i >= 2 then
								lag[i - 1] = lag[i]
							end
						end
						lag[14] = framerate
					end
				end
				local lagMeasurer = coroutine.create(function()
					while true do
						local curTime = tick()
						wait(1)
						local difference = tick() - curTime
						local framerate = math.floor(60 / difference)
						addFramerate(framerate)
						local color
						if framerate >= 45 then
							color = Color3.fromRGB(0,255,0)
						elseif framerate >= 30 then
							color = Color3.fromRGB(255,255,0)
						elseif framerate >= 15 then
							color = Color3.fromRGB(255,126,0)
						elseif framerate >= 1 then
							color = Color3.fromRGB(255,0,0)
						else
							color = Color3.fromRGB(143, 255, 244)
						end
						currentFPS:ChangeProperties({Text = tostring(framerate); TextColor3 = color;})
					end
				end)
				local lagHistory = coroutine.create(function()
					while true do 
						wait(0.5)
						lagHistoryFrame:Destroy()
						lagHistoryFrame = puter.AddWindowElement(window, "Frame", {
							Size = UDim2.fromOffset(350, 85);
							Position = UDim2.fromOffset(0, 140);
							BackgroundColor3 = Color3.fromRGB(0,0,0);
							BorderSizePixel = 0;
						})
						for i, v in pairs(lag) do
							local color
							local size
							if v >= 45 then
								color = Color3.fromRGB(0,255,0)
							elseif v >= 30 then
								color = Color3.fromRGB(255,255,0)
							elseif v >= 15 then
								color = Color3.fromRGB(255,126,0)
							elseif v >= 1 then
								color = Color3.fromRGB(255,0,0)
							else
								color = Color3.fromRGB(143, 255, 244)
							end
							if v >= 1 then
								size = UDim2.fromOffset(25,v)
							else
								size = UDim2.fromOffset(25, 60)
							end
							local lagBar = puter.AddElement(lagHistoryFrame, "Frame", {
								Size = size;
								BackgroundColor3 = color;
								BorderSizePixel = 0;
								Position = UDim2.fromOffset((i - 1) * 25, 60 - v + 25)
							})
							local lagAmount = puter.AddElement(lagBar, "TextLabel", {
								Size = UDim2.fromOffset(15, 15);
								Position = UDim2.fromOffset(5, -20);
								Text = tostring(v);
								TextScaled = true;
								TextColor3 = color;
								BackgroundTransparency = 1;
							})
						end
					end
				end)
				coroutines[#coroutines + 1] = lagMeasurer
				coroutine.resume(lagMeasurer)
				coroutines[#coroutines + 1] = lagHistory
				coroutine.resume(lagHistory)
				closebutton.MouseButton1Click:Connect(function()
					coroutine.close(lagMeasurer)
					coroutine.close(lagHistory)
					canopenlagometer = true
				end)
			end
		end
		lagOMeterApp.MouseButton1Click:Connect(function()
			lagometer()
		end)
		local function musicPlayer()
			if canopenmusic == true then
				local musicList
				local canopenadd = true
				local window, closebutton = puter.CreateWindow(400, 300, "Music Player")
				closebutton.MouseButton1Click:Connect(function()
					canopenmusic = true
				end)
				canopenmusic = false
				if storage:Read("musicList") ~= nil then
					musicList = decodeRawMusicList(storage:Read("musicList"))
				else
					musicList = {}
					storage:Write("musicList", encodeMusicList(musicList))
				end
				local addButton = puter.AddWindowElement(window, "TextButton", {
					BackgroundColor3 = Color3.fromRGB(0,255,0);
					Text = "Add";
					TextScaled = true;
					TextColor3 = Color3.fromRGB(0,0,0);
					BorderSizePixel = 0;
					Position = UDim2.fromOffset(50,0);
					Size = UDim2.fromOffset(250, 25);
				})
				local space = puter.AddWindowElement(window, "TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0,0,0);
					Text = tostring(#musicList) .. " / 70";
					TextScaled = true;
					TextColor3 = Color3.fromRGB(255,255,255);
					BorderSizePixel = 0;
					Position = UDim2.fromOffset(0,0);
					Size = UDim2.fromOffset(50, 25);
				})
				local nameLabel = puter.AddWindowElement(window, "TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0,0,0);
					Text = "Name";
					TextScaled = true;
					TextColor3 = Color3.fromRGB(255,255,255);
					BorderSizePixel = 0;
					Position = UDim2.fromOffset(0,25);
					Size = UDim2.fromOffset(150, 25);
				})
				local idlabel = puter.AddWindowElement(window, "TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0,0,0);
					Text = "Audio ID";
					TextScaled = true;
					TextColor3 = Color3.fromRGB(255,255,255);
					BorderSizePixel = 0;
					Position = UDim2.fromOffset(150,25);
					Size = UDim2.fromOffset(150, 25);
				})
				local actionLabel = puter.AddWindowElement(window, "TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0,0,0);
					Text = "Actions";
					TextScaled = true;
					TextColor3 = Color3.fromRGB(255,255,255);
					BorderSizePixel = 0;
					Position = UDim2.fromOffset(300,25);
					Size = UDim2.fromOffset(100, 25);
				})
				local scrollFrame = puter.AddWindowElement(window, "ScrollingFrame", {
					Size = UDim2.fromOffset(400, 250);
					Position = UDim2.fromOffset(0, 50);
					BackgroundColor3 = Color3.fromRGB(86, 86, 86);
					ScrollBarThickness = 2;
					ScrollingDirection = Enum.ScrollingDirection.Y;
					CanvasSize = UDim2.fromOffset(0, 0);
				})
				local function refresh()
					musicList = decodeRawMusicList(storage:Read("musicList"))
					space:ChangeProperties({Text = tostring(#musicList) .. " / 70"})
					scrollFrame:Destroy()
					scrollFrame = puter.AddWindowElement(window, "ScrollingFrame", {
						Size = UDim2.fromOffset(400, 250);
						Position = UDim2.fromOffset(0, 50);
						BackgroundColor3 = Color3.fromRGB(86, 86, 86);
						ScrollBarThickness = 2;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						CanvasSize = UDim2.fromOffset(0, 0);
					})
					for i, v in pairs(musicList) do
						local parentFrame = puter.AddElement(scrollFrame, "Frame", {
							Size = UDim2.fromOffset(398, 25);
							Position = UDim2.fromOffset(0, (i - 1) * 25);
							BackgroundTransparency = 1;
						})
						scrollFrame:ChangeProperties({CanvasSize = UDim2.fromOffset(0, i * 25)})
						for i2, v2 in pairs(v) do
							if i2 == "name" then
								puter.AddElement(parentFrame, "TextLabel", {
									Size = UDim2.fromOffset(150, 25);
									Position = UDim2.fromOffset(0, 0);
									Text = v2;
									TextColor3 = Color3.fromRGB(255,255,255);
									TextScaled = true;
									BackgroundTransparency = 1;
								})
							elseif i2 == "id" then
								puter.AddElement(parentFrame, "TextLabel", {
									Size = UDim2.fromOffset(150, 25);
									Position = UDim2.fromOffset(150, 0);
									Text = v2;
									TextColor3 = Color3.fromRGB(255,255,255);
									TextScaled = true;
									BackgroundTransparency = 1;
								})
								local playButton = puter.AddElement(parentFrame, "TextButton", {
									Text = "Play";
									TextScaled = true;
									TextColor3 = Color3.fromRGB(0,0,0);
									BackgroundColor3 = Color3.fromRGB(0,255,0);
									BorderSizePixel = 0;
									Size = UDim2.fromOffset(49, 25);
									Position = UDim2.fromOffset(300, 0);
								})
								playButton.MouseButton1Click:Connect(function()
									puter.PlayAudio(v2, speaker)
								end)
								local clickedDelete = false
								local deleteButton = puter.AddElement(parentFrame, "TextButton", {
									Text = "Delete";
									TextScaled = true;
									TextColor3 = Color3.fromRGB(0,0,0);
									BackgroundColor3 = Color3.fromRGB(255,0,0);
									BorderSizePixel = 0;
									Size = UDim2.fromOffset(49, 25);
									Position = UDim2.fromOffset(349, 0);
								})
								deleteButton.MouseButton1Click:Connect(function()
									if clickedDelete == true then
										musicList[i] = nil
										storage:Write("musicList", encodeMusicList(musicList))
										parentFrame:Destroy()
										refresh()
									else
										deleteButton:ChangeProperties({Text  = "Are you sure?"})
										clickedDelete = true
										wait(2.5)
										if deleteButton ~= nil then
											deleteButton:ChangeProperties({Text = "Delete"})
										end
										clickedDelete = false
									end
								end)
							end
						end
					end
				end
				local refreshButton = puter.AddWindowElement(window, "TextButton", {
					BackgroundColor3 = Color3.fromRGB(0,0,0);
					Text = "Refresh";
					TextScaled = true;
					TextColor3 = Color3.fromRGB(255,255,255);
					BorderSizePixel = 0;
					Position = UDim2.fromOffset(300,0);
					Size = UDim2.fromOffset(100, 25);
				})
				refreshButton.MouseButton1Click:Connect(function()
					refresh()
				end)
				refresh()
				addButton.MouseButton1Click:Connect(function()
					if canopenadd == true then
						local window, closebutton = puter.CreateWindow(400, 300, "Add Music")
						closebutton.MouseButton1Click:Connect(function()
							canopenadd = true
						end)
						canopenadd = false
						local focusedon = nil
						local name
						local id
						local musicName = puter.AddWindowElement(window, "TextButton", {
							Text = "Music Name:";
							TextScaled = true;
							TextColor3 = Color3.fromRGB(0,0,0);
							BackgroundColor3 = Color3.fromRGB(77, 77, 77);
							Size = UDim2.fromOffset(380, 25);
							Position = UDim2.fromOffset(10, 10);
						})
						local musicId = puter.AddWindowElement(window, "TextButton", {
							Text = "Music ID:";
							TextScaled = true;
							TextColor3 = Color3.fromRGB(0,0,0);
							BackgroundColor3 = Color3.fromRGB(77, 77, 77);
							Size = UDim2.fromOffset(380, 25);
							Position = UDim2.fromOffset(10, 45);
						})
						local okbutton = puter.AddWindowElement(window, "TextButton", {
							Text = "Add";
							TextColor3 = Color3.fromRGB(0,0,0);
							TextScaled = true;
							Size = UDim2.fromOffset(100, 25);
							Position = UDim2.fromOffset(150, 250);
							BackgroundColor3 = Color3.fromRGB(77, 77, 77);
						})
						musicName.MouseButton1Click:Connect(function()
							focusedon = "name"
							musicName:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
							musicId:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
						end)
						musicId.MouseButton1Click:Connect(function()
							focusedon = "id"
							musicId:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
							musicName:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
						end)
						okbutton.MouseButton1Click:Connect(function()
							if name ~= nil then
								if id ~= nil then
									if #musicList <= 69 then
										musicList[#musicList + 1] = {["name"] = name, ["id"] = id}
										storage:Write("musicList", encodeMusicList(musicList))
										refresh()
										local success = puter.AddWindowElement(window, "TextLabel", {
											Text = "saved";
											Size = UDim2.fromOffset(400, 25);
											Position = UDim2.fromOffset(0, 225);
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,255,0);
											BackgroundTransparency = 1;
										})
										wait(1)
										success:Destroy()
									else
										local err = puter.AddWindowElement(window, "TextLabel", {
											Text = "out of space";
											Size = UDim2.fromOffset(400, 25);
											Position = UDim2.fromOffset(0, 225);
											TextScaled = true;
											TextColor3 = Color3.fromRGB(255,0,0);
											BackgroundTransparency = 1;
										})
										wait(1)
										err:Destroy()
									end
								else
									local err = puter.AddWindowElement(window, "TextLabel", {
										Text = "please input an ID";
										Size = UDim2.fromOffset(400, 25);
										Position = UDim2.fromOffset(0, 225);
										TextScaled = true;
										TextColor3 = Color3.fromRGB(255,0,0);
										BackgroundTransparency = 1;
									})
									wait(1)
									err:Destroy()
								end
							else
								local err = puter.AddWindowElement(window, "TextLabel", {
									Text = "please input a name";
									Size = UDim2.fromOffset(400, 25);
									Position = UDim2.fromOffset(0, 225);
									TextScaled = true;
									TextColor3 = Color3.fromRGB(255,0,0);
									BackgroundTransparency = 1;
								})
								wait(1)
								err:Destroy()
							end
						end)
						xConnect("keyboard", "TextInputted", function(text, plr)
							text = string.sub(text, 1, #text - 1)
							if focusedon == "name" then
								name = text
								musicName:ChangeProperties({Text = "Music Name: " .. text})
							elseif focusedon == "id" then
								id = text
								musicId:ChangeProperties({Text = "Music ID: " .. text})
							end
						end, "addMusic")
					end
				end)
			end
		end
		musicApp.MouseButton1Click:Connect(function()
			musicPlayer()
		end)
		shutdownbutton.MouseButton1Click:Connect(function()
			shutdown()
		end)
		restartbutton.MouseButton1Click:Connect(function()
			screen:ClearElements()
			for i, v in pairs(coroutines) do
				coroutine.close(v)
			end
			Beep()
			TriggerPort(3)
		end)
		local canopenexplorer = true
		explorerApp.MouseButton1Click:Connect(function()
			if canopenexplorer == true then
				local explorerwindow, closeexplorer = puter.CreateWindow(500, 300, "Explorer")
				canopenexplorer = false
				local function openMainExplorer()
					puter.AddWindowElement(explorerwindow, "TextLabel", {
						Size = UDim2.fromOffset(300, 25);
						Text = "Filename";
						TextScaled = true;
						TextColor3 = Color3.fromRGB(255,255,255);
						BackgroundColor3 = Color3.fromRGB(0,0,0);
						Position = UDim2.fromOffset(0, 50);
						BorderSizePixel = 0;
					})
					puter.AddWindowElement(explorerwindow, "TextLabel", {
						Size = UDim2.fromOffset(200, 25);
						Text = "Type";
						TextScaled = true;
						TextColor3 = Color3.fromRGB(255,255,255);
						BackgroundColor3 = Color3.fromRGB(0,0,0);
						Position = UDim2.fromOffset(300, 50);
						BorderSizePixel = 0;
					})
					local actionParentFrame = puter.AddWindowElement(explorerwindow, "Frame", {
						Size = UDim2.fromOffset(500, 25);
						Position = UDim2.fromOffset(0,0);
						BackgroundColor3 = Color3.fromRGB(44, 44, 44);
						BorderSizePixel = 0;
					})
					local called = true
					local path = "Disk View"
					local viewingDisk
					local pathLabel = puter.AddWindowElement(explorerwindow, "TextLabel", {
						Size = UDim2.fromOffset(495, 25);
						Position = UDim2.fromOffset(5, 25);
						BorderSizePixel = 0;
						BackgroundTransparency = 1;
						TextColor3 = Color3.fromRGB(255,255,255);
						TextScaled = true;
						Text = path;
						TextXAlignment = Enum.TextXAlignment.Left;
					})
					local fileFrame
					local canopencfolder = true
					local canopencfile = true
					local actionFile = puter.AddElement(actionParentFrame, "TextButton", {
						Size = UDim2.fromOffset(50, 25);
						Text = "File";
						TextScaled = true;
						TextColor3 = Color3.fromRGB(255,255,255);
						BackgroundColor3 = Color3.fromRGB(44, 44, 44);
						Position = UDim2.fromOffset(0, 0);
						BorderSizePixel = 0;
					})
					local actionRefresh = puter.AddElement(actionParentFrame, "TextButton", {
						Size = UDim2.fromOffset(75, 25);
						Text = "Refresh";
						TextScaled = true;
						TextColor3 = Color3.fromRGB(255,255,255);
						BackgroundColor3 = Color3.fromRGB(44, 44, 44);
						Position = UDim2.fromOffset(75, 0);
						BorderSizePixel = 0;
					})
					local mainScrollFrame = puter.AddWindowElement(explorerwindow, "ScrollingFrame", {
						Size = UDim2.fromOffset(500, 225);
						Position = UDim2.fromOffset(0, 75);
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.fromRGB(60, 60, 60);
						ScrollBarThickness = 2;
						CanvasSize = UDim2.fromOffset(0,0);
					})
					local canopenproperties = true
					local function deleteFolder(path, disk)
						if string.sub(path, #path, #path) ~= "/" then
							path = path .. "/"
						end
						disk:Write(path, nil)
						local childFiles = filesystem.scanPath(path, disk)
						for i, v in pairs(childFiles) do
							if filesystem.read(path .. v .. "/", disk) ~= nil then
								deleteFolder(path .. v .. "/", disk)
							elseif filesystem.read(path .. v, disk) ~= nil then
								disk:Write(path .. v, nil)
							end
						end
					end
					local function addFile(fileName, fileType, position, data, trueType, trueData)
						local cachedpath = path .. fileName
						local cachedDisk = viewingDisk
						local parentFrame = puter.AddElement(mainScrollFrame, "Frame", {
							Size = UDim2.fromOffset(498, 25);
							Position = position;
							BorderSizePixel = 0;
							BackgroundTransparency = 1;
						})
						local fileNameButton = puter.AddElement(parentFrame, "TextButton", {
							Size = UDim2.fromOffset(300, 25);
							Position = UDim2.fromOffset(0,0);
							BackgroundColor3 = Color3.fromRGB(100,100,100);
							BorderSizePixel = 0;
							TextColor3 = Color3.fromRGB(255,255,255);
							TextScaled = true;
							Text = fileName
						})
						local fileTypeName
						if fileTypeNames[fileType] ~= nil then
							fileTypeName = fileTypeNames[fileType]
						else
							fileTypeName = "Unknown"
						end
						puter.AddElement(parentFrame, "TextLabel", {
							Size = UDim2.fromOffset(148, 25);
							Position = UDim2.fromOffset(300,0);
							BackgroundColor3 = Color3.fromRGB(100,100,100);
							BorderSizePixel = 0;
							TextColor3 = Color3.fromRGB(255,255,255);
							TextScaled = true;
							Text = fileTypeName
						})
						local propertiesbutton = puter.AddElement(parentFrame, "TextButton", {
							Size = UDim2.fromOffset(50, 25);
							Position = UDim2.fromOffset(448,0);
							BackgroundColor3 = Color3.fromRGB(100,100,100);
							BorderSizePixel = 0;
							TextColor3 = Color3.fromRGB(255,255,255);
							TextScaled = true;
							Text = "Properties"
						})
						fileNameButton.MouseButton1Click:Connect(function()
							local thingToDo = knownFileTypes[fileType]
							print(fileType)
							if thingToDo ~= nil then
								thingToDo(data)
							elseif fileType == "folder" then
								if filesystem.read(cachedpath .. "/", cachedDisk) == "t:folder" then
									if string.sub(path, #path, #path) ~= "/" then
										path = path .. "/"
									end
									path = cachedpath .. "/"
									called = true
								else
									called = true
								end
							else
								errorPopup("Unknown file type")
							end
						end)
						propertiesbutton.MouseButton1Click:Connect(function()
							if canopenproperties == true then
								local yes, bruh = pcall(function()
									local window, closebutton, titlebar = puter.CreateWindow(300, 300, "Properties")
									closebutton.MouseButton1Click:Connect(function()
										canopenproperties = true
									end)
									canopenproperties = false
									puter.AddWindowElement(window, "TextLabel", {
										Size = UDim2.fromOffset(280, 25);
										Position = UDim2.fromOffset(10, 10);
										BorderSizePixel = 0;
										BackgroundTransparency = 1;
										TextColor3 = Color3.fromRGB(255,255,255);
										TextScaled = true;
										Text = "Filename: " .. fileName;
									})
									puter.AddWindowElement(window, "TextLabel", {
										Size = UDim2.fromOffset(280, 25);
										Position = UDim2.fromOffset(10, 45);
										BorderSizePixel = 0;
										BackgroundTransparency = 1;
										TextColor3 = Color3.fromRGB(255,255,255);
										TextScaled = true;
										Text = "Path: " .. path;
										TextXAlignment = Enum.TextXAlignment.Left;
									})
									puter.AddWindowElement(window, "TextLabel", {
										Size = UDim2.fromOffset(280, 25);
										Position = UDim2.fromOffset(10, 80);
										BorderSizePixel = 0;
										BackgroundTransparency = 1;
										TextColor3 = Color3.fromRGB(255,255,255);
										TextScaled = true;
										Text = "Type: " .. fileTypeName .. " (" .. trueType .. ")";
										TextXAlignment = Enum.TextXAlignment.Left
									})
									local deletebutton = puter.AddWindowElement(window, "TextButton", {
										Size = UDim2.fromOffset(100, 25);
										Position = UDim2.fromOffset(100, 250);
										BorderSizePixel = 0;
										BackgroundColor3 = Color3.fromRGB(255,0,0);
										TextColor3 = Color3.fromRGB(0,0,0);
										TextScaled = true;
										Text = "Delete";
									})
									deletebutton.MouseButton1Click:Connect(function()
										if trueType ~= "t:folder" then
											cachedDisk:Write(cachedpath, nil)
											called = true
											titlebar:Destroy()
											canopenproperties = true
										else
											deleteFolder(cachedpath .. "/", cachedDisk)
											called = true
											titlebar:Destroy()
											canopenproperties = true
										end
									end)
								end)
								if yes == false then
									print(bruh)
								end
							end
						end)
					end
					local function getUp()
						local set = false
						if path ~= "/" then
							for i = #path - 1, 1, -1 do
								if string.sub(path, i, i) == "/" and set == false then
									path = string.sub(path, 1, i)
									print("i set the path to " .. path .. " because 'i' was " .. tostring(i))
									set = true
									called = true
								end
							end
						else
							path = "Disk View"
							viewingDisk = nil
							called = true
						end
					end
					local function getFolders(path, disk)
						local folders = filesystem.scanPath(path, disk)
						local offset = 0
						for i, v in pairs(folders) do
							local folder = filesystem.read(path .. v .. "/", disk)
							if folder ~= nil then
								local fileType, data, trueType = typeParser(folder)
								offset = offset + 1
								addFile(v, fileType, UDim2.fromOffset(0, offset * 25), data, trueType, filesystem.read(path .. v .. "/", disk))
								print("i got a folder")
							end
						end
						print(offset * 25)
						return offset * 25
					end
					local function getFiles(path, disk, offset)
						local files = filesystem.scanPath(path, disk)
						local offsetv2 = 0
						for i, v in pairs(files) do
							local file = filesystem.read(path .. v, disk)
							if file ~= nil then
								local fileType, data, trueType = typeParser(file)
								offsetv2 = offsetv2 + 1
								addFile(v, fileType, UDim2.fromOffset(0, offsetv2 * 25 + offset), data, trueType, filesystem.read(path .. v, disk))
								print("i got a file")
							end
						end
						print(offsetv2)
						return offsetv2 * 25
					end
					local function getPath(path, disk)
						local yay, noooo = pcall(function()
							pathLabel:ChangeProperties({Text = path})
							mainScrollFrame:Destroy()
							mainScrollFrame = puter.AddWindowElement(explorerwindow, "ScrollingFrame", {
								Size = UDim2.fromOffset(500, 225);
								Position = UDim2.fromOffset(0, 75);
								BorderSizePixel = 0;
								BackgroundColor3 = Color3.fromRGB(60, 60, 60);
								ScrollBarThickness = 2;
								CanvasSize = UDim2.fromOffset(0,0);
							})
							local parentFrame = puter.AddElement(mainScrollFrame, "Frame", {
								Size = UDim2.fromOffset(498, 25);
								Position = UDim2.fromOffset(0, 0);
								BorderSizePixel = 0;
								BackgroundTransparency = 1;
							})
							local fileNameButton = puter.AddElement(parentFrame, "TextButton", {
								Size = UDim2.fromOffset(300, 25);
								Position = UDim2.fromOffset(0,0);
								BackgroundColor3 = Color3.fromRGB(100,100,100);
								BorderSizePixel = 0;
								TextColor3 = Color3.fromRGB(255,255,255);
								TextScaled = true;
								Text = ".."
							})
							puter.AddElement(parentFrame, "TextLabel", {
								Size = UDim2.fromOffset(198, 25);
								Position = UDim2.fromOffset(300,0);
								BackgroundColor3 = Color3.fromRGB(100,100,100);
								BorderSizePixel = 0;
								TextColor3 = Color3.fromRGB(255,255,255);
								TextScaled = true;
								Text = "Folder"
							})
							fileNameButton.MouseButton1Click:Connect(function()
								getUp()
							end)
							local files = filesystem.scanPath(path, disk)
							local offset = getFolders(path, disk)
							local offsetv2 = getFiles(path, disk, offset)
							mainScrollFrame:ChangeProperties({CanvasSize = UDim2.fromOffset(0, offset + offsetv2)})
						end)
						if yay == false then
							print(noooo)
							print("DEBUG DATA: [KEY: DATA]")
							for i, v in pairs(disk:ReadEntireDisk()) do
								print(i .. ": " .. v)
							end
						end
					end
					local function displayDisks()
						pathLabel:ChangeProperties({Text = "Disk View"})
						mainScrollFrame:Destroy()
						mainScrollFrame = puter.AddWindowElement(explorerwindow, "ScrollingFrame", {
							Size = UDim2.fromOffset(500, 225);
							Position = UDim2.fromOffset(0, 75);
							BorderSizePixel = 0;
							BackgroundColor3 = Color3.fromRGB(60, 60, 60);
							ScrollBarThickness = 2;
							CanvasSize = UDim2.fromOffset(0,0);
						})
						for i, v in pairs(mounteddisks) do
							mainScrollFrame:ChangeProperties({CanvasSize = UDim2.fromOffset(0, i * 25)})
							local parentFrame = puter.AddElement(mainScrollFrame, "Frame", {
								Size = UDim2.fromOffset(498, 25);
								Position = UDim2.fromOffset(0, (i - 1) * 25);
								BorderSizePixel = 0;
								BackgroundTransparency = 1;
							})
							local fileNameButton = puter.AddElement(parentFrame, "TextButton", {
								Size = UDim2.fromOffset(300, 25);
								Position = UDim2.fromOffset(0,0);
								BackgroundColor3 = Color3.fromRGB(100,100,100);
								BorderSizePixel = 0;
								TextColor3 = Color3.fromRGB(255,255,255);
								TextScaled = true;
								Text = "Disk " ..  tostring(i)
							})
							puter.AddElement(parentFrame, "TextLabel", {
								Size = UDim2.fromOffset(198, 25);
								Position = UDim2.fromOffset(300,0);
								BackgroundColor3 = Color3.fromRGB(100,100,100);
								BorderSizePixel = 0;
								TextColor3 = Color3.fromRGB(255,255,255);
								TextScaled = true;
								Text = "Disk"
							})
							fileNameButton.MouseButton1Click:Connect(function()
								viewingDisk = v
								path = "/"
								called = true
							end)
						end
					end
					local director = coroutine.create(function()
						while true do
							wait(0.1)
							if called == true then
								print("i got called")
								if viewingDisk ~= nil then
									print("viewing disk is not nil")
									if path ~= "Disk View" then
										print("getting data at path " .. path)
										getPath(path, viewingDisk)
									else
										print("the path is Disk View, cmon you know thats not valid")
										viewingDisk = nil
										displayDisks()
									end
								else
									print("viewing disk is nil, displaying the disk displayer")
									displayDisks()
								end
								called = false
								print("ending call")
							end
						end
					end)
					coroutines[#coroutines + 1] = director
					coroutine.resume(director)
					closeexplorer.MouseButton1Click:Connect(function()
						canopenexplorer = true
						coroutine.close(director)
					end)
					actionRefresh.MouseButton1Click:Connect(function()
						called = true
					end)
					actionFile.MouseButton1Click:Connect(function()
						if fileFrame == nil then
							fileFrame = puter.AddWindowElement(explorerwindow, "Frame", {
								Size = UDim2.fromOffset(100, 50);
								Position = UDim2.fromOffset(0, 25);
								BackgroundColor3 = Color3.fromRGB(48, 48, 48);
								BorderSizePixel = 0;
							})
							local createDirectory = puter.AddElement(fileFrame, "TextButton", {
								Size = UDim2.fromOffset(100, 25);
								Position = UDim2.fromOffset(0, 0);
								BackgroundColor3 = Color3.fromRGB(48, 48, 48);
								BorderSizePixel = 0;
								TextColor3 = Color3.fromRGB(255,255,255);
								TextScaled = true;
								Text = "Create Directory";
							})
							local createFile = puter.AddElement(fileFrame, "TextButton", {
								Size = UDim2.fromOffset(100, 25);
								Position = UDim2.fromOffset(0, 25);
								BackgroundColor3 = Color3.fromRGB(48, 48, 48);
								BorderSizePixel = 0;
								TextColor3 = Color3.fromRGB(255,255,255);
								TextScaled = true;
								Text = "Create File";
							})
							createDirectory.MouseButton1Click:Connect(function()
								if canopencfolder == true then
									local focusedOn = nil
									local name
									local path
									local disk
									local window, closebutton = puter.CreateWindow(400, 225, "Directory Creator")
									closebutton.MouseButton1Click:Connect(function()
										canopencfolder = true
									end)
									canopencfolder = false
									local nameButton = puter.AddWindowElement(window, "TextButton", {
										Text = "Name: ";
										TextScaled = true;
										TextColor3 = Color3.fromRGB(0,0,0);
										BackgroundColor3 = Color3.fromRGB(77, 77, 77);
										Size = UDim2.fromOffset(380, 25);
										Position = UDim2.fromOffset(10, 10);
									})
									local pathButton = puter.AddWindowElement(window, "TextButton", {
										Text = "Path: ";
										TextScaled = true;
										TextColor3 = Color3.fromRGB(0,0,0);
										BackgroundColor3 = Color3.fromRGB(77, 77, 77);
										Size = UDim2.fromOffset(380, 25);
										Position = UDim2.fromOffset(10, 45);
									})
									local diskButton = puter.AddWindowElement(window, "TextButton", {
										Text = "Disk (number): ";
										TextScaled = true;
										TextColor3 = Color3.fromRGB(0,0,0);
										BackgroundColor3 = Color3.fromRGB(77, 77, 77);
										Size = UDim2.fromOffset(380, 25);
										Position = UDim2.fromOffset(10, 80);
									})
									local createButton = puter.AddWindowElement(window, "TextButton", {
										Text = "Create";
										TextScaled = true;
										TextColor3 = Color3.fromRGB(0,0,0);
										BackgroundColor3 = Color3.fromRGB(77, 77, 77);
										Size = UDim2.fromOffset(100, 25);
										Position = UDim2.fromOffset(150, 175);
									})
									nameButton.MouseButton1Click:Connect(function()
										focusedOn = "name"
										nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
										pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
									end)
									pathButton.MouseButton1Click:Connect(function()
										focusedOn = "path"
										nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
										diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
									end)
									diskButton.MouseButton1Click:Connect(function()
										focusedOn = "disk"
										nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
									end)
									createButton.MouseButton1Click:Connect(function()
										Beep()
										local function throwError(text)
											local err = puter.AddWindowElement(window, "TextLabel", {
												Text = text;
												Size = UDim2.fromOffset(400, 25);
												Position = UDim2.fromOffset(0, 150);
												TextScaled = true;
												TextColor3 = Color3.fromRGB(255,0,0);
												BackgroundTransparency = 1;
											})
											print("threw error " .. text)
											wait(1)
											err:Destroy()
											print("error is GONE :sob:")
										end
										local goodjob, uhoh = pcall(function()
											print("time to check")
											if mounteddisks[disk] ~= nil then
												if path ~= nil then
													if string.sub(path, #path, #path) ~= "/" then
														path = path .. "/"
														print("glued a / to the path")
													end
													if filesystem.read(path, mounteddisks[disk]) == "t:folder" then
														if name ~= nil then
															local badName = false
															for i = 1, #name, 1 do
																if string.sub(name, i, i) == "/" then
																	badName = true
																end
															end
															if badName == false then
																filesystem.createDirectory(path .. name .. "/", mounteddisks[disk])
																called = true
															else
																print("you're an idiot")
																throwError("dont put a / in the name you doofus")
															end
														else
															print("me when the untitled")
															throwError("please input a name")
														end
													else
														print("dawg that aint a folder")
														throwError("path specified is not a folder")
													end
												else
													print("wheres da path")
													throwError("please input a path")
												end
											else
												print("disk where?")
												throwError("invalid disk, make sure that you didnt accidentally type in anything other than a number")
											end
											print("back to my 1 millisecond break")
										end)
										if goodjob == false then
											throwError(uhoh)
										end
									end)
									xConnect("keyboard", "TextInputted", function(text, plr)
										text = string.sub(text, 1, #text - 1)
										if focusedOn == "name" then
											name = text
											nameButton:ChangeProperties({Text = "Name: " .. text})
										elseif focusedOn == "path" then
											path = text
											pathButton:ChangeProperties({Text = "Path: " .. text})
										elseif focusedOn == "disk" then
											disk = tonumber(text)
											diskButton:ChangeProperties({Text = "Disk (number): " .. text})
										end
									end, "folderCreator")
								end
							end)
							createFile.MouseButton1Click:Connect(function()
								local yay, nay = pcall(function()
									if canopencfile == true then
										local focusedOn = nil
										local name
										local path
										local disk
										local fileType
										local data
										local window, closebutton = puter.CreateWindow(400, 225, "File Creator")
										closebutton.MouseButton1Click:Connect(function()
											canopencfile = true
										end)
										canopencfile = false
										local nameButton = puter.AddWindowElement(window, "TextButton", {
											Text = "Name: ";
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,0,0);
											BackgroundColor3 = Color3.fromRGB(77, 77, 77);
											Size = UDim2.fromOffset(380, 20);
											Position = UDim2.fromOffset(10, 5);
										})
										local pathButton = puter.AddWindowElement(window, "TextButton", {
											Text = "Path: ";
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,0,0);
											BackgroundColor3 = Color3.fromRGB(77, 77, 77);
											Size = UDim2.fromOffset(380, 20);
											Position = UDim2.fromOffset(10, 30);
										})
										local diskButton = puter.AddWindowElement(window, "TextButton", {
											Text = "Disk (number): ";
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,0,0);
											BackgroundColor3 = Color3.fromRGB(77, 77, 77);
											Size = UDim2.fromOffset(380, 20);
											Position = UDim2.fromOffset(10, 55);
										})
										local typeButton = puter.AddWindowElement(window, "TextButton", {
											Text = "Type: ";
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,0,0);
											BackgroundColor3 = Color3.fromRGB(77, 77, 77);
											Size = UDim2.fromOffset(380, 20);
											Position = UDim2.fromOffset(10, 80);
										})
										local dataButton = puter.AddWindowElement(window, "TextButton", {
											Text = "Data: ";
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,0,0);
											BackgroundColor3 = Color3.fromRGB(77, 77, 77);
											Size = UDim2.fromOffset(380, 20);
											Position = UDim2.fromOffset(10, 105);
										})
										puter.AddWindowElement(window, "TextLabel", {
											Text = "Valid types: lua, image, audio, video";
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,0,0);
											BackgroundTransparency = 1;
											Size = UDim2.fromOffset(380, 20);
											Position = UDim2.fromOffset(10, 130);
										})
										local createButton = puter.AddWindowElement(window, "TextButton", {
											Text = "Create";
											TextScaled = true;
											TextColor3 = Color3.fromRGB(0,0,0);
											BackgroundColor3 = Color3.fromRGB(77, 77, 77);
											Size = UDim2.fromOffset(100, 25);
											Position = UDim2.fromOffset(150, 195);
										})
										nameButton.MouseButton1Click:Connect(function()
											focusedOn = "name"
											nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
											pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											typeButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											dataButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										end)
										pathButton.MouseButton1Click:Connect(function()
											focusedOn = "path"
											nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
											diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											typeButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											dataButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										end)
										diskButton.MouseButton1Click:Connect(function()
											focusedOn = "disk"
											nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
											typeButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											dataButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										end)
										typeButton.MouseButton1Click:Connect(function()
											focusedOn = "type"
											nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											typeButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0, 255, 0)})
											dataButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
										end)
										dataButton.MouseButton1Click:Connect(function()
											focusedOn = "data"
											nameButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											pathButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											diskButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											typeButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(77, 77, 77)})
											dataButton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0, 255, 0)})
										end)
										createButton.MouseButton1Click:Connect(function()
											Beep()
											local function throwError(text)
												local err = puter.AddWindowElement(window, "TextLabel", {
													Text = text;
													Size = UDim2.fromOffset(400, 25);
													Position = UDim2.fromOffset(0, 165);
													TextScaled = true;
													TextColor3 = Color3.fromRGB(255,0,0);
													BackgroundTransparency = 1;
												})
												print("threw error " .. text)
												wait(1)
												err:Destroy()
												print("error is GONE :sob:")
											end
											local function note(text)
												local note = puter.AddWindowElement(window, "TextLabel", {
													Text = text;
													Size = UDim2.fromOffset(400, 25);
													Position = UDim2.fromOffset(0, 150);
													TextScaled = true;
													TextColor3 = Color3.fromRGB(0,255,0);
													BackgroundTransparency = 1;
												})
												print("noted " .. text)
												wait(1)
												note:Destroy()
												print("no note")
											end
											local goodjob, uhoh = pcall(function()
												print("time to check")
												if mounteddisks[disk] ~= nil then
													if path ~= nil then
														if string.sub(path, #path, #path) ~= "/" then
															path = path .. "/"
															print("glued a / to the path")
														end
														if filesystem.read(path, mounteddisks[disk]) == "t:folder" then
															if name ~= nil then
																local badName = false
																for i = 1, #name, 1 do
																	if string.sub(name, i, i) == "/" then
																		badName = true
																	end
																end
																if badName == false then
																	if fileType ~= nil then
																		if data ~= nil then
																			if fileType ~= "folder" then
																				filesystem.write(path, name, "t:" .. fileType .. "/" .. data, mounteddisks[disk])
																				note("written... i think")
																				called = true
																			else
																				filesystem.createDirectory(path .. name .. "/", mounteddisks[disk])
																				note("a folder was created, did you think you could break me?")
																				called = true
																			end
																		else
																			throwError("input some data")
																			print("dont make a useless file")
																		end
																	else
																		print("type in a type")
																		throwError("please input a type")
																	end
																else
																	print("you're an idiot")
																	throwError("dont put a / in the name you doofus")
																end
															else
																print("me when the untitled")
																throwError("please input a name")
															end
														else
															print("dawg that aint a folder")
															throwError("path specified is not a folder")
														end
													else
														print("wheres da path")
														throwError("please input a path")
													end
												else
													print("disk where?")
													throwError("invalid disk, make sure that you didnt accidentally type in anything other than a number")
												end
												print("back to my 1 millisecond break")
											end)
											if goodjob == false then
												throwError(uhoh)
											end
										end)
										xConnect("keyboard", "TextInputted", function(text, plr)
											text = string.sub(text, 1, #text - 1)
											if focusedOn == "name" then
												name = text
												nameButton:ChangeProperties({Text = "Name: " .. text})
											elseif focusedOn == "path" then
												path = text
												pathButton:ChangeProperties({Text = "Path: " .. text})
											elseif focusedOn == "disk" then
												disk = tonumber(text)
												diskButton:ChangeProperties({Text = "Disk (number): " .. text})
											elseif focusedOn == "type" then
												fileType = text
												typeButton:ChangeProperties({Text = "Type: " .. text})
											elseif focusedOn == "data" then
												data = text
												dataButton:ChangeProperties({Text = "Data: " .. text})
											end
										end, "fileCreator")
									else
										print("😂😂😂")
									end
								end)
								if yay == false then
									print(nay)
								end
							end)
						else
							fileFrame:Destroy()
							fileFrame = nil
						end
					end)
				end
				openMainExplorer()
			end
		end)
		local cursors = {}
		local cursorPositions = {}
		screenCursorMoved(function(cursor)
			if cursors[cursor.Player] ~= nil then
				cursorPositions[cursor.Player] = tostring(cursor.X - 50) .. ", " .. tostring(cursor.Y - 50)
				cursors[cursor.Player]:ChangeProperties({Position = UDim2.fromOffset(cursor.X - 50, cursor.Y - 50)})
			else
				cursorPositions[cursor.Player] = tostring(cursor.X - 50) .. ", " .. tostring(cursor.Y - 50)
				local newCursor = screen:CreateElement("ImageLabel", {
					BackgroundTransparency = 1;
					Image = "rbxassetid://12582149183";
					Size = UDim2.fromOffset(100, 100);
					Position = UDim2.fromOffset(0, 0);
					ZIndex = 9;
				})
				local playerName = screen:CreateElement("TextLabel", {
					Text = cursor.Player;
					Size = UDim2.fromOffset(200, 25);
					Position = UDim2.fromOffset(-50, 25);
					TextStrokeTransparency = 0;
					TextColor3 = Color3.fromRGB(255,255,255);
					TextScaled = true;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					ZIndex = 9;
				})
				newCursor:AddChild(playerName)
				cursors[cursor.Player] = newCursor
			end
		end)
		local canopenterminal = true
		local canopenchat = true
		local canopendiskutil = true
		local chatModem = GetPartFromPort(6, "Modem")
		local function diskUtil()
			if canopendiskutil == true then
				canopendiskutil = false
				local window, closebutton = puter.CreateWindow(400, 225, "Disk Utility")
				closebutton.MouseButton1Click:Connect(function()
					canopendiskutil = true
				end)
				local key = nil
				local data = nil
				local focusedon = nil
				local keybutton = puter.AddWindowElement(window, "TextButton", {
					Text = "KEY: ";
					Size = UDim2.fromOffset(380, 25);
					Position = UDim2.fromOffset(10, 10);
					BackgroundColor3 = Color3.fromRGB(70, 70, 70);
					TextScaled = true;
				})
				local databutton = puter.AddWindowElement(window, "TextButton", {
					Text = "DATA: ";
					Size = UDim2.fromOffset(380, 25);
					Position = UDim2.fromOffset(10, 45);
					BackgroundColor3 = Color3.fromRGB(70, 70, 70);
					TextScaled = true;
				})
				local write = puter.AddWindowElement(window, "TextButton", {
					Text = "WRITE";
					Size = UDim2.fromOffset(100, 25);
					Position = UDim2.fromOffset(150, 175);
					BackgroundColor3 = Color3.fromRGB(70, 70, 70);
					TextScaled = true;
				})
				keybutton.MouseButton1Click:Connect(function()
					focusedon = "key"
					keybutton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
					databutton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
				end)
				databutton.MouseButton1Click:Connect(function()
					focusedon = "data"
					keybutton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
					databutton:ChangeProperties({BackgroundColor3 = Color3.fromRGB(0,255,0)})
				end)
				xConnect("keyboard", "TextInputted", function(text, plr)
					if canopendiskutil == false then
						text = string.sub(text, 1, #text - 1)
						if focusedon == "key" then
							key = text
							keybutton:ChangeProperties({Text = "KEY: " .. key})
						elseif focusedon == "data" then
							data = text
							databutton:ChangeProperties({Text = "DATA: " .. data})
						end
					end
				end, "diskUtil")
				write.MouseButton1Click:Connect(function()
					if key ~= nil then
						if data ~= nil then
							if GetPartFromPort(4, "Disk") ~= nil then
								GetPartFromPort(4, "Disk"):Write(key, data)
								local success = puter.AddWindowElement(window, "TextLabel", {
									Text = "written";
									Size = UDim2.fromOffset(400, 25);
									Position = UDim2.fromOffset(0, 150);
									TextScaled = true;
									TextColor3 = Color3.fromRGB(0,255,0);
									BackgroundTransparency = 1;
								})
								wait(1)
								success:Destroy()
							else
								local err = puter.AddWindowElement(window, "TextLabel", {
									Text = "please insert a disk";
									Size = UDim2.fromOffset(400, 25);
									Position = UDim2.fromOffset(0, 150);
									TextScaled = true;
									TextColor3 = Color3.fromRGB(255,0,0);
									BackgroundTransparency = 1;
								})
								wait(1)
								err:Destroy()
							end
						else
							local err = puter.AddWindowElement(window, "TextLabel", {
								Text = "data not found";
								Size = UDim2.fromOffset(400, 25);
								Position = UDim2.fromOffset(0, 150);
								TextScaled = true;
								TextColor3 = Color3.fromRGB(255,0,0);
								BackgroundTransparency = 1;
							})
							wait(1)
							err:Destroy()
						end
					else
						local err = puter.AddWindowElement(window, "TextLabel", {
							Text = "key not found";
							Size = UDim2.fromOffset(400, 25);
							Position = UDim2.fromOffset(0, 150);
							TextScaled = true;
							TextColor3 = Color3.fromRGB(255,0,0);
							BackgroundTransparency = 1;
						})
						wait(1)
						err:Destroy()
					end
				end)
			end
		end
		diskUtilApp.MouseButton1Click:Connect(function()
			diskUtil()
		end)
		local function openChat()
			if chatModem ~= nil and canopenchat == true then
				canopenchat = false
				local busyWith = nil
				local idconnected
				local window, closebutton, titlebar = puter.CreateWindow(400, 225, "Chat")
				local connectPublicNet = puter.AddWindowElement(window, "TextButton", {
					Position = UDim2.fromOffset(50, 50);
					Size = UDim2.fromOffset(300, 50);
					Text = "Connect to public chat network";
					TextScaled = true;
					BackgroundColor3 = Color3.fromRGB(121, 121, 121);
				})
				closebutton.MouseButton1Click:Connect(function()
					canopenchat = true
				end)
				local connectToSpecModem = puter.AddWindowElement(window, "TextButton", {
					Position = UDim2.fromOffset(50, 150);
					Size = UDim2.fromOffset(300, 50);
					Text = "Connect to a specific modem";
					TextScaled = true;
					BackgroundColor3 = Color3.fromRGB(121, 121, 121);
				})
				local function showChat()
					local chatFrame = puter.AddWindowElement(window, "Frame", {
						Size = UDim2.fromOffset(400, 225);
						BackgroundColor3 = Color3.fromRGB(121, 121, 121);
						BorderSizePixel = 0;
					})
					local chat = {}
					local sendname = true
					local legacymode = false
					local function addMessage(message)
						if #chat <= 8 then
							chat[#chat + 1] = message
						elseif #chat >= 9 then
							for i, v in pairs(chat) do
								if i >= 2 then
									chat[i - 1] = chat[i]
								end
							end
							chat[9] = message
						end
					end
					local function renderChat()
						chatFrame:Destroy()
						chatFrame = puter.AddWindowElement(window, "Frame", {
							Size = UDim2.fromOffset(400, 225);
							BackgroundColor3 = Color3.fromRGB(121, 121, 121);
							BorderSizePixel = 0;
						})
						Beep()
						for i, v in pairs(chat) do
							local chatMsg
							if string.sub(v, 1, 2) == "b/" then
								chatMsg = puter.AddWindowElement(window, "TextButton", {
									Size = UDim2.fromOffset(400, 25);
									BackgroundTransparency = 1;
									BorderSizePixel = 0;
									Text = string.sub(v, 3, #v);
									TextXAlignment = Enum.TextXAlignment.Left;
									TextScaled = true;
									Position = UDim2.fromOffset(0, (i - 1) * 25);
									TextColor3 = Color3.fromRGB(85, 85, 255);
								})
								local actualMessage
								for i = 1, #v, 1 do
									if string.sub(v, i, i + 1) == "]:" then
										actualMessage = i + 3
									end
								end
								chatMsg.MouseButton1Click:Connect(function()
									local commandNotFound = check(string.sub(v, actualMessage, #v), "chat.lua", GetPartFromPort(6, "Polysilicon"), GetPartFromPort(6, "Microcontroller"), function() end)
								end)
							elseif string.sub(v, 1, 2) == "t/" then
								chatMsg = puter.AddWindowElement(window, "TextLabel", {
									Size = UDim2.fromOffset(400, 25);
									BackgroundTransparency = 1;
									BorderSizePixel = 0;
									Text = string.sub(v, 3, #v);
									TextXAlignment = Enum.TextXAlignment.Left;
									TextScaled = true;
									Position = UDim2.fromOffset(0, (i - 1) * 25);
								})
							else
								chatMsg = puter.AddWindowElement(window, "TextLabel", {
									Size = UDim2.fromOffset(400, 25);
									BackgroundTransparency = 1;
									BorderSizePixel = 0;
									Text = v;
									TextXAlignment = Enum.TextXAlignment.Left;
									TextScaled = true;
									Position = UDim2.fromOffset(0, (i - 1) * 25);
								})
							end
							chatFrame:AddChild(chatMsg)
						end
					end
					local function sendMessage(plr, text, idconnected, actualPlr, legacymode, isButton)
						local messageToSend = nil
						if sendname == false then
							plr = "Anonymous"
						end
						if legacymode == false and isButton == false then
							messageToSend = "t/[" .. plr .. "]: " .. text
						elseif legacymode == false and isButton == true then
							messageToSend = "b/[" .. plr .. "]: " .. string.sub(text, 4, #text)
						elseif legacymode == true then
							messageToSend = "[" .. plr .. "]: " .. text
						end
						Beep()
						chatModem:SendMessage(messageToSend, idconnected)
					end
					xConnect("keyboard", "TextInputted", function(text, plr)
						text = string.sub(text, 1, #text - 1)
						if canopenchat == false then
							if string.sub(text, 1, 1) ~= "!" and string.sub(text, 1, 2) ~= "?c" then
								sendMessage(plr, text, idconnected, plr, legacymode, false)
							elseif string.sub(text, 1, 2) == "?c" then
								sendMessage(plr, text, idconnected, plr, legacymode, true)
							end
							if string.sub(text, 1, 1) == "!" then
								if string.sub(text, 2, 11) == "togglename" then
									if sendname == true then
										sendname = false
										addMessage("<System> Your name will not be sent.")
										renderChat()
									else
										sendname = true
										addMessage("<System> Your name will be sent.")
										renderChat()
									end
								elseif string.sub(text, 2, 11) == "legacymode" then
									legacymode = true
									addMessage("<System> Enabled legacy mode.")
									renderChat()
								elseif string.sub(text, 2, 11) == "modernmode" then
									legacymode = false
									addMessage("<System> Disabled legacy mode.")
									renderChat()
								end
							end
						end
					end, "chat")
					chatModem:Connect("MessageSent", function(message)
						if canopenchat == false then
							addMessage(message)
							renderChat()
						end
					end)
				end
				connectPublicNet.MouseButton1Click:Connect(function()
					connectPublicNet:Destroy()
					connectToSpecModem:Destroy()
					if idconnected == nil then
						idconnected = 10
						chatModem:Configure({NetworkID = idconnected})
						showChat()
					end
				end)
				connectToSpecModem.MouseButton1Click:Connect(function()
					connectPublicNet:Destroy()
					connectToSpecModem:Destroy()
					puter.AddWindowElement(window, "TextLabel", {
						Size = UDim2.fromOffset(400, 225);
						Text = "Please type in the modem ID you want to connect to in the keyboard";
						TextScaled = true;
						BackgroundColor3 = Color3.fromRGB(121, 121, 121);
					})
					xConnect("keyboard", "TextInputted", function(text, plr)
						if idconnected == nil then
							idconnected = tonumber(text)
							chatModem:Configure({NetworkID = idconnected})
							showChat()
						end
					end, "chat")
				end)
			end
		end
		chatApp.MouseButton1Click:Connect(function()
			openChat()
		end)
		if mic ~= nil then
			local listeningto
			local listening = false
			mic:Connect("Chatted", function(plr, text)
				if voicecommands == true then
					if text == "hey puter" and listening == false then
						listeningto = plr
						listening = true
					elseif string.sub(text, 1, 7) == "Jarvis," then
						local failed, reason = check(string.sub(text, 9, #text), plr, GetPartFromPort(6, "Polysilicon"), GetPartFromPort(6, "Microcontroller"), function() end)
						if failed == true then
							errorPopup(reason)
						end
					elseif string.sub(text, 1, 6) == "puter," then
						local failed, reason = check(string.sub(text, 8, #text), plr, GetPartFromPort(6, "Polysilicon"), GetPartFromPort(6, "Microcontroller"), function() end)
						if failed == true then
							errorPopup(reason)
						end
					elseif listening == true and plr == listeningto then
						local failed, reason = check(text, plr, GetPartFromPort(6, "Polysilicon"), GetPartFromPort(6, "Microcontroller"), function() end)
						if failed == true then
							errorPopup(reason)
						end
						listening = false
						listeningto = nil
					end
					if recording == true then
						recorded[#recorded + 1] = "[" .. plr .. "]: " .. text
					end
				end
			end)
		end
		test.MouseButton1Click:Connect(function()
			if canopenterminal == true then	
				local polysilicon = GetPartFromPort(6, "Polysilicon")
				local terminalmicrocontroller = GetPartFromPort(6, "Microcontroller")
				canopenterminal = false
				local test, terminalclose = puter.CreateWindow(450, 275, "Terminal", Color3.fromRGB(0,0,0))
				terminalclose.MouseButton1Click:Connect(function()
					canopenterminal = true
				end)
				local terminalFrame = puter.AddWindowElement(test, "ScrollingFrame", {
					Size = UDim2.fromOffset(450, 275);
					BackgroundColor3 = Color3.fromRGB(0,0,0);
					BorderSizePixel = 0;
				})
				local terminalOutput = {}
				local function addTextToOutput(Out)
					if #terminalOutput <= 10 then
						terminalOutput[#terminalOutput + 1] = Out
						return #terminalOutput
					else
						terminalOutput[1] = nil
						for i, v in pairs(terminalOutput) do
							if i >= 2 and i <= 11 then
								terminalOutput[i - 1] = terminalOutput[i]
							end
						end
						terminalOutput[11] = Out
						return 11
					end
				end
				local function updateOutput()
					terminalFrame:Destroy()
					terminalFrame = puter.AddWindowElement(test, "Frame", {
						Size = UDim2.fromOffset(450, 275);
						BackgroundColor3 = Color3.fromRGB(0,0,0);
						BorderSizePixel = 0;
					})
					for i, v in pairs(terminalOutput) do
						local textlabel = puter.AddWindowElement(test, "TextLabel", {
							Size = UDim2.fromOffset(444, 25);
							Position = UDim2.fromOffset(0, (i - 1) * 25);
							Text = v;
							TextColor3 = Color3.fromRGB(255,255,255);
							BackgroundColor3 = Color3.fromRGB(0,0,0);
							BorderSizePixel = 0;
							TextXAlignment = Enum.TextXAlignment.Left;
							TextScaled = true;
						})
						terminalFrame:AddChild(textlabel)
					end
				end
				local function terminalout(Out)
					addTextToOutput(Out)
					updateOutput()
				end
				--increment the version each major change
				terminalout("wOS Codename BasicSystem, Version 8 Revision 2")
				local inputbar
				local function requireNewInputBar()
					inputbar = addTextToOutput("wOS > ")
					updateOutput()
				end
				requireNewInputBar()
				Beep()
				xConnect("keyboard", "TextInputted", function(text, plr)
					if canopenterminal == false then
						text = string.sub(text, 1, #text - 1)
						if inputbar ~= nil then
							terminalOutput[inputbar] = "wOS > " .. text
							updateOutput()
						else
							requireNewInputBar()
							terminalOutput[inputbar] = "wOS > " .. text
							updateOutput()
						end
						local failed, reason = check(text, plr, polysilicon, terminalmicrocontroller, terminalout)
						if failed == true then
							terminalout(reason)
						end
						requireNewInputBar()
						if recordingtext == true then
							recordedtext[#recordedtext + 1] = "[" .. plr .. "]: " .. text
						end
					end
				end, "terminal")
			end
		end)
		local canopennetworking = true
		local canopenpreferences = true
		settingsbutton.MouseButton1Click:Connect(function()
			local settingswindow
			local closebtn
			if canspawnsettings == true then
				settingswindow, closebtn = puter.CreateWindow(450, 300, "Settings", Color3.fromRGB(50,50,50))
				local networking = puter.AddWindowElement(settingswindow, "TextButton", {
					Text = "Networking";
					Position = UDim2.fromOffset(25, 25);
					Size = UDim2.fromOffset(175, 50);
					TextScaled = true;
				})
				local preferences = puter.AddWindowElement(settingswindow, "TextButton", {
					Text = "Preferences";
					Position = UDim2.fromOffset(250, 25);
					Size = UDim2.fromOffset(175, 50);
					TextScaled = true;
				})
				networking.MouseButton1Click:Connect(function()
					--haha funny cat image placeholder
					local wawa
					local unwawa
					if canopennetworking == true then
						wawa = puter.AddWindowElement(settingswindow, "ImageLabel", {
							Image = "http://www.roblox.com/asset/?id=10630555127";
							Position = UDim2.fromOffset(75, 75);
							Size = UDim2.fromOffset(200, 200)
						})
						unwawa = puter.AddWindowElement(settingswindow, "TextButton", {
							Text = "Close";
							Position = UDim2.fromOffset(125, 125);
							Size = UDim2.fromOffset(200, 50);
							BackgroundColor3 = Color3.fromRGB(255,0,0);
							TextScaled = true;
						})
						canopennetworking = false
					end
					unwawa.MouseButton1Click:Connect(function()
						wawa:Destroy()
						unwawa:Destroy()
						canopennetworking = true
					end)
				end)
				preferences.MouseButton1Click:Connect(function()
					if canopenpreferences == true then
						local tempvoicecommands = voicecommands
						local preferenceswindow, closebutton, titlebar = puter.CreateWindow(300, 300, "Preferences", Color3.fromRGB(100, 100, 100))
						closebutton.MouseButton1Click:Connect(function()
							canopenpreferences = true
						end)
						canopenpreferences = false
						local apply = puter.AddWindowElement(preferenceswindow, "TextButton", {
							Text = "Apply";
							TextScaled = true;
							TextColor3 = Color3.fromRGB(0,0,0);
							Size = UDim2.fromOffset(50, 25);
							Position = UDim2.fromOffset(240, 265);
							BackgroundColor3 = Color3.fromRGB(85, 85, 85);
							BorderSizePixel = 0;
						})
						apply.MouseButton1Click:Connect(function()
							if tempvoicecommands ~= nil then
								voicecommands = tempvoicecommands
								if storage ~= nil then
									if tempvoicecommands == true then
										storage:Write("voicecommands", "true")
									else
										storage:Write("voicecommands", "false")
									end
								end
							end
						end)
						local cancel = puter.AddWindowElement(preferenceswindow, "TextButton", {
							Text = "Cancel";
							TextScaled = true;
							TextColor3 = Color3.fromRGB(0,0,0);
							Size = UDim2.fromOffset(50, 25);
							Position = UDim2.fromOffset(180, 265);
							BackgroundColor3 = Color3.fromRGB(85, 85, 85);
							BorderSizePixel = 0;
						})
						cancel.MouseButton1Click:Connect(function()
							titlebar:Destroy()
							canopenpreferences = true
						end)
						local ok = puter.AddWindowElement(preferenceswindow, "TextButton", {
							Text = "OK";
							TextScaled = true;
							TextColor3 = Color3.fromRGB(0,0,0);
							Size = UDim2.fromOffset(50, 25);
							Position = UDim2.fromOffset(120, 265);
							BackgroundColor3 = Color3.fromRGB(85, 85, 85);
							BorderSizePixel = 0;
						})
						ok.MouseButton1Click:Connect(function()
							if tempvoicecommands ~= nil then
								voicecommands = tempvoicecommands
								if storage ~= nil then
									if tempvoicecommands == true then
										storage:Write("voicecommands", "true")
									else
										storage:Write("voicecommands", "false")
									end
								end
							end
							titlebar:Destroy()
							canopenpreferences = true
						end)
						local voicelabel = puter.AddWindowElement(preferenceswindow, "TextLabel", {
							Text = "Voice Commands:";
							Size = UDim2.fromOffset(200, 25);
							Position = UDim2.fromOffset(10, 10);
							TextScaled = true;
							TextColor3 = Color3.fromRGB(255,255,255);
							BackgroundTransparency = 1;
						})
						local voicebutton
						if tempvoicecommands == true then
							voicebutton = puter.AddWindowElement(preferenceswindow, "TextButton", {
								Text = "ON";
								BackgroundColor3 = Color3.fromRGB(0,255,0);
								TextColor3 = Color3.fromRGB(0,0,0);
								Size = UDim2.fromOffset(50, 25);
								TextScaled = true;
								Position = UDim2.fromOffset(240, 10);
							})
						else
							voicebutton = puter.AddWindowElement(preferenceswindow, "TextButton", {
								Text = "OFF";
								BackgroundColor3 = Color3.fromRGB(255,0,0);
								TextColor3 = Color3.fromRGB(0,0,0);
								Size = UDim2.fromOffset(50, 25);
								TextScaled = true;
								Position = UDim2.fromOffset(240, 10);
							})
						end
						voicebutton.MouseButton1Click:Connect(function()
							if tempvoicecommands == true then
								tempvoicecommands = false
								voicebutton:ChangeProperties({Text = "OFF"; BackgroundColor3 = Color3.fromRGB(255,0,0)})
							else
								tempvoicecommands = true
								voicebutton:ChangeProperties({Text = "ON"; BackgroundColor3 = Color3.fromRGB(0,255,0)})
							end
						end)
					end
				end)
				canspawnsettings = false
			end
			closebtn.MouseButton1Click:Connect(function()
				canopennetworking = true
				canspawnsettings = true
			end)
		end)
		--main loop
		while true do
			local tempCursorPositions = tableRepilicate(cursorPositions)
			wait(2.5)
			for plrName, cursor in pairs(cursors) do
				if tempCursorPositions[plrName] == cursorPositions[plrName] then
					cursor:Destroy()
					cursors[plrName] = nil
					cursorPositions[plrName] = nil
				end
			end
		end
	end
end)
if success == true then

else
	ReturnError(errorcode, "CREATOR_SKILL_ISSUE")
end
