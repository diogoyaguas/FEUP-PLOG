get_line(1, [Line | _ ], Line).
get_line(N, [ _ | Remainder], Line) :-
    N > 1,
    Previous is N - 1,
    get_line(Previous, Remainder, Line).

get_piece_in_column(1, [Piece | _ ], Piece).
get_piece_in_column(N, [ _ | Remainder], Piece) :-
    N > 1,
    Previous is N - 1,
    get_piece_in_column(Previous, Remainder, Piece).

replace_piece(Column, Line, NewElement, Board, NewBoard) :-
    table(Board),
    get_line(Line, Board, List),
    replace_element(Column, List, NewElement, NewLine),
    replace_line(Line, Board, NewLine, NewBoard).

replace_element(1, [ _ | Remainder], NewElement, [NewElement | Remainder]).

replace_element(Column, [ Head | Remainder], NewElement, [Head | NewLine]) :-
    Column > 1,
    Previous is Column - 1,
    replace_element(Previous, Remainder, NewElement, NewLine).

replace_line(1, [_ | Remainder], NewList, [NewList | Remainder]).
    
replace_line(Line, [Head | Remainder], NewList, [Head | NewLine]) :-
    Line > 1,
    Previous is Line - 1,
    replace_line(Previous, Remainder, NewList, NewLine).

get_last_element([Head | []], Head).

get_last_element([_ | Tail], LastElement) :-
    get_last_element(Tail, LastElement).

get_clean_char(X) :-
    get_char(X),
    read_line(_),
    nl.

get_clean_int(I) :-
    read(I),
    get_char(_),
    integer(I),
    nl.
        
get_clean_int(I) :-
    write('Invalid Input'), nl, get_clean_int(I).

capitalize_char(Char, CapitalizedChar) :-
    char_code(Char, Code),
    Code >= 97, 
    Code =< 122, 
    CapitalizedCharCode is (Code - 32), 
    char_code(CapitalizedChar, CapitalizedCharCode).

capitalize_char(Char, Char).

column_dictionary(Column, Number) :-
    char_code(Column, Code),
    Code >= 65,
    Code =< 83,
    Number is (Code - 64).
      