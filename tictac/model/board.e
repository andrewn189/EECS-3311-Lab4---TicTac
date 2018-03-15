note
	description: "Summary description for {BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOARD

create
	make

feature
	make
		do
			create button.make_from_array (<<"_","_","_","_","_","_","_","_","_">>)
			count := 0
			game_status := 0
		end

feature {NONE} --attributes
	button : ARRAY[STRING]
	count : INTEGER
	game_status : INTEGER --0: game in play/not initialized, 1: player 1 wins, 2: player 2 wins, 3: tie game

feature --commands
	set_button (i: INTEGER; symbol: STRING)
		require
			get_button(i) ~ "_"
			symbol ~ "X" or symbol ~ "O"
			1 <= i and i <= 9
			get_count < 9
		do
			button[i] := (symbol)
			count := count + 1
			update_status
		ensure
			button[i] = symbol
			count = old count + 1
		end

feature {NONE} --private commands
	update_status
			--sets status to 0 if game not finished, 1 if player 1 won, 2 if player 2 won, and 3 if tie
		do
			if not (button[1] ~ "_") and
				((button[1] ~ button[2] and button[1] ~ button[3]) or
				(button[1] ~ button[4] and button[1] ~ button[7]))
			then
				if button[1] ~ "X" then
					game_status := 1
				else
					game_status := 2
				end
			else
				if not (button[9] ~ "_") and
					((button[9] ~ button[3] and button[9] ~ button[6]) or
					(button[9] ~ button[7] and button[9] ~ button[8]))
				then
					if button[9] ~ "X" then
						game_status := 1
					else
						game_status := 2
					end
				else
					if not (button[5] ~ "_") and
						((button[5] ~ button[1] and button[5] ~ button[9]) or
					 	(button[5] ~ button[3] and button[5] ~ button[7]) or
					 	(button[5] ~ button[2] and button[5] ~ button[8]) or
			 			(button[5] ~ button[4] and button[5] ~ button[6]))
					then
						if button[5] ~ "X" then
							game_status := 1
						else
							game_status := 2
						end
					else
						if count = 9 then
							game_status := 3
						else
							game_status := 0
						end
					end
				end
			end
		end

feature --queries
	get_status : INTEGER
		do
			Result := game_status
		ensure
			Result = game_status
		end

	get_button (i: INTEGER) : STRING
		do
			Result := button[i]
		ensure
			Result = button[i]
		end

	to_string : STRING
		do
			create Result.make_from_string (
				"  " + button[1] + button[2] + button[3] + "%N" +
				"  " + button[4] + button[5] + button[6] + "%N" +
				"  " + button[7] + button[8] + button[9] + "%N"
				)
		end

	get_count : INTEGER
		do
			Result := count
		ensure
			Result = count
		end

end
