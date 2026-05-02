-- 깃허브용: 캐릭터를 물리적으로 드래그하는 서버 엔진
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 통신용 리모트 이벤트 생성
local dragEvent = ReplicatedStorage:FindFirstChild("DragRemote") or Instance.new("RemoteEvent")
dragEvent.Name = "DragRemote"
dragEvent.Parent = ReplicatedStorage

dragEvent.OnServerEvent:Connect(function(player, action, targetRoot, position)
    if not targetRoot or not targetRoot:IsA("BasePart") then return end

    if action == "Start" then
        -- 캐릭터를 마우스 위치로 끌어당길 물리 장치 설치
        local attachment = targetRoot:FindFirstChild("DragAttachment") or Instance.new("Attachment")
        attachment.Name = "DragAttachment"
        attachment.Parent = targetRoot

        local alignPos = targetRoot:FindFirstChild("DragAlign") or Instance.new("AlignPosition")
        alignPos.Name = "DragAlign"
        alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
        alignPos.Attachment0 = attachment
        alignPos.MaxForce = 200000 
        alignPos.Responsiveness = 30
        alignPos.Position = position
        alignPos.Parent = targetRoot
        
        -- 부드러운 이동을 위해 드래그하는 사람에게 소유권 부여
        targetRoot:SetNetworkOwner(player)

    elseif action == "Update" then
        -- 마우스 위치에 따라 목적지 좌표 갱신[cite: 1]
        if targetRoot:FindFirstChild("DragAlign") then
            targetRoot.DragAlign.Position = position
        end

    elseif action == "Stop" then
        -- 드래그 종료 시 설치한 물리 장치들 제거[cite: 1]
        if targetRoot:FindFirstChild("DragAlign") then targetRoot.DragAlign:Destroy() end
        if targetRoot:FindFirstChild("DragAttachment") then targetRoot.DragAttachment:Destroy() end
        targetRoot:SetNetworkOwner(nil)
    end
end)
