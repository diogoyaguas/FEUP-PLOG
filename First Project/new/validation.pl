valid_moves(Board, ListOfMoves) :-
    verify_vertical_moves(Board, VerticalMoves), 
    ListOfMoves = VerticalMoves.

verify_vertical_moves(Board, VerticalMoves) :-
    verify_moves(Board, 'b', Moves, 'C', 'D', 1, 4, VerticalDownMovesB),
    append(VerticalDownMovesB, VerticalDownMovesW, VerticalMoves).

verify_moves([ ], _, Moves, _, _, _, _, ListOfMoves) :-
    ListOfMoves = Moves.

verify_moves([[Piece | RestOfLine] | RestOfBoard], Player, Moves, Symbol, Direction, Index, Find, ListOfMoves) :-
    RestOfLine = [], verify_moves(RestOfBoard, Player, Moves, Symbol, Direction, 1, Find, ListOfMoves);
    check_moves(Piece, RestOfBoard, Index, Player, Find, Symbol, Direction, Moves, RestOfLine, ListOfMoves);
    next_movement(Player, Index, RestOfLine, RestOfBoard, Find, Symbol, Direction, Moves, ListOfMoves).

check_moves(empty, RestOfBoard, Index, Player, Find, Symbol, Direction, Moves, RestOfLine, ListOfMoves) :-
    check_movement(RestOfBoard, Index, Player, Find),
    Play = [Symbol, Index, Direction, Player],
    append([Play], Moves, NewMoves),
    next_movement(Player, Index, RestOfLine, RestOfBoard, Find, Symbol, Direction, NewMoves, ListOfMoves).

check_moves('b', RestOfBoard, Index, Player, Find, Symbol, Direction, Moves, RestOfLine, ListOfMoves) :-
    next_movement(Player, Index, RestOfLine, RestOfBoard, Find, Symbol, Direction, Moves, ListOfMoves).

check_moves('w', RestOfBoard, Index, Player, Find, Symbol, Direction, Moves, RestOfLine, ListOfMoves) :-
    next_movement(Player, Index, RestOfLine, RestOfBoard, Find, Symbol, Direction, Moves, ListOfMoves).

next_movement(Player, Index, RestOfLine, RestOfBoard, Find, Symbol, Direction, Moves, ListOfMoves) :-
    NextIndex is Index + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    verify_moves(CutBoard, Player, Moves, Symbol, Direction, NextIndex, Find, ListOfMoves).

check_movement(_, _, _, 5).

check_movement([Line | RestOfBoard], Index, PlayerPiece, NumberOfMatches) :-
    nth1(Index, Line, Piece),
    (
        Piece = PlayerPiece,
        NextMatch is NumberOfMatches + 1,
        check_movement(RestOfBoard, Index, PlayerPiece, NextMatch)
    ).

check_play('C', Board, Play, NewBoard) :-
    Play = [Column | DirectionPlayer],
    DirectionPlayer = [Direction | PlayerInList],
    PlayerInList = [Player | _],
    check_direction(Direction, Board, Column, Player, NewBoard).

check_play('L', Board, Play, NewBoard) :-
    (
        LineNumber = 1,
        Play = [_ | DirectionPlayer], DirectionPlayer = [Direction | PlayerInList], PlayerInList = [Player | _],
        check_direction(Direction, Board, Column, Player, NewBoard, Remainder)
    );
    NextLineNumber is LineNumber - 1,
    Head = Line,
    check_line_play_direction(RestOfBoard, Play, NextLineNumber, Remainder).

check_direction('U', Board, Column, Player, NewBoard) :-
    reverse(Board, ReversedBoard),
    play_column(ReversedBoard, Column, Player, NewReversedBoard),
    reverse(NewReversedBoard, NewBoard).

check_direction('u', Board, Column, Player, NewBoard) :-
    reverse(Board, ReversedBoard),
    play_column(ReversedBoard, Column, Player, NewReversedBoard),
    reverse(NewReversedBoard, NewBoard).

check_direction('D', Board, Column, Player, NewBoard) :-
    play_column(Board, Column, Player, NewBoard).

check_direction('d', Board, Column, Player, NewBoard) :-
    play_column(Board, Column, Player, NewBoard).

check_direction('L', Board, Column, Player, NewBoard, Remainder) :-
    reverse(Line, ReversedLine), 
    play_line(ReversedLine, Player, NewReversedLine),
    reverse(NewReversedLine, Head), 
    Remainder = RestOfBoard.

check_direction('l', Board, Column, Player, NewBoard, Remainder) :-
    reverse(Line, ReversedLine), 
    play_line(ReversedLine, Player, NewReversedLine),
    reverse(NewReversedLine, Head), 
    Remainder = RestOfBoard.

check_direction('R', Board, Column, Player, NewBoard, Remainder) :-
    play_line(Line, Player, Head), 
    Remainder = RestOfBoard.

check_direction('r', Board, Column, Player, NewBoard, Remainder) :-
    play_line(Line, Player, Head), 
    Remainder = RestOfBoard.
