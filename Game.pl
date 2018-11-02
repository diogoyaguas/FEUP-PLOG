createGame(Mode) :-
    table(Table),
    Game = [Table, Mode],
    startGame(Game).

startGame(Game) :-
    nth0(0, Game, Table),
    replacePiece(10, 10, 'b', Table, NewTable),
    updateGameTable(Game, NewTable, StartedGame),
    nth0(1, StartedGame, Mode),
    (
        Mode = 'pvp' -> printBoard(NewTable), updateGamePvP(StartedGame, 'w')
    ).

updateGamePvP(Game, Player) :-
    playTurnPvP(Game, Player, PlayedGame),
    % Check for winning condition
    switchPlayers(Player, NextPlayer),
    playTurnPvP(PlayedGame, NextPlayer, EndTurnGame),
    % Check for winning condition
    switchPlayers(NextPlayer, OriginalPlayer),
    updateGamePvP(EndTurnGame, OriginalPlayer).

switchPlayers(CurrentPlayer, NextPlayer) :-
    CurrentPlayer = 'w' -> NextPlayer = 'b';
    NextPlayer = 'w'.
   
updateGameTable(Game, NewTable, StartedGame) :-
    replaceElement(1, Game, NewTable, StartedGame).

playTurnPvP(Game, Player, PlayedGame) :-
    getPlayInput(Player, Play),
    nth0(0, Game, Board),
    (
        checkPlay(Board, Play, NewBoard);
        write('Invalid Play'), nl, playTurnPvP(Game, Player, PlayedGame)
    ),
    updateGameTable(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).

checkPlay(Board, Play, NewBoard) :-
    nth0(0, Play, Symbol),
    (
        Symbol = 'C' -> checkColumnPlay(Board, Play, NewBoard);
        Symbol = 'L' -> checkLinePlay(Board, Play);
        write('Error in Play Symbol')
    ).
    
checkColumnPlay(Board, Play, NewBoard) :-
    nth0(2, Play, Direction),
    (
        Direction = 'U' -> reverse(Board, ReversedBoard),
        checkColumnPlayDirection(ReversedBoard, Play, NewReversedBoard), reverse(NewReversedBoard, NewBoard);
        Direction = 'D' -> checkColumnPlayDirection(Board, Play, NewBoard)
    ).

checkColumnPlayDirection([Line | RestOfBoard], Play, [Head | Remainder]) :-
    nth0(1, Play, Column),
    nth1(1, RestOfBoard, NextLine),
    getPieceInColumn(Column, NextLine, Piece),
    (
        Piece \= '.',
        (
            nth0(3, Play, Player),
            RestOfBoard \= [] -> nth1(2, RestOfBoard, SecondLine), 
                getPieceInColumn(Column, SecondLine, NextPiece),
                (
                    NextPiece \= '.' -> replaceElement(Column, Line, Player, Head),
                    Remainder = RestOfBoard;

                    replaceElement(Column, SecondLine, Piece, NewBottomLine),
                    replaceElement(2, RestOfBoard, NewBottomLine, NewRestOfBoard),
                    replaceElement(Column, NextLine, Player, NewLine),
                    replaceElement(1, NewRestOfBoard, NewLine, Remainder),
                    Head = Line
                )
        ) 
    );
    Head = Line, checkColumnPlayDirection(RestOfBoard, Play, Remainder).

getPlayInput(Player, Play) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    getCleanChar(Option),
    (
        Option = '1' -> getPlayColumn(Column, Direction), Play = ['C', Column, Direction, Player];
        Option = '2' -> getPlayLine(Line, Direction), Play = ['L', Line, Direction, Player];
        write('Invalid Input'), nl, getPlayInput(Play)
    ).

getPlayLine(Line, Direction) :-
    write('Line (1 to 19): '),
    getCleanInt(Line),
    Line > 1, Line < 20,
    getPlayLineDirection(Direction).

getPlayLine(Line, Direction) :-
    write('Invalid Input'), nl, getPlayLine(Line, Direction).

getPlayLineDirection(Direction) :-
    write('L (Left) or R (right): '),
    getCleanChar(Direction),
    (
        Direction = 'L';
        Direction = 'R'
    ), nl.

getPlayLineDirection(Direction) :-
    write('Invalid Input'), nl, getPlayLineDirection(Direction). 
        
getPlayColumn(Column, Direction):-
    write('Column (A to S): '),
    getCleanChar(ColumnChar),
    (
        ColumnChar = 'A';
        ColumnChar = 'B'; 
        ColumnChar = 'C'; 
        ColumnChar = 'D'; 
        ColumnChar = 'E'; 
        ColumnChar = 'F'; 
        ColumnChar = 'G';
        ColumnChar = 'H'; 
        ColumnChar = 'I'; 
        ColumnChar = 'J'; 
        ColumnChar = 'K';
        ColumnChar = 'L'; 
        ColumnChar = 'M'; 
        ColumnChar = 'N'; 
        ColumnChar = 'O'; 
        ColumnChar = 'P'; 
        ColumnChar = 'Q'; 
        ColumnChar = 'R'; 
        ColumnChar = 'S' 
    ), nl,
    columnDictionary(ColumnChar, Column),
    getPlayColumnDirection(Direction).

getPlayColumn(Column, Direction) :-
    write('Invalid Option'), nl, getPlayColumn(Column, Direction).  

getPlayColumnDirection(Direction) :-
    write('Direction (U (Up) or D (Down)): '),
    getCleanChar(Direction),
    (
        Direction = 'U';
        Direction = 'D'
    ), nl.

getPlayColumnDirection(Direction) :-
    write('Invalid Option'), nl, getPlayColumnDirection(Direction).

checkForPieceBelow(Column, [Line | _], Piece) :-
    getPieceInColumn(Column, Line, Piece).

