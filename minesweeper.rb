require 'awesome_print'

class Game
end

class Tile
  attr_accessor :bomb, :flagged, :bombs_near, :visible
  def initialize
    @bomb = false
    @flagged = false
    @bombs_near = 0
    @visible = false
    @internal = false
  end
end

class Playing_Board
  attr_accessor :board
  attr_reader :mines :dimensions
  def initialize
    ap "Please type small or large for the gameboard size"
    size = gets.chomp
    if size == "small"
      dimensions = 9
      @mines = 10
    elsif size == "large"
      dimensions = 16
      @mines = 40
    end
    @board = Array.new(dimensions) { Array.new(dimensions, "_") }
    build_board(@board)
  end

  def build_board
    bomb_indices = generate_bomb_indices
    bomb_indices.each do |bomb_index|
      board[bomb_index.first][bomb_index.last].bomb = true
      increment_adjacent_bombs(bomb_index)
  end

  def generate_bomb_indices
    indices = []
    until indices.count == mines
      index = (0..dimensions).to_a.sample(2)
      indices << index unless indices.include?(index)
    end
  end

  def increment_adjacent_bombs(bomb_index)
    generalized_indices = [-1,0,1].repeated_permutation(2).to_a
    generalized_indices.delete([0,0])
    adjacent_bomb_indices = generalized_indices.map { |array| array[0] += bomb_index[0]; array[1] += bomb_index[1]; array }
    .select { |array| array[0].between?(0, dimensions - 1) && array[1].between?(0, dimensions - 1) }
    adjacent_bomb_indices.each do |adj_idx|
      board[adj_idx[0]][adj_idx[1]].bombs_near += 1
    end
  end

  def print_board
    self.board.each {|line| p line}
  end
end

b = Playing_Board.new

b.print_board