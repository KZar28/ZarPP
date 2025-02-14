-- Initialize MoneyPicked as a global variable

MoneyPicked = 0
MoneyPickedAll = 0


local copper = 0			-- these three are used below.. prob could be local.
local silver = 0
local gold = 0


local PP_Time = time()

-- HELPERS
local function CreateGoldString(money)
  if type(money) ~= "number" then return "-" end

  local gold = floor(money/ 100 / 100)
  local silver = floor(mod((money/100),100))
  local copper = floor(mod(money,100))

  local string = ""
  if gold > 0 then string = string .. "|cffffffff" .. gold .. "|cffffd700g" end
  if silver > 0 or gold > 0 then string = string .. "|cffffffff " .. silver .. "|cffc7c7cfs" end
  string = string .. "|cffffffff " .. copper .. "|cffeda55fc"

  return string
 end

 --sets up slash commands
 
-- HANDLERS
 SLASH_PICKPOCKETER1 = "/pp"
 local function handler(msg, editBox)
    if msg == 'markers' then
        markerToggle()
	elseif msg == 'idc' then
		local itemId = GetContainerItemID(0, 1)
		DEFAULT_CHAT_FRAME:AddMessage(itemId)
	elseif msg == 'lock' or msg == 'unlock' then
		frameLock()
	elseif msg == 'items' or msg == 'item' then
		itemToggle()
    else -- for just /pp
	DEFAULT_CHAT_FRAME:AddMessage("Session Total is: " ..CreateGoldString(MoneyPicked))
	DEFAULT_CHAT_FRAME:AddMessage("In your lifetime you have stolen " ..CreateGoldString(MoneyPickedAll) .."|cffffffff from the people of Azeroth.")
    end
end
SlashCmdList["PICKPOCKETER"] = handler;

-- ADDON LOADER EVENTS
local DataFrame=CreateFrame("Frame","DataFrame",UIParent);--    Our frame
DataFrame:RegisterEvent("VARIABLES_LOADED")
DataFrame:SetScript("OnEvent", 
	function(self, event, ...)
	
		print('loading MoneyPickedAll')
		if not MoneyPickedAll then
			DEFAULT_CHAT_FRAME:AddMessage("MoneyPickedAll not initialized.")
			MoneyPicked = 0
			DataFrame:Hide()
		end
	end)

local DataFrame=CreateFrame("Frame","DataFrame",UIParent);--    Our frame
DataFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
DataFrame:RegisterEvent("BAG_UPDATE")
DataFrame:SetScript("OnEvent", 
	function(self, event, ...)

		if not MoneyPickedAll then
			DEFAULT_CHAT_FRAME:AddMessage("MoneyPickedAll not initialized.")
			MoneyPicked = 0
			MoneyPickedAll = 0
			DataFrame:Hide()
		end
	end)

 -- used to initialize the global variables
 -- AFTER Player Load World
local Variables_Frame = CreateFrame("Frame")
Variables_Frame:RegisterEvent("ADDON_LOADED")
Variables_Frame:SetScript("OnEvent",
	function(self, event, name)

		local arg1 = name
		if(arg1 == "ZarPP") then
			DEFAULT_CHAT_FRAME:AddMessage("|cffff0000 PickPocketer|r |cffff00ff 2.0 |r Loaded:")
			DEFAULT_CHAT_FRAME:AddMessage("      Type |cffff0000 /pp|r to see the loot you've stolen.")
			DEFAULT_CHAT_FRAME:AddMessage("      Type |cffff0000 /pp markers|r to toggle raid markers on or off.")
			DEFAULT_CHAT_FRAME:AddMessage("      Type |cffff0000 /pp lock|r to toggle locking the reagent frame.")
			DEFAULT_CHAT_FRAME:AddMessage("      Type |cffff0000 /pp item|r to toggle functionality of item invenory")
			if (MoneyPickedAll == nil) then
				MoneyPickedAll = 0;
			end
			if (MoneyPicked == nil) then
				MoneyPicked = 0;
			end
			
		end
	end )
	
-- ACTION EVENTS
	
local PP_EventFrame = CreateFrame("Frame")
PP_EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
PP_EventFrame:SetScript("OnEvent",
	function(self, event, arg1, arg2, arg3, arg4, arg5)
		print('Out of Combat')
		PP_Time = time() -- OUT of COMBAT alarm
		
		
	end)
	
--.. here. this catched the loot that shows up after a pp is successful
-- after looting, set pp to false to protect against non pp-loot
local Loot_EventFrame = CreateFrame("Frame")
Loot_EventFrame:RegisterEvent("LOOT_OPENED")
Loot_EventFrame:SetScript("OnEvent",
	function(self, event, argloot)
	
		local numItems = GetNumLootItems() -- this catches the loot from slot 1, which is usually coins
		lootIcon, lootName, lootQuantity, rarity, locked, isQuestItem, questId, isActive = GetLootSlotInfo(1);
		
		local targetIsDead = UnitIsDead("target")

		if(time() - PP_Time < 8)
		then
			--DEFAULT_CHAT_FRAME:AddMessage("Looted: " ..lootName)

		elseif(not targetIsDead) then
			local arg1 = argloot
			
			--DEFAULT_CHAT_FRAME:AddMessage("PickPocketed: " ..lootName)
			
			coinFunction(lootName)
			DEFAULT_CHAT_FRAME:AddMessage("Lifetime Total Is: " ..CreateGoldString(MoneyPickedAll))
		else
			--DEFAULT_CHAT_FRAME:AddMessage("This is probably gathering: " ..lootName)

		end
	end)
