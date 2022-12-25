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
}) do Window:Watermark({Enabled = true})
	local VisualsTab = Window:Tab({Name = "Visuals"}) do
		local GlobalSection = VisualsTab:Section({Name = "ESP",Side = "Left"}) do
			GlobalSection:Colorpicker({Name = "Enable ESP",Flag = "ESP/Enable",Value = {0.3333333432674408,0.6666666269302368,1,0,false}})
			
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
	
	if Window.Flags["ESP/Enable"] == true then
		--// SERVICES \\--
		local playerser = game:GetService("Players")
		local repstor = game:GetService("ReplicatedStorage")
		local repfirst = game:GetService("ReplicatedFirst")
		local inputser = game:GetService("UserInputService")
		local runser = game:GetService("RunService")
		local coregui = game:GetService("CoreGui")
		local tweenser = game:GetService("TweenService")

		--// VARIABLES \\--
		local client = playerser.LocalPlayer
		local camera = workspace.CurrentCamera
		local playergui = client:WaitForChild("PlayerGui")
		playergui:SetTopbarTransparency(1)
		local mouse = client:GetMouse()
		local heartbeat = runser.Heartbeat
		local renderstep = runser.RenderStepped

		--// LOCALS \\--
		local colors = {
			esp = Color3.fromRGB(171, 73, 245),
			esp_visible = Color3.fromRGB(255, 128, 234),
			minDistance = Color3.fromRGB(0, 255, 127)
		}
		local options = {
			drawMinDistance = true, --// toggles circle visibility
			minDistance = 50, --// minimum distance from crosshair to lock on
		}
		local aimbotting = false
		local sg = Instance.new("ScreenGui", coregui)
		local espFolder = Instance.new("Folder", sg)

		local circle = Instance.new("ImageLabel")
		circle.Position = UDim2.new(0.5,0,0.5,-18)
		circle.AnchorPoint = Vector2.new(0.5,0.5)
		circle.Size = UDim2.new(0,options.minDistance*2,0,options.minDistance*2)
		circle.BackgroundTransparency = 1
		circle.ImageColor3 = colors.minDistance
		circle.Image = "rbxassetid://3400997895"
		if options.drawMinDistance then
			circle.Parent = sg
		end

		local bodyParts = {
			["Head"] = true,
			["Chest"] = true,
			["Abdomen"] = true,
			["Hips"] = true,
			["LeftUpperArm"] = true,
			["RightUpperArm"] = true,
			["RightLowerArm"] = true,
			["LeftLowerArm"] = true,
			["LeftHand"] = true,
			["RightHand"] = true,
			["LeftUpperLeg"] = true,
			["RightUpperLeg"] = true,
			["LeftLowerLeg"] = true,
			["RightLowerLeg"] = true,
			["LeftFoot"] = true,
			["RightFoot"] = true
		}
		--// FUNCTIONS \\--
		function mouseMove(x,y)
			if syn  then
				mousemoverel(x,y)
			end
		end
		local function createBox(player)
			local lines = Instance.new("Frame")
			lines.Name = player.Name
			lines.BackgroundTransparency = 1
			lines.AnchorPoint = Vector2.new(0.5,0.5)

			local outlines = Instance.new("Folder", lines)
			outlines.Name = "outlines"
			local inlines = Instance.new("Folder", lines)
			inlines.Name = "inlines"

			local outline1 = Instance.new("Frame", outlines)
			outline1.Name = "left"
			outline1.BorderSizePixel = 0
			outline1.BackgroundColor3 = Color3.new(0,0,0)
			outline1.Size = UDim2.new(0,-1,1,0)

			local outline2 = Instance.new("Frame", outlines)
			outline2.Name = "right"
			outline2.BorderSizePixel = 0
			outline2.BackgroundColor3 = Color3.new(0,0,0)
			outline2.Position = UDim2.new(1,0,0,0)
			outline2.Size = UDim2.new(0,1,1,0)

			local outline3 = Instance.new("Frame", outlines)
			outline3.Name = "up"
			outline3.BorderSizePixel = 0
			outline3.BackgroundColor3 = Color3.new(0,0,0)
			outline3.Size = UDim2.new(1,0,0,-1)

			local outline4 = Instance.new("Frame", outlines)
			outline4.Name = "down"
			outline4.BorderSizePixel = 0
			outline4.BackgroundColor3 = Color3.new(0,0,0)
			outline4.Position = UDim2.new(0,0,1,0)
			outline4.Size = UDim2.new(1,0,0,1)

			local inline1 = Instance.new("Frame", inlines)
			inline1.Name = "left"
			inline1.BorderSizePixel = 0
			inline1.Size = UDim2.new(0,1,1,0)

			local inline2 = Instance.new("Frame", inlines)
			inline2.Name = "right"
			inline2.BorderSizePixel = 0
			inline2.Position = UDim2.new(1,0,0,0)
			inline2.Size = UDim2.new(0,-1,1,0)

			local inline3 = Instance.new("Frame", inlines)
			inline3.Name = "up"
			inline3.BorderSizePixel = 0
			inline3.Size = UDim2.new(1,0,0,1)

			local inline4 = Instance.new("Frame", inlines)
			inline4.Name = "down"
			inline4.BorderSizePixel = 0
			inline4.Position = UDim2.new(0,0,1,0)
			inline4.Size = UDim2.new(1,0,0,-1)

			local text = Instance.new("TextLabel", lines)
			text.Name = "nametag"
			text.Position =  UDim2.new(0.5,0,0,-12)
			text.Size = UDim2.new(0,100,0,-20)
			text.AnchorPoint = Vector2.new(0.5,0.5)
			text.BackgroundTransparency = 1
			text.Text = player.Name
			text.Font = Enum.Font.Code
			text.TextSize = 14
			text.TextStrokeTransparency = 0

			local health = Instance.new("Frame", lines)
			health.Name = "health"
			health.Position = UDim2.new(0,1,1,-1)
			health.Size = UDim2.new(0.1,0,1,-2)
			health.AnchorPoint = Vector2.new(0,1)
			health.BackgroundTransparency = 0
			health.BackgroundColor3 = Color3.fromRGB(30,30,30)
			health.BorderSizePixel = 0
			local bar = Instance.new("Frame", health)
			bar.Name = "bar"
			bar.Position = UDim2.new(0,0,1,0)
			bar.AnchorPoint = Vector2.new(0,1)
			bar.BackgroundTransparency = 0
			bar.BackgroundColor3 = Color3.fromRGB(0,255,127)
			bar.BorderSizePixel = 0

			return lines
		end

		local function updateEsp(player, box)
			runser:BindToRenderStep(player.Name.."'s esp", 1, function()
				local clientchar = workspace.Characters:FindFirstChild(client.Name)
				local xMin = camera.ViewportSize.X
				local yMin = camera.ViewportSize.Y
				local xMax = 0
				local yMax = 0
				if player and player:FindFirstChild"Body" and player.Body:FindFirstChild"Head" then
					local screenPos, vis = camera:WorldToScreenPoint(player.PrimaryPart.Position)
					local nameTagPos = camera:WorldToScreenPoint(player.Body.Head.Position)
					if vis then
						box.Visible = true
						local function getCorners(obj, size)
							local corners = {
								Vector3.new(obj.X+size.X/2, obj.Y+size.Y/2, obj.Z+size.Z/2);
								Vector3.new(obj.X-size.X/2, obj.Y+size.Y/2, obj.Z+size.Z/2);

								Vector3.new(obj.X-size.X/2, obj.Y-size.Y/2, obj.Z-size.Z/2);
								Vector3.new(obj.X+size.X/2, obj.Y-size.Y/2, obj.Z-size.Z/2);

								Vector3.new(obj.X-size.X/2, obj.Y+size.Y/2, obj.Z-size.Z/2);
								Vector3.new(obj.X+size.X/2, obj.Y+size.Y/2, obj.Z-size.Z/2);

								Vector3.new(obj.X-size.X/2, obj.Y-size.Y/2, obj.Z+size.Z/2);
								Vector3.new(obj.X+size.X/2, obj.Y-size.Y/2, obj.Z+size.Z/2);
							}
							return corners
						end
						local i = 1
						local allCorners = {}
						for _,v in pairs(player.Body:GetChildren()) do
							if bodyParts[v.Name] then
								local a = getCorners(v.CFrame, v.Size)
								for _,v in pairs(a) do
									table.insert(allCorners, i, v)
									i = i + 1
								end
							end
						end
						for i,v in pairs(allCorners) do
							local pos = camera:WorldToScreenPoint(v)
							if pos.X > xMax then
								xMax = pos.X
							end
							if pos.X < xMin then
								xMin = pos.X
							end
							if pos.Y > yMax then
								yMax = pos.Y
							end
							if pos.Y < yMin then
								yMin = pos.Y
							end
						end
						local xSize = xMax - xMin
						local ySize = yMax - yMin
						box.Position = UDim2.new(0,xMin+(Vector2.new(xMax,0)-Vector2.new(xMin,0)).magnitude/2,0,yMin+(Vector2.new(0,yMax)-Vector2.new(0,yMin)).magnitude/2)
						box.Size = UDim2.new(0,xSize,0,ySize)

						local ignore = {clientchar, camera, workspace:FindFirstChild"Arms"}
						for _,v in pairs(workspace:GetChildren()) do
							if v:IsA"Model" and v.Name ~= "Arms" then
								table.insert(ignore, 4, v)
							end
						end
						local ray = Ray.new(camera.CFrame.p, (player.Body.Head.Position-camera.CFrame.p).unit*1000)
						local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore, false, false)
						local suffix
						if hit and hit:FindFirstAncestor(player.Name) then
							suffix = "_visible"
						else
							suffix = ""
						end
						for _,v in pairs(box.inlines:GetChildren()) do
							v.BackgroundColor3 = colors["esp"..suffix]
						end
						box.nametag.TextColor3 = Color3.fromRGB(255, 255, 255)
						if player:FindFirstChild"Health" then
							box.health.bar.Size = UDim2.new(1,0,player.Health.Value/150,0)
						end
					else
						box.Visible = false
					end
				else
					box.Visible = false
				end
			end)
		end

		local function checkTeam(player, caller)
			local omegaTeam = game.Teams.Omega.Players
			local betaTeam = game.Teams.Beta.Players
			local myTeam
			if omegaTeam:FindFirstChild(client.Name) then
				myTeam = "Omega"
			elseif betaTeam:FindFirstChild(client.Name) then
				myTeam = "Beta"
			end
			local enemyTeam
			if omegaTeam:FindFirstChild(player.Name) then
				enemyTeam = "Omega"
			elseif betaTeam:FindFirstChild(player.Name) then
				enemyTeam = "Beta"
			end
			if enemyTeam ~= myTeam then
				if caller == "esp" then
					local box = createBox(player)
					updateEsp(player, box)
					box.Parent = espFolder
				end
				return true
			else
				return false
			end
		end





		for _,player in pairs(workspace.Characters:GetChildren()) do
			checkTeam(player, "esp")
		end

		workspace.Characters.ChildAdded:connect(function(player)
			checkTeam(player, "esp")
		end)

		workspace.Characters.ChildRemoved:connect(function(player)
			runser:UnbindFromRenderStep(player.Name.."'s esp")
			if espFolder:FindFirstChild(player.Name) then
				espFolder[player.Name]:Destroy()
			end
		end)

		local LocalPlayer, Characters, ESPList, LocalCharacter = game:GetService('Players').LocalPlayer, workspace.Characters, {}

		local Leaderboard = LocalPlayer.PlayerGui.LeaderboardGui.Leaderboard
		local function GetTeam(Player)
			local Name = Player.Name
			for i,v in next, Leaderboard.Teams:GetDescendants() do
				if v.Name == 'NameLabel' and v.Text == Name then
					return v.Parent.Parent.Parent
				end
			end
		end

		local Camera, Div = workspace.CurrentCamera, Vector2.new(2,2)
		local function GetNearestToCenter()
			local Center = Camera.ViewportSize / Div
			local Character, CharacterDistance, ScreenPosition = nil, 0, nil
			-- Created by Peyton @ V3rmillion
			for i,v in next, Characters:GetChildren() do
				if v.Name ~= LocalPlayer.Name and GetTeam(v) ~= GetTeam(LocalPlayer) and v:FindFirstChild('Health') and v.Health.Value > 0 and v:FindFirstChild('Hitbox') and v.Hitbox:FindFirstChild('Head') then
					local clientchar = workspace.Characters:FindFirstChild(client.Name)
					local ignore = {clientchar, camera, workspace:FindFirstChild"Arms"}
					for _,v in pairs(workspace:GetChildren()) do
						if v:IsA"Model" and v.Name ~= "Arms" then
							table.insert(ignore, 4, v)
						end
					end
					local ray = Ray.new(camera.CFrame.p, (v.Body.Head.Position-camera.CFrame.p).unit*1000)
					local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore, false, false)
					if hit and hit:FindFirstAncestor(v.Name) then
						local Position, OnScreen = Camera:WorldToViewportPoint(v.Hitbox.Head.Position)
						if OnScreen then
							local Vec2 = Vector2.new(Position.X, Position.Y)
							local Distance = (Vec2 - Center).magnitude
							if not Character or CharacterDistance > Distance then
								Character, CharacterDistance, ScreenPosition = v, Distance, Vec2
							end
						end
					end
				end
			end
			return ScreenPosition and Center and (ScreenPosition - Center) or nil
		end


		local function Add(Character)
			if Character == workspace.Characters:FindFirstChild(LocalPlayer.Name) then
				LocalCharacter = Character
			elseif GetTeam(Character) ~= GetTeam(LocalPlayer) then
				--ESPList[Character] = NewCircle()
			end
		end

		local function Remove(Character)
			if ESPList[Character] then
				ESPList[Character]:Remove()
				ESPList[Character] = nil
			end
		end


		for i,v in next, Characters:GetChildren() do Add(v) end
		Characters.ChildAdded:Connect(Add)
		Characters.ChildRemoved:Connect(Remove)
	else
		--// SERVICES \\--
		local playerser = game:GetService("Players")
		local repstor = game:GetService("ReplicatedStorage")
		local repfirst = game:GetService("ReplicatedFirst")
		local inputser = game:GetService("UserInputService")
		local runser = game:GetService("RunService")
		local coregui = game:GetService("CoreGui")
		local tweenser = game:GetService("TweenService")

		--// VARIABLES \\--
		local client = playerser.LocalPlayer
		local camera = workspace.CurrentCamera
		local playergui = client:WaitForChild("PlayerGui")
		playergui:SetTopbarTransparency(1)
		local mouse = client:GetMouse()
		local heartbeat = runser.Heartbeat
		local renderstep = runser.RenderStepped

		--// LOCALS \\--
		local colors = {
			esp = Color3.fromRGB(171, 73, 245),
			esp_visible = Color3.fromRGB(255, 128, 234),
			minDistance = Color3.fromRGB(0, 255, 127)
		}
		local options = {
			drawMinDistance = false,
			minDistance = 0,
		}
		local aimbotting = false
		local sg = Instance.new("ScreenGui", coregui)
		local espFolder = Instance.new("Folder", sg)

		local circle = Instance.new("ImageLabel")
		circle.Position = UDim2.new(0.5,0,0.5,-18)
		circle.AnchorPoint = Vector2.new(0.5,0.5)
		circle.Size = UDim2.new(0,options.minDistance*2,0,options.minDistance*2)
		circle.BackgroundTransparency = 1
		circle.ImageColor3 = colors.minDistance
		circle.Image = "rbxassetid://3400997895"
		if options.drawMinDistance then
			circle.Parent = sg
		end

		local bodyParts = {
			["Head"] = false,
			["Chest"] = false,
			["Abdomen"] = false,
			["Hips"] = false,
			["LeftUpperArm"] = false,
			["RightUpperArm"] = false,
			["RightLowerArm"] = false,
			["LeftLowerArm"] = false,
			["LeftHand"] = false,
			["RightHand"] = false,
			["LeftUpperLeg"] = false,
			["RightUpperLeg"] = false,
			["LeftLowerLeg"] = false,
			["RightLowerLeg"] = false,
			["LeftFoot"] = false,
			["RightFoot"] = false
		}
		--// FUNCTIONS \\--
		function mouseMove(x,y)
			if syn  then
				mousemoverel(x,y)
			end
		end
		local function createBox(player)
			local lines = Instance.new("Frame")
			lines.Name = player.Name
			lines.BackgroundTransparency = 1
			lines.AnchorPoint = Vector2.new(0.5,0.5)

			local outlines = Instance.new("Folder", lines)
			outlines.Name = "outlines"
			local inlines = Instance.new("Folder", lines)
			inlines.Name = "inlines"

			local outline1 = Instance.new("Frame", outlines)
			outline1.Name = "left"
			outline1.BorderSizePixel = 0
			outline1.BackgroundColor3 = Color3.new(0,0,0)
			outline1.Size = UDim2.new(0,-1,1,0)

			local outline2 = Instance.new("Frame", outlines)
			outline2.Name = "right"
			outline2.BorderSizePixel = 0
			outline2.BackgroundColor3 = Color3.new(0,0,0)
			outline2.Position = UDim2.new(1,0,0,0)
			outline2.Size = UDim2.new(0,1,1,0)

			local outline3 = Instance.new("Frame", outlines)
			outline3.Name = "up"
			outline3.BorderSizePixel = 0
			outline3.BackgroundColor3 = Color3.new(0,0,0)
			outline3.Size = UDim2.new(1,0,0,-1)

			local outline4 = Instance.new("Frame", outlines)
			outline4.Name = "down"
			outline4.BorderSizePixel = 0
			outline4.BackgroundColor3 = Color3.new(0,0,0)
			outline4.Position = UDim2.new(0,0,1,0)
			outline4.Size = UDim2.new(1,0,0,1)

			local inline1 = Instance.new("Frame", inlines)
			inline1.Name = "left"
			inline1.BorderSizePixel = 0
			inline1.Size = UDim2.new(0,1,1,0)

			local inline2 = Instance.new("Frame", inlines)
			inline2.Name = "right"
			inline2.BorderSizePixel = 0
			inline2.Position = UDim2.new(1,0,0,0)
			inline2.Size = UDim2.new(0,-1,1,0)

			local inline3 = Instance.new("Frame", inlines)
			inline3.Name = "up"
			inline3.BorderSizePixel = 0
			inline3.Size = UDim2.new(1,0,0,1)

			local inline4 = Instance.new("Frame", inlines)
			inline4.Name = "down"
			inline4.BorderSizePixel = 0
			inline4.Position = UDim2.new(0,0,1,0)
			inline4.Size = UDim2.new(1,0,0,-1)

			local text = Instance.new("TextLabel", lines)
			text.Name = "nametag"
			text.Position =  UDim2.new(0.5,0,0,-12)
			text.Size = UDim2.new(0,100,0,-20)
			text.AnchorPoint = Vector2.new(0.5,0.5)
			text.BackgroundTransparency = 1
			text.Text = player.Name
			text.Font = Enum.Font.Code
			text.TextSize = 14
			text.TextStrokeTransparency = 0

			local health = Instance.new("Frame", lines)
			health.Name = "health"
			health.Position = UDim2.new(0,1,1,-1)
			health.Size = UDim2.new(0.1,0,1,-2)
			health.AnchorPoint = Vector2.new(0,1)
			health.BackgroundTransparency = 0
			health.BackgroundColor3 = Color3.fromRGB(30,30,30)
			health.BorderSizePixel = 0
			local bar = Instance.new("Frame", health)
			bar.Name = "bar"
			bar.Position = UDim2.new(0,0,1,0)
			bar.AnchorPoint = Vector2.new(0,1)
			bar.BackgroundTransparency = 0
			bar.BackgroundColor3 = Color3.fromRGB(0,255,127)
			bar.BorderSizePixel = 0

			return lines
		end

		local function updateEsp(player, box)
			runser:BindToRenderStep(player.Name.."'s esp", 1, function()
				local clientchar = workspace.Characters:FindFirstChild(client.Name)
				local xMin = camera.ViewportSize.X
				local yMin = camera.ViewportSize.Y
				local xMax = 0
				local yMax = 0
				if player and player:FindFirstChild"Body" and player.Body:FindFirstChild"Head" then
					local screenPos, vis = camera:WorldToScreenPoint(player.PrimaryPart.Position)
					local nameTagPos = camera:WorldToScreenPoint(player.Body.Head.Position)
					if vis then
						box.Visible = true
						local function getCorners(obj, size)
							local corners = {
								Vector3.new(obj.X+size.X/2, obj.Y+size.Y/2, obj.Z+size.Z/2);
								Vector3.new(obj.X-size.X/2, obj.Y+size.Y/2, obj.Z+size.Z/2);

								Vector3.new(obj.X-size.X/2, obj.Y-size.Y/2, obj.Z-size.Z/2);
								Vector3.new(obj.X+size.X/2, obj.Y-size.Y/2, obj.Z-size.Z/2);

								Vector3.new(obj.X-size.X/2, obj.Y+size.Y/2, obj.Z-size.Z/2);
								Vector3.new(obj.X+size.X/2, obj.Y+size.Y/2, obj.Z-size.Z/2);

								Vector3.new(obj.X-size.X/2, obj.Y-size.Y/2, obj.Z+size.Z/2);
								Vector3.new(obj.X+size.X/2, obj.Y-size.Y/2, obj.Z+size.Z/2);
							}
							return corners
						end
						local i = 1
						local allCorners = {}
						for _,v in pairs(player.Body:GetChildren()) do
							if bodyParts[v.Name] then
								local a = getCorners(v.CFrame, v.Size)
								for _,v in pairs(a) do
									table.insert(allCorners, i, v)
									i = i + 1
								end
							end
						end
						for i,v in pairs(allCorners) do
							local pos = camera:WorldToScreenPoint(v)
							if pos.X > xMax then
								xMax = pos.X
							end
							if pos.X < xMin then
								xMin = pos.X
							end
							if pos.Y > yMax then
								yMax = pos.Y
							end
							if pos.Y < yMin then
								yMin = pos.Y
							end
						end
						local xSize = xMax - xMin
						local ySize = yMax - yMin
						box.Position = UDim2.new(0,xMin+(Vector2.new(xMax,0)-Vector2.new(xMin,0)).magnitude/2,0,yMin+(Vector2.new(0,yMax)-Vector2.new(0,yMin)).magnitude/2)
						box.Size = UDim2.new(0,xSize,0,ySize)

						local ignore = {clientchar, camera, workspace:FindFirstChild"Arms"}
						for _,v in pairs(workspace:GetChildren()) do
							if v:IsA"Model" and v.Name ~= "Arms" then
								table.insert(ignore, 4, v)
							end
						end
						local ray = Ray.new(camera.CFrame.p, (player.Body.Head.Position-camera.CFrame.p).unit*1000)
						local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore, false, false)
						local suffix
						if hit and hit:FindFirstAncestor(player.Name) then
							suffix = "_visible"
						else
							suffix = ""
						end
						for _,v in pairs(box.inlines:GetChildren()) do
							v.BackgroundColor3 = colors["esp"..suffix]
						end
						box.nametag.TextColor3 = Color3.fromRGB(255, 255, 255)
						if player:FindFirstChild"Health" then
							box.health.bar.Size = UDim2.new(1,0,player.Health.Value/150,0)
						end
					else
						box.Visible = false
					end
				else
					box.Visible = false
				end
			end)
		end

		local function checkTeam(player, caller)
			local omegaTeam = game.Teams.Omega.Players
			local betaTeam = game.Teams.Beta.Players
			local myTeam
			if omegaTeam:FindFirstChild(client.Name) then
				myTeam = "Omega"
			elseif betaTeam:FindFirstChild(client.Name) then
				myTeam = "Beta"
			end
			local enemyTeam
			if omegaTeam:FindFirstChild(player.Name) then
				enemyTeam = "Omega"
			elseif betaTeam:FindFirstChild(player.Name) then
				enemyTeam = "Beta"
			end
			if enemyTeam ~= myTeam then
				if caller == "esp" then
					local box = createBox(player)
					updateEsp(player, box)
					box.Parent = espFolder
				end
				return true
			else
				return false
			end
		end





		for _,player in pairs(workspace.Characters:GetChildren()) do
			checkTeam(player, "esp")
		end

		workspace.Characters.ChildAdded:connect(function(player)
			checkTeam(player, "esp")
		end)

		workspace.Characters.ChildRemoved:connect(function(player)
			runser:UnbindFromRenderStep(player.Name.."'s esp")
			if espFolder:FindFirstChild(player.Name) then
				espFolder[player.Name]:Destroy()
			end
		end)

		local LocalPlayer, Characters, ESPList, LocalCharacter = game:GetService('Players').LocalPlayer, workspace.Characters, {}

		local Leaderboard = LocalPlayer.PlayerGui.LeaderboardGui.Leaderboard
		local function GetTeam(Player)
			local Name = Player.Name
			for i,v in next, Leaderboard.Teams:GetDescendants() do
				if v.Name == 'NameLabel' and v.Text == Name then
					return v.Parent.Parent.Parent
				end
			end
		end

		local Camera, Div = workspace.CurrentCamera, Vector2.new(2,2)
		local function GetNearestToCenter()
			local Center = Camera.ViewportSize / Div
			local Character, CharacterDistance, ScreenPosition = nil, 0, nil
			-- Created by Peyton @ V3rmillion
			for i,v in next, Characters:GetChildren() do
				if v.Name ~= LocalPlayer.Name and GetTeam(v) ~= GetTeam(LocalPlayer) and v:FindFirstChild('Health') and v.Health.Value > 0 and v:FindFirstChild('Hitbox') and v.Hitbox:FindFirstChild('Head') then
					local clientchar = workspace.Characters:FindFirstChild(client.Name)
					local ignore = {clientchar, camera, workspace:FindFirstChild"Arms"}
					for _,v in pairs(workspace:GetChildren()) do
						if v:IsA"Model" and v.Name ~= "Arms" then
							table.insert(ignore, 4, v)
						end
					end
					local ray = Ray.new(camera.CFrame.p, (v.Body.Head.Position-camera.CFrame.p).unit*1000)
					local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore, false, false)
					if hit and hit:FindFirstAncestor(v.Name) then
						local Position, OnScreen = Camera:WorldToViewportPoint(v.Hitbox.Head.Position)
						if OnScreen then
							local Vec2 = Vector2.new(Position.X, Position.Y)
							local Distance = (Vec2 - Center).magnitude
							if not Character or CharacterDistance > Distance then
								Character, CharacterDistance, ScreenPosition = v, Distance, Vec2
							end
						end
					end
				end
			end
			return ScreenPosition and Center and (ScreenPosition - Center) or nil
		end


		local function Add(Character)
			if Character == workspace.Characters:FindFirstChild(LocalPlayer.Name) then
				LocalCharacter = Character
			elseif GetTeam(Character) ~= GetTeam(LocalPlayer) then
				--ESPList[Character] = NewCircle()
			end
		end

		local function Remove(Character)
			if ESPList[Character] then
				ESPList[Character]:Remove()
				ESPList[Character] = nil
			end
		end


		for i,v in next, Characters:GetChildren() do Add(v) end
		Characters.ChildAdded:Connect(Add)
		Characters.ChildRemoved:Connect(Remove)
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
