valid_moves(Board, ListOfMoves, Player) :-
    get_moves(Board, [], 1, 'L', Player, HorizontalMoves), 
    transpose(Board, TransposedBoard),
    get_moves(TransposedBoard, [], 1, 'C', Player, VerticalMoves),
    append(HorizontalMoves, VerticalMoves, ListOfMoves).

get_moves([ ], Moves, _, _, _, Moves).

get_moves([Line | RestOfBoard], Moves, Index, Symbol, Player, ListOfMoves) :-
    (
        has_pieces(Line),
        (
            (
                get_last_element(Line, LastElement),
                LastElement = empty,
                (Symbol = 'L', FirstDirection = 'L'; Symbol = 'C', FirstDirection = 'D'),
                PlayOne = [Symbol, Index, FirstDirection, Player],
                append([PlayOne], Moves, NewMoves)
            ); PlayOne = []
        ),
        (
            (
                nth0(0, Line, FirstElement),
                FirstElement = empty,
                (Symbol = 'L', SecondDirection = 'R'; Symbol = 'C', SecondDirection = 'U'),
                PlayTwo = [Symbol, Index, SecondDirection, Player],
                ((PlayOne \= [], append([PlayTwo], NewMoves, NewMoves2)); append([PlayTwo], Moves, NewMoves2))
            ); PlayTwo = []
        ),
        NextIndex is (Index + 1),
        ((PlayTwo \= [], get_moves(RestOfBoard, NewMoves2, NextIndex, Symbol, Player, ListOfMoves)); 
            get_moves(RestOfBoard, NewMoves, NextIndex, Symbol, Player, ListOfMoves))
    );
    NextIndex is (Index + 1),
    get_moves(RestOfBoard, Moves, NextIndex, Symbol, Player, ListOfMoves).

has_pieces([Head | RestOfList]) :-
    Head \= [],
    (Head \= 'empty'; has_pieces(RestOfList)).
