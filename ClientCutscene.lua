--[[
    Cutscenes may seem hard, but they're surprisingly easy—though they're quite fragile. As a failsafe, though, you'll need the following code in a localscript,
    in case the player dies or their character somehow respawns:
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera;

player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid");
	camera.CameraSubject = char.Humanoid;
	camera.CameraType = Enum.CameraType.Custom;
end)

--[[
    Now, we're able to get to the meat of the code!
    To fully comprehend the meaning of it, however, you'll need a basic understanding of Roblox CFrames and Roblox's TweenService. 
    You can find out more here:

    https://create.roblox.com/docs/reference/engine/datatypes/CFrame
    https://create.roblox.com/docs/reference/engine/classes/TweenService

    Now, our first step is to find the CFrame of each of our desired cutscene angles.
    While this can be done manually, I find it's much easier to use Cutscene Editor v2, created by BadlyDev.
    We'll be using that plugin to acquire a table of CFrame values.
    
    Once you're done finding your angles, you should see a table the same or similar to the following one pop up on your screen:
]]

	local cutsceneAngles =
		{
			{CFrame = CFrame.lookAt((chest.PrimaryPart.CFrame:ToWorldSpace(CFrame.new(6, 0, 0)).Position), chest.PrimaryPart.CFrame.Position); Seconds = 0; Style = Enum.EasingStyle.Quad},

			{CFrame = CFrame.lookAt((chest.PrimaryPart.CFrame:ToWorldSpace(CFrame.new(6, 0, 0)).Position), chest.PrimaryPart.CFrame.Position); Seconds = 1.5; Style = Enum.EasingStyle.Quad}, -- same as previous

			{CFrame = CFrame.lookAt((chest.PrimaryPart.CFrame:ToWorldSpace(CFrame.new(0, 8, 10)).Position), chest.PrimaryPart.CFrame.Position); Seconds = 3.2; Style = Enum.EasingStyle.Quad},

			{CFrame = CFrame.lookAt((chest.PrimaryPart.CFrame:ToWorldSpace(CFrame.new(0, 8, 10)).Position), chest.PrimaryPart.CFrame.Position); Seconds = 1; Style = Enum.EasingStyle.Quad}, -- same as previous

			{CFrame = CFrame.lookAt((chest.PrimaryPart.CFrame:ToWorldSpace(CFrame.new(0, 8, 5)).Position), chest.PrimaryPart.CFrame.Position); Seconds = 0.5--[[6.66]]; Style = Enum.EasingStyle.Quart},
		}
--[[
    This table stores the position and rotation of the camera at each angle, as well as editable data about each angle,
    such as how long it takes the camera to tween between each angle's CFrame, and its general TweenInfo (again, study TweenService.)
    
    While this will be crucial for the structure of our cutscene, right now it's just a table. How do we utilize this table?
    Well, since each angle in our cutscene executes sequentially, we can index through the table using an ipairs for loop.
]]

	--> PLAY CAMERA CUTSCENES IN SUCCESSION
	for i, cutsceneInfo in ipairs(cutsceneAngles) do
		--[[ Put in here whatever actions you want to happen when the cutscene moves from angle-to-angle.]]
		end;
		local tween = ts:Create(camera, TweenInfo.new(cutsceneInfo.Seconds, cutsceneInfo.Style, Enum.EasingDirection.Out), {CFrame = cutsceneInfo.CFrame})
		tween:Play();
		tween.Completed:Wait();
	end
  
  --> Congratulations, you have run your cutscene! However, personally, I usually do stuff after the camera movements end, such as bring up a dialogue box. I do so below:
  local dialogueBox = Assets.GUIs.dialogueBox:Clone();
	dialogueBox.Parent = player.PlayerGui;
	local textLabel = dialogueBox.Frame.TextLabel;
	local endButton = dialogueBox.Frame.endButton;
	--> Orange text format (FOR RICHTEXT)
	local orangeRichTextBeginning = '<b><i><font color="#FF7800">';
	local orangeRichTextEnd       = '</font></i></b>';
	
	local gainBookTextLeftSide = "You have found  ";
	local gainBookTextRightSide = "  You can find it in the items section of your inventory.";
	
	--> Add text before the book name (character by character)
	for i = 1, string.len(gainBookTextLeftSide) do
		task.wait(0.01);
		local nextCharacter = string.sub(gainBookTextLeftSide, i, i);
		textLabel.Text = textLabel.Text .. nextCharacter;
		characterAddSound:Play();
	end
	--> Add the book name (character by character)
	for i = 1, string.len(book) do
		task.wait(0.025);
		local nextCharacter = orangeRichTextBeginning .. string.sub(book, i, i) .. orangeRichTextEnd;
		textLabel.Text = textLabel.Text .. nextCharacter;
		characterAddSound:Play();
	end
	textLabel.Text = textLabel.Text .. orangeRichTextBeginning .. '!' .. orangeRichTextEnd;
	task.wait(1);
	--> Add the text after the book name (character by character)
	for i = 1, string.len(gainBookTextRightSide) do
		task.wait(0.01);
		local nextCharacter = string.sub(gainBookTextRightSide, i, i);
		textLabel.Text = textLabel.Text .. nextCharacter;
		characterAddSound:Play();
	end
	
	--> Bring up the textbutton to close the dialogueBox
	local tweenSizeOfEndButton = ts:Create(
		endButton, 
		TweenInfo.new(1.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), 
		{Size = UDim2.new(0.2, 0, 0.4, 0)}
	):Play();
	
	--> Plays sound when mouse hovers over button
	local hoverOverButton = endButton.MouseEnter:Connect(function()
		hoverOverButtonSound:Play();
	end)
	
	--[[
		The closeEverything function below does the following:
			1.) Plays the closing dialogueBox sound
			2.) Stops the player's animations and destroys the chest (happens when openSourceChestEvent is fired [the name is misleading, i know])
			4.) Sets the camera back on the player
			5.) Disconnects the function connections (remove them from the server's memory)
			6.) Destroy the dialogueBox itself
	]]
	local closeEverything; closeEverything = endButton.MouseButton1Click:Connect(function()
		print("AAAAAAAAAAAAA");
		clickCloseDialogueButtonSound:Play();
		
		--> Fire callback (destroys the chest & cleans up all that stuff. "openSourceChestEvent" is misleading, i know)
		openSourceChestEvent:FireServer(player);
		
		camera.CameraSubject = player.Character.Humanoid;
		camera.CameraType = Enum.CameraType.Custom;
		
		hoverOverButton:Disconnect();
		closeEverything:Disconnect();
		
		dialogueBox:Destroy();
	end)
