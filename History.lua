local T = AceLibrary("Tablet-2.0")
local D = AceLibrary("Dewdrop-2.0")
local C = AceLibrary("Crayon-2.0")

EPGP_History = EPGP:NewModule("EPGP_History", "AceDB-2.0")
EPGP_History:RegisterDB("EPGP_History_DB", "EPGP_History_DB_CHAR")
EPGP_History:RegisterDefaults("char", {
  data = { },
  detached_data = { }
})

function EPGP_History:OnEnable()
  self.index_start = 1
  if not T:IsRegistered("EPGP_History") then
    T:Register("EPGP_History",
      "children", function()
        T:SetTitle("EPGP History")
        T:SetHint("EP: Effort Points, GP: Gear Points, PR: Priority")
        self:OnTooltipUpdate()
      end,
      "data", self.db.char.data,
      "detachedData", self.db.char.detached_data,
  		"showTitleWhenDetached", true,
  		"showHintWhenDetached", true,
  		"cantAttach", true
    )
  end
  if not T:IsAttached("EPGP_History") then
    T:Open("EPGP_History")
  end
end

function EPGP_History:OnDisable()
  T:Close("EPGP_History")
end

function EPGP_History:Refresh()
  T:Refresh("EPGP_History")
end

function EPGP_History:Toggle()
  if T:IsAttached("EPGP_History") then
    T:Detach("EPGP_History")
  else
    T:Attach("EPGP_History")
  end
end

function EPGP_History:NavigateNext()
  self.index_start = math.min(11, self.index_start + 5)
  self:Refresh()
end

function EPGP_History:NavigatePrevious()
  self.index_start = math.max(1, self.index_start - 5)
  self:Refresh()
end

function EPGP_History:OnTooltipUpdate()
  local prev = T:AddCategory(
      "columns", 1
    )
  prev:AddLine(
    "text", C:Colorize("00ffff", "Previous"),
    "func", "NavigatePrevious",
    "arg1", self
    )
  local cat = T:AddCategory(
      "columns", 6,
      "text",  C:Orange("Name"),                        "child_textR",  1, "child_textG",  1, "child_textB",  1, "child_justify",  "LEFT",
      "text2", C:Orange("Raid " .. self.index_start),   "child_text2R", 1, "child_text2G", 1, "child_text2B", 1, "child_justify2", "RIGHT",
      "text3", C:Orange("Raid " .. self.index_start+1), "child_text3R", 1, "child_text3G", 1, "child_text3B", 1, "child_justify3", "RIGHT",
      "text4", C:Orange("Raid " .. self.index_start+2), "child_text4R", 1, "child_text4G", 1, "child_text4B", 1, "child_justify4", "RIGHT",
      "text5", C:Orange("Raid " .. self.index_start+3), "child_text5R", 1, "child_text5G", 1, "child_text5B", 1, "child_justify5", "RIGHT",
      "text6", C:Orange("Raid " .. self.index_start+4), "child_text6R", 1, "child_text6G", 1, "child_text6B", 1, "child_justify6", "RIGHT"
    )
  local t = EPGP:BuildHistoryTable()
  for i = 1, table.getn(t) do
    assert(table.getn(t[i][2]) == table.getn(t[i][3]), "EP and GP tables are not equal!")
    cat:AddLine(
      "text",  t[i][1],
      "text2", string.format("%d/%d", t[i][2][self.index_start],   t[i][3][self.index_start]),
      "text3", string.format("%d/%d", t[i][2][self.index_start+1], t[i][3][self.index_start+1]),
      "text4", string.format("%d/%d", t[i][2][self.index_start+2], t[i][3][self.index_start+2]),
      "text5", string.format("%d/%d", t[i][2][self.index_start+3], t[i][3][self.index_start+3]),
      "text6", string.format("%d/%d", t[i][2][self.index_start+4], t[i][3][self.index_start+4])
    )
  end
  local prev = T:AddCategory(
      "columns", 1
    )
  prev:AddLine(
    "text", C:Colorize("00ffff", "Next"),
    "func", "NavigateNext",
    "arg1", self
    )
end