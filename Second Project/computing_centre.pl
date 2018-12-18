:- use_module(library(clpfd)).
:- use_module(library(random)).

:- include('tools.pl').

ceco :-
    % TODO Splash Screen with delay
    main_menu.

main_menu :-
    write('1 - Manual Input'), nl,
    write('2 - Generate Data'), nl,
    get_option(Option, 1, 2),
    (
        (Option = 1, manual_input(ServerList, TaskList));
        (Option = 2, generate_data(ServerList, TaskList)) 
    ),
    print_list(ServerList), nl,
    print_list(TaskList).

generate_data(ServerList, TaskList) :-
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    generate_servers(NoServers, ServerList),
    write('Number of Tasks: '),
    get_clean_int(NoTasks), nl,
    generate_tasks(NoTasks, TaskList).

generate_tasks(0, []).
generate_tasks(NoTasks, [Task | RestOfTaskList]) :-
    random(1, 4, Plan),
    random(1, 8, Cores),
    random(1, 9, PartialFrequencyI),
    PartialFrequencyF is (PartialFrequencyI / 10),
    Frequency is (1.0 + PartialFrequencyF),
    random(1, 16, RAM),
    random(120, 1000, Storage),
    random(5, 360, ETA),
    Task = [Plan, Cores, Frequency, RAM, Storage, ETA],
    NoTasksAux is (NoTasks - 1),
    generate_tasks(NoTasksAux, RestOfTaskList).


generate_servers(0, []).
generate_servers(NoServers, [Server | RestOfServerList]) :-
    random(1, 8, Cores),
    random(1, 9, PartialFrequencyI),
    PartialFrequencyF is (PartialFrequencyI / 10),
    Frequency is (1.0 + PartialFrequencyF),
    random(1, 16, RAM),
    random(120, 1000, Storage),
    NoServersAux is (NoServers - 1),
    Server = [Cores, Frequency, RAM, Storage],
    generate_servers(NoServersAux, RestOfServerList).


manual_input(ServerList, TaskList) :-
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    ServerAux is (NoServers + 1),
    create_servers(NoServers, ServerAux, ServerList),
    get_tasks(1, TaskList, 1),
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

get_tasks(1, [Task | RestOfTaskList], TaskNo) :-
    get_task(Task, TaskNo),
    get_tasks_option(Option),
    NextTaskNo is (TaskNo + 1),
    !, get_tasks(Option, RestOfTaskList, NextTaskNo).

get_tasks(2, [], _).

get_tasks_option(Option) :-
    write('1 - Add a new task'), nl,
    write('2 - Save and Go Back'), nl,
    get_option(Option, 1, 2).

get_task(Task, TaskNo) :-
    write('-----------'), nl,
    write('Task #'), write(TaskNo), nl,
    write('-----------'), nl,
    write('Client Plan (1,2,3 or 4): '),
    get_option(Plan, 1, 4),
    write('Number of Cores: '), get_clean_int(NoCores), nl,
    write('Frequency (GHz): '), get_clean_number(Frequency), nl,
    write('RAM (GB): '), get_clean_number(RAM), nl,
    write('Storage (GB): '), get_clean_number(Storage), nl,
    write('ETA (mins): '), get_clean_int(ETA), nl,
    Task = [Plan, NoCores, Frequency, RAM, Storage, ETA].
    