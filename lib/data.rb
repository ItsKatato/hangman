# frozen_string_literal: true

# Methods related to saving the game
module LoadData
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
    choice == 'y'
  end

  def save?
    File.exist?('saves/saved_game.json')
  end

  def game_start
    sel_word unless save?
    if load_message?
      board_info.replace(load_save)
      puts "Incorrect Letters: #{board_info[:guess_list]}"
      p board_info[:current_state].join(' ')
    else
      sel_word
    end
  end

  # Loads up wordlist and selects words with correct length
  def load_wordlist
    wordlist = File.readlines('google-10000-english-no-swears.txt')
    wordlist.select { |word| word.length.between?(5, 12) }
  end

  # Selects word from the wordlist
  def sel_word
    board_info[:secr_word] = load_wordlist.sample.chomp.split('')
    board_info[:current_state] = Array.new(board_info[:secr_word].length, '_')
  end
end
