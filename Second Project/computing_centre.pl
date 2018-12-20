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
       % (Option = 1, manual_input(ServerList, ServerNo, TaskList, TaskNo));
        (Option = 2, generate_data(ServerCores, ServerFreqs, ServerRAM, ServerSt, ServerNo, TaskList, TaskNo)) 
    ),
    write('----- Server Cores ----- '), nl,
    print_list(ServerCores), nl, 
    write('----- Server Frequencies ----- '), nl,
    print_list(ServerFreqs), nl,
    write('----- Server RAM ----- '), nl,
    print_list(ServerRAM), nl,
    write('----- Server Storage ----- '), nl,
    print_list(ServerSt), nl,
    write('----- User Tasks ----- '), nl,
    print_list(TaskList), nl,
    schedule(ServerCores, ServerFreqs, ServerRAM, ServerSt, ServerNo, TaskList, TaskNo, StartTimes, EndTimes, MachineIds),
    write('----- Machine/Tasks ----- '), nl,
    print_list(MachineIds), nl,
    write('----- Start Times ----- '), nl,
    print_list(StartTimes), nl,
    write('----- End Times ----- '), nl,
    print_list(EndTimes), nl.

schedule(ServerCores, ServerFreqs, ServerRAM, ServerSt, ServerNo, TaskList, TaskNo, StartTimes, EndTimes, MachineIds) :-
    length(StartTimes, TaskNo),
    length(EndTimes, TaskNo),
    domain(StartTimes, 0, 86400), %Check what domain is best (hours vs minutes vs ?)
    domain(EndTimes, 0, 86400),
    %Machines
    length(Machines, ServerNo),
    create_machines(1, Machines),
    /*
    write('----- Machines ----- '), nl,
    print_list(Machines), nl, */
    %Tasks
    length(MachineIds, TaskNo),
    domain(MachineIds, 1, ServerNo),
    length(Tasks, TaskNo),
    create_prolog_tasks(TaskList, StartTimes, EndTimes, MachineIds, ServerCores, ServerFreqs, ServerRAM, ServerSt, Tasks),
    /*
    write('----- Tasks ----- '), nl,
    print_list(Tasks), nl, */
    cumulatives(Tasks, Machines, [bound(upper)]),
    write('Passed cumulatives'), nl,
    maximum(End, EndTimes),
    domain([End], 0, 86400),
    append([MachineIds, StartTimes], Vars),
    labeling([minimize(End)], Vars). %Minimizar simetrico de plano de tarefas (?)

create_machines(_, []).
create_machines(MachineId, [Machine | Rm]) :-
    Machine = machine(MachineId, 1),
    NextMachineId is (MachineId + 1),
    create_machines(NextMachineId, Rm).

create_prolog_tasks([], [], [], [], _, _, _, _, []).
create_prolog_tasks([UserTask | Rtl], [StartTime | Rs], [EndTime | Re], [MachineId| Rmid], ServerCores, ServerFreqs, 
    ServerRAM, ServerSt, [Task | Rt]) :-
    UserTask = [_, NoCores, Frequency, RAM, Storage, Duration],
    %Check For Duration Discrepancies (h vs mins)
    Task = task(StartTime, Duration, EndTime, 1, MachineId),
    element(MachineId, ServerCores, NoCoresS),
    element(MachineId, ServerFreqs, FrequencyS),
    element(MachineId, ServerRAM, RAMS),
    element(MachineId, ServerSt, StorageS),
    NoCoresS #>= NoCores,
    FrequencyS #>= Frequency,
    RAMS #>= RAM,
    StorageS #>= Storage,
    create_prolog_tasks(Rtl, Rs, Re, Rmid, ServerCores, ServerFreqs, ServerRAM, ServerSt, Rt).
    
generate_data(ServerCores, ServerFreq, ServerRAM, ServerSt, NoServers, TaskList, TaskNo) :-
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    generate_servers(NoServers, ServerCores, ServerFreq, ServerRAM, ServerSt),
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

generate_servers(0, [], [], [], []).
generate_servers(NoServers, [SC | Rsc], [SF | Rsf], [SR | Rsr], [SS | Rss]) :-
    random(4, 8, SC),
    random(2, 3, SF),
    random(8, 16, SR),
    random(122, 1000, SS),
    NoServersAux is (NoServers - 1),
    generate_servers(NoServersAux, Rsc, Rsf, Rsr, Rss).

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
    