
Ice = Entity:extend()

function Ice:new(x, y)
    --Image by Freepik "https://www.freepik.com/free-vector/flat-snow-cap-collection_3507261.htm#page=2&query=ice&position=23&from_view=search&track=sph"
    Ice.super.new(self, x, y, "ice.jpg")
    self.strength = 100
    self.weight = 0

end