:- use_module(library(clpfd)).
:- use_module(library(lists)).
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
        (Option = 1, manual_input(ServerList, ServerNo, TaskList, TaskNo));
        (Option = 2, generate_data(ServerList, ServerNo, TaskList, TaskNo)) 
    ),
    write('----- Servers ----- '), nl,
    print_list(ServerList), nl,
    write('----- User Tasks ----- '), nl,
    print_list(TaskList), nl,
    schedule(ServerList, ServerNo, TaskList, TaskNo, StartTimes, EndTimes, MachineIds),
    write('----- Machine/Tasks ----- '), nl,
    print_list(MachineIds), nl,
    write('----- Start Times ----- '), nl,
    print_list(StartTimes), nl,
    write('----- End Times ----- '), nl,
    print_list(EndTimes), nl.


schedule(ServerList, ServerNo, TaskList, TaskNo, StartTimes, EndTimes, MachineIds) :-
    length(StartTimes, TaskNo),
    length(EndTimes, TaskNo),
    domain(StartTimes, 0, 86400), %Check what domain is best (hours vs minutes vs ?)
    domain(EndTimes, 0, 86400),
    %Machines
    length(Machines1, ServerNo),
    length(Machines2, ServerNo),
    length(Machines3, ServerNo),
    length(Machines4, ServerNo),
    create_machines(ServerList, 1, CoresList, FreqList, Machines1, Machines2, Machines3, Machines4),
    /*
    write('----- Machines 1 ----- '), nl,
    print_list(Machines1), nl,
    write('----- Machines 2 ----- '), nl,
    print_list(Machines2), nl,
    write('----- Machines 3 ----- '), nl,
    print_list(Machines3), nl,
    write('----- Machines 4 ----- '), nl,
    print_list(Machines4), nl, */
    %Tasks
    length(MachineIds, TaskNo),
    domain(MachineIds, 1, ServerNo),
    length(Tasks1, TaskNo),
    length(Tasks2, TaskNo),
    length(Tasks3, TaskNo),
    length(Tasks4, TaskNo),
    create_prolog_tasks(TaskList, StartTimes, EndTimes, MachineIds, CoresList, FreqList, Tasks1, Tasks2, Tasks3, Tasks4),
    /*
    write('----- Tasks 1 ----- '), nl,
    print_list(Tasks1), nl,
    write('----- Tasks 2 ----- '), nl,
    print_list(Tasks2), nl,
    write('----- Tasks 3 ----- '), nl,
    print_list(Tasks3), nl,
    write('----- Tasks 4 ----- '), nl,
    print_list(Tasks4), nl, */
    cumulatives(Tasks1, Machines1, [bound(upper)]),
    cumulatives(Tasks2, Machines2, [bound(upper)]),
    cumulatives(Tasks3, Machines3, [bound(upper)]),
    cumulatives(Tasks4, Machines4, [bound(upper)]),
    write('Passed cumulatives'), nl,
    maximum(End, EndTimes),
    domain([End], 0, 86400),
    append([MachineIds, StartTimes], Vars),
    labeling([minimize(End)], Vars). %Minimizar simetrico de plano de tarefas (?)

create_machines([], _, [], [], [], [], [], []).
create_machines([Server | Rsl], MachineId, [NoCores | Rc], [Frequency | Rf], [M1 | Rm1], [M2 | Rm2], [M3 | Rm3], 
    [M4 | Rm4]) :-
    Server = [NoCores, Frequency, RAM, Storage],
    M1 = machine(MachineId, NoCores),
    M2 = machine(MachineId, Frequency),
    M3 = machine(MachineId, RAM),
    M4 = machine(MachineId, Storage),
    NextMachineId is (MachineId + 1),
    create_machines(Rsl, NextMachineId, Rc, Rf, Rm1, Rm2, Rm3, Rm4).

create_prolog_tasks([], [], [], [], _, _, [], [], [], []).
create_prolog_tasks([UserTask | Rtl], [StartTime | Rs], [EndTime | Re], [MachineId| Rmid], CoresList, FreqList,
    [Task1 | Rt1], [Task2 | Rt2], [Task3 | Rt3], [Task4 | Rt4]) :-
    UserTask = [_, NoCores, Frequency, RAM, Storage, ETA],
    TaskCost is (NoCores * Frequency),
    element(MachineId, CoresList, CoreS),
    element(MachineId, FreqList, FreqS),
    CPUSpeed #= (CoreS * FreqS),
    Diff #= (CPUSpeed - TaskCost),
    HalfwayPoint #= (CPUSpeed / 2),
    (Diff #>= HalfwayPoint #/\ Duration #= (ETA / (Diff / TaskCost))) 
    #\/ (Diff #< HalfwayPoint #/\ Duration #= (ETA * (TaskCost / Diff))),
    %Check For Duration Discrepancies (h vs mins)
    Task1 = task(StartTime, Duration, EndTime, NoCores, MachineId),
    Task2 = task(StartTime, Duration, EndTime, Frequency, MachineId),
    Task3 = task(StartTime, Duration, EndTime, RAM, MachineId),
    Task4 = task(StartTime, Duration, EndTime, Storage, MachineId), 
    create_prolog_tasks(Rtl, Rs, Re, Rmid, CoresList, FreqList, Rt1, Rt2, Rt3, Rt4).
    
generate_data(ServerList, NoServers, TaskList, TaskNo) :-
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    generate_servers(NoServers, ServerList),
    write('Number of Tasks: '),
    get_clean_int(TaskNo), nl,
    AvgTime is (86400 div TaskNo),
    generate_tasks(TaskNo, AvgTime, TaskList).

generate_tasks(0, _, []).
generate_tasks(NoTasks, AvgTime, [Task | RestOfTaskList]) :-
    random(1, 4, Plan),
    random(1, 4, Cores),
    random(1, 2, Frequency),
    random(1, 8, RAM),
    random(1, 122, Storage),
    random(1, AvgTime, ETAHours),
    Task = [Plan, Cores, Frequency, RAM, Storage, ETAHours],
    NoTasksAux is (NoTasks - 1),
    generate_tasks(NoTasksAux, AvgTime, RestOfTaskList).

generate_servers(0, []).
generate_servers(NoServers, [Server | RestOfServerList]) :-
    random(4, 8, Cores),
    random(2, 3, Frequency),
    random(8, 16, RAM),
    random(122, 1000, Storage),
    NoServersAux is (NoServers - 1),
    Server = [Cores, Frequency, RAM, Storage],
    generate_servers(NoServersAux, RestOfServerList).

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
    