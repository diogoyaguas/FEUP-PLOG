:- include('tools.pl').

ceco :-
    % TODO Splash Screen with delay
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    ServerAux is (NoServers + 1),
    create_servers(NoServers, ServerAux, ServerList),
    get_tasks(1, TaskList),
    print_list(TaskList).

create_servers(0, _, []).
create_servers(NoServers, ServerAux, [Server | RestOfServerList]) :-
    ServerNumber is (ServerAux - NoServers),
    write('-----------'), nl,
    write('Server #'), write(ServerNumber), nl,
    write('-----------'), nl, 
    write('Number of Cores: '), get_clean_int(NoCores), nl,
    write('Frequency (GHz): '), get_clean_number(Frequency), nl,
    write('RAM (GB): '), get_clean_number(RAM), nl,
    write('Storage (GB): '), get_clean_number(Storage), nl,
    Server = [NoCores, Frequency, RAM, Storage], 
    NoServersAux is (NoServers - 1),
    create_servers(NoServersAux, ServerAux, RestOfServerList).

get_tasks(1, [Task | RestOfTaskList]) :-
    get_task(Task),
    get_tasks_option(Option),
    get_tasks(Option, RestOfTaskList).

get_tasks(2, []).

get_tasks(_, [Task | RestOfTaskList]) :-
    write('Invalid Option'), nl,
    get_tasks_option(Option),
    get_tasks(Option, [Task | RestOfTaskList]).

get_tasks_option(Option) :-
    write('1 - Add a new task'), nl,
    write('2 - Save and Go Back'), nl,
    get_clean_char(Option).

    