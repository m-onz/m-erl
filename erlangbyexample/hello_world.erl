
% https://erlangbyexample.org/hello-world
% $ ls
% hello_world.erl
% $ erl
% Eshell (abort with ^G)
% 1> c(hello_world).
% 2> hello_world:hello().
% hello world
% ok

-module(hello_world).
-compile(export_all).

hello() ->
    io:format("hello world~n").
