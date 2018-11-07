%to be able to use the random function
:- use_module(library(random)).

selectRandomOption(X) :-
    random(1,2, X).

selectColumnAndDirection(Column, Direction, Board) :-
    selectRandomOption(Option),
    N is 19,
    (
        Option = '1' -> Direction is "D", SelectColumn(Column, Direction, Board, N);
        Option = '2' -> Direction is "U", SelectColumn(Column, Direction, Board, N);
    ).

SelectColumn(Column, Direction, [Line | RestOfBoard], N) :-
    nth1(1, RestOfBoard, NextLine),
    Column > 1,
    Previous is Column - 1,
    getPieceInColumn(Column, NextLine, Piece),
    (
        Piece \= 'b' -> getPieceInColumn(Column, NextLine, Piece)
    ).
