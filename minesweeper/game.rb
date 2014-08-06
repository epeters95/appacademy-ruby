require './board'

class Game
  def initialize
    start_game
  end
  
  def start_game
    puts
    puts "=" * 15
    puts "* MINESWEEPER *"
    puts "=" * 15
    puts
    print "Select difficulty (Easy, Medium, Hard) : "
    difficulty = gets.chomp
    puts
    case difficulty.downcase
    when 'easy'
      @board = Board.new(9,9,10)
    when 'medium'
      @board = Board.new(16,16,40)
    when 'hard'
      @board = Board.new(30,16,99)
    end
    @board.display
  end
  
  def play_game
    game_over = false
    prev_move = ""
    until game_over
      @board.display
      puts prev_move
      print "Use WASD to move, SPACE to reveal, / to flag, V to save, and L to load: "
      choice = STDIN.getch
      prev_move = @board.select_move(choice, prev_move)
      if prev_move == "Game saved."
        save_game
      end
      if prev_move == "You lose!"
        return
      elsif prev_move == "Game loaded."
        load = load_game
        load.play_game
        return
      elsif check_win
        game_over = true
        puts "\n\nCongratulations, you win!\n\n"
        return
      elsif prev_move == "Goodbye"
        puts "Goodbye\n"
        return
      end
    end
  end
  
  def check_win
    win = true
    @board.tiles.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        tile = @board.tile([x,y])
        if tile.bomb
          win = false if !tile.flag
        else
          win = false unless tile.revealed
        end
      end
    end
    win
  end
  
  def save_game
    @game_state = self.to_yaml
    f = File.open('minesweepergame', 'w')
    f.puts @game_state
    f.close
  end
  
  def load_game
    File.open('minesweepergame') do |f|
      @game_state = YAML::load(f)
    end
    @game_state
  end
  
end

Game.new.play_game