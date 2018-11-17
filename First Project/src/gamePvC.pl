:- use_module(library(system)).

% Starts a PvC game
startPvC(Game) :-
    nth0(0, Game, Table),
    replace_piece(10, 10, 'b', Table, NewTable),
    update_game_table(Game, NewTable, StartedGame),
    update_game_PvC(StartedGame, 'w').

% Main PvC game loop
update_game_PvC(Game, Player) :-
    play_turn_PvC(Game, Player, PlayedGame),
    nth0(0, PlayedGame, Board),
    (
        % Ends if there is a winner
        game_over(Board, Winner, 0), victory(Winner), print_board(Board);
        % Or switchess player
        switch_players(Player, NextPlayer), !, update_game_PvC(PlayedGame, NextPlayer)
    ).

% Executes the necessary instructions to play a PvC turn
play_turn_PvC(Game, Player, PlayedGame) :-
    nth0(0, Game, Board),
    display_game(Board, Player), % Displays the board
    nth0(1, Game, Difficulty),  
    valid_moves(Board, ListOfMoves, Player), % Gets valid moves
    (
        Player = 'b', choose_move(Board, Player, Move, Difficulty, ListOfMoves); % Gets bot input
        Player = 'w', get_play_input(Player, Move) % Gets player input
    ),
    (
        move(Move, ListOfMoves, Board, NewBoard); % Verifies if player move is acceptable
        !, play_turn_PvC(Game, Player, PlayedGame) % If not repeats the process.
    ),
    update_game_table(Game, NewBoard, PlayedGame). % Updates the game board with the new one

% Writes the bot input 
write_move(Symbol, Move) :-
    write('1 - Choose Column'), nl,
    write('2 - Choose Line'), nl,
    write('|: '),
    random(2, 5, Time),
    sleep(Time),
    (
        Symbol = 'C',
        nth1(2, Move, Index),
        nth1(3, Move, Direction), 
        write(1), nl,
        write('\nColumn (A to S): '),
        Code is (Index + 64),
        char_code(Column, Code),
        write(Column), nl,
        write('\nDirection (U (Up) or D (Down)): '),
        write(Direction), nl, nl
    );
    (
        Symbol = 'L',
        nth1(2, Move, Line),
        nth1(3, Move, Direction),
        write(2), nl,
        write('\nLine (1 to 19): '),
        write(Line), nl,
        write('\nL (Left) or R (right): '),
        write(Direction), nl, nl
    ).
