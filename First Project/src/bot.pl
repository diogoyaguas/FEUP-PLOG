:- use_module(library(random)).

choose_move(_, _, Move, 1, ListOfMoves) :-
    random_move(ListOfMoves, Index),
    nth1(Index, ListOfMoves, Move),
    nth1(1, Move, Symbol),
    write_move(Symbol, Move).

choose_move(Board, Player, Move, 2, ListOfMoves) :-
    value(Board, Player, Value),
    (
        Value < 0, Try = -1;
        Try = 1    
    ),
    evaluate_and_choose(Try, Board, Player, Move, ListOfMoves),
    nth1(1, Move, Symbol),
    write_move(Symbol, Move).

evaluate_and_choose(1, Board, Player, Move, ListOfMoves) :-
    choose_best_play(Board, Player, Move, ListOfMoves, [], Index),
    nth0(Index, ListOfMoves, Move).

evaluate_ad_choose(-1, Board, Player, Move, ListOfMoves) :-
    switch_players(Player, Opponent),
    choose_best_play(Board, Opponent, Move, ListOfMoves, [], Index),
    nth0(Index, ListOfMoves, Move).

random_move(ListOfMoves, Index) :-
    length(ListOfMoves, L),
    random(1, L, Index).

choose_best_play(_, _, _, [], Values, Index) :-
    reverse(Values, RightValues),
    max_member(Value, RightValues),
    nth0(Index, RightValues, Value).

choose_best_play(Board, Player, Move, [Try | RestOfMoves], Values, Index) :-
    move(Try, [Try], Board, ResultBoard),
    value(ResultBoard, Player, Value),
    append([Value], Values, ValuesList),
    choose_best_play(Board, Player, Move, RestOfMoves, ValuesList, Index).
    
