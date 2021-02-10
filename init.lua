-- CP77 Language Settings Patch fixes the issue that language settings don't persist after restart.
-- Copyright (C) 2021  Mingming Cui
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
