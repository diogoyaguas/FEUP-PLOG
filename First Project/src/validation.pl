valid_moves(Board, ListOfMoves, Player) :-
    get_moves(Board, [], 1, 'L', Player, HorizontalMoves), 
    transpose(Board, TransposedBoard),
    get_moves(TransposedBoard, [], 1, 'C', Player, VerticalMoves),
    append(HorizontalMoves, VerticalMoves, ListOfMoves).

get_moves([ ], Moves, _, _, _, Moves).

get_moves([Line | RestOfBoard], Moves, Index, Symbol, Player, ListOfMoves) :-
        has_pieces(Line), 
        check_last_element_and_add_play(Line, Moves, Index, Symbol, Player, NewMoves),
        check_first_element_and_add_play(Line, NewMoves, Index, Symbol, Player, NewMoves2),
        NextIndex is (Index + 1),
        get_moves(RestOfBoard, NewMoves2, NextIndex, Symbol, Player, ListOfMoves).
    
get_moves([_ | RestOfBoard], Moves, Index, Symbol, Player, ListOfMoves) :-
    NextIndex is (Index + 1),
    get_moves(RestOfBoard, Moves, NextIndex, Symbol, Player, ListOfMoves).

check_first_element_and_add_play(Line, Moves, Index, Symbol, Player, NewMoves) :-
    check_first_element(Line),
    (Symbol = 'L', SecondDirection = 'R'; Symbol = 'C', SecondDirection = 'D'),
    NewPlay = [Symbol, Index, SecondDirection, Player],
    append([NewPlay], Moves, NewMoves).

check_first_element_and_add_play(_, Moves, _, _, _, NewMoves) :-
    NewMoves = Moves.

check_first_element([FirstElement | _]) :-
    FirstElement = empty, !.

check_first_element([_ | [SecondElement | _]]) :-
   SecondElement = empty.

check_last_element_and_add_play(Line, Moves, Index, Symbol, Player, NewMoves) :-
    check_last_element(Line), !,
    (Symbol = 'L', FirstDirection = 'L'; Symbol = 'C', FirstDirection = 'U'),
    NewPlay = [Symbol, Index, FirstDirection, Player],
    append([NewPlay], Moves, NewMoves).

check_last_element_and_add_play(_, Moves, _, _, _, NewMoves) :-
    NewMoves = Moves.

check_last_element(Line) :-
    get_last_element(Line, LastElement),
    LastElement = empty, !.

check_last_element(Line) :-
    get_second_to_last_element(Line, SecondToLastElement),
    SecondToLastElement = empty.

has_pieces([Head | RestOfList]) :-
    Head \= [],
    (Head \= 'empty'; has_pieces(RestOfList)).
