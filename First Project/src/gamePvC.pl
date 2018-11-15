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
        Player = 'b', choose_move(Board, Player, Move, Difficulty, ListOfMoves);
        Player = 'w', get_play_input(Player, Move)
    ),
    (
        move(Move, ListOfMoves, Board, NewBoard);
        !, printBoard(Board), nl, play_turn_PvP(Game, Player, PlayedGame)
    ),
    update_game_table(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).

choose_move(Board, Player, Move, 2, ListOfMoves) :-
    value(Board, Player, Value),
    (
        Value < 0, switch_players(Player, Opponent), choose_opponent(Board, Opponent, Move, ListOfMoves)    
    );
    (
        Value >= 0, choose_player(Board, Player, Move, ListOfMoves)    
    ).

choose_move(_, _, Move, 1, ListOfMoves) :-
    random_move(ListOfMoves, Index),
    nth1(Index, ListOfMoves, Move),
    nth1(1, Move, Symbol),
    write_move(Symbol, Move).

value(Board, Player, Value) :-
    switch_players(Player, Opponent),
    count_rows(Board, Player, 0, [], NumberPlayer),
    count_rows(Board, Opponent, 0, [], NumberOpponent),
    Value is NumberPlayer - NumberOpponent.

count_rows([[] | []], _, _, Rows, NumberPlayer) :-
    max_member(Number, Rows),
    NumberPlayer is Number.

count_rows([[Piece | RestOfLine] | RestOfBoard], Player, Index, Rows, NumberPlayer) :- 
    RestOfLine = [], count_rows(RestOfBoard, Player, 0, Rows, NumberPlayer);
    Piece = Player,
    (
        count_horizontal(RestOfLine, Piece, 1, CounterHorizontal), append([CounterHorizontal], Rows, Rows1),
        count_vertical(RestOfBoard, Piece, Index, 1, CounterVertical), append([CounterVertical], Rows1, Rows2),
        count_diagonal_right(RestOfBoard, Piece, Index, 1, CounterDiagonalRight), append([CounterDiagonalRight], Rows2, Rows3),
        count_diagonal_left(RestOfBoard, Piece, Index, 1, CounterDiagonalLeft), append([CounterDiagonalLeft], Rows3, FinalRow),

        NextIndex is Index + 1,
        append([RestOfLine], RestOfBoard, CutBoard),
        count_rows(CutBoard, Player, NextIndex, FinalRow, NumberPlayer)
    );
    NextIndex is Index + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    count_rows(CutBoard, Player, NextIndex, Rows, NumberPlayer).

count_horizontal([Piece | RestOfLine], PlayerPiece, Counter, CounterHorizontal) :-
    (
        Piece = PlayerPiece, 
        UpdatedCounter is Counter + 1, 
        count_horizontal(RestOfLine, PlayerPiece, UpdatedCounter, CounterHorizontal)
    );
    CounterHorizontal is Counter.

count_vertical([Line | RestOfBoard], PlayerPiece, Index, Counter, CounterVertical) :-
    nth0(Index, Line, Piece),
    (
        Piece = PlayerPiece, 
        UpdatedCounter is Counter + 1, 
        count_vertical(RestOfBoard, PlayerPiece, Index, UpdatedCounter, CounterVertical)
    );
    CounterVertical is Counter.

count_diagonal_right([Line | RestOfBoard], PlayerPiece, Index, Counter, CounterDiagonalRight) :-
    PreviousIndex is Index + 1,
    nth0(PreviousIndex, Line, Piece),
    (
        Piece = PlayerPiece,
        UpdatedCounter is Counter + 1,
        count_diagonal_right(RestOfBoard, PlayerPiece, PreviousIndex, UpdatedCounter, CounterDiagonalRight)
    );
    CounterDiagonalRight is Counter.

count_diagonal_left([Line | RestOfBoard], PlayerPiece, Index, Counter, CounterDiagonalLeft) :-
    PreviousIndex is Index - 1,
    nth0(PreviousIndex, Line, Piece),
    (
        Piece = PlayerPiece,
        UpdatedCounter is Counter + 1,
        count_diagonal_left(RestOfBoard, PlayerPiece, PreviousIndex, UpdatedCounter, CounterDiagonalLeft)
    );
    CounterDiagonalLeft is Counter.

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
