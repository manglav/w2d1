class Tile
  attr_accessor :bomb, :flagged, :bombs_near, :visible, :internal
  def initialize
    @bomb = false
    @flagged = false
    @bombs_near = 0
    @visible = false
    @internal = false
  end
end