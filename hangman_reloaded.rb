require "sinatra"
require "sinatra/reloader"

def get_dict
  @dict = File.readlines("dict.txt")
  @dict.map! { |word| word.chomp }
  @dict.select! { |word| word.length.between?(3,12) }
end

def get_random_word
  @random_word = @dict.sample.downcase.chars
end

def create_display_spaces
  @guessing_spaces = Array.new(@random_word.length, "_")
end

def display_spaces
  @display_spaces = @guessing_spaces.join(" ")
end

=begin
def keep_track_input
  if @userinput.length > 1 || @userinput.empty?
    puts "Invalid Input"
  elsif (@random_word.include? @userinput) == false
    @incorrect_guess << @userinput.upcase
    @rounds -= 1
    @incorrect = true
  end
end
=end
def game_over?
  if (@display_spaces.include? "_") == false
    puts "You Win!"
    puts "The word is #{@rand_word.upcase}"
    @game_over = true
  elsif @rounds == 0
    puts "You Lose!"
    puts "The word is #{@rand_word.upcase}"
    @game_over = true
  else
    @game_over = false
  end
end

def show_result
  if @incorrect == true && @rounds != 0
    puts "Incorrect: #{@incorrect_guess}" 
    puts "Rounds left: #{@rounds}"
  end
end

def play
  display_spaces
  while @game_over != true
    guess_word
  end
end

def guess_word
  puts display_spaces
  @userinput = gets.chomp
  @random_word.each_index do |i|
    if @random_word[i] == @userinput
      @guessing_spaces[i] = @random_word[i].upcase
    end
  end
end

get "/" do
  get_dict
  get_random_word
  create_display_spaces
  erb :index
end

("A".."Z").to_a.each do |char|
  get "/#{char}" do
    redirect "/"
  end
end