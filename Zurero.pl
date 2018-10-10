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

display_game(Board, Player) :- 
    table(Board), 
    viewTab(Board),
    write(Player),
    write(' Turn').

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

replacePiece(Column, Line, NewElement, Board, NewBoard) :-
    table(Board),
    getLine(Line, Board, List),
    replaceElement(Column, List, NewElement, NewLine),
    replaceLine(Line, Board, NewLine, NewBoard),
    viewTab(NewBoard).

replaceElement(1, [ _ | Remainder], NewElement, [NewElement | Remainder]).

replaceElement(Column, [ Head | Remainder], NewElement, [Head | NewLine]) :-
    Column > 1,
    Previous is Column - 1,
    replacePieceInColumn(Previous, Remainder, NewElement, NewLine).

replaceLine(1, [_ | Remainder], NewList, [NewList | Remainder]).
    
replaceLine(Line, [Head | Remainder], NewList, [Head | NewLine]) :-
    Line > 1,
    Previous is Line - 1,
    replacePieceInLine(Previous, Remainder, NewList, NewLine).
