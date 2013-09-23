class Playing_Board
  attr_accessor :board, :total_flags
  attr_reader :mines, :dimensions, :bomb_indices
  def initialize
    @dimensions, @mines = get_size
    @total_flags = 0
    @board = generate_board
    @bomb_indices = generate_bomb_indices
    build_board
  end

  def get_size
    puts "Please type small or large for the gameboard size"
    size = gets.chomp
    if size == "small"
      size = 9
      bombs = 10
    elsif size == "large"
      size = 16
      bombs = 40
    end
    return size, bombs
  end


  def [](index)
    board[index[0]][index[1]]
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



  def reveal(index)
    self[index].visible = true
    adjacent_ind = adjacent_indices(index)
    repeat = adjacent_ind.map { |bm_idx| self[bm_idx].bomb }.none?
    if repeat
      adjacent_ind.each do |index|
        reveal(index) unless self[index].visible
      end
    end
  end

  def adjacent_indices(index)
    generalized_indices = [-1,0,1].repeated_permutation(2).to_a
    generalized_indices.delete([0,0])
    adjacent_bomb_indices = generalized_indices.map do |array|
      array[0] += index[0]
      array[1] += index[1]
      array
    end
    adjacent_bomb_indices.select do |array|
      array[0].between?(0, dimensions - 1) &&
      array[1].between?(0, dimensions - 1)
    end
  end

  def build_board
    bomb_indices.each do |bomb_index|
      self[bomb_index].bomb = true
      increment_adjacent_bombs(bomb_index)
    end
    board.each_index do |row|
      board.each_index do |col|
        current_tile = self[[row,col]]
        if !current_tile.bomb && current_tile.bombs_near == 0
          current_tile.internal = true
        end
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
      self[adj_idx].bombs_near += 1
    end
  end

  def print_board
    self.board.each_index do |row|
      self.board.each_index do |col|
        current_tile = self[[row,col]]
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