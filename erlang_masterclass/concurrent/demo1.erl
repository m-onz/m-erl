
-module(demo1).
-export([ area/0 ]).

% sequential
% area({ square, X }) ->
%   X*X;
% area({ rectangle, X, Y }) ->
%   X*Y.

% concurrent

% Pid = spawn(...)
% Pid ! message
% receive Pattern -> Actions; end
% self

Pid = spawn(demo1, area, []),
Pid ! { self(), { square, 10 } },
receive
  {Pid, Reply} ->
    Reply
end.

area() ->
  receive
    { From, square, X } ->
      From ! { self(), X * X };
    { From, rectangle, X, Y } ->
      From ! { self(), X * Y }
  after Time ->
    TimeoutActions
  end,
  area().

%
%
% register(Name, Pid)
