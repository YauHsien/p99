:- module(unit_test, [unit_test/0]).

% For the fact case([ p99:'xxyyzz' ]),
% unit test may be result in following messages:
%   ERROR: Prolog initialisation failed:
%   ERROR: unit_test:assert_all/1: Undefined procedure: p99:xxyyzz/0
% For defined procedures, unit test will result
% as following output:
%   p99:1.01(b,[a,b]) passed.
%   p99:1.01(a,[a,b]) did not pass.

case([     p99:'1.01'(b, [a,b]),
       not(p99:'1.01'(a, [a,b])),
           p99:'1.02'(b, [a,b,c]),
       not(p99:'1.02'(a, [a,b,c])),
       not(p99:'1.02'(c, [a,b,c])),
       not(p99:'1.02'(a, [a])),
	   p99:'1.03'(a, [a,b,c], 1),
           p99:'1.03'(c, [a,b,c], 3),
       not(p99:'1.03'(a, [], 1)),
	   p99:'1.04'([], 0),
	   p99:'1.04'([a,b], 2),
       not(p99:'1.04'([a,b,c,d,e], 6)),
           p99:'1.05'([], []),
	   p99:'1.05'([a,b,c,d], [d,c,b,a]),
	   p99:'1.06'([]),
	   p99:'1.06'([a]),
       not(p99:'1.06'([a,b,c])),
           p99:'1.07'([a, [b, [c, d], e]], [a,b,c,d,e]),
           p99:'1.08'([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [a,b,c,a,d,e]),
	   p99:'1.09'([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]),
           p99:'1.10'([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [[4,a],[1,b],[2,c],[2,a],[1,d],[4,e]])
  ]).

unit_test :-
    case(List),
    format('Unit test start.~n'),
    assert_all(List).

assert_all([]) :-
    format('Unit test done.~n'),
    halt.
assert_all([G|List]) :- G, !,
    format('~p passed.~n', [G]),
    assert_all(List).
assert_all([G|_]) :-
    format('~p did not pass.~n', [G]).
