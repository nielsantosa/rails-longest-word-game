require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    start_session
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @_total_score = session[:total_score]
  end

  def score
    @original_letters = params[:original_letters].upcase
    @answer = params[:answer].upcase
    @original_letters_array = @original_letters.split(" ")

    # Check 1 : Check if answer got all the letters from original letters
    check1 = true
    @answer.split("").each do |letter|
      letter_index = @original_letters_array.find_index(letter)
      if letter_index
        @original_letters_array.delete_at(letter_index)
      else
        check1 = false
        break
      end
    end
    # Check 2 : Check if it is a valid word from api
    dict_api_url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    raw_json = URI.open(dict_api_url).read
    json = JSON.parse(raw_json)

    check2 = json["found"] == true

    if !check1
      @text = "Sorry but #{@answer} can't be built out of #{@original_letters.gsub(" ",",")}."
    elsif !check2
      @text = "Sorry but #{@answer} is not a valid word."
    else
      @text = "Congratulations! #{@answer} is a valid english word."
      session[:total_score] += compute_score(@answer)
    end

    @_total_score = session[:total_score]
  end

  private

  def compute_score(words)
    words.length * 10
  end

  def start_session
    if session[:total_score] == nil
      session[:total_score] = 0
    end
  end

  def refresh_session
    session[:total_score] = 0
  end
end
