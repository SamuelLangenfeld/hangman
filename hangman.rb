class Game

	def initialize(secret_word=nil, incorrect_guesses=nil, correct_guesses=nil)

		if (incorrect_guesses==nil && correct_guesses==nil)
			@incorrect_guesses=[]
			@correct_guesses=[]
			@secret_word=secret_word
			@display_array=Array.new(@secret_word.size, '-')


		else

			@incorrect_guesses=incorrect_guesses.split("")
			@correct_guesses=correct_guesses.split("")
			@secret_word=secret_word
			@display_array=Array.new(@secret_word.size, '-')
			
			


			@correct_guesses.each do |guess|
				
				index_array=[]
				start=0

				while @secret_word.index(guess, start) do
					
					indx=@secret_word.index(guess, start)
					index_array.push(indx)
					start=indx+1

				end

				index_array.each do |i|
					@display_array[i]=guess
				end


			end
			display_game_state
		end




	end

	private

	def verify_guess
		puts "Enter one letter from the English alphabet or enter 'save' to save your game"
		guess=gets.chomp.downcase
		if guess=='save'
			save_game
		end

		while (guess.size!=1 || guess>'z' || guess<'A') do
			puts "Enter one letter from the English alphabet or enter 'save' to save your game"
			guess=gets.chomp
			if guess=='save'
				save_game
			end
		end

		already_guessed=false
		@correct_guesses.each do |i|
			if i==guess
				already_guessed=true
			end
		end
		@incorrect_guesses.each do |i|
			if i==guess
				already_guessed=true
			end
		end

		if already_guessed
			puts "You already guessed that letter. Try again."
			guess=verify_guess
		end

		return guess
	end





	def display_game_state

		wrong_string=@incorrect_guesses.join(", ")
		puts "Wrong guesses: #{wrong_string}"

		partial_secret_word=@display_array.join		
		puts "Secret word: #{partial_secret_word}"

	end



	def win?
		if @incorrect_guesses.size>5
			return false
		else
			return true
		end
	end




	def save_game
		puts "Enter a name for your game"
		
		game_name=Game.get_save_name
		while File.exists? game_name do
			puts "That is already the name of a saved game. Enter a new name for this game."
			game_name=get_save_name
		end
		f = File.new game_name, 'w'
		f.puts("#{@secret_word}")
		incorrect_guesses=@incorrect_guesses.join
		f.puts("#{incorrect_guesses}")
		correct_guesses=@correct_guesses.join
		f.puts("#{correct_guesses}")
		f.close

	end

	public

	def self.get_save_name
		game_name=gets.chomp.downcase
		while (game_name>='{' || game_name<'a') do
			puts "Enter a name only using English letters"
			game_name=gets.chomp.downcase
		end
		game_name+='.txt'
		game_name= "saved_games/"+game_name
		return game_name
	end

	def try
		guess=verify_guess


		if @secret_word.index(guess)
			
			start=0
			index_array=[]
			while @secret_word.index(guess, start) do
				indx=@secret_word.index(guess, start)
				index_array.push(indx)
				start=indx+1
			end
			@correct_guesses.push(guess)
			index_array.each do |i|
				@display_array[i]=guess
			end


		else
			@incorrect_guesses.push(guess)
		end
		display_game_state
		
	end

	def is_over?
		if @incorrect_guesses.size>5
			return true
		end

		remaining_letters=0
		@display_array.each do |i|
			if i=='-'
				remaining_letters+=1
			end
		end

		if remaining_letters>0
			return false
		else
			return true
		end
	end

	def end_game_output
		
		if win?
			puts "Congratulations, you won!"
		else
			puts "You lose"
			puts "The secret word was #{@secret_word}"
		end
	end








end



def new_game
	puts "Would you like to load a previous game? y/n"
	answer=gets.chomp.downcase
	if answer=="yes" || answer=='y'
		load_game
		return
	else
		puts "New game"
	end

	secret_word=""

	while (secret_word.size<5 || secret_word.size>12) do
	dictionary=File.readlines "5desk.txt"
	dictionary.map! {|i| i.downcase.chomp!}
	secret_word=dictionary[rand(dictionary.size)]
	end



	game= Game.new(secret_word)
	game.try
	while !game.is_over? do
		game.try
	end
	game.end_game_output

end

def new_game_from_load(secret_word,incorrect_guesses,correct_guesses)
	game= Game.new(secret_word,incorrect_guesses,correct_guesses)
	game.try
	while !game.is_over? do
		game.try
	end
	game.end_game_output
end



def new_game?

	puts "Would you like to play again? y/n"
	answer=gets.chomp.downcase
	if answer=='y' || answer=='yes'
		return true
	else
		puts "Goodbye"
		return false
	end
end

def load_game
	puts "Enter the name of your saved game."
	file_name=Game.get_save_name
	while !File.exists? file_name do
		puts "The game name you entered does not exist. Please enter another name."
		file_name=Game.get_save_name
	end
	file=File.open(file_name)
	secret_word=file.readline.chomp
	incorrect_guesses=file.readline.chomp
	correct_guesses=file.readline.chomp
	new_game_from_load(secret_word, incorrect_guesses, correct_guesses)


end

puts "Welcome to Hangman!"
puts "Guess letters until you discover the secret word. If you guess six wrong letters you lose."

new_game
while new_game? do
	new_game
end



