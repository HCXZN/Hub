local Config = 
	{Toggles = {
		BoxEsp = false,
		TracerEsp = false,
		NameEsp = false,
		TeamColor = false,
	},
	Visuals = {
		BoxEsp = false,
		TracerEsp = false,
		Names = false,
		TeamCheck = true,
		EnemyColor = Color3.fromRGB(255,0,0),
		TeamColor = Color3.fromRGB(0,255,0),
		ShowTeam = false,
		Rainbow = false,
		Rainbow2 = false
	},
}
local UI_LIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/HCXZN/Hub/main/Utilities/UI.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/HCXZN/Hub/main/Utilities/Drawing.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeamService = game:GetService("Teams")

local LocalPlayer = PlayerService.LocalPlayer
local SilentAim,Aimbot,Trigger,GunModel,
ProjectileSpeed,ProjectileGravity,
GravityCorrection,Tortoiseshell
	= nil,false,false,nil,
1600,Vector3.new(0,150,0),2,
require(ReplicatedStorage.TS)

repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("LoadingGui").Enabled

function msg(txt)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CloudWare",
		Text = txt,
		Icon = "rbxassetid://7402129021"
	})
end


local BanReasons = {
	"Unsafe function",
	"Camera object",
	"Geometry deleted", 
	"Deleted remote",
	"Looking hard",
	"Unbound gloop", 
	"_G",
	"Alternate mode",
	"Shooting hard",
	"Fallback config",
	"Int check",
	"Coregui instance",
	"Floating",
	"Root",
	"Hitbox extender",
	"GetUpdate",
	"SetUpdate",
	"Invoke",
	"GetSetting",
	"FireProjectile",
}

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
	local args = {...}
	if getnamecallmethod() == "FireServer" then
		for Index, Reason in pairs(BanReasons) do
			if typeof(args[2]) == "string" and string.match(args[2],Reason) then
				return
			end
		end
	end
	return __namecall(self, ...)
end)

msg("Bypassed Client AntiCheat.")



