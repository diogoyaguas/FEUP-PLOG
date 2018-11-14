:- use_module(library(clpfd)).

create_game(Mode, Level) :-
    table(Table),
    Game = [Table, Mode, Level],
    start_game(Game).

start_game(Game) :-
    nth0(0, Game, Table),
    replace_piece(10, 10, 'b', Table, NewTable),
    update_game_table(Game, NewTable, StartedGame),
    nth0(1, StartedGame, Mode),
    (
        Mode = 'pvp' -> printBoard(NewTable), update_game_PvP(StartedGame, 'w');
        Mode = 'pvc' -> printBoard(NewTable), update_game_PvC(StartedGame, 'w', 4);
        Mode = 'cvc' -> printBoard(NewTable), update_game_CvC(StartedGame, 'w', 4)
    ).
    
switch_players(CurrentPlayer, NextPlayer) :-
    CurrentPlayer = 'w' -> NextPlayer = 'b';
    NextPlayer = 'w'.
   
update_game_table(Game, NewTable, StartedGame) :-
    replace_element(1, Game, NewTable, StartedGame).

 valid_moves(Board, Player, ListOfMoves, Find) :- 
    verify_moves(Board, 'b', VerticalDownMovesB, 'C', 'D', 1, Find),
    verify_moves(Board, 'w', VerticalDownMovesW, 'C', 'D', 1, Find),
    reverse(Board, ReversedBoard), 
    verify_moves(ReversedBoard, 'b', VerticalUpMovesB, 'C', 'U', 1, Find),
    verify_moves(ReversedBoard, 'w', VerticalUpMovesW, 'C', 'U', 1, Find),
    transpose(Board, TransposedBoard),
    verify_moves(TransposedBoard, 'b', HorizontalRightMovesB, 'L', 'R', 1, Find),
    verify_moves(TransposedBoard, 'w', HorizontalRightMovesW, 'L', 'R', 1, Find),
    reverse(TransposedBoard, TransposedReversedBoard),
    verify_moves(TransposedReversedBoard, 'b', HorizontalLeftMovesB, 'L', 'L', 1, Find),
    verify_moves(TransposedReversedBoard, 'w', HorizontalLeftMovesW, 'L', 'L', 1, Find),
    append(VerticalDownMovesB, VerticalDownMovesW, VerticalDownMoves),
    append(VerticalUpMovesB, VerticalUpMovesW, VerticalUpMoves),
    append(VerticalDownMoves, VerticalUpMoves, VerticalMoves),
    append(HorizontalRightMovesB, HorizontalRightMovesW, HorizontalRightMoves),
    append(HorizontalLeftMovesB, HorizontalLeftMovesW, HorizontalLeftMoves),
    append(HorizontalRightMoves, HorizontalLeftMoves, HorizontalMoves),
    append(VerticalMoves, HorizontalMoves, ListOfMoves).

select_movement([[.] | []], _, _, _, _, _, _).

verify_moves([[Piece | RestOfLine] | RestOfBoard], Player, VerticalMoves, Symbol , Direction, Index, Find) :-
    RestOfLine = [] -> verify_moves(RestOfBoard, Player, VerticalMoves, Symbol , Direction, Index, Find);
    Piece = empty ->
    (
        write('oiii'),  
        check_movement(RestOfBoard, Index, Player, Find),
        write('hey'),
        Play = [Symbol, Index, Direction, Player],
        append([Play], VerticalMoves, NewMoves),
        NextIndex is (Index + 1),
        append([RestOfLine], RestOfBoard, CutBoard),
        verify_moves(CutBoard, Player, NewMoves, Symbol, Direction, NewIndex, Find)
    );
    write('coewnner'),
    NextIndex is (Index + 1),
    append([RestOfLine], RestOfBoard, CutBoard),
    verify_moves(CutBoard, Player, VerticalMoves, Symbol, Direction, NewIndex, Find).

    
move(Move, Board, NewBoard) :-
    Move = [Symbol | RestOfPlay],
    RestOfPlay = [LineNumber | _],
    (
        Symbol = 'C' -> check_column_play_direction(Board, RestOfPlay, NewBoard);
        Symbol = 'L' -> check_line_play_direction(Board, RestOfPlay, LineNumber, NewBoard);
        write('Error in Play Symbol')
    ).

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

game_over([[] | []], _) :-
    write('End Of Board'), nl,
    false.

game_over([[Piece | RestOfLine] | RestOfBoard], Winner, PieceIndex) :-
    RestOfLine = [] -> game_over(RestOfBoard, Winner, 0);
    Piece \= empty ->
    (
        check_game_over_horizontal(RestOfLine, Piece, 1), Winner = Piece;
        check_game_over_vertical(RestOfBoard, PieceIndex, Piece, 1), Winner = Piece;
        check_game_over_diagonal_left(RestOfBoard, PieceIndex, Piece, 1), Winner = Piece;
        check_game_over_diagonal_right(RestOfBoard, PieceIndex, Piece, 1), Winner = Piece;

        NexIndex = PieceIndex + 1,
        append([RestOfLine], RestOfBoard, CutBoard),
        game_over(CutBoard, Winner, NextIndex)
    );
    NexIndex = PieceIndex + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    game_over(CutBoard, Winner, NextIndex).


