:- module(p99, ['1.01'/2, my_last/2,
                '1.02'/2, my_last_but_one/2,
	        '1.03'/3, element_at/3,
                '1.04'/2, list_len/2
	  ]).

% 1.01 (*) Find the last element of a list.
%       Example:
%       ?- my_last(X,[a,b,c,d]).
%       X = d
my_last(A, B) :- '1.01'(A, B).
'1.01'(X, [X]) :- !.
'1.01'(X, [_|Ys]) :- '1.01'(X, Ys).

% 1.02 (*) Find the last but one element of a list.
%       (de: zweitletztes Element, fr: avant-dernier élément)
my_last_but_one(A, B) :- '1.02'(A, B).
'1.02'(X, [X, _]) :- !.
'1.02'(X, [_|Ys]) :- '1.02'(X, Ys).

% 1.03 (*) Find the Kth element of a list.
%       The first element in the list is number 1.
%       Example:
%       ?- element_at(X,[a,b,c,d,e],3).
%       X = c
element_at(X, List, N) :- '1.03'(X, List, N).
'1.03'(X, [X|_], 1) :- !.
'1.03'(X, [_|List], N) :-
    N1 is N - 1,
    '1.03'(X, List, N1).

% 1.04 (*) Find the number of elements of a list.
list_len(List, N) :- '1.04'(List, N).
'1.04'([], 0).
'1.04'([_|List], N) :- '1.04'(List, N1), N is N1 + 1.