local Window = UI_LIB:Window({
	Name = "Bad Business",
	Position = UDim2.new(0.05,0,0.5,-248)
}) do Window:Watermark({Enabled = false})
	local VisualsTab = Window:Tab({Name = "Visuals"}) do
		local GlobalSection = VisualsTab:Section({Name = "ESP",Side = "Left"}) do
			GlobalSection:Toggle({Name = "Boxes",Flag = "ESP/Boxes",Value = false})
			GlobalSection:Toggle({Name = "Names", Flag = "ESP/Names", Value = false})
			GlobalSection:Toggle({Name = "TeamColor", Flag = "ESP/TeamColor", Value = false})
		end
		
		local TracerSection = VisualsTab:Section({Name = "Tracers",Side = "Right"}) do
			TracerSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Tracer/Enabled",Value = false})
			TracerSection:Dropdown({Name = "Mode",Flag = "ESP/Player/Tracer/Mode",List = {
				{Name = "From Bottom",Mode = "Button",Value = true},
				{Name = "From Mouse",Mode = "Button"}
			}})
			TracerSection:Slider({Name = "Thickness",Flag = "ESP/Player/Tracer/Thickness",Min = 1,Max = 10,Value = 1})
			TracerSection:Slider({Name = "Transparency",Flag = "ESP/Player/Tracer/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
		end
	end
	
	local AimAssistTab = Window:Tab({Name = "Aimbot"})
	local SilentAimSection = AimAssistTab:Section({Name = "Silent Aim",Side = "Left"}) do
		SilentAimSection:Toggle({Name = "Enabled",Flag = "SilentAim/Enabled",Value = false})
		:Keybind({Mouse = true,Flag = "SilentAim/Keybind"})
		SilentAimSection:Toggle({Name = "AutoShoot",Flag = "BadBusiness/AutoShoot",Value = false})
		SilentAimSection:Toggle({Name = "AutoShoot 360 Mode",Flag = "BadBusiness/AutoShoot/AllFOV",Value = false})
		SilentAimSection:Toggle({Name = "Visibility Check",Flag = "SilentAim/WallCheck",Value = false})
		SilentAimSection:Toggle({Name = "Distance Check",Flag = "SilentAim/DistanceCheck",Value = false})
		SilentAimSection:Toggle({Name = "Dynamic FOV",Flag = "SilentAim/DynamicFOV",Value = false})
		SilentAimSection:Slider({Name = "Hit Chance",Flag = "SilentAim/HitChance",Min = 0,Max = 100,Value = 100,Unit = "%"})
		SilentAimSection:Slider({Name = "Field Of View",Flag = "SilentAim/FieldOfView",Min = 0,Max = 500,Value = 100})
		SilentAimSection:Slider({Name = "Distance",Flag = "SilentAim/Distance",Min = 25,Max = 1000,Value = 1000,Unit = "meters"})
		SilentAimSection:Dropdown({Name = "Body Parts",Flag = "SilentAim/BodyParts",List = {
			{Name = "Head",Mode = "Toggle",Value = true},
			{Name = "Neck",Mode = "Toggle"},
			{Name = "Chest",Mode = "Toggle"},
			{Name = "Abdomen",Mode = "Toggle"},
			{Name = "Hips",Mode = "Toggle"}
		}})
	end
	
	local MiscTab = Window:Tab({Name = "Miscellaneous"}) do
		local GMSection = MiscTab:Section({Name = "GunMods",Side = "Left"}) do
			GMSection:Toggle({Name = "Infinite Ammo",Flag = "Gunmods/InfAmmo",Value = false})
		end
	end
	
	
	
	local PlayerTable=getupvalue(require(game.ReplicatedStorage.TS).Characters.GetCharacter,1)
	local RemoteFolder
	local RemoteObjects={}
	for _,v in pairs(game.ReplicatedStorage:GetChildren())do
		if v:IsA("Folder")then
			for _,c in pairs(v:GetChildren())do
				if c:IsA("ModuleScript")then
					for _,x in pairs(c:GetChildren())do
						if x:IsA("Folder")then
							if x:FindFirstChild("Character")then
								RemoteFolder=x
								for _,z in pairs(x:GetChildren())do
									RemoteObjects[z.Name.."_"..z.ClassName]=z
								end
							end
						end
					end
				end
			end
		end
	end
	local IsAlive=function()
		if PlayerTable[game.Players.LocalPlayer]then
			if PlayerTable[game.Players.LocalPlayer].Parent==game.Workspace.Characters then
				if PlayerTable[game.Players.LocalPlayer]:FindFirstChild("Root")then
					return true
				end
			end
		end
		return false
	end
	game.RunService.RenderStepped:Connect(function()
		if IsAlive() and Window.Flags["Gunmods/InfAmmo"] == true then
			RemoteFolder.Item_Paintball:FireServer("Reload",PlayerTable[game.Players.LocalPlayer].Backpack.Equipped.Value)
			PlayerTable[game.Players.LocalPlayer].Backpack.Equipped.Value.State.Ammo.Value=9999
		end
	end)
	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Tortoiseshell = require(ReplicatedStorage.TS)

	
end

Window:LoadDefaultConfig("CloudWare/BadBussiness")

for Index,Player in pairs(PlayerService:GetPlayers()) do
	if Player == LocalPlayer then continue end
	CloudWare.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
end
PlayerService.PlayerAdded:Connect(function(Player)
	CloudWare.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
	CloudWare.Utilities.Drawing:RemoveESP(Player)
end)


Config.Toggles.BoxEsp = Window.Flags["ESP/Boxes"]
Config.Toggles.NameEsp = Window.Flags["ESP/Names"]
Config.Toggles.TeamColor = Window.Flags["ESP/TeamColor"]

function DrawSquare()
local Box = Drawing.new("Square")
Box.Color = Color3.fromRGB(190, 190, 0)
Box.Thickness = 0.5
Box.Filled = false
Box.Transparency = 1
return Box
end

function DrawLine()
	local line = Drawing.new("Line")
	line.Color = Color3.new(190, 190, 0)
	line.Thickness = 0.5
	return line
end

function DrawText()
	local text = Drawing.new("Text")
	text.Color = Color3.fromRGB(190, 190, 0)
	text.Size = 20
	text.Outline = true
	text.Center = true
	return text
end

Main = require(game:GetService("ReplicatedStorage"):WaitForChild("TS"));

function AddEsp(player)
	local Box = DrawSquare()
	local Tracer = DrawLine()
	local Name = DrawText()
	game:GetService('RunService').Stepped:Connect(function()
		pcall(function()
			if Main.Characters:GetCharacter(player) == nil or Main.Characters:GetCharacter(player).Health.Value == 0 then
				Box.Visible = false
				Tracer.Visible = false
				Name.Visible = false
			else
				if Config.Toggles.ShowTeam then
					if Config.Visuals.TeamCheck and Main.Teams:GetPlayerTeam(player) == Main.Teams:GetPlayerTeam(game.Players.LocalPlayer) then
						Box.Color = Config.Visuals.TeamColor
						Tracer.Color = Config.Visuals.TeamColor
						Name.Color = Config.Visuals.TeamColor
					else
						Box.Color = Config.Visuals.EnemyColor
						Tracer.Color = Config.Visuals.EnemyColor
						Name.Color = Config.Visuals.EnemyColor
					end
					if Main.Characters:GetCharacter(player).Body:FindFirstChild("Chest") and player.InMenu.Value == false then
						local RootPosition, OnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position)
						local HeadPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position + Vector3.new(0, 0.5, 0))
						local LegPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position - Vector3.new(0, 4, 0))
						if Config.Toggles.BoxEsp then
							Box.Visible = OnScreen
							Box.Size = Vector2.new((2350 / RootPosition.Z) + 2.5, HeadPosition.Y - LegPosition.Y)
							Box.Position = Vector2.new((RootPosition.X - Box.Size.X / 2) - 1, RootPosition.Y - Box.Size.Y / 2)
						else
							Box.Visible = false
						end
						if Config.Toggles.TracerEsp then
							Tracer.Visible = OnScreen
							Tracer.To = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, 1000)
							Tracer.From = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position).X - 1, RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2)
						else
							Tracer.Visible = false
						end
						if Config.Toggles.NameEsp then
							Name.Visible = OnScreen
							Name.Position = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).X, game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).Y - 40)
							Name.Text = player.Name
						else
							Name.Visible = false
						end
					else
						Box.Visible = false
						Tracer.Visible = false
						Name.Visible = false
					end
					if not player then
						Box.Visible = false
						Tracer.Visible = false
						Name.Visible = false
					end
				else
					if Main.Teams:GetPlayerTeam(player) == Main.Teams:GetPlayerTeam(game.Players.LocalPlayer) then
						Box.Visible = false
						Tracer.Visible = false
						Name.Visible = false
					end
					if Config.Visuals.TeamCheck and Main.Teams:GetPlayerTeam(player) ~= Main.Teams:GetPlayerTeam(game.Players.LocalPlayer) then
						Box.Color = Config.Visuals.EnemyColor
						Tracer.Color = Config.Visuals.EnemyColor
						Name.Color = Config.Visuals.EnemyColor
						if Main.Characters:GetCharacter(player).Body:FindFirstChild("Chest") and player.InMenu.Value == false then
							local RootPosition, OnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position)
							local HeadPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position + Vector3.new(0, 0.5, 0))
							local LegPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position - Vector3.new(0, 4, 0))
							if Config.Toggles.BoxEsp then
								Box.Visible = OnScreen
								Box.Size = Vector2.new((2350 / RootPosition.Z) + 2.5, HeadPosition.Y - LegPosition.Y)
								Box.Position = Vector2.new((RootPosition.X - Box.Size.X / 2) - 1, RootPosition.Y - Box.Size.Y / 2)
							else
								Box.Visible = false
							end
							if Config.Toggles.TracerEsp then
								Tracer.Visible = OnScreen
								Tracer.To = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, 1000)
								Tracer.From = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Chest.Position).X - 1, RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2)
							else
								Tracer.Visible = false
							end
							if Config.Toggles.NameEsp then
								Name.Visible = OnScreen
								Name.Position = Vector2.new(game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).X, game.Workspace.CurrentCamera:WorldToViewportPoint(Main.Characters:GetCharacter(player).Body.Head.Position).Y - 40)
								Name.Text = player.Name
							else
								Name.Visible = false
							end
						else
							Box.Visible = false
							Tracer.Visible = false
							Name.Visible = false
						end
						if not player then
							Box.Visible = false
							Tracer.Visible = false
							Name.Visible = false
						end
					end
				end
			end
		end)
	end)
end

for i, v in pairs(game:GetService('Players'):GetPlayers()) do
	if v ~= game:GetService('Players').LocalPlayer then
		AddEsp(v)
	end
end

game:GetService('Players').PlayerAdded:Connect(function(player)
	if v ~= game:GetService('Players').LocalPlayer then
		AddEsp(player)
	end
end)
