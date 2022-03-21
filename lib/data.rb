# frozen_string_literal: true

# Methods related to saving the game
module SaveData
  def create_save
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = 'saves/saved_game.json'

    File.open(filename, 'w') do |file|
      JSON.dump(board_info, file)
    end

    puts 'Game Saved'
  end

  def load_save
    filename = 'saves/saved_game.json'
    contents = {}
    File.open(filename) do |file|
      contents = JSON.parse(file.read, { symbolize_names: true })
    end
    contents
  end

  def load_message?
    choice = ''
    loop do
      puts 'Would you like to continue your last saved game? Type "y" or "n"'
      choice = gets.chomp
      break if %w[y n].include?(choice)
    end
    case choice
    when 'y'
      true
    when 'n'
      false
    end
  end

  def game_start
    if load_message?
      board_info.replace(load_save)
      puts "Incorrect Letters: #{board_info[:guess_list]}"
      p board_info[:current_state].join(' ')
    else
      sel_word
    end
  end
end
