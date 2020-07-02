
% https://erlangbyexample.org/list-comprehension
%
% 1> c(list_comp).
% {ok,list_comp}
%
% 2> list_comp:run().
% [1,2,3,4,5]
% [1,4,9,16,25]
% [2,4]
% ok

-module(list_comp).
-compile(export_all).

run() ->
    L = [1,2,3,4,5],
    LL = [X*X || X <- L],
    io:format("~p~n", [L]),
    io:format("~p~n", [LL]),
    Evens = [X || X <- L, X rem 2 == 0],
    io:format("~p~n", [Evens]).
