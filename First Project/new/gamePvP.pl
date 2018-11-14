startPvP(Game) :-
    nth0(0, Game, Table),
    replace_piece(10, 10, 'b', Table, NewTable),
    update_game_table(Game, NewTable, StartedGame),
    printBoard(NewTable), update_game_PvP(StartedGame, 'w').

update_game_PvP(Game, Player) :-
    play_turn_PvP(Game, Player, PlayedGame),
    nth0(0, PlayedGame, Board),
    (
        game_over(Board, Winner, 0), victory(Winner); 
        switch_players(Player, NextPlayer), update_game_PvP(PlayedGame, NextPlayer)
    ).

play_turn_PvP(Game, Player, PlayedGame) :-
    showPlayer(Player),
    nth0(0, Game, Board),
    valid_moves(Board, ListOfMoves),
    PrintList = ListOfMoves,
    printListOfMoves(PrintList, 1),
    get_human_input(Player, ListOfMoves, Move),   
    move(Move, Board, NewBoard);
    write(NewBoard), nl, 
    update_game_table(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).

get_human_input(Player, ListOfMoves, Play) :-
    write('\nChoose on of the plays'), nl,
    get_clean_char(OptionChar),
    name(OptionChar, [OptionInt]),
    Index is OptionInt - 48,
    (
        length(ListOfMoves, L),
        Index > 0, Index =< L,
        nth1(Index, ListOfMoves, Play)
    );
    write('Invalid Play'), nl, get_human_input(Player, ListOfMoves, Play).
    