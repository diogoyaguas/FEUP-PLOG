:- include('Tools.pl').
:- include('Game.pl').
:- use_module(library(lists)).

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
    Next is N + 1,
    viewTab(T, Next).

printList([]).
printList([H|T]) :-
    write(H),
    write('|'),
    printList(T).

display_game(Board) :- 
    table(Board),
    printBoard(Board).

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

play :-
    displayMenu,
    getCleanChar(Option),
    (
        Option = '1' -> write('Started Human vs Human'), nl, createGame('pvp');
        Option = '2';
        write('Invalid Input'),
        nl,
        play
    ).

getPlayerInput(Game, PlayedGame) :-
    write('Column: '),
    get_char(Column),
    nl,
    write('Line: '),
    get_char(Line),
    nl,
    nth0(1, Game, NewCharacter),
    replacePiece(Column, Line, NewCharacter, Game, PlayedGame).

showPlayer(Player) :-
    Player = 'b' -> nl, write('Black Turn'), newLine(2);
    Player = 'w' -> nl, write('White Turn'), newLine(2).
