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
    print_list(ServerList), nl,
    print_list(TaskList), nl,
    schedule(ServerList, ServerNo, TaskList, TaskNo, StartTimes, EndTimes, Vars),
    print_list(Vars).

schedule(ServerList, ServerNo, TaskList, TaskNo, StartTimes, EndTimes, Vars) :-
    length(StartTimes, TaskNo),
    length(EndTimes, TaskNo),
    domain(StartTimes, 0, 24), %Check what domain is best (hours vs minutes vs ?)
    domain(EndTimes, 0, 24),
    %Machines
    length(Machines1, ServerNo),
    length(Machines2, ServerNo),
    length(Machines3, ServerNo),
    length(Machines4, ServerNo),
    create_machines(ServerList, 1, Machines1, Machines2, Machines3, Machines4),
    print_list(Machines1), nl,
    %Tasks
    BiggerMachineLimit is (TaskNo * 4),
    length(MachineIds, BiggerMachineLimit),
    length(Tasks1, TaskNo),
    length(Tasks2, TaskNo),
    length(Tasks3, TaskNo),
    length(Tasks4, TaskNo),
    domain(MachineIds, 1, ServerNo),
    create_prolog_tasks(TaskList, StartTimes, EndTimes, MachineIds, Tasks1, Tasks2, Tasks3, Tasks4),
    write('Passed'), nl,
    %-----
    maximum(End, EndTimes),
    domain([End], 1, 24),
    print_list(Tasks1), nl,
    print_list(Machines1), nl,
    cumulatives(Tasks1, Machines1, [bound(upper)]),
    cumulatives(Tasks2, Machines2, [bound(upper)]),
    cumulatives(Tasks3, Machines3, [bound(upper)]),
    cumulatives(Tasks4, Machines4, [bound(upper)]),
    append(StartTimes, [End], Vars),
    labeling([minimize(End)], Vars). %Minimizar simetrico de plano de tarefas (?)

create_machines([], _, [], [], [], []).
create_machines([Server | Rsl], MachineId, [M1 | Rm1], [M2 | Rm2], [M3 | Rm3], [M4 | Rm4]) :-
    Server = [NoCores, Frequency, RAM, Storage],
    Id1 is (MachineId + 1),
    Id2 is (MachineId + 2),
    Id3 is (MachineId + 3),
    M1 = machine(MachineId, NoCores),
    M2 = machine(Id1, Frequency),
    M3 = machine(Id2, RAM),
    M4 = machine(Id3, Storage),
    NextMachineId is (MachineId + 4),
    create_machines(Rsl, NextMachineId, Rm1, Rm2, Rm3, Rm4).

/*
create_capacities([], []).
create_capacities([Server | RestOfServerList], [Capacity | RestOfCapacities]) :-
    Server = [NoCores, Frequency, RAM, Storage],
    Capacity = [cumulative(NoCores), cumulative(Frequency), cumulative(RAM), cumulative(Storage)],
    create_capacities(RestOfServerList, RestOfCapacities). */

create_prolog_tasks([], [], [], [], [], [], [], []).
create_prolog_tasks([UserTask | Rtl], [StartTime | Rs], [EndTime | Re], [MId1, MId2, MId3, MId4 | Rmid], 
    [Task1 | Rt1], [Task2 | Rt2], [Task3 | Rt3], [Task4 | Rt4]) :-
    UserTask = [_, NoCores, Frequency, RAM, Storage, Duration],
    %Check For Duration Discrepancies (h vs mins)
    Task1 = task(StartTime, Duration, EndTime, NoCores, MId1),
    Task2 = task(StartTime, Duration, EndTime, Frequency, MId2),
    Task3 = task(StartTime, Duration, EndTime, RAM, MId3),
    Task4 = task(StartTime, Duration, EndTime, Storage, MId4),
    MId1 #= (MId2 - 1) #/\ MId1 #= (MId3 - 2) #/\ MId1 #= (MId4 - 3) #/\ MId2 #= (MId3 - 1) #/\ MId2 #= (MId4 - 2) 
        #/\ MId3 #= (MId4 - 1),
    write('Pass'), nl,
    create_prolog_tasks(Rtl, Rs, Re, Rmid, Rt1, Rt2, Rt3, Rt4).
    
generate_data(ServerList, NoServers, TaskList, TaskNo) :-
    write('Server Amount: '),
    get_clean_int(NoServers), nl,
    generate_servers(NoServers, ServerList),
    write('Number of Tasks: '),
    get_clean_int(TaskNo), nl,
    generate_tasks(TaskNo, TaskList).

generate_tasks(0, []).
generate_tasks(NoTasks, [Task | RestOfTaskList]) :-
    random(1, 4, Plan),
    random(1, 8, Cores),
    %Replace with real values
    /*random(1, 9, PartialFrequencyI),
    PartialFrequencyF is (PartialFrequencyI / 10),
    Frequency is (1.0 + PartialFrequencyF), */
    random(1, 2, Frequency),
    random(1, 16, RAM),
    random(120, 1000, Storage),
    random(5, 360, ETAMins),
    ETAHours is (ETAMins / 60),
    Task = [Plan, Cores, Frequency, RAM, Storage, ETAHours],
    NoTasksAux is (NoTasks - 1),
    generate_tasks(NoTasksAux, RestOfTaskList).

generate_servers(0, []).
generate_servers(NoServers, [Server | RestOfServerList]) :-
    random(1, 8, Cores),
    %Replace with real values
    /*
    random(1, 9, PartialFrequencyI),
    PartialFrequencyF is (PartialFrequencyI / 10),
    Frequency is (1.0 + PartialFrequencyF), */
    random(1, 2, Frequency),
    random(1, 16, RAM),
    random(120, 1000, Storage),
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
    