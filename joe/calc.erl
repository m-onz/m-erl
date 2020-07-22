-module(calc).
-export([ start/0, stop/0, execute/1 ]).

start() -> spawn(calc, init, []).

init() ->
  io:format("starting... ~n"),
  register(calc, self()),
  loop().

loop() ->
  receive
    { Request, From, Expr } ->
      From ! { reply, expr:eval(Expr) },
      loop();
    stop ->
      io:format("Terminating... ~n")
  end.

  stop () ->
    calc ! stop.


 execute (X) ->
   calc ! { Request, self(), X },
   receive
     { reply, Reply } ->
       Reply
   end.
