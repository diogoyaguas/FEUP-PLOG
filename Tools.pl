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
    printBoard(NewBoard).

replaceElement(1, [ _ | Remainder], NewElement, [NewElement | Remainder]).

replaceElement(Column, [ Head | Remainder], NewElement, [Head | NewLine]) :-
    Column > 1,
    Previous is Column - 1,
    replaceElement(Previous, Remainder, NewElement, NewLine).

replaceLine(1, [_ | Remainder], NewList, [NewList | Remainder]).
    
replaceLine(Line, [Head | Remainder], NewList, [Head | NewLine]) :-
    Line > 1,
    Previous is Line - 1,
    replaceLine(Previous, Remainder, NewList, NewLine).

getCleanChar(X) :-
    get_char(X),
    get_char(_).

getCleanInt(I) :-
    read(I),
    get_char(_),
    integer(I).
        
getCleanInt(I) :-
    write('Invalid Input'), nl, getCleanInt(I).
    
newLine(1) :-
    nl.
newLine(N) :-
    NewN is N - 1,
    nl,
    newLine(NewN).
