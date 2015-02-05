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
           p99:'1.10'([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [[4,a],[1,b],[2,c],[2,a],[1,d],[4,e]]),
           p99:'1.11'([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [[4,a],b,[2,c],[2,a],d,[4,e]]),
	   p99:'1.12'([[4,a],b,[2,c],[2,a],d,[4,e]], [a,a,a,a,b,c,c,a,a,d,e,e,e,e]),
           p99:'1.13'([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [[4,a],[1,b],[2,c],[2,a],[1,d],[4,e]]),
	   p99:'1.14'([a,b,c,c,d], [a,a,b,b,c,c,c,c,d,d]),
	   p99:'1.15'([a,b,c], 3, [a,a,a,b,b,b,c,c,c]),
           p99:'1.16'([a,b,c,d,e,f,g,h,i,k], 3, [a,b,d,e,g,h,k]),
	   p99:'1.17'([a,b,c,d,e,f,g,h,i,k], 3, [a,b,c], [d,e,f,g,h,i,k]),
	   p99:'1.17'([a,b], 3, [a,b], []),
  	   p99:'1.18'([a,b,c,d,e,f,g,h,i,k], 3, 7, [c,d,e,f,g]),
	   p99:'1.18'([a,b,c,d], 3, 5, [c,d]),
	   p99:'1.19'([a,b,c,d,e,f,g,h], 3, [d,e,f,g,h,a,b,c]),
	   p99:'1.19'([a,b,c,d,e,f,g,h], -2, [g,h,a,b,c,d,e,f]),
       not(p99:'1.20'(_, [a,b,c,d], 0, _)),
	   p99:'1.20'(a, [a,b,c,d], 1, [b,c,d]),
      	   p99:'1.20'(b, [a,b,c,d], 2, [a,c,d]),
	   p99:'1.20'(d, [a,b,c,d], 4, [a,b,c]),
       not(p99:'1.20'(_, [a,b,c,d], 5, _)),
       not(p99:'1.21'(alfa, [a,b,c,d], 0, _)),
	   p99:'1.21'(alfa, [a,b], 1, [alfa,a,b]),
  	   p99:'1.21'(alfa, [a,b], 2, [a,alfa,b]),
       not(p99:'1.21'(alfa, [a,b,c,d], 3, _)),
	   p99:'1.22'(4, 9, [4,5,6,7,8,9]),
  	   p99:'1.22'(9, 9, [9]),
       not(p99:'1.22'(10, 9, _)),
         % Not easy to test using solution_count/2:
         %   p99:'1.23'([a,b,c,d,e,f,g,h], 1, [_])
         %   p99:'1.23'([a,b,c,d,e,f,g,h], 3, [_,_,_])
         %   (p99:'1.23'([a,b,c,d,e,f,g,h], 8, R123_8), p99:list_len(R123_8, 8))
	 %   p99:'1.24'(6, 49, [_,_,_,_,_,_])
           [random,
	    p99:'1.23'([a,b,c,d,e,f,g,h], 1, [_])],
	   [random,
	    p99:'1.23'([a,b,c,d,e,f,g,h], 3, [_,_,_])],
	   [random,
	    (p99:'1.23'([a,b,c,d,e,f,g,h], 8, R123_8), p99:list_len(R123_8, 8))],
           [random,
	    (p99:'1.24'(6, 49, R124_6_49), p99:list_len(R124_6_49, 6))],
	   [random,
	    (p99:'1.25'([a,b,c,d,e,f], R125_6), p99:list_len(R125_6, 6),
	     forall(member(X,[a,b,c,d,e,f]), member(X,R125_6)))],
	   [120,
	    combination(3, [a,b,c,d,e,f], X)]
  ]).

unit_test :-
    case(List),
    format('Unit test start.~n'),
    assert_all(List).

assert_all([]) :-
    format('Unit test done.~n'),
    halt.
assert_all([[random,G]|List]) :- !,
    write(G),
    (G -> !,
         format(' passed.~n'),
         assert_all(List);
     format(' not passed.~n')).
assert_all([[N,G]|List]) :- !,
    write(G),
    solution_count(G, C),
    (G, C == N -> !,
         format(' passed.~n'),
         assert_all(List);
     not(G) ->
         format(' not passed.~n')).
assert_all([G|List]) :- not(is_list(G)),
    write(G),
    (G, solution_count(G, 1) -> !,
         format(' passed.~n'),
         assert_all(List);
     not(G) ->
         format(' not passed.~n')).

% For test case p99:'1.23', when using the following case to inspect what happened,
%
%   solution_count(G, N) :- write('A'), write(bagof(_, G, L)),
%       bagof(_, G, L), write('B'),
%
% then the following information was showed,
%
%   p99:1.23([a,b,c,d,e,f,g,h],1,_G1964)Abagof(_G4878,p99:1.23([a,b,c,d,e,f,g,h],1,[g]),_G4880)?- 
%
% it is that when a goal is passed into solution_count/2, it is unified.
% This fact make testing random predicates hard, because bagof/3 will
% not take same goals at next run.
%
solution_count(G, N) :-
    bagof(X, G, L), write(L), nl,
    length(L, M), write(N), nl, write(M), nl,
    (N == M -> !;
     format(' does not have ~d solutions (~d found);', [N, M]), fail).
