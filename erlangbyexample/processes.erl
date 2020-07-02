
% https://erlangbyexample.org/processes
%
% 1> c(processes).
% {ok,processes}
% 2> processes:run().
% I'm a process with id <0.166.0>
% I'm a process with id <0.167.0>
% I'm a process with id <0.168.0>
% ok

-module(processes).
-compile([export_all]).

proc() ->
    io:format("I'm a process with id ~p~n", [self()]).

loop() -> loop().

run() ->
    spawn(fun() -> proc() end),
    spawn(processes, proc, []),
    spawn(?MODULE, proc, []),
    ok.
