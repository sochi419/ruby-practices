# frozen_string_literal: true

require './game'
score = ARGV[0]
scores = score.split(',')
game = Game.new(scores)
p game.score
