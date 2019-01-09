--Michael Gwynn
--This controls the UI during combat
attack = false
ehealth = 100
enemypower = 30 
enemy = false
power = 0
playerHealth = 100
clipDistance = 5.7725929
hpDistance = 3.8690111201102
bClipDistance = 2.598304
bhpdis = 3.871153368608
counter = 0
damageDealt = 0
percentDealt = 0
qteSuccess = false
clock = os.clock()
timer = 0
attackEnabled = true
moveType = 1
eCount = 0
pCount = 0
name = ""
moveTable = {0,0,0,0}
local delay = false
local delayInt = 0
local selectedAttack = 0
local over = false

function init(self)
	menu = gui.get_node("menu")
 	gui.set_enabled(menu, true)
	gui.set_text(gui.get_node("turntext"), "TURN: PLAYER")	
	msg.post(".", "acquire_input_focus")
	--get appropriate save data from the save file
	msg.post("scenes:/autoSaver#autoSave", "get", {4,1})
	msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
	msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
	msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
	msg.post("scenes:/autoSaver#autoSave", "get", {5,"playerStats"})
	msg.post("scenes:/autoSaver#autoSave", "get", {5,"EnemyStats"})
	self.move_bridge=require "main.move_select_bridge"
	self.Player_Anim_Table={}
	self.attack_nodes={}
	clock = os.clock()
	--turn off any nodes that shouldn't be visable at the startr
	gui.set_enabled(gui.get_node("QTE"), false)
	gui.set_enabled(gui.get_node("PlayerHit"), false)
	gui.set_enabled(gui.get_node("PlayerMiss"), false)
	gui.set_enabled(gui.get_node("PlayerCrit"), false)
	gui.set_enabled(gui.get_node("EnemyHit"), false)
	gui.set_enabled(gui.get_node("EnemyMiss"), false)
	gui.set_enabled(gui.get_node("EnemyCrit"), false)
	gui.set_enabled(gui.get_node("Win"), false)
	gui.set_enabled(gui.get_node("Loss"), false)
	gui.set_enabled(gui.get_node("FinishedBack"), false)
end

