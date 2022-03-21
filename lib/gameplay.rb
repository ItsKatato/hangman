# frozen_string_literal: true

require_relative 'data'

# The class for the main board. Used to save board information
class Board
  attr_accessor :board_info # , :secr_word, :current_state, :health, :guessed_letter

  include SaveData

  def initialize
    @board_info = {
      secr_word: [],
      current_state: [],
      health: 6,
      guessed_letter: '',
      guess_list: []
    }
  end

  def load_wordlist
    wordlist = File.readlines('google-10000-english-no-swears.txt')
    wordlist.select { |word| word.length.between?(5, 12) }
  end

  def sel_word
    board_info[:secr_word] = load_wordlist.sample.chomp.split('')
    board_info[:current_state] = Array.new(board_info[:secr_word].length, '_')
  end

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
    puts "The word was #{board_info[:secr_word].join}"
  end

  def play_round
    puts 'Guess a (1) letter, type "save" to save the game, or type "exit" to end the game!'
    loop do
      board_info[:guessed_letter] = gets.chomp
      board_info[:guessed_letter].downcase!
      break unless guess_invalid?

      if board_info[:guessed_letter] == 'save'
        create_save
        puts 'Guess a (1) letter, type "save" to save the game, or type "exit" to end the game!'
        redo
      end

      if board_info[:guessed_letter] == 'exit'
        puts 'Thanks for playing!'
        exit
      end

      puts 'Guess only 1 letter & don\'t repeat letters!'
    end
    compare_guess
  end

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

  def update_guess_list
    return if board_info[:secr_word].include?(board_info[:guessed_letter])

    board_info[:guess_list].push(board_info[:guessed_letter])
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