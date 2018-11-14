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

move(Move, Board, NewBoard) :-
    Move = [Symbol | RestOfPlay],
    check_play(Symbol, Board, RestOfPlay, NewBoard);
    write('Error in Play Symbol').

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