function on_message(self, message_id, message, sender)
	if message_id == hash("return") then 
		--set the player's available moves based on what they selected in the MoveSelectionGUI
		if(message[2] == 1) then
			counter = counter + 1
			local pos1 = gui.get_node("pos1")
			local attack_one
			if message[1] == "attack0" then
				attack_one = gui.get_node("attack0.1")
			else
				attack_one = gui.get_node(message[1])
				local num_string = string.sub(message[1], 7)
				local index = tonumber(num_string)
				if(index == 11) then
					self.Player_Anim_Table[5]="#blast_attack_p"
				elseif(index == 12) then
					self.Player_Anim_Table[6]="#cascade_attack_p"
				end
				self.Player_Anim_Table[1]="#"..self.move_bridge.get_move(index)
				moveTable[1] = index
			end
			gui.set_position(attack_one, gui.get_position(pos1))
			self.attack_nodes[1]=message[1]
		elseif(message[2] == 2) then
			counter = counter + 1
			local pos2 = gui.get_node("pos2")
			local attack_two
			if message[1] == "attack0" then
				attack_two = gui.get_node("attack0.2")
			else
				attack_two = gui.get_node(message[1])
				local num_string = string.sub(message[1], 7)
				local index = tonumber(num_string)
				if(index == 11) then
					self.Player_Anim_Table[5]="#blast_attack_p"
				elseif(index == 12) then
					self.Player_Anim_Table[6]="#cascade_attack_p"
				end
				self.Player_Anim_Table[2]="#"..self.move_bridge.get_move(index)
				moveTable[2] = index
			end
			gui.set_position(attack_two, gui.get_position(pos2))
			self.attack_nodes[2]=message[1]
		elseif(message[2] == 3) then
			counter = counter + 1
			local pos3 = gui.get_node("pos3")
			local attack_three
			if message[1] == "attack0" then
				attack_three = gui.get_node("attack0.3")
			else
				attack_three = gui.get_node(message[1])
				local num_string = string.sub(message[1], 7)
				local index = tonumber(num_string)
				if(index == 11) then
					self.Player_Anim_Table[5]="#blast_attack_p"
				elseif(index == 12) then
					self.Player_Anim_Table[6]="#cascade_attack_p"
				end
				self.Player_Anim_Table[3]="#"..self.move_bridge.get_move(index)
				moveTable[3] = index
			end
			gui.set_position(attack_three, gui.get_position(pos3))
			self.attack_nodes[3]=message[1]
		elseif(message[2] == 4) then
			counter = counter + 1
			local pos4 = gui.get_node("pos4")
			local attack_four
			if message[1] == "attack0" then
				attack_four = gui.get_node("attack0.4")
			else
				attack_four = gui.get_node(message[1])
				local num_string = string.sub(message[1], 7)
				local index = tonumber(num_string)
				if(index == 11) then
					self.Player_Anim_Table[5]="#blast_attack_p"
				elseif(index == 12) then
					self.Player_Anim_Table[6]="#cascade_attack_p"
				end
				self.Player_Anim_Table[4]="#"..self.move_bridge.get_move(index)
				moveTable[4] = index
			end
			gui.set_position(attack_four, gui.get_position(pos4))
			self.attack_nodes[4]=message[1]
		elseif(message[2] == "playerStats") then
			playerHealth = message[1]["HP"]
		elseif(message[2] == "EnemyStats") then
			eHealth = message[1]["HP"]
		end		
		if counter == 4 then
			msg.post("combat:/Player#AnimationHandler", "fix_player_table", self.Player_Anim_Table)
		end
	elseif message_id == hash("attack_anim_finished") and enemy == false then
		msg.post("combat:/collection0/Enemy#CircleController", hash("get QTE success"))
		
	elseif message_id == hash("QTE Success") then
        msg.post("combat:/combatController#script", "player_attack", {self.current_attack, message[1]})
        timer = 0
        qteSuccess = false
        
    elseif message_id == hash("return type") then
    	moveType = message[1]
        msg.post("combat:/collection0/Enemy#CircleController", hash("set move type"), {moveType})
        gui.set_enabled(gui.get_node("QTE"), true)
    	msg.post("combat:/collection0/Target#pos", "get_pos")
        
    elseif message_id == hash("switch") then	
    	turn_switch(self)
    	
	elseif message_id == hash("enemy damage dealt") then
		damageDealt = message[1]
		percentDealt = message[2]
		if message[4] == true then
			gui.set_enabled(gui.get_node("EnemyCrit"), true)
		end
		if message[3] == true then
			gui.set_enabled(gui.get_node("EnemyMiss"), true)
			enemyNodes = true
			enemyMiss(self)
		else
			gui.set_enabled(gui.get_node("EnemyHit"), true)
			enemyNodes = true
			if(over == false) then
				Player_damage(self, percentDealt)
			end
    	end
    	
	elseif message_id == hash("player damage dealt") then
		damageDealt = message[1]
		percentDealt = message[2]  
    	if(over == false) then   	
        	gui.set_text(gui.get_node("turntext"), "TURN: ENEMY")
    	end
        enemy = true
        msg.post("combat:/collection0/Enemy#Enemy", "hit")
		if message[4] == true then
			gui.set_enabled(gui.get_node("PlayerCrit"), true)
		end
		if message[3] == true then
			gui.set_enabled(gui.get_node("PlayerMiss"), true)
			playerNodes = true
			playerMiss(self)
		else
			gui.set_enabled(gui.get_node("PlayerHit"), true)
			playerNodes = true
			enemy_damage(self, percentDealt)
    	end    	
    	
    elseif message_id == hash("pos_return") then
      	msg.post(".", "start_attack", {attack_num = self.current_attack, enemy_hitbox=message.pos})
	
	elseif message_id == hash("set_enemy_name") then
		local name_node = gui.get_node("Enemy_Name")
		name = message["name"]
		gui.play_flipbook(name_node, "UI_Name_"..message["name"])
	end
end

function update(self,dt)
	if(enemyNodes == true) then
		--turn off the pop-ups that occur for "Hit" "Miss" and "Critical Hit" after an appropriate amount of time has passed
		eCount = eCount + 1
		if(eCount >= 30) then			
			gui.set_enabled(gui.get_node("EnemyHit"), false)
			gui.set_enabled(gui.get_node("EnemyMiss"), false)
			gui.set_enabled(gui.get_node("EnemyCrit"), false)   
			eCount = 0
			enemyNodes = false 
		end
	end
	if(playerNodes == true) then
		pCount = pCount + 1
		if(pCount >= 30) then			
			gui.set_enabled(gui.get_node("PlayerHit"), false)
			gui.set_enabled(gui.get_node("PlayerMiss"), false)
			gui.set_enabled(gui.get_node("PlayerCrit"), false)    
			pCount = 0
			playerNodes = false
		end
	end
	if delay == true then
		--delay between selecting a move and starting the attack animation
		delayInt = delayInt + 1
		gui.set_enabled(menu, false)
	end
	if delayInt >= 24 then
   		msg.post("combat:/combatController#script", "get attack type", {selectedAttack})
		attack = true
		power = 10
       	attackEnabled = false
        self.current_attack=selectedAttack
        msg.post("combat:/collection0/Enemy#CircleController", hash("set move number"), {tonumber(string.sub(self.attack_nodes[selectedAttack], 7))})
		delay = false
		delayInt = 0
	end
