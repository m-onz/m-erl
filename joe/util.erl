-module(util).
-export([ pmap/1 ]).

% pmap :: compute functions in parallel
% F = fun() -> 10 + 1 end.
% util:pmap([ F ]).
% 11.
pmap (L) ->
  S = self(),
  Pids = [do(S, F) || F <- L],
  [ receive { Pid, Val } -> Val end || Pid <- Pids ].

 do (Parent, F) ->
   spawn(fun() ->
   	 Parent ! { self(), F() }
   end).
