note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_GAME
inherit
	ETF_NEW_GAME_INTERFACE
		redefine new_game end
create
	make
feature -- command
	new_game(player1: STRING ; player2: STRING)
		require else
			new_game_precond(player1, player2)
    	do
    		if player1 ~ player2 then
				model.set_status_message ("names of players must be different")
			else
				if not player1.at (1).is_alpha or not player2.at (1).is_alpha then
					model.set_status_message ("name must start with A-Z or a-z")
				else
					model.new_game(player1, player2)
					model.set_status_message ("ok")
				end
    		end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
