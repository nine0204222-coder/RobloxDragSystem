local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dragEvent = ReplicatedStorage:FindFirstChild("DragRemote") or Instance.new("RemoteEvent", ReplicatedStorage)
dragEvent.Name = "DragRemote"

dragEvent.OnServerEvent:Connect(function(player, action, target, pos)
    if not target or not target:IsA("BasePart") then return end
    
    if action == "Update" then
        -- 서버에서 직접 위치를 박아버려서 리턴 방지
        target.CFrame = CFrame.new(pos)
        target.Velocity = Vector3.new(0, 0.1, 0) -- 물리 엔진 강제 깨우기
    elseif action == "Stop" then
        -- 놓는 순간 서버가 최종 위치를 확정
        target.CFrame = CFrame.new(pos)
        target.Velocity = Vector3.new(0, 0, 0)
    end
end)
