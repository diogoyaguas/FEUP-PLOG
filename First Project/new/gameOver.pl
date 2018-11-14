game_over([[] | []], _) :-
    write('End Of Board'), nl,
    false.

game_over([[Piece | RestOfLine] | RestOfBoard], Winner, PieceIndex) :-
    RestOfLine = [], game_over(RestOfBoard, Winner, 0);
    Piece \= empty,
    (
        check_game_over_horizontal(RestOfLine, Piece, 1), Winner = Piece;
        check_game_over_vertical(RestOfBoard, PieceIndex, Piece, 1), Winner = Piece;
        check_game_over_diagonal_left(RestOfBoard, PieceIndex, Piece, 1), Winner = Piece;
        check_game_over_diagonal_right(RestOfBoard, PieceIndex, Piece, 1), Winner = Piece;

        NexIndex = PieceIndex + 1,
        append([RestOfLine], RestOfBoard, CutBoard),
        game_over(CutBoard, Winner, NextIndex)
    );
    NexIndex = PieceIndex + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    game_over(CutBoard, Winner, NextIndex).

check_game_over_diagonal_left(_, _, _, 5).

check_game_over_diagonal_left([Line | RestOfBoard], Column, PlayerPiece, NumberOfMatches) :-
    nth0(Column, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, PreviousColumn is Column - 1, 
    check_game_over_diagonal_left(RestOfBoard, PreviousColumn, PlayerPiece, NextMatch).

check_game_over_diagonal_right(_, _, _, 5).

check_game_over_diagonal_right([Line | RestOfBoard], Column, PlayerPiece, NumberOfMatches) :-
    nth0(Column, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, PreviousColumn is Column + 1, 
    check_game_over_diagonal_right(RestOfBoard, PreviousColumn, PlayerPiece, NextMatch).

check_game_over_vertical(_, _, _, 5).

check_game_over_vertical([Line | RestOfBoard], Index, PlayerPiece, NumberOfMatches) :-
    nth0(Index, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, 
    check_game_over_vertical(RestOfBoard, Index, PlayerPiece, NextMatch).

check_game_over_horizontal(_, _, 5).

check_game_over_horizontal([Piece | RestOfLine], PlayerPiece, NumberOfMatches) :-
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, check_game_over_horizontal(RestOfLine, PlayerPiece, NextMatch).