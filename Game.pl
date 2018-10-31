createGame(Mode) :-
    table(Table),
    Game = [Table, b, Mode],
    startGame(Game).

startGame(Game) :-
    nth0(0, Game, Table),
    replacePiece(10, 10, 'b', Table, NewTable),
    updateGameTable(Game, NewTable, StartedGame),
    updateGame(StartedGame).

updateGame(Game) :-
    playTurn(Game, PlayedGame).
    % Check for winning condition

updateGameTable(Game, NewTable, StartedGame) :-
    replaceElement(1, Game, NewTable, StartedGame).

playTurn(Game, PlayedGame) :-
    nth0(2, Game, Mode),
    (
        Mode = 'pvp' -> playTurnPvP(Game, PlayedGame)
    ).

playTurnPvP(Game, PlayedGame) :-
    nth0(1, Game, Player),
    getPlayInput(Play),
    printList(Play).

getPlayInput(Play) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    getCleanChar(Option),
    (
        Option = '1' -> getPlayColumn(Column, Direction), Play = ['C', Column, Direction];
        Option = '2' -> getPlayLine(Line, Direction), Play = ['L', Line, Direction]
    ).

getPlayInput(Play) :-
    write('Invalid Input'), nl, getPlayInput(Play).

getPlayLine(Line, Direction) :-
    write('Line (1 to 19): '),
    getCleanInt(Line),
    Line > 1, Line < 20,
    getPlayLineDirection(Direction).

getPlayLineDirection(Direction) :-
    write('L (Left) or R (right): '),
    getCleanChar(Direction),
    (
        Direction = 'L'; Direction = 'l';
        Direction = 'R'; Direction = 'r'
    ), nl.

getPlayLineDirection(Direction) :-
    write('Invalid Input'), nl, getPlayLineDirection(Direction).
    
getPlayLine(Line, Direction) :-
    write('Invalid Input'), nl, getPlayLine(Line, Direction).
    
getPlayColumn(Column, Direction):-
    write('Column (A to S): '),
    getCleanChar(Column),
    (
        Column = 'A'; Column = 'a';
        Column = 'B'; Column = 'b';
        Column = 'C'; Column = 'c';
        Column = 'D'; Column = 'd';
        Column = 'E'; Column = 'e';
        Column = 'F'; Column = 'f';
        Column = 'G'; Column = 'g';
        Column = 'H'; Column = 'h';
        Column = 'I'; Column = 'i';
        Column = 'J'; Column = 'j';
        Column = 'K'; Column = 'k';
        Column = 'L'; Column = 'l';
        Column = 'M'; Column = 'm';
        Column = 'N'; Column = 'n';
        Column = 'O'; Column = 'o';
        Column = 'P'; Column = 'p';
        Column = 'Q'; Column = 'q';
        Column = 'R'; Column = 'r';
        Column = 'S'; Column = 's'
    ), nl,
    getPlayColumnDirection(Direction).

getPlayColumn(Column, Direction) :-
    write('Invalid Option'), nl, getPlayColumn(Column, Direction).


getPlayColumnDirection(Direction) :-
    write('Direction (U (Up) or D (Down)): '),
    getCleanChar(Direction),
    (
        Direction = 'U'; Direction = 'u';
        Direction = 'D'; Direction = 'd'
    ), nl.

getPlayColumnDirection(Direction) :-
    write('Invalid Option'), nl, getPlayColumnDirection(Direction).

