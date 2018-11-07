columnDictionary(Column, Number) :-
    Column = 'A' -> Number = 1;
    Column = 'B' -> Number = 2;
    Column = 'C' -> Number = 3;
    Column = 'D' -> Number = 4;
    Column = 'E' -> Number = 5;
    Column = 'F' -> Number = 6;
    Column = 'G' -> Number = 7;
    Column = 'H' -> Number = 8;
    Column = 'I' -> Number = 9;
    Column = 'J' -> Number = 10;
    Column = 'K' -> Number = 11;
    Column = 'L' -> Number = 12;
    Column = 'M' -> Number = 13;
    Column = 'N' -> Number = 14;
    Column = 'O' -> Number = 15;
    Column = 'P' -> Number = 16;
    Column = 'Q' -> Number = 17;
    Column = 'R' -> Number = 18;
    Column = 'S' -> Number = 19;
    write('Invalid Column').

getPiece(Line, Column , Table, Piece) :-
    table(Table),
    getLine(Line, Table, ActualLine),
    getPieceInColumn(Column, ActualLine, Piece).

getLine(1, [Line | _ ], Line).
getLine(N, [ _ | Remainder], Line) :-
    N > 1,
    Previous is N - 1,
    getLine(Previous, Remainder, Line).

getPieceInColumn(1, [Piece | _ ], Piece).
getPieceInColumn(N, [ _ | Remainder], Piece) :-
    N > 1,
    Previous is N - 1,
    getPieceInColumn(Previous, Remainder, Piece).

replacePiece(Column, Line, NewElement, Board, NewBoard) :-
    table(Board),
    getLine(Line, Board, List),
    replaceElement(Column, List, NewElement, NewLine),
    replaceLine(Line, Board, NewLine, NewBoard).

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
