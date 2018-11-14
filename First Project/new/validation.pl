valid_moves(Board, ListOfMoves) :-
    verify_moves(Board, [], 1, 'L', HorizontalMoves), 
    transpose(Board, TransposedBoard),
    verify_moves(TransposedBoard, [], 1, 'C', VerticalMoves),
    append(HorizontalMoves, VerticalMoves, ListOfMoves).

verify_moves([ ], Moves, _, _, ListOfMoves) :-
    ListOfMoves = Moves.

verify_moves([Line | RestOfBoard], Moves, Index, Symbol, ListOfMoves) :-
    (
        (member('w', Line), Player = 'w'; member('b', Line), Player = 'b'),
        (
            (
                get_last_element(Line, LastElement),
                LastElement = empty,
                (Symbol = 'L', FirstDirection = 'L'; Symbol = 'C', FirstDirection = 'D'),
                PlayOne = [Symbol, Index, FirstDirection, Player]
            ); PlayOne = []
        ),
        (
            (
                nth0(0, Line, FirstElement),
                FirstElement = empty,
                (Symbol = 'L', SecondDirection = 'R'; Symbol = 'C', SecondDirection = 'U'),
                PlayTwo = [Symbol, Index, SecondDirection, Player]
            ); PlayTwo = []
        ),
        append([PlayOne], Moves, NewMoves),
        append([PlayTwo], NewMoves, NewNewMoves),
        NextIndex is (Index + 1),
        verify_moves(RestOfBoard, NewNewMoves, NextIndex, Symbol, ListOfMoves)
    );
    NextIndex is (Index + 1),
    verify_moves(RestOfBoard, Moves, NextIndex, Symbol, ListOfMoves).

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
