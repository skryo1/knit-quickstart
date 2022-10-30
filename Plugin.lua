local toolbar = plugin:CreateToolbar("Quickstart")
local newScriptButton = toolbar:CreateButton("Setup", "Set up a service / controller", "rbxassetid://4458901886")

local pluginPackage = script.Parent
local pluginUI = pluginPackage.UI.Frame
local interface = plugin:CreateDockWidgetPluginGui(
	"Quickstart",
	DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Right,
		true,
		true,
		300,
		200,
		200,
		200
	)
)



local moduleName = pluginUI.ModuleName
local moduleType = pluginUI.ModuleType
local currentRealm = "Server"

pluginUI.Parent = interface


local open = false

function CreateNewScript(_moduleName, _moduleRealm, _moduleType)
	local paths = {
		["Client"] = game.ReplicatedFirst.Client.Controllers,
		["Server"] = game.ServerScriptService.Server.Services
	}
	
	local templateName = _moduleRealm == "Client" and "ControllerTemplate" or "ServiceTemplate"
	local clonedTemplate = pluginPackage[templateName]:Clone()
	local path = paths[_moduleRealm]
	
	
	local parent = path:FindFirstChild(_moduleType)
	if not parent then
		parent =  Instance.new("Folder", path)
		parent.Name = _moduleType
	end
	
	clonedTemplate.Name = _moduleName
	clonedTemplate.Parent = parent
	clonedTemplate.Source = string.gsub(clonedTemplate.Source, templateName, _moduleName)
	plugin:OpenScript(clonedTemplate)
end


pluginUI.Create.MouseButton1Click:Connect(function()
	local _moduleName = moduleName.Text ~= "" and moduleName.Text or "UNNAMED"
	local _moduleRealm = currentRealm
	local _moduleType = moduleType.Text
	CreateNewScript(_moduleName, _moduleRealm, _moduleType)
end)


newScriptButton.Click:Connect(function()
	interface.Enabled = not interface.Enabled
end)

local function unColorButtons()
	for _, k in ipairs (pluginUI.Buttons:GetChildren()) do
		if k:IsA("TextButton") then
			k.BackgroundColor3 = Color3.fromRGB(40, 43, 49)
		end
	end
end

local function colorButton(button)
	unColorButtons()
	button.BackgroundColor3 = Color3.fromRGB(83, 138, 189)
end

pluginUI.Buttons.Server.MouseButton1Click:Connect(function()
	currentRealm = "Server"
	colorButton(pluginUI.Buttons.Server)
end)

pluginUI.Buttons.Client.MouseButton1Click:Connect(function()
	currentRealm = "Client"
	colorButton(pluginUI.Buttons.Client)
end)