end

function turn_switch(self)
	--switch from the enemy turn to the player turn
	timer = 0
	if(over == false) then
		gui.set_text(gui.get_node("turntext"), "TURN: PLAYER")
	end
	gui.set_enabled(menu, true)
	attackEnabled = true
	enemy = false
end

function Player_damage(self, damageTaken)
	--decrease the player's health and trigger a loss if they are at less than 1 hp
	playerHealth = playerHealth - damageDealt
	hpBar = gui.get_node("PlayerHP")
	clipBar = gui.get_node("PlayerClip")
	eHPBarPos = gui.get_position(gui.get_node("PlayerHP"))
	eHPBarPos.x = eHPBarPos.x - (bhpdis * damageTaken)
	eHPClipPos = gui.get_position(gui.get_node("PlayerClip"))
	eHPClipPos.x = eHPClipPos.x + (bClipDistance * damageTaken)
	gui.set_position(hpBar, eHPBarPos)
	gui.set_position(clipBar, eHPClipPos)
	if playerHealth <= 0 then
		gui.set_enabled(gui.get_node("Loss"), true)
		gui.set_enabled(gui.get_node("FinishedBack"), true)
		gui.set_text(gui.get_node("turntext"), "")
		over = true
	end
end

function loss(self)
	msg.post("scenes:/autoSaver#autoSave","set",{8,1,vmath.vector3(-2145.97256,-2341.18338,0)})
	msg.post(".", "load_overworld")  
end

function enemy_damage(self, damageTaken)
	--decrease the enemy's health and trigger a win if they are at less than 1 hp
	ehealth = ehealth - damageDealt
	hpBar = gui.get_node("EnemyHP")
	clipBar = gui.get_node("EnemyClip")
	bHPBarPos = gui.get_position(gui.get_node("EnemyHP"))
	bHPBarPos.x = bHPBarPos.x + (hpDistance * damageTaken)
	bHPClipPos = gui.get_position(gui.get_node("EnemyClip"))
	bHPClipPos.x = bHPClipPos.x - (clipDistance * damageTaken)
	gui.set_position(hpBar, bHPBarPos)
	gui.set_position(clipBar, bHPClipPos)	
	if ehealth <= 0 then
		gui.set_enabled(gui.get_node("Win"), true)
		gui.set_enabled(gui.get_node("FinishedBack"), true)
		gui.set_text(gui.get_node("turntext"), "")
		over = true
	end
end

function victory(self)
	msg.post("scenes:/autoSaver#autoSave","set",{8,1,vmath.vector3(-2145.97256,-2341.18338,0)})
	msg.post("scenes:/autoSaver#autoSave", hash("set"), {1,name,true}) 
	msg.post(".", "load_overworld")
end

function on_input(self, action_id, action)
	if action_id == hash("click") and action.pressed then        		
        local x = action.x
        local y = action.y
		
		if gui.pick_node(gui.get_node("QTE"), x, y)	and gui.is_enabled(gui.get_node("QTE")) == true then
			--send a message to the QTE controller when the button is tapped on.
			msg.post("combat:/collection0/Enemy#CircleController", hash("stop movement"))
			gui.set_enabled(gui.get_node("QTE"), false)
		end
       if over == false then
			for i=1, #self.attack_nodes,1 do
				if self.attack_nodes[i] ~= "attack0" then
		       		local attack_node = gui.get_node(self.attack_nodes[i])
		   			if gui.pick_node(attack_node, x, y) and gui.is_enabled(attack_node) == true and attackEnabled == true then
		   				delay = true
			   				selectedAttack = i
		        	end
	        	end
	   		end
   		else
   			if gui.pick_node(gui.get_node("Win"), x, y) then
   				victory(self)
   			elseif gui.pick_node(gui.get_node("Loss"), x, y) then
   				loss(self)
   			end
   		end
	end
end