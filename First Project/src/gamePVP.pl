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
    valid_moves(Board, Player, ListOfMoves, 4),
    printListOfMoves(ListOfMoves, 1),
    get_play_input(Player, Move),
    (       
        move(Move, Board, NewBoard);
        write('Invalid Play'), nl, play_turn_PvP(Game, Player, PlayedGame)
    ),
    update_game_table(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).

get_play_input(Player, Play) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    get_clean_char(Option),
    (
        Option = '1' -> get_play_column(Column, Direction), Play = ['C', Column, Direction, Player];
        Option = '2' -> get_play_line(Line, Direction), Play = ['L', Line, Direction, Player];
        write('Invalid Input'), nl, get_play_input(Player, Play)
    ).

get_play_line(Line, Direction) :-
    write('Line (1 to 19): '),
    get_clean_int(Line),
    Line > 1, Line < 20,
    get_play_line_direction(Direction).

get_play_line(Line, Direction) :-
    write('Invalid Input'), nl, get_play_line(Line, Direction).

get_play_line_direction(Direction) :-
    write('L (Left) or R (right): '),
    get_clean_char(DirectionChar),
    (
        DirectionChar = 'L', Direction = DirectionChar; DirectionChar = 'l', Direction = 'L';
        DirectionChar = 'R', Direction = DirectionChar; DirectionChar = 'r', Direction = 'R'
    ), nl.

get_play_line_direction(Direction) :-
    write('Invalid Input'), nl, get_play_line_direction(Direction). 
        
get_play_column(Column, Direction):-
    write('Column (A to S): '),
    get_clean_char(ColumnChar),
    char_code(ColumnChar, Code),
    (
        Code >= 65, Code =< 83, Column is (Code - 65);
        Code >= 97, Code =< 115, Column is (Code - 96)
    ), 
    get_play_column_direction(Direction).

get_play_column(Column, Direction) :-
    write('Invalid Option'), nl, get_play_column(Column, Direction).  

get_play_column_direction(Direction) :-
    write('Direction (U (Up) or D (Down)): '),
    get_clean_char(DirectionChar),
    (
        DirectionChar = 'U', Direction = DirectionChar; DirectionChar = 'u', Direction = 'U';
        DirectionChar = 'D', Direction = DirectionChar; DirectionChar = 'd', Direction = 'D'
    ), nl.

get_play_column_direction(Direction) :-
    write('Invalid Option'), nl, get_play_column_direction(Direction).