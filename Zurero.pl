table([
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,b,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.]]).  

line([.,.,b]).

black('Player 1').
black('B').
white('Player 2').
white('W').

viewTab([]).
viewTab([H|T]) :-
    printList(H),
    viewTab(T).

printList([]) :-
    nl.
printList([H|T]) :-
    write(H),
    write('|'),
    printList(T).

display_game(Board) :- table(Board), viewTab(Board).

getPiece(Line, Column , Table, Piece) :-
    table(Table),
    getLine(Line, Table, ActualLine),
    getColumn(Column, ActualLine, Piece).

getLine(1, [Line | _ ], Line).
getLine(N, [ _ | Remainder], Line) :-
    N > 1,
    Previous is N - 1,
    getLine(Previous, Remainder, Line).

getColumn(1, [Piece | _ ], Piece).
getColumn(N, [ _ | Remainder], Piece) :-
    N > 1,
    Previous is N - 1,
    getColumn(Previous, Remainder, Piece).

replacePiece(Column, List, NewElement, NewLine) :-
    replacePieceInColumn(Column, List, NewElement, NewLine).

replacePieceInColumn(1, [ _ | Remainder ], NewElement, NewLine) :-
    append(NewLine, [NewElement], NewNewLine),
    append(NewNewLine, Remainder, NewLine3),
    printList(NewLine3).

replacePieceInColumn(Column, [ Head | Remainder], NewElement, NewLine) :-
    Column > 1,
    Previous is Column - 1,
    append(NewLine, [Head], NewNewLine),
    replacePieceInColumn(Previous, Remainder, NewElement, NewNewLine).
    


