
% https://erlangbyexample.org/case-of
%
% 1> c(case_of).
% {ok,case_of}
% 2> case_of:run().
% yes_with_cover
% yes_no_cover
% no_boy_admission
% no_girl_admission
% ok

-module(case_of).
-compile([export_all]).

admit(Person) ->
    case Person of
        {male, Age} when Age >= 21 ->
            yes_with_cover;
        {female, Age} when Age >= 21 ->
            yes_no_cover;
        {male, _} ->
            no_boy_admission;
        {female, _} ->
            no_girl_admission;
        _ ->
            unknown
    end.

run() ->
    AdultMale = {male, 25},
    io:format(admit(AdultMale)),
    io:nl(),
    AdultFemale = {female, 25},
    io:format(admit(AdultFemale)),
    io:nl(),
    KidMale = {male, 5},
    io:format(admit(KidMale)),
    io:nl(),
    KidFemale = {female, 5},
    io:format(admit(KidFemale)),
    io:nl().
