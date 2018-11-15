:- use_module(library(random)).
:- use_module(library(system)).

startPvC(Game) :-
    nth0(0, Game, Table),
    replace_piece(10, 10, 'b', Table, NewTable),
    update_game_table(Game, NewTable, StartedGame),
    printBoard(NewTable), update_game_PvC(StartedGame, 'w').

update_game_PvC(Game, Player) :-
    play_turn_PvC(Game, Player, PlayedGame),
    nth0(0, PlayedGame, Board),
    (
        game_over(Board, Winner, 0), victory(Winner); 
        switch_players(Player, NextPlayer), update_game_PvC(PlayedGame, NextPlayer)
    ).
    
play_turn_PvC(Game, Player, PlayedGame) :-
    showPlayer(Player),
    nth0(0, Game, Board),
    nth0(1, Game, Difficulty),
    valid_moves(Board, ListOfMoves, Player),
    (
        Player = 'b', get_computer_input(Player, Move, Difficulty, ListOfMoves);
        Player = 'w', get_play_input(Player, Move)
    ),
    (
        move(Move, ListOfMoves, Board, NewBoard);
        !, printBoard(Board), nl, play_turn_PvP(Game, Player, PlayedGame)
    ),
    update_game_table(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).

get_computer_input(Player, Move, 1, ListOfMoves) :-
    random_move(ListOfMoves, Index),
    nth1(Index, ListOfMoves, Move),
    nth1(1, Move, Symbol),
    write_move(Symbol, Move).

get_computer_input(Player, Move, 2, ListOfMoves).


random_move(ListOfMoves, Index) :-
    length(ListOfMoves, L),
    random(1, L, Index).

write_move(Symbol, Move) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    write('|: '),
    random(2, 5, Time),
    sleep(Time),
    (
        Symbol = 'C',
        nth1(2, Move, Index),
        nth1(3, Move, Direction), 
        write(1), nl,
        write('Column (A to S): '),
        Code is (Index + 64),
        char_code(Column, Code),
        write(Column), nl,
        write('Direction (U (Up) or D (Down)): '),
        write(Direction), nl, nl
    );
    (
        Symbol = 'L',
        nth1(2, Move, Line),
        nth1(3, Move, Direction),
        write(2), nl,
        write('Line (1 to 19): '),
        write(Line), nl,
        write('L (Left) or R (right): '),
        write(Direction), nl, nl
    ).
