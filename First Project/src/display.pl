:- use_module(library(lists)).

% Empty board. A cycle could've been used to generate it however we like to keep it this way because its easier to generate
% custom boards.
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
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty]]).  

% Prints the table's header and footer: a line containing the name of each column
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

% Prints a number in the 0D format if D < 10.
printFormatNumber(N) :-
    N < 10, !, 
    write('0'), 
    write(N).
   
printFormatNumber(N) :-
    write(N).

% Prints the board as well as its headers.
printBoard(Board) :-
    printTableHeader,
    viewTab(Board, 1),
    printTableHeader.

% Prints a list of lists (board) as well as the line numbers on each side.
viewTab([], 20) :-
    !.

viewTab([H|T], N) :-
    printFormatNumber(N),
    write('|'),
    printList(H),
    printFormatNumber(N),
    nl,
    Next is (N + 1),
    viewTab(T, Next).

% Prints a list, replacing certain characters with custom unicode ones.
printList([]) :-
    !.

printList([H|T]) :-
    printPiece(H),
    write('|'),
    printList(T).

% Prints custom characters depending on the one received.
printPiece(empty) :-
    write('.'), !.

printPiece('b') :-
    put_code(9679), !.

printPiece('w') :-
    put_code(9675).

% Prints the game's board and current player.
display_game(Board, Player) :- 
    printBoard(Board),
    showPlayer(Player).

% Prints a message telling which player is to play next.
showPlayer(Player) :-
    Player = 'b', nl, write('Black Turn'), nl, nl;
    Player = 'w', nl, write('White Turn'), nl, nl.

% Utility function to print a list of moves, only used for test purposes.
printListOfMoves([], _).

printListOfMoves([Play | RestOfMoves], Index) :-
    nth0(0, Play, Symbol),
    printMove(Symbol, Play, Index), nl, 
    NewIndex is (Index + 1),
    printListOfMoves(RestOfMoves, NewIndex).

% Utility function to print a particular move, only used for test purposes.
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