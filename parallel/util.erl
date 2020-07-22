
-module(util).
-export([ random_list/1, qsort/1, benchmark/2, psort/1 ]).

qsort([]) -> [];
qsort([X|Xs]) -> qsort([ Y || Y <- Xs, Y<X])
  ++ [X]
  ++ qsort([Y || Y <- Xs, Y>=X]).

% psort([]) ->
%   [];
% psort([X|Xs]) ->
%   Parent = self(),
%   spawn_link(
%     fun() ->
%       Parent ! psort([Y || Y <- Xs, Y >= X])
%     end),
%   psort([Y || Y <- Xs, Y < X]) ++
%     [X] ++ receive Ys -> Ys end.

random_list(N) ->
  [ rand:uniform(1000000) || _ <- lists:seq(1, N) ].

% util:benchmark(qsort, L)
benchmark(Fun, L) ->
  Runs = [timer:tc(?MODULE, Fun, [L]) || _ <- lists:seq(1, 100)],
          lists:sum([T || {T, _} <- Runs]) /
          (1000*length(Runs)).
