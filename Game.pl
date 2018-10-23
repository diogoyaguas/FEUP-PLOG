startGamePvP(Game) :-
    table(Table),
    Game = [Table, b, pvp].

updateGame(Game) :-
    playTurn(Game, PlayedGame).

playTurn(Game, PlayedGame) :-
    nth0(2, Game, Mode),
    (
        Mode = 'pvp' -> playTurnPvP(Game, PlayedGame)
    ).

playTurnPvP(Game, PlayedGame) :-
    nth0(1, Game, Player),
    getPlayerInput(Game, PlayedGame),
    (
        Player = 'w' -> (display_game(PlayedGame, 'Player 2 Turn'), replaceElement(2, Game, b, PlayedGame)); 
        Player = 'b' -> (dispplay_game(PlayedGame, 'Player 1 Turn'), replaceElement(2, Game, w, PlayedGame))
    ).


