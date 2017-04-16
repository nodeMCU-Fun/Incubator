-- "INCUBATOR"
-- Measures temperature then turns on/off an incandescent bulb via relay
-- to keep the temperature within a target zone.
-- Cobbled together by Tim Connolly
-- Visit nodeMCU-Fun on GitHub for more stuff
--
-- REQUIRES DHT, I2C, MATH, GPIO, TMR

setting = 80	-- Target temperature
plusMinus = .5	-- defines the width of target temperature window
sensorPin = 4	-- DHT sensor on nodeMCU pin 4
relayPin = 1	-- relay on nodeMCU pin 1
turn="on"		-- action to be taken with relay @ relayPin

function GetSensorData()
    --sensorPin = 4  
    status, temp, humi, temp_dec, humi_dec = dht.read(sensorPin)
    temp = (1.8*temp)+32
	temp = round(temp,1)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

--
-- MAIN
--		

gpio.mode(1,gpio.OUTPUT)
    
tmr.alarm(1, 30000, 1, function() 
	GetSensorData()
	-- Does Heating Element need to be turned ON or OFF?
	if (temp<=(setting-plusMinus)) then turn="on"
		elseif (temp>=(setting+plusMinus)) then turn="off" end
	-- Control Heating Element
	-- The action in this if/then seems counter to logic but it's what works :/ 
	if (turn=="on") then gpio.write(relayPin,gpio.LOW)					
		elseif (turn=="off") then gpio.write(relayPin,gpio.HIGH) end
	-- Display current operation to console (if attached) 
	print (temp.." Degrees F    Pin D"..relayPin.." is "..turn..".  Target is "..setting.." +/- "..plusMinus)
end)
