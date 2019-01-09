--Michael Gwynn
--Basic Quick Time Event controller
local updateEnabled = false
local moveType = 1
local moveNumber = 1
local QTE_Passed = false
local initialPos = vmath.vector3(1,1,1)
local UpdateSpeeds = {0.009,0.009,0.009,0.009,0.009,0.009,0.009,0.009,0.009,0.009,0.009,0.009}--"speed" of the quick time event
local DisciplineColors = {vmath.vector4(1,0,0,1),vmath.vector4(1,1,0,1),vmath.vector4(0.5,0,0.5,1),vmath.vector4(1,0.5,0,1),vmath.vector4(0,1,0,1),vmath.vector4(0,191/255,1,1), vmath.vector4(1,1,1,0)}--colors of the quick time event indicator

function init(self)
	initialPos = go.get_position("combat:/collection0/Circles")
	initialPos.z = 10
    sprite.set_constant("combat:/collection0/Moving_Circle", "tint", DisciplineColors[7])
    sprite.set_constant("combat:/collection0/Stationary_Circle", "tint", DisciplineColors[7])
end

function update(self, dt)
    if(updateEnabled == true)then
    	--shrink the circle until the player taps the screen or if they took too long
    	old = go.get_scale_vector("Moving_Circle")
    	old.x = old.x - UpdateSpeeds[moveNumber]
    	old.y = old.y - UpdateSpeeds[moveNumber]
    	if(old.x <= go.get_scale_vector("Stationary_Circle").x - .05) then
    		msg.post(".", hash("stop movement"))
		else
    		go.set_scale(old, "Moving_Circle")
    	end
    end
end

function on_message(self, message_id, message, sender)
    if(message_id == hash("set move number")) then
    	moveNumber = message[1]
    elseif(message_id == hash("set move type")) then
    	--set the color of the indicator to the appropriate color
    	sprite.set_constant("combat:/collection0/Moving_Circle", "tint", DisciplineColors[message[1]])
    	sprite.set_constant("combat:/collection0/Stationary_Circle", "tint", DisciplineColors[message[1]])
    	updateEnabled = true
    elseif(message_id == hash("stop movement")) then
    	--turn the circles invisible
    	sprite.set_constant("combat:/collection0/Moving_Circle", "tint", DisciplineColors[7])
    	sprite.set_constant("combat:/collection0/Stationary_Circle", "tint", DisciplineColors[7])
    	updateEnabled = false
    	QTE_Check(self)
    	reset = vmath.vector3(0.5,0.5,3)
    	go.set_scale(reset, "Moving_Circle")
    	go.set_position(initialPos, "combat:/collection0/Circles")
	elseif(message_id == hash("get QTE success")) then
		--return if the player succeeded
		msg.post(sender, "QTE Success", {QTE_Passed})
    end
end

function QTE_Check(self)
	--determine if the player passed or succeeded in the quick time event
	if(go.get_scale_vector("Moving_Circle").x <= 0.2 and go.get_scale_vector("Moving_Circle").x >= 0.12) then
		QTE_Passed = true
	else
		QTE_Passed = false
	end
end