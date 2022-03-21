# frozen_string_literal: true

require 'json'
require_relative 'gameplay'
require_relative 'data'

gameboard = Board.new
gameboard.game_start
gameboard.hangman
