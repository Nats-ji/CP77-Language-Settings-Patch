registerForEvent("onInit", function()
  LanguagePatch:Init()
end)

registerForEvent("onShutdown", function()
  LanguagePatch:Save()
end)

LanguagePatch = {}

function LanguagePatch:Init()
  self.Settings = Game.GetSettingsSystem():GetRootGroup():GetGroups(true)
  self.Languages = self.Settings[6]:GetVars(true)
  self.VoiceOver = self.Languages[1]
  self.Subtitles = self.Languages[2]
  self.OnScreen = self.Languages[3]
  self:Apply()
end

function LanguagePatch:Apply()
  local file = io.open("languages.json", "r")
  if file then
    local languages = json.decode(file:read("*a"))
    for k,v in pairs(languages) do
      self[k]:SetIndex(v)
    end
    Game.GetSettingsSystem():ConfirmChanges()
  end
  file:close()
end

function LanguagePatch:Save()
  local file = io.open("languages.json", "w")
  local languages = {
    VoiceOver = self.VoiceOver:GetIndex(),
    Subtitles = self.Subtitles:GetIndex(),
    OnScreen = self.OnScreen:GetIndex(),
  }
  file:write(json.encode(languages))
  file:close()
end
