:- use_module(library(lists)).

table([
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
['b',empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty]]).  

printTableHeader :-
    write('   '),
    write('A'), write('|'), write('B'), write('|'),
    write('C'), write('|'), write('D'), write('|'),
    write('E'), write('|'), write('F'), write('|'),
    write('G'), write('|'), write('H'), write('|'),
    write('I'), write('|'), write('J'), write('|'),
    write('K'), write('|'), write('L'), write('|'),
    write('M'), write('|'), write('N'), write('|'),
    write('O'), write('|'), write('P'), write('|'),
    write('Q'), write('|'), write('R'), write('|'),
    write('S'), write('|'), nl.

printFormatNumber(N) :-
    (
        N < 10, write('0'), write(N)
    );
    write(N).

printBoard(Board) :-
    printTableHeader,
    viewTab(Board, 1),
    printTableHeader.

viewTab([], 20).
viewTab([H|T], N) :-
    printFormatNumber(N),
    write('|'),
    printList(H),
    printFormatNumber(N),
    nl,
    Next is (N + 1),
    viewTab(T, Next).

printList([]).
printList([H|T]) :-
    (
        H = empty, write('.');
        H = 'b', write('b');
        H = 'w', write('w')
    ),
    write('|'),
    printList(T).

display_game(Board) :- 
    table(Board),
    printBoard(Board).

showPlayer(Player) :-
    Player = 'b', nl, write('Black Turn'), nl, nl;
    Player = 'w', nl, write('White Turn'), nl, nl.

printListOfMoves([], _).

printListOfMoves([Play | RestOfMoves], Index) :-
    nth0(0, Play, Symbol),
    printMove(Symbol, Play, Index), nl, 
    NewIndex is (Index + 1),
    printListOfMoves(RestOfMoves, NewIndex).

printMove('C', Play, Index) :-
    nth0(1, Play, Column), 
    nth0(2, Play, Direction),
    write(Index), 
    write(' - Column '), 
    write(Column), 
    write(Direction).

printMove('L', Play, Index) :-
    nth0(1, Play, Line), 
    nth0(2, Play, Direction), 
    write(Index), 
    write(' - Line '), 
    write(Line), 
    write(Direction).