
% https://erlangbyexample.org/records
% 1> c(records).
% {ok,records}
%
% 2> records:run().
% Created person "Joe Doe"
% Record fields: [name,age,status]
% Record size: 4
% ok

-module (records).
-compile([export_all]).

-record(person, {
        name,
        age,
        status = single
    }).

run() ->
    P1 = #person{name="Joe Doe", age="25"},
    io:format("Created person ~p~n", [P1#person.name]),
    io:format("Record fields: ~p~n", [record_info(fields, person)]),
    io:format("Record size: ~p~n", [record_info(size, person)]).
