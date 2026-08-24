-- Edit these two values after installing the Raspberry Pi service.
local PI_URL = "REPLACE ME"
local TOKEN = "REPLACE ME"

if TOKEN == "CHANGE_ME" then
  error("Edit play_pi.lua and set PI_URL and TOKEN first", 0)
end

local response, err, errorResponse = http.post(
  PI_URL,
  "",
  {
    ["X-Audio-Token"] = TOKEN,
    ["Content-Type"] = "text/plain",
  }
)

if not response then
  if errorResponse then
    local body = errorResponse.readAll()
    local status = errorResponse.getResponseCode()
    errorResponse.close()
    error("Pi returned HTTP " .. status .. ": " .. body, 0)
  end
  error("Request failed: " .. tostring(err), 0)
end

local body = response.readAll()
local status = response.getResponseCode()
response.close()

if status < 200 or status >= 300 then
  error("Pi returned HTTP " .. status .. ": " .. body, 0)
end

print("Pi accepted trigger: " .. body)
