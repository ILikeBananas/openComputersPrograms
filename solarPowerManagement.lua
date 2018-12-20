local term = require("term")
local component = require("component")
local sides = require("sides")
local board = component.keyboard
local sleep = os.sleep
local sleeptime = 2 -- Sleep time between each interval in seconds

-- Components
local solarBat = component.proxy("8d755311-97a4-4d46-935b-4b55cd2c410b")    -- Batbox for solar energy
local mainBat = component.proxy("72993e9d-1c96-4d51-9d8d-d7300119ee32")     -- Main batbox
local r_solar = component.proxy("188aeb43-f2bc-4f1d-9ca3-98ca5c12971f")     -- Redstone IO for the solar energy output

-- booleans
local emergency = false
local usingSolar = false
local keepRunning = true

-- Config
local emergencyStock = 30000 -- Minimum stock keeping for emergencies
local emergencyModeLimit = 500 -- Limit after wich we pass in emergency mode


function main()
    while keepRunning do
        -- Check the current state of the installation
        usingSolar = solarBat.getEnergy() > emergencyStock or mainBat.getEnergy() < emergencyModeLimit
        emergency = mainBat.getEnergy() < emergencyModeLimit and solarBat.getEnergy() < emergencyStock
        
        if usingSolar then
            r_solar.setOutput(sides.west, 0)
        else
            r_solar.setOutput(sides.west, 15)
        end
        drawInterface(emergency, usingSolar)
        sleep(sleeptime)
    
    end
end


function drawInterface(emergency, usingSolar)
    term.clear()
    print("Main batbox : " , mainBat.getEnergy(), "/", mainBat.getCapacity())
    print("Solar batbox : ", solarBat.getEnergy(), "/", solarBat.getCapacity())

    if emergency then 
        print("Emergency mode activated")
    else 
        print("System running normaly")
    end

    if usingSolar then
        print("Currently using solar energy, veri naiss")
    end
end
main()