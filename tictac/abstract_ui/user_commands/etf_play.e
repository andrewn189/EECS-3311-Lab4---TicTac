note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
		redefine play end
create
	make
feature -- command
	play(player: STRING ; press: INTEGER_64)
		require else
			play_precond(player, press)
    	do
    		if model.is_game_finished then
    			model.set_status_message ("game is finished")
    		else
    			if not model.player_exists (player) then
					model.set_status_message ("no such player")
	    		else
	    			if not model.is_next (player) then
	    			model.set_status_message ("not this player's turn")
					else
						if not model.is_button_empty (press.to_integer) then
							model.set_status_message ("button is already taken")
						else
							model.play (player, press.to_integer)
							inspect model.get_board.get_status
							when 0 then
								model.set_status_message ("ok")
							when 1, 2 then
								model.set_status_message ("there is a winner")
							when 3 then
								model.set_status_message ("game ended in a tie")
							end
						end
	    			end
	    		end
    		end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
