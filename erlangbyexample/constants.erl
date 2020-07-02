
% https://erlangbyexample.org/constants
% N = 123
% M = "what"
% 25

-module(constants).
-compile(export_all).

-define(N, 123).
-define(M, "what").
-define(SQUARED (X), X*X).

showConstants() ->
    io:format("N = ~p ~n", [?N]),
    io:format("M = ~p ~n", [?M]),
    io:format("~p ~n", [?SQUARED(5)]).
