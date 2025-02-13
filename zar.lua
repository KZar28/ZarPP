-- Functions for pp.lua
-- this function calculates the total monies
coinFunction = function(lootName) 
	--local testMoney = "5 Gold 3 Copper"	
	tempTotal = stringToCopper(lootName)
	
	MoneyPicked = MoneyPicked + tempTotal	
	MoneyPickedAll = MoneyPickedAll + tempTotal
end

-- this connverts the string value that GetLootSlotInfo(1) returns ("in for 1 gold xx silver.. ect")
-- and converts it into a single integer in copper, then returns that total.

stringToCopper = function(lootName) 
	local temp = lootName			
	local tempCStart, tempCEnd = string.find(temp, " Copper")

	if(tempCStart ~= nil)
	then
		tempC = string.sub(temp, tempCStart-2, tempCStart)
		tempC = string.gsub(tempC, " ", "")
		tempC = string.format( "%02d", tempC)
	else

		tempC = 00
	end
	local tempSStart, tempSEnd = string.find(temp, " Silver")
	if(tempSStart ~= nil)
	then	
		tempS = string.sub(temp, tempSStart-2, tempSStart)
		tempS = string.gsub(tempS, " ", "")
		tempS = string.format( "%02d", tempS)
	else
		tempS = 00
	end
	
	local tempGStart, tempGEnd = string.find(temp, " Gold")
	if(tempGStart ~= nil)
	then
		tempG = string.sub(temp, tempGStart-2, tempGStart)
		tempG = string.gsub(tempG, " ", "")
		tempG = string.format( "%02d", tempG)
	else
		tempG = 00
	end
	
	local tempTotal = tempC + tempS*100 + tempG*10000
	
	return tempTotal

end