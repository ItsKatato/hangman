# frozen_string_literal: true

require_relative 'data'

# The class for the main board. Used to save board information
class Board
  attr_accessor :board_info

  include LoadData

  def initialize
    @board_info = {
      secr_word: [],
      current_state: [],
      health: 6,
      guessed_letter: '',
      guess_list: []
    }
  end

  # main gameplay method
  def hangman
    loop do
      puts "Hangman's Health: #{board_info[:health]}/6"
      play_round
      update_guess_list
      puts "Incorrect Letters: #{board_info[:guess_list]}"
      board_info[:health] -= 1 unless correct_guess?
      break if board_info[:health].zero? || board_info[:secr_word] == board_info[:current_state]

      p board_info[:current_state].join(' ')
    end
    win_test
  end

  # plays a single round of hangman
  def play_round
    puts 'Guess a (1) letter, type "save" to save the game, or type "exit" to end the game!'
    loop do
      board_info[:guessed_letter] = gets.chomp
      board_info[:guessed_letter].downcase!
      break unless guess_invalid?

      game_options
    end
    compare_guess
  end

  # User options to save or exit the game
  def game_options
    case board_info[:guessed_letter]
    when 'save'
      create_save
      puts 'Guess a (1) letter, type "save" to save the game, or type "exit" to end the game!'
    when 'exit'
      puts 'Thanks for playing!'
      exit
    else
      puts 'Remember to guess only 1 letter & don\'t repeat letters!'
    end
  end

  # Checks if user entered a valid guess
  def guess_invalid?
    if board_info[:guessed_letter].length != 1
      true
    elsif /\d/.match?(board_info[:guessed_letter])
      true
    elsif board_info[:current_state].include?(board_info[:guessed_letter])
      true
    else
      false
    end
  end

  # Updated incorrect guess list
  def update_guess_list
    return if board_info[:secr_word].include?(board_info[:guessed_letter])

    board_info[:guess_list].push(board_info[:guessed_letter])
  end

  # Checks if guessed letter is in the secret wword
  def compare_guess
    board_info[:secr_word].each_index do |i|
      next unless board_info[:secr_word][i] == board_info[:guessed_letter]

      board_info[:current_state][i] = board_info[:guessed_letter]
    end
  end

  # Checks if guess was correct
  def correct_guess?
    board_info[:current_state].include?(board_info[:guessed_letter])
  end

  def win_test
    if board_info[:secr_word] == board_info[:current_state]
      puts "You win! The word was #{board_info[:secr_word].join}"
    else
      puts "You lose! The word was #{board_info[:secr_word].join}"
    end
  end
end
