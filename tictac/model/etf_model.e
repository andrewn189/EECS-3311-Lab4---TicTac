note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end


create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create board.make
			create player1.make ("", 1)
			create player2.make ("", 2)
			current_player := Void
			status_message := "ok"
		end

feature {NONE} --model attributes
	board : BOARD
	player1 : PLAYER
	player2 : PLAYER
	current_player : detachable PLAYER
	status_message : STRING

feature -- model operations
	reset
		do
			make
		end

	new_game (p1: STRING; p2: STRING)
		require
			not (p1 ~ p2)
			p1.at (1).is_alpha
			p2.at (1).is_alpha
		do
			create board.make
			create player1.make (p1, 1)
			create player2.make (p2, 2)
			current_player := player1
		ensure
			player1.get_name ~ p1
			player2.get_name ~ p2
		end

	play (player: STRING; i: INTEGER)
		require
			1 <= i and i <= 9
			get_board.get_status = 0
			player_exists (player)
			is_next (player)
			get_board.get_button (i) ~ "_"
		do
			check attached current_player as l_cp then
				board.set_button (i, l_cp.get_symbol)
			end
			inspect board.get_status
			when 0 then
				if current_player = player2 then
					current_player := player1
				else
					current_player := player2
				end
			when 1 then
				player1.increase_score
			when 2 then
				player2.increase_score
			else
				--tie so do nothing
			end
		ensure
			not (get_board.get_button (i) ~ "_")
		end

	play_again
		require
			get_board.get_status /= 0
		do
			current_player := player1
			board.make
		ensure
			board.get_status = 0
			board.get_count = 0
			current_player = player1
		end

	set_status_message (s: STRING)
		do
			status_message := s
		ensure
			status_message = s
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  " + status_message + ": => ")
			if current_player = Void then
				Result.append ("start new game%N")
			else
				if not is_game_finished then
					check attached current_player as l_cp then
						Result.append (l_cp.get_name + " plays next%N")
					end
				else
					Result.append ("play again or start new game%N")
				end
			end
			Result.append (board.to_string)
			Result.append ("  " + player1.get_score.out + ": score for %"" + player1.get_name + "%" (as X)%N")
			Result.append ("  " + player2.get_score.out + ": score for %"" + player2.get_name + "%" (as O)%N")
		end

	is_next (player: STRING) : BOOLEAN
		require
			player_exists (player)
		do
			check attached current_player as l_cp then
				if l_cp.get_name ~ player then
					Result := True
				else
					Result := False
				end
			end
		end

	player_exists (player: STRING) : BOOLEAN
		do
			if player1.get_name ~ player or player2.get_name ~ player then
				Result := True
			else
				Result := False
			end
		end

	is_button_empty (i: INTEGER) : BOOLEAN
		require
			1 <= i and i <= 9
		do
			if board.get_button(i) ~ "_" then
				Result := True
			else
				Result := False
			end
		end

	is_game_finished : BOOLEAN
		do
			if board.get_status = 0 then
				Result := False
			else
				Result := True
			end
		end

	get_board : BOARD
		do
			Result := board
		ensure
			Result = board
		end

end




