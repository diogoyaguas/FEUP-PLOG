selectMovement([[.] | []], _, _, _).

selectMovement([[Piece | RestOfLine] | RestOfBoard], Index, Movement, Find) :-
    RestOfLine = [] -> selectMovement(RestOfBoard, 1, Movement, Find);
    
    Piece = '.' ->
    (
        checkMovement(RestOfBoard, Index, 'b', Find), Movement is Index;
        diagonalMovement(RestOfBoard, Index, Movement, Find);
        nextMovement(Index, RestOfLine, RestOfBoard, Movement, Find)
    );
    nextMovement(Index, RestOfLine, RestOfBoard, Movement, Find).

nextMovement(Index, RestOfLine, RestOfBoard, Movement, Find) :-
    NextMovement is Index + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    selectMovement(CutBoard, NextMovement, Movement, Find).

checkMovement(_, _, _, 5).

checkMovement([Line | RestOfBoard], Movement, PlayerPiece, NumberOfMatches) :-
    nth1(Movement, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, 
    checkFiveInARowVertical(RestOfBoard, Movement, PlayerPiece, NextMatch).

diagonalMovement(RestOfBoard, Index, Movement, Find) :-

        (
            nth1(1, RestOfBoard, NextLine), nth1(Index, NextLine, NextPiece),
            NextPiece \= '.' ->  checkMovementDiagonalRight(RestOfBoard, Index, 'b', Find), write('oi'), nl, Movement is Index
        ).

checkMovementDiagonalRight(_, _, _, 5).

checkMovementDiagonalRight([Line | RestOfBoard], Column, PlayerPiece, NumberOfMatches) :-
    nth0(Column, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, PreviousColumn is Column + 1, 
    checkFiveInARowDiagonalRight(RestOfBoard, PreviousColumn, PlayerPiece, NextMatch).
