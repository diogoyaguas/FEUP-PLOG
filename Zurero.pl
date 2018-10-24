:- include('Tools.pl').
:- include('Game.pl').

table([
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
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.],
[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.]]).  

line([.,.,b]).

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
    N < 10 -> write('0'), write(N);
    write(N).


viewTab([], 20).
viewTab([H|T], N) :-
    printFormatNumber(N),
    write('|'),
    printList(H),
    printFormatNumber(N),
    nl,
    Next is N + 1,
    viewTab(T, Next).

printList([]).
printList([H|T]) :-
    write(H),
    write('|'),
    printList(T).

display_game(Board, Player) :- 
    table(Board),
    printTableHeader,
    viewTab(Board, 1),
    printTableHeader.

displayMenu :-
    write('Zurero'),
    nl,
    write('------'),
    nl,
    write('1 - Human vs Human'),
    nl,
    write('2 - Human vs CPU'),
    nl,
    write('3 - CPU vs CPU'),
    nl.

zurero :-
    displayMenu,
    getCleanChar(Option),
    (
        Option = '1' -> write('Started Human vs Human'), createGame('pvp');
        Option = '2';
        write('Invalid Input'),
        newLine(30),
        zurero
    ).