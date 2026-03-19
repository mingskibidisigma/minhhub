-- Minh Hub

-- UI LIB
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/source.lua"))()

-- WINDOW
local W = Fluent:CreateWindow({
    Title = "Minh Hub",
    SubTitle = "Blox Fruits",
    Size = UDim2.fromOffset(520, 360),
    Theme = "Dark"
})

-- TAB
local T = {
    Farm = W:AddTab({ Title = "Farm" }),
    Main = W:AddTab({ Title = "Main" })
}

-- VAR
getgenv().AutoFarm = false
getgenv().Mob = nil
getgenv().AutoSkill = false
getgenv().AutoClick = false

-- DROPDOWN CHỌN QUÁI
local D = T.Farm:AddDropdown("Mob", {Title="Chọn quái", Values={}})

task.spawn(function()
    while task.wait(2) do
        local m = {}
        for _,v in pairs(workspace.Enemies:GetChildren()) do
            if not table.find(m,v.Name) then
                table.insert(m,v.Name)
            end
        end
        D:SetValues(m)
    end
end)

D:OnChanged(function(v)
    getgenv().Mob = v
end)

-- TOGGLE
T.Farm:AddToggle("Farm", {Title="Auto Farm"}):OnChanged(function(v)
    getgenv().AutoFarm = v
end)

T.Main:AddToggle("Skill", {Title="Auto Skill"}):OnChanged(function(v)
    getgenv().AutoSkill = v
end)

T.Main:AddToggle("Click", {Title="Auto Click"}):OnChanged(function(v)
    getgenv().AutoClick = v
end)

-- SERVICES
local VIM = game:GetService("VirtualInputManager")

local function pressKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    task.wait()
    VIM:SendKeyEvent(false, key, false, game)
end

-- LOOP
task.spawn(function()
    while task.wait(.2) do
        pcall(function()
            local p = game.Players.LocalPlayer
            local c = p.Character
            if not (c and c:FindFirstChild("HumanoidRootPart")) then return end

            -- AUTO FARM
            if getgenv().AutoFarm and getgenv().Mob then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == getgenv().Mob 
                    and v:FindFirstChild("HumanoidRootPart") 
                    and v:FindFirstChild("Humanoid") 
                    and v.Humanoid.Health > 0 then
                        
                        c.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,3)

                        mouse1click()
                        break
                    end
                end
            end

            -- AUTO SKILL
            if getgenv().AutoSkill then
                for _,k in pairs({"Z","X","C","V"}) do
                    pressKey(k)
                end
            end

            -- AUTO CLICK
            if getgenv().AutoClick then
                mouse1click()
            end

        end)
    end
end)
