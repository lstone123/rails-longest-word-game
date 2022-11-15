class GamesController < ApplicationController
  require 'open-uri'
  require 'json'
  def new
    alphabet_array = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
                      'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    @letters = 10.times.map { alphabet_array.sample }
  end

  def valid?
    submitted = params[:word].downcase.split('')
    generated = params[:letters].downcase.split(' ')
    submitted.each do |letter|
      return false if generated.index(letter).nil?
      generated.delete_at(generated.index(letter))
    end
    true
  end

  def score
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    wagon_api = URI.open(url).read
    dictionary = JSON.parse(wagon_api)
    if dictionary['found'] == true && valid?
      @message = "Congratulations! #{@word.capitalize} is a valid English word!"
    elsif dictionary['found'] == false
      @message = "Sorry but #{@word.capitalize} does not seem to be a valid English word..."
    elsif !valid?
      @message = "Sorry but #{@word.capitalize} can't be made out of #{params[:letters]}"
    end
  end
end
