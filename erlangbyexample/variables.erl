
% https://erlangbyexample.org/variables
% 1> c(variables).
% {ok,variables}
% 2> variables:showVariables().
% Name: "Joe Doe"
% Age: 25
% Male: true
% A = 1
% Head = 10
% Second = 20
% Rest = [30,40]

-module(variables).
-compile(export_all).

showVariables() ->
    Name = "Joe Doe",
    io:format("Name: ~p ~n", [Name]),
    Age = 25,
    io:format("Age: ~p ~n", [Age]),
    IsMale = fun() -> true end,
    io:format("Male: ~p ~n", [IsMale()]),
    {A, [Head,Second|Rest]} = {1, [10,20,30,40]},
    io:format("A = ~p ~n", [A]),
    io:format("Head = ~p ~n", [Head]),
    io:format("Second = ~p ~n", [Second]),
    io:format("Rest = ~p ~n", [Rest]),
    _ = 1,
    _ = 2.
