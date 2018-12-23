% Displays the main menu banner
display_banner :-
    write('\e[2J'),
    write('-------'), nl,
    write(' CeCo'), nl,
    write('-------'), nl.

% Prints the final results in a user friendly way
print_results([], [], [], []).
print_results([[TaskId | _] | Rt], [MachineId | Rmid], [StartTime | Rst], [EndTime | Ret]) :-
    StartTimeMins is (StartTime // 60),
    EndTimeMins is (EndTime // 60),
    write('Task #'), write(TaskId), write(' was associated with server #'), write(MachineId), write(', starting at '),
    write(StartTimeMins), write(' minutes and ending at '), write(EndTimeMins),  write(' minutes.'),  nl,
    print_results(Rt, Rmid, Rst, Ret).

% Prints the data generated automatically
print_data(ServerList, ServerNo, TaskList) :-
    print_servers(ServerList, ServerNo, 1), nl,
    print_tasks(TaskList), nl.

% Prints the tasks generated
print_tasks([]).
print_tasks([Task | Rt]) :-
    Task = [TaskId, Plan, NoCores, Frequency, RAM, Storage, ETA],
    ETAmins is (ETA // 60),
    write('-----------'), nl,
    write('Task #'), write(TaskId), nl,
    write('-----------'), nl,
    write('Client Plan: '), write(Plan), nl,
    write('Number of Cores: '), write(NoCores), nl,
    write('Frequency (GHz): '), write(Frequency), nl,
    write('RAM (GB): '), write(RAM), nl,
    write('Storage (GB): '), write(Storage), nl,
    write('ETA (mins): '), write(ETAmins), nl,
    print_tasks(Rt).

% Prints the servers generated
print_servers([], ServerNo, Counter) :-
    Counter is (ServerNo + 1).
print_servers([Server | Rs], ServerNo, Counter) :-
    Server = [NoCores, Frequency, RAM, Storage],
    write('-----------'), nl,
    write('Server #'), write(Counter), nl,
    write('-----------'), nl, 
    write('Number of Cores: '), write(NoCores), nl,
    write('Frequency (GHz): '), write(Frequency), nl,
    write('RAM (GB): '), write(RAM), nl,
    write('Storage (GB): '), write(Storage), nl,
    NextCounter is (Counter + 1),
    print_servers(Rs, ServerNo, NextCounter).

% Retrieves the input from the user
manual_input(ServerList, NoServers, TaskList, TaskNo) :-
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    ServerAux is (NoServers + 1),
    create_servers(NoServers, ServerAux, ServerList),
    write('Task Amount: '),
    get_clean_int(TaskNo), nl,
    length(TaskList, TaskNo),
    get_tasks(TaskNo, ServerList, TaskList).
    
% Creates the servers with inputes from the user
create_servers(0, _, []).
create_servers(NoServers, ServerAux, [Server | RestOfServerList]) :-
    ServerNumber is (ServerAux - NoServers),
    write('-----------'), nl,
    write('Server #'), write(ServerNumber), nl,
    write('-----------'), nl, 
    write('Number of Cores: '), get_clean_int(NoCores), nl,
    write('Frequency (GHz): '), get_clean_int(Frequency), nl,
    write('RAM (GB): '), get_clean_int(RAM), nl,
    write('Storage (GB): '), get_clean_int(Storage), nl,
    Server = [NoCores, Frequency, RAM, Storage], 
    NoServersAux is (NoServers - 1),
    create_servers(NoServersAux, ServerAux, RestOfServerList).

% Creates the tasks with inputs from the user
get_tasks(TaskNo, ServerList, TaskList) :-
    get_task_list(1, TaskNo, TaskList),
    check_tasks_compatibility(ServerList, TaskList, 0).

get_tasks(TaskNo, ServerList, TaskList) :-
    write('2nd Pass'), nl,
    get_tasks(TaskNo, ServerList, TaskList).

% Checks if the tasks are accepted by at least one server and that their total time doesn't exceed 24h
check_tasks_compatibility(_, [], TotalTime) :-
    (TotalTime =< 86400);
    (write('Total task time must not exceed 24 hours (1440 mins)'), nl, fail).

check_tasks_compatibility(ServerList, [Task | Rt], TotalTime) :-
    (
        check_server_compatibility(ServerList, Task),
        Task = [_, _, _, _, _, _, TaskTime],
        AccumulatedTime is (TotalTime + TaskTime),
        check_tasks_compatibility(ServerList, Rt, AccumulatedTime) 
    );
    (write('There is at least one task that cannot be serviced by any server!'), nl, fail).

% Checks if there is at least one server able to process a given task
check_server_compatibility([], _) :-
    fail.
check_server_compatibility([Server | Rs], Task) :-
    Server = [NoCoresS, FrequencyS, RAMS, StorageS],
    Task = [_, _, NoCoresT, FrequencyT, RAMT, StorageT, _],
    ((NoCoresS >= NoCoresT, FrequencyS >= FrequencyT, RAMS >= RAMT, StorageS >= StorageT);
    check_server_compatibility(Rs, Task)).

% Creates a task list with inputs from the user
get_task_list(Counter, TaskNo, []) :-
    Counter is (TaskNo + 1).

get_task_list(Counter, TaskNo, [Task | Rt]) :-
    write('-----------'), nl,
    write('Task #'), write(Counter), nl,
    write('-----------'), nl,
    write('Client Plan (1,2,3 or 4): '), get_option(Plan, 1, 4), nl,
    write('Number of Cores: '), get_clean_int(NoCores), nl,
    write('Frequency (GHz): '), get_clean_int(Frequency), nl,
    write('RAM (GB): '), get_clean_int(RAM), nl,
    write('Storage (GB): '), get_clean_int(Storage), nl,
    write('ETA (mins): '), get_clean_int(ETAMins), nl,
    ETASeconds is (ETAMins * 60),
    Task = [Counter, Plan, NoCores, Frequency, RAM, Storage, ETASeconds],
    NextCounter is (Counter + 1),
    get_task_list(NextCounter, TaskNo, Rt).