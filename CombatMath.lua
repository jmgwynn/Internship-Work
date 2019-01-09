--Michael Gwynn
local playerStats = {}
local enemyStats = {}
local playerMoves = {}
local enemyMoves = {}
local DAC = {} --Discipline Advangage Chart
local playerStance = 0
local enemyStance = 0
local playerMoveDamages = {20, 20, 20, 20, 5, 5, 5, 5}
local enemyMoveDamages = {20, 20, 20, 20, 0, 0, 0, 0}
local playerMaxHP = 0
local enemyMaxHP = 0
local derp = false
local bench = os.clock()
local moveTypeColors = {vmath.vector4(1,1,1,1), vmath.vector4(1,1,1,1), vmath.vector4(1,1,1,1), vmath.vector4(1,1,1,1), vmath.vector4(1,1,1,1), vmath.vector4(1,1,1,1), vmath.vector4(1,1,1,1)}

--Attack Types: Kung Fu = 1, Muay Thai = 2, Ninjitsu = 3, Gatka = 4, Capoeira = 5, Taedekai = 6, NULL = 7
function init(self)
	math.randomseed(os.time())
	math.random()
    msg.post("scenes:/autoSaver#autoSave", "get", {5,"playerStats"})
    msg.post("scenes:/autoSaver#autoSave", "get", {5,"EnemyStats"})
    msg.post("scenes:/autoSaver#autoSave", "get", {4,5})
    DAC[1] = {1, 1, 0.5, 1, 2, 1, 1}
    DAC[2] = {1, 1, 1, 0.5, 1, 2, 1}
    DAC[3] = {2, 1, 1, 1, 0.5, 1, 1}
    DAC[4] = {1, 2, 1, 1, 1, 0.5, 1}
    DAC[5] = {0.5, 1, 2, 1, 1, 1, 1}
    DAC[6] = {1, 0.5, 1, 2, 1, 1, 1}
    DAC[7] = {1, 1, 1, 1, 1, 1, 1}
    bench = os.clock()
end

function update(self)
	if derp == false then
		derp = true
	end
end

function on_message(self, message_id, message, sender)
	if message_id== hash("enemy attacks") then
		--record and calculate data about the enemy
   		enemyMoves = message
   		calcAdvantages(self, enemyMoves, false)
   		calcStance(self, enemyMoves, false)
	end
	
	if message_id == hash("get attack type") then
		--returns the type of a given move
		msg.post(sender, "return type", {playerMoves[message[1]]})
	end
   
   	if message_id == hash("return") then
   		--process data returned from the save file
   		if(message["table_num"] == 4) then
	   		playerMoves = message[1]
	   		calcAdvantages(self, playerMoves, true)
	   		calcStance(self, playerMoves, true)
   		else	
	   		if(message[2] == "playerStats") then
	   			playerStats = message[1]
	   			playerStats["RES"] = 1
	   			playerStats["DMG"] = 1
	   			playerStats["MISS"] = 1.0
	   			playerStats["HIT"] = 1.0
	   			playerMaxHP = playerStats["HP"]
	   		else
	   			enemyStats = message[1]
	   			enemyStats["RES"] = 1
	   			enemyStats["DMG"] = 1
	   			enemyStats["MISS"] = 1.0
	   			enemyStats["HIT"] = 1.0
	   			enemyMaxHP = enemyStats["HP"]
	   		end
   		end
   	end
   	
   	--in order: Move Number, quicktime succeeded
   	if message_id == hash("player_attack") then
   		--calculate damage done and return to sender
   		hpLost = 0
   		hpLostP = 0
   		totalDmg = 0
   		isMiss = false
   		isCrit = false
   		missCalc = (enemyStats["EVA"]/playerStats["ACC"]) * 100   	
   		missCalc = missCalc * (playerStats["HIT"]) * (enemyStats["MISS"])	
   		if(math.random() + math.random(1,100)) > (100 - missCalc) then
   			isMiss = true
   		end
   		if(message[2] == true) then
   			totalDmg = playerMoveDamages[message[1]] + playerMoveDamages[message[1] + 4]
   		else
   			totalDmg = playerMoveDamages[message[1]]
   		end
   		totalDmg = totalDmg * DAC[playerMoves[message[1]]][enemyStance] * playerStats["DMG"] * enemyStats["RES"]
   		if((math.random() + math.random(1,100)) > (100 - playerStats["CRT"])) then
   			totalDmg = totalDmg * 2
   			isCrit = true
   		end
   		percentDone = (totalDmg / enemyMaxHP) * 100
   		msg.post(sender, "player damage dealt", {totalDmg, percentDone, isMiss, isCrit})
   	end
   	
   	if message_id == hash("enemy_attack") then
   		--calculate damage done and return to sender
   		hpLost = 0
   		hpLostP = 0
   		totalDmg = 0
   		isMiss = false
   		isCrit = false
   		missCalc = (playerStats["EVA"]/enemyStats["ACC"]) * 100
   		missCalc = missCalc * (enemyStats["HIT"]) * (playerStats["MISS"])
   		if(math.random() + math.random(1,100)) > (100 - missCalc) then
   			isMiss = true
   		end   		
   		if(message[3] == true) then
   			totalDmg = enemyMoveDamages[message[1]] + enemyMoveDamages[message[1] + 4]
   		else
   			totalDmg = enemyMoveDamages[message[1]]
   		end
   		totalDmg = totalDmg * DAC[enemyMoves[message[1]]][playerStance] * enemyStats["DMG"] * playerStats["RES"]
   		if((math.random() + math.random(1,100)) > (100 - enemyStats["CRT"]) and isMiss == false) then
   			totalDmg = totalDmg * 2
			isCrit = true
   		end
   		percentDone = (totalDmg / playerMaxHP) * 100
   		msg.post("combat:/Player#gui", "enemy damage dealt", {totalDmg, percentDone, isMiss, isCrit})
   	end
