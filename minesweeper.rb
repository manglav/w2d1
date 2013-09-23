require './board_class.rb'
require './tile_class.rb'
require 'yaml'
class Game
  attr_accessor :game_board
  def initialize
    load_game
    @game_board = Playing_Board.new
  end

  def play
    game_board.print_board
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
    when "save"
      File.open("most_recent_save.txt", "w") do |f|
        f.puts self.to_yaml
      end
    end
  end

  def load_game
    puts "Do you want to load a game?"
    input = gets.chomp
    load_game = nil
    if input == "yes"
      puts "Please give the filename"
      filename = gets.chomp
      load_game = YAML::load(File.read(filename))
    end
    load_game.play if load_game
  end

end





b = Game.new

b.play