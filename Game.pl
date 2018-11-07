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
        Mode = 'pvp' -> printBoard(NewTable), updateGamePvP(StartedGame, 'w');
        Mode = 'pvc' -> printBoard(NewTable), updateGamePvC(StartedGame, 'w');
        Mode = 'cvc' -> printBoard(NewTable), updateGamePvP(StartedGame, 'w')
    ).

updateGamePvP(Game, Player) :-
    playTurnPvP(Game, Player, PlayedGame),
    nth0(0, PlayedGame, Board),
    (fiveInARow(Board, 0), write('Victory'); switchPlayers(Player, NextPlayer), updateGamePvC(PlayedGame, NextPlayer)).

updateGamePvC(Game, Player) :-
    playTurnPvC(Game, Player, PlayedGame),
    nth0(0, PlayedGame, Board),
    (fiveInARow(Board, 0), write('Victory'); switchPlayers(Player, NextPlayer), updateGamePvC(PlayedGame, NextPlayer)).

updateGameCvC(Game, Player) :-
    playTurnCvC(Game, Player, PlayedGame),
    nth0(0, PlayedGame, Board),
    (fiveInARow(Board, 0), write('Victory'); switchPlayers(Player, NextPlayer), updateGameCvC(PlayedGame, NextPlayer)).
    
switchPlayers(CurrentPlayer, NextPlayer) :-
    CurrentPlayer = 'w' -> NextPlayer = 'b';
    NextPlayer = 'w'.
   
updateGameTable(Game, NewTable, StartedGame) :-
    replaceElement(1, Game, NewTable, StartedGame).

playTurnPvP(Game, Player, PlayedGame) :-
    showPlayer(Player),
    getPlayInput(Player, Play),
    nth0(0, Game, Board),
    (
        play(Board, Play, NewBoard);
        write('Invalid Play'), nl, playTurnPvP(Game, Player, PlayedGame)
    ),
    updateGameTable(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).

playTurnPvC(Game, Player, PlayedGame) :-
    showPlayer(Player),
    nth0(0, Game, Board),
    (
        Player = 'b' -> getComputerInput(Player, Play, Board);
        Player = 'w' -> getPlayInput(Player, Play)
    ),
    (
        play(Board, Play, NewBoard);
        write('Invalid Play'), nl, playTurnPvC(Game, Player, PlayedGame)
    ),
    updateGameTable(Game, NewBoard, PlayedGame),
    printBoard(NewBoard).

play(Board, Play, NewBoard) :-
    Play = [Symbol | RestOfPlay],
    RestOfPlay = [LineNumber | _],
    (
        Symbol = 'C' -> checkColumnPlayDirection(Board, RestOfPlay, NewBoard);
        Symbol = 'L' -> checkLinePlayDirection(Board, RestOfPlay, LineNumber, NewBoard);
        write('Error in Play Symbol')
    ).

checkLinePlayDirection([Line | RestOfBoard], Play, LineNumber, [Head | Remainder]) :-
    (
        LineNumber = 1,
        Play = [_ | DirectionPlayer], DirectionPlayer = [Direction | PlayerInList], PlayerInList = [Player | _],
        (
            Direction = 'R' -> playLine(Line, Player, Head), Remainder = RestOfBoard;
            Direction = 'r' -> playLine(Line, Player, Head), Remainder = RestOfBoard;
            Direction = 'L' -> reverse(Line, ReversedLine), playLine(ReversedLine, Player, NewReversedLine),
            reverse(NewReversedLine, Head), Remainder = RestOfBoard;
            Direction = 'l' -> reverse(Line, ReversedLine), playLine(ReversedLine, Player, NewReversedLine),
            reverse(NewReversedLine, Head), Remainder = RestOfBoard
        )
    );
    NextLineNumber is LineNumber - 1,
    Head = Line,
    checkLinePlayDirection(RestOfBoard, Play, NextLineNumber, Remainder).

playLine([Head | RestOfLine], Player, [NewHead | Remainder]) :- 
    nth1(1, RestOfLine, NextPiece),
    (
        NextPiece \= '.', Head = '.',
        (
            length(RestOfLine, L), L >= 2 ->
            (
                nth1(2, RestOfLine, SecondPiece),
                (
                    SecondPiece \= '.' -> NewHead = Player, Remainder = RestOfLine;

                    replaceElement(2, RestOfLine, NextPiece, NewRestOfLine),
                    replaceElement(1, NewRestOfLine, Player, Remainder),
                    NewHead = Head
                )
            );
            NewHead = Player, Remainder = RestOfLine
        )
    );
    NewHead = Head, playLine(RestOfLine, Player, Remainder).

checkColumnPlayDirection(Board, Play, NewBoard) :-
    Play = [Column | DirectionPlayer],
    DirectionPlayer = [Direction | PlayerInList],
    PlayerInList = [Player | _],
    (
        Direction = 'U' -> reverse(Board, ReversedBoard),
        playColumn(ReversedBoard, Column, Player, NewReversedBoard), reverse(NewReversedBoard, NewBoard);
        Direction = 'u' -> reverse(Board, ReversedBoard),
        playColumn(ReversedBoard, Column, Player, NewReversedBoard), reverse(NewReversedBoard, NewBoard);
        Direction = 'D' -> playColumn(Board, Column, Player, NewBoard);
        Direction = 'd' -> playColumn(Board, Column, Player, NewBoard)
    ).

