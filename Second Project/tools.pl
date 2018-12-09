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