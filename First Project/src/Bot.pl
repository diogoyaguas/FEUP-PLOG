%to be able to use the random function
:- use_module(library(random)).

selectRandomOption(X) :-
    random(1,2, X).

selectColumn([[.] | []], _, _, _).

selectColumn([[Piece | RestOfLine] | RestOfBoard], Index, Column, Find) :-
    RestOfLine = [] -> selectColumn(RestOfBoard, 1, Column, Find);
    Piece = '.' ->
    (
        checkForMatch(RestOfBoard, Index, 'b', Find),
        Column is Index;

        NexColumn is Index + 1,
        append([RestOfLine], RestOfBoard, CutBoard),
        selectColumn(CutBoard, NexColumn, Column, Find)
    );
    NexColumn is Index + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    selectColumn(CutBoard, NexColumn, Column, Find).

checkForMatch(_, _, _, 5).

checkForMatch([Line | RestOfBoard], Column, PlayerPiece, NumberOfMatches) :-
    nth1(Column, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, 
    checkFiveInARowVertical(RestOfBoard, Column, PlayerPiece, NextMatch).
