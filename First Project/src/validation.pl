valid_moves(Board, ListOfMoves, Player) :-
    get_moves(Board, [], 1, 'L', Player, HorizontalMoves), 
    transpose(Board, TransposedBoard),
    get_moves(TransposedBoard, [], 1, 'C', Player, VerticalMoves),
    append(HorizontalMoves, VerticalMoves, ListOfMoves).

get_moves([ ], Moves, _, _, _, Moves).

get_moves([Line | RestOfBoard], Moves, Index, Symbol, Player, ListOfMoves) :-
        has_pieces(Line), 
        check_last_element_and_add_play(Line, Moves, Index, Symbol, Player, PlayOne, NewMoves),
        check_first_element_and_add_play(Line, NewMoves, Index, Symbol, Player, PlayOne, PlayTwo, NewMoves2),
        NextIndex is (Index + 1),
        (
            (PlayTwo \= [], get_moves(RestOfBoard, NewMoves2, NextIndex, Symbol, Player, ListOfMoves));

            get_moves(RestOfBoard, NewMoves, NextIndex, Symbol, Player, ListOfMoves)
        ).
    
get_moves([_ | RestOfBoard], Moves, Index, Symbol, Player, ListOfMoves) :-
    NextIndex is (Index + 1),
    get_moves(RestOfBoard, Moves, NextIndex, Symbol, Player, ListOfMoves).

check_first_element_and_add_play(Line, Moves, Index, Symbol, Player, FirstPlay, NewPlay, NewMoves) :-
    check_first_element(Line),
    (Symbol = 'L', SecondDirection = 'R'; Symbol = 'C', SecondDirection = 'U'),
    NewPlay = [Symbol, Index, SecondDirection, Player],
    add_play(FirstPlay, NewPlay, Moves, NewMoves).

check_first_element_and_add_play(_, _, _, _, _, _, NewPlay, _) :-
    NewPlay = [].

add_play(FirstPlay, NewPlay, OldMoves, NewMoves) :-
    FirstPlay \= [], !,
    append([NewPlay], OldMoves, NewMoves).

add_play(_, NewPlay, OldMoves, NewMoves) :-
    append([NewPlay], OldMoves, NewMoves).

check_first_element([FirstElement | _]) :-
    FirstElement = empty.

check_first_element([_ | [SecondElement | _]]) :-
    SecondElement = empty.

check_last_element_and_add_play(Line, Moves, Index, Symbol, Player, NewPlay, NewMoves) :-
    check_last_element(Line), !,
    (Symbol = 'L', FirstDirection = 'L'; Symbol = 'C', FirstDirection = 'D'),
    NewPlay = [Symbol, Index, FirstDirection, Player],
    append([NewPlay], Moves, NewMoves).

check_last_element_and_add_play(_, _, _, _, _, NewPlay, _) :-
    NewPlay = [].

check_last_element(Line) :-
    get_last_element(Line, LastElement),
    LastElement = empty, !.

check_last_element(Line) :-
    get_second_to_last_element(Line, SecondToLastElement),
    SecondToLastElement = empty.

has_pieces([Head | RestOfList]) :-
    Head \= [],
    (Head \= 'empty'; has_pieces(RestOfList)).
