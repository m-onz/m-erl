
% https://erlangbyexample.org/values
% c(values).
% 2> values:show().
% [5,7,4090,2.3e3]
% "this is a string"
% false
% cool
% [1,2,3]
% {"Joe",1,ok}
% #{"age" => 20}
% {dude,"Joe",20}
% [<<"ABC">>,<<1>>]
% #Ref<0.0.0.220>
% #Fun<values.0.48304201>
% <0.35.0>
% ok

-module(values).
-export([show/0]).
-record(dude, {name, age}).

println(What) -> io:format("~p~n", [What]).

show() ->
    println([2+3, 2#111, 16#ffa, 2.3e3]),
    println("this is a string"),
    println(true and false),
    println(cool),
    println([1,2,3]),
    println({"Joe", 1, ok}),
    println(#{"age"=> 20}),
    println(#dude{name="Joe", age=20}),
    println([<<"ABC">>, <<001>>]),
    println(make_ref()),
    Fun = fun() -> 10 end,
    println(Fun),
    println(self()).
