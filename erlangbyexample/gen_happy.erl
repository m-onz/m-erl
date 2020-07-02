
% custom behaviours
%
% https://erlangbyexample.org/custom-behaviours
%
% To implement your own behaviors, export `behaviour_info/1`
% which should return the list of required callabacks
% to be implemented in the module implementing this behavior.
%
% When a module declares that it implements gen_happy,
% the compiler will check to make sure it exports and
% implements the required callbacks, and it will print
% warnings if this is not the case.
%
% -module(my_module).
% -behavior(gen_happy).
%
% get_happy() ->
%     "Yay!".
%
% get_ecstatic() ->
%     "Wow, Wow, OMG, Yes, Yes!".

-module(gen_happy).
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [{get_happy, 0}, {get_ecstatic, 0}];
behavior_info(_) ->
    undefined.
