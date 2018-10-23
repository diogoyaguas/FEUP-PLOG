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

start :-
    displayMenu.

line([.,.,b]).

viewTab([]).
viewTab([H|T]) :-
    printList(H),
    viewTab(T).

printList([]) :-
    nl.
printList([H|T]) :-
    write(H),
    printList(T).

display_game(Board, Player) :- 
    table(Board), 
    write(Player),
    nl,
    viewTab(Board),
    write(' Turn').

displayMenu :-
    write('Zurero'),
    nl,
    write('------'),
    nl,
    write('1 - Human vs Human'),
    nl,
    nl,
    processMenuInput.

processMenuInput :-
    displayMenu,
    get_char(Option),
    (
        Option = '1' -> write('Started Human vs Human');
        Option = '2'
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