end

function calcStance(self, moveTable, isPlayer)
	--calculate the player's "stance" which then determines what their type for damage calculation.
	--whichever discipline is represented the most in their moves becomes the "stance" 
	disciplines = {0,0,0,0,0,0,0}
	for i=1,4,1 do
		if(moveTable[i] == 1) then
			disciplines[1] = disciplines[1] + 1
		elseif(moveTable[i] == 2) then
			disciplines[2] = disciplines[2] + 1
		elseif(moveTable[i] == 3) then
			disciplines[3] = disciplines[3] + 1
		elseif(moveTable[i] == 4) then
			disciplines[4] = disciplines[4] + 1
		elseif(moveTable[i] == 5) then
			disciplines[5] = disciplines[5] + 1
		elseif(moveTable[i] == 6) then
			disciplines[6] = disciplines[6] + 1
		elseif(moveTable[i] == 0) then
			disciplines[7] = disciplines[7] + 1
		end
	end
	a = 1
	b = 0
	c = 0
	d = 0
	for i=1,7,1 do
		if(disciplines[i] > disciplines[a]) then
			a = i
		end
	end
	if(disciplines[a] == 2) then
		for i=1,7,1 do
			if(i ~= a) then
				if(disciplines[i] == 2) then
					b = i
				end
			end
		end
	elseif(disciplines[a] == 1) then
		for i=1,7,1 do
			if(i ~= a) then
				if(disciplines[i] == 1) then
					if(b == 0) then
						b = i
					elseif(c == 0) then
						c = i
					elseif(d == 0) then
						d = i
					end
				end
			end
		end
	end
	if(isPlayer == true) then		
		if(c>0)then
			playerStance = 7
		elseif(b>0)then
			playerStance = 7
		else
			playerStance = a
		end
	else
		if(b>0)then
			enemyStance = 7
		else
			enemyStance = a
		end		
	end
end

function calcAdvantages(self, moveTable, isPlayer)
	--for each move of a specific type, the player gets a bonus to a stat
	playerCapCounter = 0
	enemyCapCounter = 0
	for i=1,4,1 do
		if(moveTable[i] == 1) then
			if(isPlayer == true) then
				playerStats["RES"] = playerStats["RES"] - 0.03
			else
				enemyStats["RES"] = enemyStats["RES"] - 0.03
			end
		elseif(moveTable[i] == 2) then
			if(isPlayer == true) then
				playerCapCounter = playerCapCounter + 1
			else
				enemyCapCounter = enemyCapCounter + 1
			end
		elseif(moveTable[i] == 3) then
			if(isPlayer == true) then
				playerStats["MISS"] = playerStats["MISS"] - 0.03
			else
				enemyStats["MISS"] = enemyStats["MISS"] - 0.03
			end
		elseif(moveTable[i] == 4) then
			if(isPlayer == true) then
				playerStats["DMG"] = playerStats["DMG"] + 0.03
			else
				enemyStats["DMG"] = enemyStats["DMG"] + 0.03
			end
		elseif(moveTable[i] == 5) then
			if(isPlayer == true) then
				playerStats["CRT"] = playerStats["CRT"] + 4
			else
				enemyStats["CRT"] = enemyStats["CRT"] + 4
			end
		elseif(moveTable[i] == 6) then
			if(isPlayer == true) then
				playerStats["HIT"] = playerStats["HIT"] + 0.03
			else
				enemyStats["HIT"] = enemyStats["HIT"] + 0.03
			end
		end
	end
	if(isPlayer == true) then
		playerStats["SPD"] = playerStats["SPD"] * (1.0 + (playerCapCounter * 0.05))
	else
		enemyStats["SPD"] = playerStats["SPD"] * (1.0 + (enemyCapCounter * 0.05))
	end
end