local PurchaseTypes = {}

for _, TypeModule in pairs(script:GetChildren()) do
    PurchaseTypes[TypeModule.Name] = require(TypeModule)
end

return PurchaseTypes