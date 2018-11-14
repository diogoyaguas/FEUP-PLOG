check_line_play_direction([Line | RestOfBoard], Play, LineNumber, [Head | Remainder]) :-
    (
        LineNumber = 1,
        Play = [_ | DirectionPlayer], DirectionPlayer = [Direction | PlayerInList], PlayerInList = [Player | _],
        (
            Direction = 'R' -> play_line(Line, Player, Head), Remainder = RestOfBoard;
            Direction = 'r' -> play_line(Line, Player, Head), Remainder = RestOfBoard;
            Direction = 'L' -> reverse(Line, ReversedLine), play_line(ReversedLine, Player, NewReversedLine),
            reverse(NewReversedLine, Head), Remainder = RestOfBoard;
            Direction = 'l' -> reverse(Line, ReversedLine), play_line(ReversedLine, Player, NewReversedLine),
            reverse(NewReversedLine, Head), Remainder = RestOfBoard
        )
    );
    NextLineNumber is LineNumber - 1,
    Head = Line,
    check_line_play_direction(RestOfBoard, Play, NextLineNumber, Remainder).

check_column_play_direction(Board, Play, NewBoard) :-
    Play = [Column | DirectionPlayer],
    DirectionPlayer = [Direction | PlayerInList],
    PlayerInList = [Player | _],
    (
        Direction = 'U' -> reverse(Board, ReversedBoard),
        play_column(ReversedBoard, Column, Player, NewReversedBoard), reverse(NewReversedBoard, NewBoard);
        Direction = 'u' -> reverse(Board, ReversedBoard),
        play_column(ReversedBoard, Column, Player, NewReversedBoard), reverse(NewReversedBoard, NewBoard);
        Direction = 'D' -> play_column(Board, Column, Player, NewBoard);
        Direction = 'd' -> play_column(Board, Column, Player, NewBoard)
    ).

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
