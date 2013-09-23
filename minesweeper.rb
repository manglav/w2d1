require 'awesome_print'

class Game
  attr_accessor :game_board
  def initialize
    @game_board = Playing_Board.new
  end

  def play
    ap game_board.bomb_indices
    until game_board.game_won?
      puts "Please put the f or r, x, and y"
      inputs = gets.chomp.split(" ")
      action = inputs[0]
      x = inputs[1].to_i
      y = inputs[2].to_i
      case action
      when "r"
        game_board.reveal(x, y)
        if game_board.game_lose?
          puts "You lost"
          return
        end
      when "f"
        game_board.board[x][y].flagged = true
      end
        game_board.print_board
    end
  end
end

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

class Playing_Board
  attr_accessor :board, :total_flags
  attr_reader :mines, :dimensions, :bomb_indices
  def initialize
    @total_flags = 0

    ap "Please type small or large for the gameboard size"
    size = gets.chomp
    if size == "small"
      @dimensions = 9
      @mines = 10
    elsif size == "large"
      @dimensions = 16
      @mines = 40
    end
    @board = generate_board
    @bomb_indices = generate_bomb_indices
    build_board
  end

  def generate_board
    result = Array.new(dimensions) { Array.new(dimensions)}
    result.each_index do |row|
    result.each_index do |col|
        result[row][col] = Tile.new
      end
    end
    result
  end

  def game_won?
    mines == total_flags &&
      bomb_indices.map { |bm_idx| board[bm_idx[0]][bm_idx[1]].flagged }.all?
  end

  def game_lose?
      bomb_indices.map { |bm_idx| board[bm_idx[0]][bm_idx[1]].visible }.any?
  end

  def reveal(x,y)
    board[x][y].visible = true
    return if game_lose?
    adjacent_ind = adjacent_indices([x,y])
    repeat = adjacent_ind.map { |bm_idx| board[bm_idx[0]][bm_idx[1]].bomb }.none?
    if repeat
      adjacent_ind.each do |index|
        reveal(index[0],index[1]) unless board[index[0]][index[1]].visible
      end
    end
  end

  def adjacent_indices(index)
    generalized_indices = [-1,0,1].repeated_permutation(2).to_a
    generalized_indices.delete([0,0])
    adjacent_bomb_indices = generalized_indices.map { |array| array[0] += index[0]; array[1] += index[1]; array }
    .select { |array| array[0].between?(0, dimensions - 1) && array[1].between?(0, dimensions - 1) }
  end

  def build_board
    bomb_indices.each do |bomb_index|
      board[bomb_index.first][bomb_index.last].bomb = true
      increment_adjacent_bombs(bomb_index)
    end
    board.each_index do |row|
      board.each_index do |col|
        current_tile = board[row][col]
        current_tile.internal = true if !current_tile.bomb && current_tile.bombs_near == 0
      end
    end
  end

  def generate_bomb_indices
    indices = []
    until indices.count == mines
      index = (0...dimensions).to_a.sample(2)
      indices << index unless indices.include?(index)
    end
    indices
  end

  def increment_adjacent_bombs(bomb_index)
    adjacent_bomb_indices = adjacent_indices(bomb_index)
    adjacent_bomb_indices.each do |adj_idx|
      board[adj_idx[0]][adj_idx[1]].bombs_near += 1
    end
  end

  def print_board
    self.board.each_index do |row|
      self.board.each_index do |col|
        current_tile = board[row][col]
        case
        when current_tile.flagged == true
          print "F "
        when current_tile.visible == false
          print "* "
        when current_tile.bombs_near > 0
          print "#{current_tile.bombs_near} "
        else
          print "_ "
        end
      end
      puts nil
    end
  end
end

b = Game.new

b.play