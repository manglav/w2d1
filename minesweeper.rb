require 'awesome_print'
require './board_class.rb'
require './tile_class.rb'

class Game
  attr_accessor :game_board
  def initialize
    @game_board = Playing_Board.new
  end

  def play
    ap game_board.bomb_indices
    until game_won?
      puts "Please put the f or r, x, and y"
      inputs = gets.chomp.split(" ")
      action = inputs[0]
      index = inputs[1..2].map {|e| e.to_i }
      perform_action(action, index)
      game_board.print_board
    end
    puts "You won!"
  end

  def game_won?
    game_board.mines == game_board.total_flags &&
      game_board.bomb_indices.map { |bm_idx| self.game_board[bm_idx].flagged }.all?
  end

  def game_lose?
      game_board.bomb_indices.map { |bm_idx| self.game_board[bm_idx].visible }.any?
  end# move into Game class

  def perform_action(action, index)
    case action
    when "r"
      game_board.reveal(index)
      if game_lose?
        puts "You lost"
        return
      end
    when "f"
      game_board[index].flagged ? game_board.total_flags -= 1 : game_board.total_flags += 1
      game_board[index].flagged = !game_board[index].flagged
    end
  end
end





b = Game.new

b.play