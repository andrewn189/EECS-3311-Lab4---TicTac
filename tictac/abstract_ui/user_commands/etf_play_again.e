note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY_AGAIN
inherit
	ETF_PLAY_AGAIN_INTERFACE
		redefine play_again end
create
	make
feature -- command
	play_again
    	do
    		if not model.is_game_finished then
				model.set_status_message ("finish this game first")
			else
				model.play_again
				model.set_status_message ("ok")
    		end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
