update_game_PvC(Game, Player, Find) :-
    play_turn_PvC(Game, Player, PlayedGame, Find),
    nth0(0, PlayedGame, Board),
    (game_over(Board, Winner, 0), victory(Winner); switch_players(Player, NextPlayer), update_game_PvC(PlayedGame, NextPlayer, Find)).

play_turn_PvC(Game, Player, PlayedGame, Find) :-
    showPlayer(Player),
    nth0(0, Game, Board),
    (
        Player = 'b' -> get_computer_input(Player, Move, Board, Find);
        Player = 'w' -> get_play_input(Player, Move)
    ),
    (
        move(Move, Board, NewBoard);
        write('Invalid Play'), nl, play_turn_PvC(Game, Player, PlayedGame, Find)
    ),
    update_game_table(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).    

get_computer_input(Player, Play, Board, Find) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    (
        select_movement(Player, Board, 1, Column, Find), Direction = 'D', Column \= -1 -> Play = ['C', Column, Direction, Player], write_options(1, Play);
        reverse(Board, ReversedBoard), select_movement(Player, ReversedBoard, 1, Column, Find), nl, Direction = 'U', Column \= -1 -> Play = ['C', Column, Direction, Player], write_options(1, Play);
        transpose(Board, NewBoard), select_movement(Player, NewBoard, 1, Line, Find), Direction = 'R', Line \= -1 -> Play = ['L', Line, Direction, Player], write_options(2, Play);
        transpose(Board, NewBoard), reverse(NewBoard, ReversedBoard), select_movement(Player, ReversedBoard, 1, Line, Find), Direction = 'L', Line \= -1 -> Play = ['L', Line, Direction, Player], write_options(2, Play);
        write('Invalid Input'), nl
    ).

write_options(Option, Play) :-
    Option = 1 ->
    (
        nth1(2, Play, Column),
        nth1(3, Play, Direction), 
        write('|: '),
        write(Option), nl,
        write('Column (A to S): '),
        Code is (Column + 64),
        char_code(Letter, Code),
        write(Letter), nl,
        write('Direction (U (Up) or D (Down)): '),
        write(Direction), nl, nl
    );
    Option = 2 ->
    (
        nth1(2, Play, Line),
        nth1(3, Play, Direction),
        write('|: '),
        write(Option), nl,
        write('Line (1 to 19): '),
        write(Line), nl,
        write('L (Left) or R (right): '),
        write(Direction), nl, nl
    ).