playColumn([Line | RestOfBoard], Column, Player, [Head | Remainder]) :-
    nth1(1, RestOfBoard, NextLine),
    getPieceInColumn(Column, NextLine, Piece),
    (
        Piece \= '.', getPieceInColumn(Column, Line, LocalPiece), LocalPiece = '.',
        (
            length(RestOfBoard, L), L >= 2 -> 
                (
                    nth1(2, RestOfBoard, SecondLine), 
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
                );
                replaceElement(Column, Line, Player, Head), Remainder = RestOfBoard
        ) 
    );
    Head = Line, playColumn(RestOfBoard, Column, Player, Remainder).

getPlayInput(Player, Play) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    getCleanChar(Option),
    (
        Option = '1' -> getPlayColumn(Column, Direction), Play = ['C', Column, Direction, Player];
        Option = '2' -> getPlayLine(Line, Direction), Play = ['L', Line, Direction, Player];
        write('Invalid Input'), nl, getPlayInput(Play, Player)
    ).

getComputerInput(Player, Play, Board) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    selectRandomOption(Option),
    (
        Option = '1' -> selectColumnAndDirection(Column, Direction, Board), Play = ['C', Column, Direction, Player];
        Option = '2' -> selectLine(Line, Direction), Play = ['L', Line, Direction, Player];
        write('Invalid Input'), nl, getComputerInput(Play, Player)
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
        Direction = 'R';
        Direction = 'l';
        Direction = 'r'
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
        ColumnChar = 'S';
        ColumnChar = 'a';
        ColumnChar = 'b'; 
        ColumnChar = 'c'; 
        ColumnChar = 'd'; 
        ColumnChar = 'e'; 
        ColumnChar = 'f'; 
        ColumnChar = 'g';
        ColumnChar = 'h'; 
        ColumnChar = 'i'; 
        ColumnChar = 'j'; 
        ColumnChar = 'k';
        ColumnChar = 'l'; 
        ColumnChar = 'm'; 
        ColumnChar = 'n'; 
        ColumnChar = 'o'; 
        ColumnChar = 'p'; 
        ColumnChar = 'q'; 
        ColumnChar = 'r'; 
        ColumnChar = 's'  
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
        Direction = 'D';
        Direction = 'u';
        Direction = 'd'
    ), nl.

getPlayColumnDirection(Direction) :-
    write('Invalid Option'), nl, getPlayColumnDirection(Direction).

fiveInARow([[] | []], _) :-
    write('End Of Board'), nl,
    false.

fiveInARow([[Piece | RestOfLine] | RestOfBoard], PieceIndex) :-
    RestOfLine = [] -> fiveInARow(RestOfBoard, 0);
    Piece \= '.' ->
    (
        %write(Piece), nl,
        checkFiveInARowRight(RestOfLine, Piece, 1), write('Horizontal ');
        %write('Before down'), nl,
        checkFiveInARowDown(RestOfBoard, PieceIndex, Piece, 1), write('Vertical ');
        %write('Before Diagonal Left'), nl,
        checkFiveInARowDiagonalLeft(RestOfBoard, PieceIndex, Piece, 1), write('Left Diagonal ');
        %write('Before Right'), nl,
        checkFiveInARowDiagonalRight(RestOfBoard, PieceIndex, Piece, 1), write('Right Diagonal ');

        NexIndex = PieceIndex + 1,
        append([RestOfLine], RestOfBoard, CutBoard),
        fiveInARow(CutBoard, NextIndex)
    );
    NexIndex = PieceIndex + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    fiveInARow(CutBoard, NextIndex).

checkFiveInARowDiagonalLeft(_, _, _, 5).

checkFiveInARowDiagonalLeft([Line | RestOfBoard], Column, PlayerPiece, NumberOfMatches) :-
    nth0(Column, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, PreviousColumn is Column - 1, 
    checkFiveInARowDiagonalLeft(RestOfBoard, PreviousColumn, PlayerPiece, NextMatch).

checkFiveInARowDiagonalRight(_, _, _, 5).

checkFiveInARowDiagonalRight([Line | RestOfBoard], Column, PlayerPiece, NumberOfMatches) :-
    nth0(Column, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, PreviousColumn is Column + 1, 
    checkFiveInARowDiagonalRight(RestOfBoard, PreviousColumn, PlayerPiece, NextMatch).

checkFiveInARowDown(_, _, _, 5).

checkFiveInARowDown([Line | RestOfBoard], Column, PlayerPiece, NumberOfMatches) :-
    nth0(Column, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, 
    checkFiveInARowDown(RestOfBoard, Column, PlayerPiece, NextMatch).

checkFiveInARowRight(_, _, 5).

checkFiveInARowRight([Piece | RestOfLine], PlayerPiece, NumberOfMatches) :-
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, checkFiveInARowRight(RestOfLine, PlayerPiece, NextMatch).

