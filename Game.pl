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

updateGameTable(Game, NewTable, StartedGame) :-
    replaceElement(1, Game, NewTable, StartedGame).

playTurn(Game, PlayedGame) :-
    nth0(2, Game, Mode),
    (
        Mode = 'pvp' -> playTurnPvP(Game, PlayedGame)
    ).

playTurnPvP(Game, PlayedGame) :-
    nth0(1, Game, Player),
    getPlayInput(Game, PlayedGame),
    (
        Player = 'w' -> (display_game(PlayedGame, 'Player 2 Turn'), replaceElement(2, Game, b, PlayedGame)); 
        Player = 'b' -> (dispplay_game(PlayedGame, 'Player 1 Turn'), replaceElement(2, Game, w, PlayedGame))
    ).

getPlayInput(Play) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    getCleanChar(Option),
    (
        Option = '1' -> getPlayColumn(Column, Direction), Play = ['C', Column, Direction];
        Option = '2' -> getPlayLine(Line, Direction), Play = ['L', Line, Direction];
    ).

getPlayLine(Line, Direction) :-
    write('Line (1 to 19): '),
    getCleanInt(Line),
    (
        Line > 1, Line < 19;
        write('Invalid Input'), nl, getPlayLine(Line, Direction)
    ).
    
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
        Column = 'S'; Column = 's';
        write('Invalid Option'), nl, getColumnPlay(Column, Direction) % Might not work
    ), nl,
    getPlayColumnDirection(Direction).

getPlayColumnDirection(Direction) :-
    write('Direction (Up or Down): '),
    read(Direction),
    (
        Direction = 'Up'; Direction = 'up';
        Direction = 'Down'; Direction = 'down';
        write('Invalid Option'), nl, getPlayColumnDirection(Direction) % Might not work
    ), nl.

