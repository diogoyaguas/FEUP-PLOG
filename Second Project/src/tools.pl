% Reads an option from the console as an int and checks if it is within the bounds stipulated.
get_option(Opt, LowerBound, UpperBound) :-
    get_clean_int(Opt),
    Opt >= LowerBound,
    Opt =< UpperBound.

get_option(Opt, LowerBound, UpperBound) :-
    write('Invalid Option'), nl,
    get_option(Opt, LowerBound, UpperBound).

% Reads a char from the input stream, discarding everything after it
get_clean_char(X) :-
    get_char(X),
    read_line(_),
    nl.

% Reads an int from the input stream, verifying if it's actually an int
get_clean_int(I) :-
    catch(read(I), _, true),
    get_char(_),
    integer(I).
        
get_clean_int(I) :-
    write('<<< Invalid Input >>>\n\n'), get_clean_int(I).

% Reads a number from the console.
get_clean_number(N) :-
    catch(read(N), _, true),
    get_char(_).

get_clean_number(N) :-
    write('<<< Invalid Input >>>\n\n'), get_clean_number(N).

% Prints a list
print_list([]) :-
    !.

print_list([H|T]) :-
    write(H),
    write('|'),
    print_list(T).