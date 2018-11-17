choose_move(_, _, Move, 1, ListOfMoves) :-
    random_move(ListOfMoves, Index),
    nth1(Index, ListOfMoves, Move),
    nth1(1, Move, Symbol),
    write_move(Symbol, Move).

choose_move(Board, Player, Move, 2, ListOfMoves) :-
    value(Board, Player, Value),
    write(Value), nl,
    write(ListOfMoves), nl,
    ( 
        Value < 0, 
        write('VALUE <  0'), nl,
        switch_players(Player, Opponent),
        choose_best_play(Board, Opponent, Move, ListOfMoves, [], Index),
        nth0(Index, ListOfMoves, Move),
        write(Move), nl
    ).

choose_move(Board, Player, Move, 2, ListOfMoves) :-
    write('VALUE >=  0'), nl,
    choose_best_play(Board, Player, Move, ListOfMoves, [], Index),
    nth0(Index, ListOfMoves, Move),
    write(Move), nl.

random_move(ListOfMoves, Index) :-
    length(ListOfMoves, L),
    random(1, L, Index).

choose_best_play(_, _, _, [], Values, Index) :-
    write(Values), nl,
    max_member(Value, Values),
    nth0(Index, Values, Value).

choose_best_play(Board, Player, Move, [Try | RestOfMoves], Values, Index) :-
    move(Try, [Try], Board, ResultBoard),
    value(ResultBoard, Player, Value),
    append([Value], Values, ValuesList),
    choose_best_play(Board, Player, Move, RestOfMoves, ValuesList, Index).
    
