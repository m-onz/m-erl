
% https://erlangbyexample.org/links
%
% 1> c(links).
% {ok,links}
%
% 2> links:run().
% I (grandparent) have pid <0.183.0>
% I (parent) have pid <0.184.0>
% I (child) have pid: <0.185.0>
% I (grandparent) have a linked child: <0.184.0>
% I (parent) have a linked child: <0.185.0>
% I (parent) have another linked child: <0.186.0>
% I (child) have pid: <0.186.0>
% I (parent) have another linked child: <0.187.0>
% I (child) have pid: <0.187.0>
% I (parent) have another linked child: <0.188.0>
% I (child) have pid: <0.188.0>
% I (parent) have another linked child: <0.189.0>
% I (child) have pid: <0.189.0>
%
% I (child <0.189.0>) will die now!
% I (child <0.188.0>) will die now!
% I (child <0.187.0>) will die now!
% I (child <0.186.0>) will die now!
% I (child <0.185.0>) will die now!
% I (parent) have a dying child(<0.185.0>). Reason: normal
% I (parent) will die too ...
% I (grandparent) have a dead child(<0.184.0>). Reason: normal
% I (grandparent) will die too ...
% ok
% 25>

-module(links).
-compile([export_all]).

child() ->
    io:format("I (child) have pid: ~p~n", [self()]),
    receive
    after 1000 ->
        io:format("I (child ~p) will die now!~n", [self()])
    end.

parent() ->
    Pid = spawn(links, child, []),
    link(Pid),
    io:format("I (parent) have pid ~p~n", [self()]),
    io:format("I (parent) have a linked child: ~p~n", [Pid]),

    lists:foreach(
        fun(_) ->
            P = spawn_link(links, child, []),
            io:format("I (parent) have another linked child: ~p~n", [P])
        end,
        lists:seq(1,4)
    ),
    process_flag(trap_exit, true),
    receive
        {'EXIT', Pid, Reason} ->
            timer:sleep(10),
            io:format("I (parent) have a dying child(~p). Reason: ~p~n", [Pid, Reason]),
            io:format("I (parent) will die too ...~n")
    end.

grandparent() ->
    Pid = spawn_link(links, parent, []),
    io:format("I (grandparent) have pid ~p~n", [self()]),
    io:format("I (grandparent) have a linked child: ~p~n", [Pid]),
    process_flag(trap_exit, true),
    receive
        {'EXIT', Pid, Reason} ->
            timer:sleep(10),
            io:format("I (grandparent) have a dead child(~p). Reason: ~p~n", [Pid, Reason]),
            io:format("I (grandparent) will die too ...~n")
    end.

run() ->
    spawn(links, grandparent, []),
    timer:sleep(1100),
    ok.
