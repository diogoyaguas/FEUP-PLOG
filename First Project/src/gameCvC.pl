update_game_CvC(Game, Player, Find) :-
    play_turn_CvC(Game, Player, PlayedGame, Find),
    nth0(0, PlayedGame, Board),
    (game_over(Board, 0), write('Victory'); switch_players(Player, NextPlayer), update_game_CvC(PlayedGame, NextPlayer, Find)).

play_turn_CvC(Game, Player, PlayedGame, Find) :-
    showPlayer(Player),
    nth0(0, Game, Board),
    (
        Player = 'b' -> get_computer_input(Player, Move, Board, Find);
        Player = 'w' -> get_computer_input(Player, Move, Board, Find)
    ),
    (
        move(Move, Board, NewBoard);
        write('Invalid Play'), nl, play_turn_CvC(Game, Player, PlayedGame, Find)
    ),
    update_game_table(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).