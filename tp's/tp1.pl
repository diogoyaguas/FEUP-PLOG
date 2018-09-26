/* Exercício RC 1. Representação de Conhecimento – Prison Break */

male('Aldo Burrows').
male('Lincoln Burrows').
male('LJ Burrows').
male('Michael Scofield').

female('Christina Rose Scofield').
female('Lisa Rix').
female('Sara Tancredi').
female('Ella Scofield').

parent('Aldo Burrows','Michael Scofield').
parent('Aldo Burrows','Lincoln Burrows').
parent('Christina Rose Scofield','Michael Scofield').
parent('Christina Rose Scofield','Lincoln Burrows').

parent('Lincoln Burrows','LJ Burrows').
parent('Lisa Rix','LJ Burrows').

parent('Michael Scofield','Ella Scofield').
parent('Sara Tancredi','Ella Scofield').

/* Exercício RC 2. Representação de Conhecimento – Red Bull Air Race */

pilote('Lamb').
pilote('Besenyei').
pilote('Chambliss').
pilote('MacLean').
pilote('Mangold').
pilote('Jones').
pilote('Bonhomme').

team('Breitling','Lamb').
team('Red Bull','Besenyei').
team('Red Bull','Chambliss').
team('Mediterranean Racing Team','MacLean').
team('Cobra','Mangold').
team('Matador','Jones').
team('Matador','Bonhomme').

plane('MX2','Lamb').
plane('Edge 540','Besenyei').
plane('Edge 540','Chambliss').
plane('Edge 540','MacLean').
plane('Edge 540','Mangold').
plane('Edge 540','Jones').
plane('Edge 540','Bonhomme').

circuits('Istanbul').
circuits('Budapest').
circuits('Porto').

won('Jones','Porto').
won('Mangold','Budapest').
won('Mangold','Istanbul').

gates('Istanbul',9).
gates('Budapest',6).
gates('Porto',5).

%A
won(X,'Porto').

%B
win(X,Z) :- team(X,Y), won(Y,Z).

%C
pilote(X,'>1') :- won(X,C1), won(X,C2), C2\=C1.

%D
circuits(X,Y) :- gates(X,Z), Z>Y.

%E
pilote(X,Y) :- plane(Z,X), Y\=Z.

/* Exercício RC 3. Representação de Conhecimento – Autores de Livros */

book('Os Maias').

author('Eca de Queiroz').

nacionality('portugues').
nacionality('ingles').

nacionalityOf('Eca de Queiroz','portugues').

genre('romance').
genre('ficcao').

genre('Os Maias','romance').

wrote('Eca de Queiroz','Os Maias').

%A
wrote(X,'Os Maias').

%B
wrote(X,Y,Z) :- nacionalityOf(X,Y), wrote(X,T), genre(T,Z).

%C
wroteOtherGenre(X,G1) :- wrote(X,Y), wrote(X,Z), genre(Y,G1), genre(Z,G2), G1\=G2.

/* Exercício RC 4. Representação de Conhecimento – Comidas e Bebidas */

pair('Ana','Bruno').
pair('Antonio','Barbara').
married(X,Y) :- pair(X,Y) ; pair(Y,X).

plate('peru','cerveja').
plate('frango','cerveja').
plate('salmao','cerveja').
plate('solha','cerveja').
plate('peru','vinho maduro').
plate('frango','vinho verde').
plate('salmao','vinho verde').
plate('solha','vinho maduro').

goesWith(X,Y) :- plate(X,Y) ; plate(Y,X).

like('Ana','vinho verde').
like('Ana','peru').
like('Ana','solha').
like('Bruno','vinho verde').
like('Bruno','cerveja').
like('Bruno','frango').
like('Antonio','vinho verde').
like('Antonio','vinho maduro').
like('Antonio','cerveja').
like('Barbara','peru').
like('Barbara','frango').
like('Barbara','salmao').
like('Barbara','solha').

%A
sameTastes(X,Y,Z) :- married(X,Y), like(X,Z), like(Y,Z), X\=Y.
