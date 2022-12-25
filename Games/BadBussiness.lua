local UI_LIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/HCXZN/Bad-Bussiness/main/Utilities/UI_Library.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/HCXZN/Bad-Bussiness/main/Utilities/ESP_LIB.lua"))()
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
}) do Window:Watermark({Enabled = true})
	local AimAssistTab = Window:Tab({Name = "Aimbot"})
	local SilentAimSection = AimAssistTab:Section({Name = "Silent Aim",Side = "Right"}) do
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
	
	local VisualsTab = Window:Tab({Name = "Visuals"}) do
		local GlobalSection = VisualsTab:Section({Name = "ESP",Side = "Left"}) do
			GlobalSection:Colorpicker({Name = "Ally Color",Flag = "ESP/Player/Ally",Value = {0.3333333432674408,0.6666666269302368,1,0,false}})
			GlobalSection:Colorpicker({Name = "Enemy Color",Flag = "ESP/Player/Enemy",Value = {1,0.6666666269302368,1,0,false}})
			GlobalSection:Toggle({Name = "Team Check",Flag = "ESP/Player/TeamCheck",Value = true})
			GlobalSection:Toggle({Name = "Use Team Color",Flag = "ESP/Player/TeamColor",Value = false})
			GlobalSection:Toggle({Name = "Distance Check",Flag = "ESP/Player/DistanceCheck",Value = false})
			GlobalSection:Slider({Name = "Distance",Flag = "ESP/Player/Distance",Min = 25,Max = 1000,Value = 250,Unit = "meters"})
		end
		local BoxSection = VisualsTab:Section({Name = "ESP Boxes",Side = "Left"}) do
			BoxSection:Toggle({Name = "Box Enabled",Flag = "ESP/Player/Box/Enabled",Value = false})
			BoxSection:Toggle({Name = "Healthbar",Flag = "ESP/Player/Box/Healthbar",Value = false})
			BoxSection:Divider()
			BoxSection:Toggle({Name = "Text Enabled",Flag = "ESP/Player/Text/Enabled",Value = false})
			BoxSection:Dropdown({Name = "Font",Flag = "ESP/Player/Text/Font",List = {
				{Name = "UI",Mode = "Button",Value = true},
				{Name = "System",Mode = "Button"},
				{Name = "Plex",Mode = "Button"},
				{Name = "Monospace",Mode = "Button"}
			}})
			BoxSection:Slider({Name = "Size",Flag = "ESP/Player/Text/Size",Min = 13,Max = 100,Value = 16})
			BoxSection:Slider({Name = "Transparency",Flag = "ESP/Player/Text/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
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
end

UI_LIB:Init()

for Index,Player in pairs(PlayerService:GetPlayers()) do
	if Player == LocalPlayer then continue end
	--CloudWare.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
end
PlayerService.PlayerAdded:Connect(function(Player)
	--CloudWare.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
	--CloudWare.Utilities.Drawing:RemoveESP(Player)
end)
