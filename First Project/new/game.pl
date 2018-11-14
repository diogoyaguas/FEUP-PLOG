create_game(Game, Difficulty) :-
    table(Table),
    Game = [Table, Difficulty].

% Start the game
start_game(1, 1) :- 
    write('\n       <<< Started Human vs Human >>>\n'), nl,
    create_game(Game, 1),
    startPvP(Game).

start_game(2, Difficulty) :- 
    write('\n     <<< Started Human vs Computer >>>\n'), nl,
    create_game(Game, Difficulty),
    startPvC(Game).

start_game(3, Difficulty) :-
    write('\n    <<< Started Computer vs Computer >>>\n'), nl,    
    create_game(Game, Difficulty),
    startCvC(Game).

update_game_table(Game, NewTable, StartedGame) :-
    replace_element(1, Game, NewTable, StartedGame).

switch_players(CurrentPlayer, NextPlayer) :-
    (
        CurrentPlayer = 'w', NextPlayer = 'b'
    );
    NextPlayer = 'w'.

move(Move, MoveList, Board, NewBoard) :-
    (
        member(Move, MoveList),
        Move = [Symbol | RestOfPlay],
        (
            Symbol = 'C', check_column_play_direction(Board, RestOfPlay, NewBoard);
            RestOfPlay = [LineNumber | _], 
            Symbol = 'L', check_line_play_direction(Board, RestOfPlay, LineNumber, NewBoard)
        )
    );
    write('Invalid Play'), nl, false.

play_column([Line | RestOfBoard], Column, Player, [Head | Remainder]) :-
    nth1(1, RestOfBoard, NextLine),
    get_piece_in_column(Column, NextLine, Piece),
    (
        Piece \= empty, get_piece_in_column(Column, Line, LocalPiece), LocalPiece = empty,
        (
            length(RestOfBoard, L), L >= 2 -> 
                (
                    nth1(2, RestOfBoard, SecondLine), 
                    get_piece_in_column(Column, SecondLine, NextPiece),
                    (
                        NextPiece \= empty -> replace_element(Column, Line, Player, Head),
                        Remainder = RestOfBoard;

                        replace_element(Column, SecondLine, Piece, NewBottomLine),
                        replace_element(2, RestOfBoard, NewBottomLine, NewRestOfBoard),
                        replace_element(Column, NextLine, Player, NewLine),
                        replace_element(1, NewRestOfBoard, NewLine, Remainder),
                        Head = Line
                    )
                );
                replace_element(Column, Line, Player, Head), Remainder = RestOfBoard
        ) 
    );
    Head = Line, play_column(RestOfBoard, Column, Player, Remainder).

play_line([Head | RestOfLine], Player, [NewHead | Remainder]) :- 
    nth1(1, RestOfLine, NextPiece),
    (
        NextPiece \= empty, Head = empty,
        (
            length(RestOfLine, L), L >= 2 ->
            (
                nth1(2, RestOfLine, SecondPiece),
                (
                    SecondPiece \= empty -> NewHead = Player, Remainder = RestOfLine;

                    replace_element(2, RestOfLine, NextPiece, NewRestOfLine),
                    replace_element(1, NewRestOfLine, Player, Remainder),
                    NewHead = Head
                )
            );
            NewHead = Player, Remainder = RestOfLine
        )
    );
    NewHead = Head, play_line(RestOfLine, Player, Remainder).

check_column_play_direction(Board, Play, NewBoard) :-
    Play = [Column | DirectionPlayer],
    DirectionPlayer = [Direction | PlayerInList],
    PlayerInList = [Player | _],
    (
        (Direction = 'U', reverse(Board, ReversedBoard), play_column(ReversedBoard, Column, Player, NewReversedBoard), 
            reverse(NewReversedBoard, NewBoard));
        (Direction = 'D', play_column(Board, Column, Player, NewBoard))
    ).

check_line_play_direction([Line | RestOfBoard], Play, LineNumber, [Head | Remainder]) :-
    (
        LineNumber = 1,
        Play = [_ | DirectionPlayer], DirectionPlayer = [Direction | PlayerInList], PlayerInList = [Player | _],
        (
            (Direction = 'R', play_line(Line, Player, Head), Remainder = RestOfBoard);
            (Direction = 'L', reverse(Line, ReversedLine), play_line(ReversedLine, Player, NewReversedLine),
            reverse(NewReversedLine, Head), Remainder = RestOfBoard)
        )
    );
    NextLineNumber is LineNumber - 1,
    Head = Line,
    check_line_play_direction(RestOfBoard, Play, NextLineNumber, Remainder).
