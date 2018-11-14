select_movement(_, [[.] | []], _, _, _).

select_movement(Player, [[Piece | RestOfLine] | RestOfBoard], Index, Movement, Find) :-
    RestOfLine = [] -> select_movement(Player, RestOfBoard, 1, Movement, Find);
    
    Piece = empty ->
    (
        check_movement(RestOfBoard, Index, Player, Find), Movement is Index;
        diagonal_movement(RestOfBoard, Index, Movement, Find);
        next_movement(Player, Index, RestOfLine, RestOfBoard, Movement, Find)
    );
    next_movement(Player, Index, RestOfLine, RestOfBoard, Movement, Find).

next_movement(Player, Index, RestOfLine, RestOfBoard, Movement, Find) :-
    NextMovement is Index + 1,
    append([RestOfLine], RestOfBoard, CutBoard),
    select_movement(Player, CutBoard, NextMovement, Movement, Find).

check_movement(_, _, _, 5).

check_movement([Line | RestOfBoard], Movement, PlayerPiece, NumberOfMatches) :-
    write('pila'),
    nth1(Movement, Line, Piece),
    Piece = PlayerPiece -> NextMatch is NumberOfMatches + 1, 
    check_movement(RestOfBoard, Movement, PlayerPiece, NextMatch).

diagonal_movement(RestOfBoard, Index, Movement, Find) :-

        (
            nth1(1, RestOfBoard, NextLine), nth1(Index, NextLine, NextPiece),
            NextPiece \= empty ->  check_game_over_diagonal_right(RestOfBoard, Index, 'b', Find), Movement is Index
        ).
