startCvC(Game) :-
    nth0(0, Game, Table),
    replace_piece(10, 10, 'b', Table, NewTable),
    update_game_table(Game, NewTable, StartedGame),
    print_board(NewTable), update_game_CvC(StartedGame, 'w').

update_game_CvC(Game, Player) :-
    play_turn_CvC(Game, Player, PlayedGame),
    nth0(0, PlayedGame, Board),
    (
        game_over(Board, Winner, 0), victory(Winner); 
        switch_players(Player, NextPlayer), update_game_CvC(PlayedGame, NextPlayer)
    ).
    
play_turn_CvC(Game, Player, PlayedGame) :-
    show_player(Player),
    nth0(0, Game, Board),
    nth0(1, Game, Difficulty),
    valid_moves(Board, ListOfMoves, Player),
    (
        Player = 'b', choose_move(Board, Player, Move, Difficulty, ListOfMoves);
        Player = 'w', choose_move(Board, Player, Move, Difficulty, ListOfMoves)
    ),
    (
        move(Move, ListOfMoves, Board, NewBoard);
        !, print_board(Board), nl, play_turn_CvC(Game, Player, PlayedGame)
    ),
    update_game_table(Game, NewBoard, PlayedGame),
    print_board(NewBoard).