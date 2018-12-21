main_menu :-
    display_banner,
    write('1 - Manual Input'), nl,
    write('2 - Generate Data'), nl,
    get_option(Option, 1, 2),
    (
        (Option = 1, manual_input(ServerList, ServerNo, TaskList, TaskNo));
        (Option = 2, generate_data(ServerList, ServerNo, TaskList, TaskNo), 
        print_data(ServerList, ServerNo, TaskList)) 
    ),
    samsort(compare_tasks, TaskList, NewTaskList),
    schedule(ServerList, ServerNo, NewTaskList, TaskNo, StartTimes, EndTimes, MachineIds),
    print_results(NewTaskList, MachineIds, StartTimes, EndTimes), nl.


display_banner :-
    write('\e[2J'),
    write('-------'), nl,
    write(' CeCo'), nl,
    write('-------'), nl.

print_results([], [], [], []).
print_results([[TaskId | _] | Rt], [MachineId | Rmid], [StartTime | Rst], [EndTime | Ret]) :-
    StartTimeMins is (StartTime // 60),
    EndTimeMins is (EndTime // 60),
    write('Task #'), write(TaskId), write(' was associated with server #'), write(MachineId), write(', starting at '),
    write(StartTimeMins), write(' minutes and ending at '), write(EndTimeMins),  write(' minutes.'),  nl,
    print_results(Rt, Rmid, Rst, Ret).

print_data(ServerList, ServerNo, TaskList) :-
    print_servers(ServerList, ServerNo, 1), nl,
    print_tasks(TaskList), nl.

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

manual_input(ServerList, NoServers, TaskList, TaskNo) :-
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    ServerAux is (NoServers + 1),
    create_servers(NoServers, ServerAux, ServerList),
    get_tasks(1, TaskList, 1),
    length(TaskList, TaskNo).
    
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

%DEPRECATED ----- CHANGE!!!!
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
    write('ETA (mins): '), get_clean_int(ETAMins), nl,
    ETAHours is (ETAMins / 60),
    Task = [Plan, NoCores, Frequency, RAM, Storage, ETAHours].