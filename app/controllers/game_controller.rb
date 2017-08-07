require 'open-uri'
require 'json'

class GameController < ApplicationController
  def score
    @attempt = params[:attempt]
    @grid_sent = params[:grid]
    @start_time = Time.parse(params[:start_time])
    @score = run_game(@attempt, @grid_sent, @start_time, Time.now)[:score]
    @message = run_game(@attempt, @grid_sent, @start_time, Time.now)[:message]
    @time = run_game(@attempt, @grid_sent, @start_time, Time.now)[:time]
    session[:games] += 1
  end

  def game
    @grid = generate_grid(8)
    @number_of_games = session[:games]
    session[:username] = params[:username]
    @player = session[:username]
  end

  def init
    session[:games] = 0
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    (1..grid_size).to_a.each { |_i| grid << ('A'..'Z').to_a.sample }
    return grid
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    result = {}
    result[:score] = 0
    result[:time] = end_time - start_time
    grid = eval(grid)
    if word_is_english?(attempt) && word_in_grid?(attempt, grid)
      result[:message] = "well done!"
      result[:score] = attempt.size + [(start_time - end_time)/100, -3].max
    else
      result[:message] = "Sorry, this is not an english word!" if word_is_english?(attempt) == false
      result[:message] = "Sorry, this word is not in the grid!" if word_in_grid?(attempt, grid) == false
    end
    return result
  end

  def word_is_english?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    parsed = JSON.parse(response)
    if parsed["found"] == true
      return true
    else return false
    end
  end

  def word_in_grid?(word, grid)
    hash_grid = {}
    grid.each { |letter| hash_grid[letter] = hash_grid[letter].to_i + 1 }
    word.upcase.split('').each { |letter| hash_grid[letter] = hash_grid[letter].to_i - 1 }
    return hash_grid.none? { |_k, v| v < 0 }
  end

end
