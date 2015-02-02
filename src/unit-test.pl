:- module(unit_test, [unit_test/0]).

% For the fact case([ p99:'xxyyzz' ]),
% unit test may be result in following messages:
%   ERROR: Prolog initialisation failed:
%   ERROR: unit_test:assert_all/1: Undefined procedure: p99:xxyyzz/0
% For defined procedures, unit test will result
% as following output:
%   p99:1.01(b,[a,b]) passed.
%   p99:1.01(a,[a,b]) did not pass.

case([ p99:'1.01'(b, [a,b]),
       p99:'1.01'(a, [a,b])  ]).

unit_test :-
    case(List),
    assert_all(List),
    halt.

assert_all([]) :-
    format('All cases passed.~n').
assert_all([G|List]) :- callable(G), G, !,
    format('~p passed.~n', [G]),
    assert_all(List).
assert_all([G|_]) :-
    format('~p did not pass.~n', [G]).
