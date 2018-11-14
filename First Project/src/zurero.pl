:- include('display.pl').
:- include('game.pl').
:- include('gameOver.pl').
:- include('gamePvP.pl').
:- include('menu.pl').
:- include('tools.pl').
:- include('validation.pl').

play :-
    displayMenu,
    get_clean_char(Option),
    menu_option(Option).