game.ReplicatedStorage.Events.openChest:FireClient(player, chest, bookToAward);

--> Initiate callback to clean up anything that needs to disappear (e.g. treasure chest needs to be destroyed on the server after cutscene ends:

local onClientClickToStopOpeningChest; onClientClickToStopOpeningChest = game.ReplicatedStorage.Events.openSourceChest.OnServerEvent:Connect(function(plrPassedByEvent)
		if (plrPassedByEvent == player) then
			holdItem:Stop()
			--> Moves the player backwards so they don't accidentally touch another chest that might spawn immediately:
			player.Character.HumanoidRootPart.CFrame += player.Character.HumanoidRootPart.CFrame.LookVector * -4;
			if (chest) then 
				chest:Destroy();
			end;
			if (destination) then 
				destination:Destroy(); 
			end
			if (bookModel) then 
				bookModel:Destroy(); 
			end;
			if (player.Character.HumanoidRootPart.Anchored == true) then
				player.Character.Humanoid.WalkSpeed = 16;
				player.Character.HumanoidRootPart.Anchored = false;
			end
			onClientClickToStopOpeningChest:Disconnect();
		end
	end)
