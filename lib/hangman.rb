# frozen_string_literal: true

def sel_word(list)
  list.sample
end

# The class for the main board. Used to save board information
class Board
  attr_accessor :board_info

  def initialize
    @board_info = {
      current_state: [],
      secr_word: '',
      rem_turns: '',
      guessed_letter: ''
    }
  end
end

# module with gameplay related methods
module Gameplay
  def load_wordlist
    wordlist = File.readlines('google-10000-english-no-swears.txt')
    wordlist.select { |word| word.length.between?(5, 12) }
  end

  def hangman
    gameboard = Board.new
    gameboard.board_info[:secr_word] = load_wordlist.to_a
    gameboard.board_info[:current_state] = Array.new(gameboard.board_info[:secr_word].length, '_')
    6.times do
      puts 'Guess a letter!'
    end
  end

  def play_round
    puts 'Guess a letter!'
    loop do
      gameboard.board_info[:guessed_letter] = gets.chomp
      break unless gameboard.board_info[:guessed_letter] != 1 || /\D/.match?(gameboard.board_info[:guessed_letter])
    end
  end

  def compare_guess
    gameboard.board_info[:secr_word].for_each_index do |i|
      next unless gameboard.board_info[:secr_word][i] == gameboard.board_info[:guessed_letter]

      gameboard.board_info[:current_state][i] = gameboard.board_info[:guessed_letter]
    end
  end
end
gameplay
