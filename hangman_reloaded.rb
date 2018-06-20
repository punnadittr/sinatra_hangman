require "sinatra"
require "sinatra/reloader"

def get_dict
  @dict = File.readlines("dict.txt")
  @dict.map! { |word| word.chomp }
  @dict.select! { |word| word.length.between?(3,12) }
end

def get_random_word
  @random_word = @dict.sample.downcase
end

def create_display_spaces
  @guessing_spaces = Array.new(@session[:rand_word].length, "_")
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
  session[:rand_word].chars.each_index do |i|
    if session[:rand_word][i].upcase == @session[:clicked_char]
      @session[:display][i] = session[:rand_word][i].upcase
    end
  end
end

configure do
  enable :sessions
end

get "/" do
  @session = session
  get_dict
  session[:clicked_chars] ||= []
  session[:rand_word] ||= get_random_word
  session[:display] ||= create_display_spaces
  session[:wrong_counter] ||= 8
  guess_word
  erb :index
end

get "/reset" do
  @session = session
  get_dict
  @session[:clicked_chars] = []
  @session[:clicked_char] = nil
  @session[:rand_word] = get_random_word
  @session[:display] = create_display_spaces
  @session[:wrong_counter] = 8
  redirect "/"
end

("A".."Z").to_a.each do |char|
  get "/#{char}" do
    session[:clicked_char] = char
    redirect "/"
  end
end