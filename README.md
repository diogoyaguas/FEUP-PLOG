# Zurero
![image](https://user-images.githubusercontent.com/32617691/60514743-0441d800-9cd2-11e9-9fed-609e0c2ae62c.png)

This project represents a Prolog implementation of the classical game Zurero, which was developed in the Logic Programming class (PLOG).
It features 3 different gamemodes:

* Human vs Human
* Human vs Computer
* Computer vs Computer

There are two different difficulty settings for the Computer player as well: easy and smart.

## Rules
Zurero is a classical board game in which a player must align 5 of their pieces, either in a row, column or diagonaly. This can be done by "sliding" pieces from one of the board's edges. A player can only slide a piece in a row/column where there is at least another piece.
When two pieces "collide", one of two scenarios can happen:

* If the piece that was already on the board doesn't have another piece blocking its way, it slides one space in the opposite direction of the thrown piece. This last one will occupy the former place of the piece that was already on the board.

* If the above condition fails, the thrown piece will occupy the space directly before the first piece that encountered.

## Gameplay
During the game, a player will first have to choose if it wants to play in a column or line. After that, it will have to input the letter corresponding to the column or the line number, respectively. Next, the player will also have to indicate the direction in which it wishes to play. This could be Down (D) or Up (U) for column plays or Left (L) or Right (R) for line ones. After this, if the move is valid, it will be performed and the resultant board printed onto the screen.

![image](https://user-images.githubusercontent.com/32617691/60515621-ed9c8080-9cd3-11e9-93e2-9c74b8d3c952.png)

If it's the computer's turn, depending on the difficulty chosen, he will choose a possible move and execute it, printing it's details on the screen as well as the resultant board.

![image](https://user-images.githubusercontent.com/32617691/60515950-9a76fd80-9cd4-11e9-8a1d-24e3c4da0706.png)

## Usage
To use this application, you must load the Zurero.pl file in a Prolog interpreting machine. After it has loaded all the other files, you can initiate the game with the 'play' command. **Note: Don't forget the '.' after the command.**

# Computing Center

