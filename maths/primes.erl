-module(primes).

% This is a simple linda tuplespace. Here we use it to find primes numbers.
% This tuplespace cannot have duplicate tuples, but with a prime sieve it does
% not matter.

-compile(export_all).

start() -> start(100).  % default value for max is 100
start(Max) ->
    io:format("  Loading ~w numbers into matrix (+N) \n ", [ Max ] ),
    Lid = spawn_link( primes, linda, [Max, [], [] ]),
    Sqrt = round(math:sqrt(Max)+0.5),
    io:format(" Sqrt(~w) + 1 = ~w \n " , [Max,Sqrt] ),
    io:format(" Tuple space is started ~n ",[]),
    io:format(" ~w sieves are spawning (+PN) ~n ", [Sqrt] ),
    io:format(" Non prime sieves are being halted (-PN) ~n ", [] ),
    % load numbers into tuplespace
    % and spawn sieve process
    spawn( primes, put_it, [Max, Max, Lid] ).

start_sieves(Lid) ->
    Lid ! {self(), get, all, pids},
    receive
        {lindagram, pids, Pids} -> done
    end,
    start_sieve_loop(Pids).

start_sieve_loop([]) -> done;
start_sieve_loop([Pid|Pids]) ->
    receive
    after 100 -> done
    end,
    Pid ! {start},
    start_sieve_loop(Pids).

spawn_sieves( _Max, Sqrt, _Lid, Sqrt ) -> done;
spawn_sieves( Max, Inc, Lid, Sqrt ) ->
    T = 1000,
    Pid = spawn( primes, sieve, [ Max, Inc+Inc, Inc, Lid, T ]),
    Name = list_to_atom("P" ++ integer_to_list(Inc)),
    Lid ! {put, pid, Name},
    register( Name, Pid),
    io:format(" +~s ", [atom_to_list(Name)]),
    spawn_sieves( Max, Inc+1, Lid, Sqrt ).

put_it(Max, N, Lid) when N =< 1 ->
    Sqrt = round(math:sqrt(Max)+0.5),
    spawn_sieves( Max, 2, Lid, Sqrt );

put_it(Max, N,Lid) when N > 1 ->
    receive
    after 0 ->
        Lid ! {put, N, N},
        if
            N rem 1000 == 0 ->
                io:format(" +~w ", [N]);
            true -> done
        end,
        put_it(Max, N-1,Lid)
    end.

% the 2 sieve starts last and has the most to do so it finishes last
sieve(Max, N, 2, Lid, _T) when N > Max ->
    io:format("final sieve ~w done, ~n", [2] ),
    Lid ! {dump,output};

sieve(Max, N, Inc, _Lid, _T) when N > Max ->
    io:format("sieve ~w done ", [Inc] );

sieve(Max, N, Inc, Lid, T) when N =< Max ->
    receive
    after
        T -> NT = 0
    end,
    receive
        {lindagram,Number} when Number =/= undefined ->
            clearing_the_queue;
        {exit} -> exit(normal)
    after
        1 -> done
    end,

    % remove multiple of number from tuple-space
    Lid ! {self(), get, N},
    Some_time = (N rem 1000)==0,
    if Some_time -> io:format("."); true -> done end,

    % remove (multiple of Inc) from sieve-process space
    Name = list_to_atom("P" ++ integer_to_list(N)),
    Exists = lists:member( Name, registered()),
    if
        Exists ->
            Name ! {exit},
            io:format(" -~s ", [atom_to_list(Name)] );
        true -> done
    end,
    sieve(Max, N+Inc, Inc, Lid, NT).        % next multiple

%% linda is a simple tutple space
%%    if it receives no messages for 2 whole seconds it dumps its contents
%%    as output and halts

linda(Max, Keys, Pids) ->
    receive
    {put, pid, Pid} ->
        linda(Max, Keys, Pids++[Pid]);
    {put, Name, Value} ->
        put( Name, Value),
        linda(Max, Keys++[Name], Pids);
    {From, get, Name} ->
        From ! {lindagram, get( Name)},
        erase( Name ),                          % get is a destructive read
        linda(Max, Keys--[Name],Pids);
    {From, get, all, pids} ->
        From ! {lindagram, pids, Pids},
        linda(Max, Keys, Pids );
    {From, get, pid, Pid} ->
        L1 = length( Pids ),
        L2 = length( Pids -- [Pid]),
        if
            L1 > L2 ->  % if it exists
                From ! {lindagram, pid, Pid};
            true ->
                From ! {lindagram, pid, undefined}
        end,
        linda(Max, Keys, Pids );
    {dump,output} ->
        io:format(" ~w final primes remain: ~w ~n ", [length(Keys),  lists:sort(Keys) ])
    after (100*Max) -> % if there is not tuple action after some time then print the results
        io:format(" ~w primes remain: ~w ~n ", [length(Keys),  lists:sort(Keys) ])
    end.
