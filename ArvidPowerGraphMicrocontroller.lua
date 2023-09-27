local Screen = GetPartFromPort(1, "Screen") or GetPartFromPort(1, "TouchScreen")	
	Screen:ClearElements()
	
	local Instrument = GetPartFromPort(2, "Instrument")
	local Disk = GetPartFromPort(2, "Disk")
	
	local background = Screen:CreateElement("ImageLabel", { Image = "rbxassetid://3899340539", ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(120, 120), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromHex("#FFFFFF"), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1) })
	
	local sessionDataContainer = Screen:CreateElement("Frame", { Active = true, AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = Color3.fromHex("#3E3E3E"), BackgroundTransparency = 0.5, BorderSizePixel = 0, Position = UDim2.new(0, 6, 1, -6), Selectable = true, Size = UDim2.new(0.5, -9, 0, 114), SelectionGroup = true })
	local sessionDataTitle = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 0.5, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 3), Size = UDim2.new(1, -6, 0, 24) })
	sessionDataTitle:AddChild(Screen:CreateElement("TextLabel", { Text = "Session Data", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -6, 1, -6) }))
	
	local currentPower = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 30), Size = UDim2.new(1, -6, 0, 18) })
	local currentPowerText = Screen:CreateElement("TextLabel", { Text = "N/A", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromScale(1, 1) })
	currentPower:AddChild(Screen:CreateElement("TextLabel", { Text = "Current Power:", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 1) }))
	
	local highestSession = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 51), Size = UDim2.new(1, -6, 0, 18) })
	local highestSessionText = Screen:CreateElement("TextLabel", { Text = "N/A", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromScale(1, 1) })
	highestSession:AddChild(Screen:CreateElement("TextLabel", { Text = "Highest Power:", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 1) }))
	
	local lowestSession = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 72), Size = UDim2.new(1, -6, 0, 18) })
	local lowestSessionText = Screen:CreateElement("TextLabel", { Text = "N/A", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromScale(1, 1) })
	lowestSession:AddChild(Screen:CreateElement("TextLabel", { Text = "Lowest Power:", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 1) }))
	
	local averageSession = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 93), Size = UDim2.new(1, -6, 0, 18) })
	local averageSessionText = Screen:CreateElement("TextLabel", { Text = "N/A", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromScale(1, 1) })
	averageSession:AddChild(Screen:CreateElement("TextLabel", { Text = "Average Trend:", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 1) }))
	
	local allTimeDataContainer = Screen:CreateElement("Frame", { Active = true, AnchorPoint = Vector2.new(1, 1), BackgroundColor3 = Color3.fromHex("#3E3E3E"), BackgroundTransparency = 0.5, BorderSizePixel = 0, Position = UDim2.new(1, -6, 1, -6), Selectable = true, Size = UDim2.new(0.5, -9, 0, 114), SelectionGroup = true })
	local allTimeDataTitle = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 0.5, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 3), Size = UDim2.new(1, -6, 0, 24) })
	allTimeDataTitle:AddChild(Screen:CreateElement("TextLabel", { Text = "All Time Data", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -6, 1, -6) }))
	
	local averageAllTime = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 72), Size = UDim2.new(1, -6, 0, 18) })
	local averageAllTimeText = Screen:CreateElement("TextLabel", { Text = "N/A", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromScale(1, 1) })
	averageAllTime:AddChild(Screen:CreateElement("TextLabel", { Text = "Average Trend:", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 1) }))
	
	local highestAllTime = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 30), Size = UDim2.new(1, -6, 0, 18) })
	local highestAllTimeText = Screen:CreateElement("TextLabel", { Text = "N/A", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromScale(1, 1) })
	highestAllTime:AddChild(Screen:CreateElement("TextLabel", { Text = "Highest Power:", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 1) }))
	
	local lowestAllTime = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 51), Size = UDim2.new(1, -6, 0, 18) })
	local lowestAllTimeText = Screen:CreateElement("TextLabel", { Text = "N/A", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromScale(1, 1) })
	lowestAllTime:AddChild(Screen:CreateElement("TextLabel", { Text = "Lowest Power:", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 1) }))
	
	local barGraphContainer = Screen:CreateElement("ScrollingFrame", { BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png", CanvasSize = UDim2.new(), ScrollBarImageColor3 = Color3.fromHex("#1F1F1F"), ScrollBarThickness = 6, ScrollingDirection = Enum.ScrollingDirection.X, TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png", VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar, Active = true, AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Color3.fromHex("#3E3E3E"), BackgroundTransparency = 0.5, BorderSizePixel = 0, Position = UDim2.new(0.5, 0, 0, 36), Size = UDim2.new(1, -12, 1, -162) })
	
	local graphHeader = Screen:CreateElement("Frame", { Active = true, BackgroundColor3 = Color3.fromHex("#3E3E3E"), BackgroundTransparency = 0.5, BorderSizePixel = 0, Position = UDim2.fromOffset(6, 6), Selectable = true, Size = UDim2.new(1, -12, 0, 30), SelectionGroup = true })
	local graphTitle = Screen:CreateElement("Frame", { BackgroundColor3 = Color3.fromHex("#1F1F1F"), BackgroundTransparency = 0.5, BorderSizePixel = 0, Position = UDim2.fromOffset(3, 3), Size = UDim2.new(1, -6, 0, 24) })
	graphTitle:AddChild(Screen:CreateElement("TextLabel", { Text = "Power Graph", TextColor3 = Color3.fromHex("#FFFFFF"), TextScaled = true, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -6, 1, -6) }))
	
	background:AddChild(sessionDataContainer)
	sessionDataContainer:AddChild(sessionDataTitle)
	sessionDataContainer:AddChild(currentPower)
	currentPower:AddChild(currentPowerText)
	sessionDataContainer:AddChild(highestSession)
	highestSession:AddChild(highestSessionText)
	sessionDataContainer:AddChild(lowestSession)
	lowestSession:AddChild(lowestSessionText)
	sessionDataContainer:AddChild(averageSession)
	averageSession:AddChild(averageSessionText)
	
	background:AddChild(allTimeDataContainer)
	allTimeDataContainer:AddChild(allTimeDataTitle)
	allTimeDataContainer:AddChild(averageAllTime)
	averageAllTime:AddChild(averageAllTimeText)
	allTimeDataContainer:AddChild(highestAllTime)
	highestAllTime:AddChild(highestAllTimeText)
	allTimeDataContainer:AddChild(lowestAllTime)
	lowestAllTime:AddChild(lowestAllTimeText)
	
	background:AddChild(graphHeader)
	graphHeader:AddChild(graphTitle)
	background:AddChild(barGraphContainer)
	
	local Components = {
	Bar = function(Power: number, Index: number)
	local mainColour = if Power < 0 then Color3.fromRGB(255, 127, 127) else Color3.fromRGB(127, 255, 127)
	
	if math.abs(Power) <= 10 then
	local text = Screen:CreateElement("TextLabel", {
	Text = math.abs(math.round(Power)),
	AnchorPoint = Vector2.new(0, 0.5),
	TextColor3 = if Power == 0 then Color3.fromRGB(64, 192, 255) else mainColour,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 6 + ( Index - 1 ) * 28, 0.5, 0),
	Size = UDim2.fromOffset(25, 15),
	TextSize = 10,
	})
	
	barGraphContainer:AddChild(text)
	return text
	end
	
	local powerBar = Screen:CreateElement("Frame", {
	AnchorPoint = Vector2.new(0, 1),
	BackgroundColor3 = mainColour,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 6 + ( Index - 1 ) * 28, 0.5, 0),
	Size = UDim2.fromOffset(25, Power / 10)
	})
	
	if math.abs(Power) <= 500 then
	powerBar:AddChild(Screen:CreateElement("TextLabel", {
	Text = math.abs(math.round(Power)),
	TextColor3 = mainColour,
	TextSize = 10,
	AnchorPoint = Vector2.new(0.5, if Power < 0 then 0 else 1),
	BackgroundTransparency = 1,
	Position = UDim2.fromScale(0.5, if Power < 0 then 1 else 0),
	AutomaticSize = Enum.AutomaticSize.XY,
	TextXAlignment = Enum.TextXAlignment.Center,
	}))
	else
	powerBar:AddChild(Screen:CreateElement("TextLabel", {
	Text = math.abs(math.round(Power)),
	TextColor3 = if Power < 0 then Color3.fromRGB(200, 0, 0) else Color3.fromRGB(0, 150, 0),
	TextSize = 10,
	AnchorPoint = Vector2.new(0.5, if Power < 0 then 0 else 1),
	BackgroundTransparency = 1,
	Position = if Power < 0 then UDim2.new(0.5, 0, 0, 0) else UDim2.new(0.5, 0, 1, 0),
	Rotation = 90,
	AutomaticSize = Enum.AutomaticSize.Y,
	TextXAlignment = if Power < 0 then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right,
	}))
	end
	
	barGraphContainer:AddChild(powerBar)
	return powerBar
	end,
	}
	
	local barFrames = { }
	local lastPower = Instrument:GetReading(4)
	
	local totalLoops = 1
	local sessionData = {
	Highest = lastPower,
	Lowest = lastPower,
	HighestChange = -math.huge,
	LowestChange = math.huge,
	Total = 0,
	}
	
	while true do
	task.wait(1)
	local currentPower = Instrument:GetReading(4)
	local powerChange = currentPower - lastPower
	lastPower = currentPower
	
	while #barFrames >= 100 do
	table.remove(barFrames):Destroy()
	end
	
	for i, barFrame in barFrames do
	barFrame.Position = UDim2.new(0, 6 + i * 28, 0.5, 0)
	end
	
	local newBar = Components.Bar(powerChange, 1)
	table.insert(barFrames, 1, newBar)
	
	sessionData.HighestChange = math.max(powerChange, sessionData.HighestChange)
	sessionData.LowestChange = math.min(powerChange, sessionData.LowestChange)
	
	sessionData.Highest = math.max(currentPower, sessionData.Highest)
	sessionData.Lowest = math.min(currentPower, sessionData.Lowest)
	sessionData.Total += powerChange
	
	local allTimeData = Disk:ReadEntireDisk()
	allTimeData.Highest = math.max(currentPower, allTimeData.Highest or 0)
	allTimeData.Lowest = math.min(currentPower, allTimeData.Lowest or math.huge)
	allTimeData.Total = ( allTimeData.Total or 0 ) + powerChange
	allTimeData.TotalLoops = allTimeData.TotalLoops or 1
	
	currentPowerText.Text = math.round(currentPower)
	highestSessionText.Text = math.round(sessionData.Highest)
	lowestSessionText.Text = math.round(sessionData.Lowest)
	averageSessionText.Text = math.round(sessionData.Total / totalLoops)
	
	highestAllTimeText.Text = math.round(allTimeData.Highest)
	lowestAllTimeText.Text = math.round(allTimeData.Lowest)
	averageAllTimeText.Text = math.round(allTimeData.Total / allTimeData.TotalLoops)
	
	barGraphContainer.CanvasSize = UDim2.fromOffset(6 + #barFrames * 28, 0)
	--sessionData.HighestChange + sessionData.HighestChange
	
	allTimeData.TotalLoops += 1
	totalLoops += 1
	
	for key, value in allTimeData do
	Disk:Write(key, value)
	end
	end
