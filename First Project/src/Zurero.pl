:- include('bot.pl').
:- include('display.pl').
:- include('game.pl').
:- include('gameCvC.pl').
:- include('gamePvC.pl').
:- include('gamePvP.pl').
:- include('tools.pl').
:- include('validation.pl').

displayMenu :-
    write('\e[2J'),
    write('\nZurero\n\n'),
    write('1 - Human vs Human\n'), 
    write('2 - Human vs CPU\n'), 
    write('3 - CPU vs CPU\n').

play :-
    displayMenu,
    get_clean_char(Option),
    (
        Option = '1' -> write('\n       <<< Started Human vs Human >>>\n'), nl, create_game('pvp', 0);
        Option = '2' -> bot_difficulty;
        Option = '3' -> write('\n    <<< Started Computer vs Computer >>>\n'), nl, create_game('cvc', 0);
        write('Invalid Input'),
        nl,
        play
    ).

% Choose the bot difficulty
bot_difficulty :-

    write('\nBot Difficulty\n\n'), 
    write('1-Random\n'), 
    write('2-Smart\n'), 
    get_clean_char(Option),
    (
        Option = '1' -> write('\n     <<< Started Human vs Computer >>>\n'), nl, create_game('pvc', 1);
        Option = '2' -> write('\n     <<< Started Human vs Computer >>>\n'), nl, create_game('pvc', 2);
        write('Invalid bot difficulty'), nl, bot_difficulty(Option)
    ).

showPlayer(Player) :-
    Player = 'b' -> nl, write('Black Turn'), nl, nl;
    Player = 'w' -> nl, write('White Turn'), nl, nl.

victory(Winner) :-
    nl,
    Winner = 'b' -> write('Black Player wins!');
    write('White Player wins!').
