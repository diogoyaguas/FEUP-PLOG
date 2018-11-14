displayMenu :-
    write('\e[2J'),
    write('\nZurero\n\n'),
    write('1 - Human vs Human\n'), 
    write('2 - Human vs CPU\n'), 
    write('3 - CPU vs CPU\n').


menu_option('1'):-  start_game(1, 1).
menu_option('2'):-  bot_difficulty(2). 
menu_option('3'):-  bot_difficulty(3).

menu_option(Option):-   
    Option \= '1',
    Option \= '2',
    Option \= '3',
    play.

% Choose the bot difficulty
bot_difficulty(Type) :-

    write('\nBot Difficulty\n\n'), 
    write('1-Random\n'), 
    write('2-Smart\n'), 
    get_clean_char(Difficulty_Char),
    name(Difficulty_Char, [Difficulty_Int_Char]),
    Difficulty is Difficulty_Int_Char - 48,
    (
        Difficulty > 0,
        Difficulty < 3, 
        start_game(Type, Difficulty)
    );
    write('\nInvalid bot difficulty'), nl, bot_difficulty(Type).