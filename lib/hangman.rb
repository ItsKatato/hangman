# frozen_string_literal: true

def sel_word(list)
  list.sample
end

# The class for the main board. Used to save board information
class Board
  attr_accessor :board_info, :secr_word, :current_state, :health, :guessed_letter

  def initialize
    @board_info = {
      secr_word: sel_word.split(''),
      current_state: Array.new(:secr_word.length, '_'),
      health: 6,
      guessed_letter: ''
    }
  end

  def load_wordlist
    wordlist = File.readlines('google-10000-english-no-swears.txt')
    wordlist.select { |word| word.length.between?(5, 12) }
  end

  def sel_word
    load_wordlist.sample
  end

  def hangman
    loop do
      puts "Hangman's Health: #{board_info[:health]}/6"
      play_round
      board_info[:health] -= 1 unless correct_guess?
      break if board_info[:health].zero? || board_info[:secr_word] == board_info[:current_state]

      print board_info[:current_state].join(' ')
    end
    puts "The word was #{board_info[:secr_word].join}"
  end

  def play_round
    puts 'Guess a (1) letter!'
    loop do
      board_info[:guessed_letter] = gets.chomp
      board_info[:guessed_letter].downcase!
      break unless board_info[:guessed_letter].length != 1 || /\d/.match?(board_info[:guessed_letter])

      puts 'Guess only 1 letter! Try Again.'
    end
    compare_guess
  end

  def compare_guess
    board_info[:secr_word].each_index do |i|
      next unless board_info[:secr_word][i] == board_info[:guessed_letter]

      board_info[:current_state][i] = board_info[:guessed_letter]
    end
  end

  def correct_guess?
    board_info[:current_state].include?(board_info[:guessed_letter])
  end
end

gameboard = Board.new
gameboard.hangman
