require 'awesome_print'
class Game
end

class Playing_Board
  attr_accessor :board
  attr_reader :mines
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
    @board = Array.new(dimensions, "*") { Array.new(dimensions, "*") }
    build_board(@board)
  end

  def build_board(board)
  end

  def print_board
    self.board.each {|line| p line}
  end
end

b = Playing_Board.new

b.print_board